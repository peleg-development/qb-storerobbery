local QBCore = exports['qb-core']:GetCoreObject()

-- Load the config
local Config = Config or {}

-- Callback to get the number of police online
QBCore.Functions.CreateCallback('qb-storerobbery:server:GetPoliceCount', function(source, cb)
    local policeCount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k, v in pairs(players) do
        if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end
    cb(policeCount)
end)
-- test
-- Event to reward the payer after successful robbery
RegisterNetEvent('qb-storerobbery:server:rewardPlayer', function(target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local reward = 0
    if target == 'register' then
        reward = math.random(Config.RegisterReward.min, Config.RegisterReward.max)
    elseif target == 'safe' then
        reward = math.random(Config.SafeReward.min, Config.SafeReward.max)
    end
    if Config.UseBlackMoney then
        Player.Functions.AddMoney('dirty', reward, 'store-robbery')
    else
        Player.Functions.AddMoney('cash', reward, 'store-robbery')
    end
end)

-- Event to alert police
RegisterNetEvent('qb-storerobbery:server:alertPolice', function(coords)
    local alertData = {
        title = "Store Robbery",
        coords = { x = coords.x, y = coords.y, z = coords.z },
        description = "A store is being robbed! Respond immediately.",
    }
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
    TriggerClientEvent('qb-storerobbery:client:policeNotify', -1, coords)
end)
