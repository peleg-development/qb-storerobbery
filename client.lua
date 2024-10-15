local QBCore = exports['qb-core']:GetCoreObject()
local robberyInProgress = false
local currentStore = nil
local lastRobberyTime = {}

-- Load the config
local Config = Config or {}

-- Player data
local PlayerData = {}

-- Update player data when resource starts
Citizen.CreateThread(function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- Update player data when it changes
RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

-- Function to start the register robbery (initiated by shooting)
function StartRegisterRobbery(storeIndex)
    local store = Config.Stores[storeIndex]
    robberyInProgress = true
    currentStore = storeIndex

    local playerPed = PlayerPedId()
    RequestAnimDict("missheist_agency2ahands_up")
    while not HasAnimDictLoaded("missheist_agency2ahands_up") do
        Citizen.Wait(10)
    end
    TaskPlayAnim(playerPed, "missheist_agency2ahands_up", "hands_up_anxious", 8.0, -8, -1, 49, 0, false, false, false)

    QBCore.Functions.Progressbar("rob_register", "Robbing the cash register...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- On Complete
        ClearPedTasks(playerPed)
        TriggerServerEvent('qb-storerobbery:server:rewardPlayer', 'register')
        QBCore.Functions.Notify("You grabbed the money from the register!", "success")
        TriggerServerEvent('qb-storerobbery:server:alertPolice', store.coords)
        SetupSafeCracking(storeIndex)
    end, function() -- On Cancel
        ClearPedTasks(playerPed)
        QBCore.Functions.Notify("You stopped robbing!", "error")
        robberyInProgress = false
    end)
end

-- Function to set up safe cracking interaction
function SetupSafeCracking(storeIndex)
    local store = Config.Stores[storeIndex]
    exports['qb-target']:AddBoxZone("StoreSafe" .. storeIndex, store.safeCoords, 1.0, 1.0, {
        name = "StoreSafe" .. storeIndex,
        heading = 0,
        debugPoly = false,
        minZ = store.safeCoords.z - 1.0,
        maxZ = store.safeCoords.z + 1.0,
    }, {
        options = {
            {
                type = "client",
                event = "qb-storerobbery:client:startSafeCracking",
                icon = "fas fa-lock",
                label = "Crack Safe",
                storeIndex = storeIndex,
                canInteract = function()
                    return not store.robbed and robberyInProgress
                end,
            },
        },
        distance = 1.5,
    })
end

-- Event to start safe cracking minigame
RegisterNetEvent('qb-storerobbery:client:startSafeCracking', function(data)
    local storeIndex = data.storeIndex
    local store = Config.Stores[storeIndex]
    local playerPed = PlayerPedId()

    RequestAnimDict("mini@safe_cracking")
    while not HasAnimDictLoaded("mini@safe_cracking") do
        Citizen.Wait(10)
    end
    TaskPlayAnim(playerPed, "mini@safe_cracking", "dial_turn_anti_fast_1", 8.0, -8, -1, 1, 0, false, false, false)

    exports['safecracker']:StartSafeCracking(function(success)
        ClearPedTasks(playerPed)
        if success then
            TriggerServerEvent('qb-storerobbery:server:rewardPlayer', 'safe')
            QBCore.Functions.Notify("You cracked the safe and got the loot!", "success")
        else
            QBCore.Functions.Notify("You failed to crack the safe!", "error")
        end
        robberyInProgress = false
        store.robbed = true
        exports['qb-target']:RemoveZone("StoreSafe" .. storeIndex)
        StartCooldown(storeIndex)
    end)
end)

-- Function to start the cooldown timer
function StartCooldown(storeIndex)
    local store = Config.Stores[storeIndex]
    store.robbed = true
    lastRobberyTime[storeIndex] = GetGameTimer()

    Citizen.CreateThread(function()
        while GetGameTimer() - lastRobberyTime[storeIndex] < Config.RobberyCooldown * 1000 do
            Citizen.Wait(1000)
        end
        store.robbed = false
        QBCore.Functions.Notify("The store is now available for robbery again.", "info")
    end)
end

-- Detect shooting inside the store to initiate robbery
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) and not robberyInProgress then
            local playerPos = GetEntityCoords(playerPed)
            for index, store in pairs(Config.Stores) do
                if #(playerPos - store.coords) < 20.0 and not store.robbed then
                    QBCore.Functions.TriggerCallback('qb-storerobbery:server:GetPoliceCount', function(policeCount)
                        if policeCount >= Config.RequiredPolice then
                            StartRegisterRobbery(index)
                        else
                            QBCore.Functions.Notify("Not enough police in the city!", "error")
                        end
                    end)
                    return
                end
            end
        end
    end
end)

-- Police notification blip
RegisterNetEvent('qb-storerobbery:client:policeNotify', function(coords)
    if PlayerData.job and PlayerData.job.name == 'police' then
        local alpha = 250
        local robberyBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(robberyBlip, 161)
        SetBlipScale(robberyBlip, 2.0)
        SetBlipColour(robberyBlip, 1)
        PulseBlip(robberyBlip)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Store Robbery")
        EndTextCommandSetBlipName(robberyBlip)
        while alpha ~= 0 do
            Citizen.Wait(500 * 4)
            alpha = alpha - 1
            SetBlipAlpha(robberyBlip, alpha)
            if alpha == 0 then
                RemoveBlip(robberyBlip)
                return
            end
        end
    end
end)

-- test
