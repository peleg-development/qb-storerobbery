-- test 
Config = {}

-- Option to receive black money (true) or regular cash (false)
Config.UseBlackMoney = true

-- Minimum and maximum cash reward from the register
Config.RegisterReward = {
    min = 500,
    max = 1500
}

-- Minimum and maximum cash reward from the safe
Config.SafeReward = {
    min = 2000,
    max = 5000
}

-- Time in seconds before a store can be robbed again
Config.RobberyCooldown = 1800 -- 30 minutes

-- Required number of police online to start a robbery
Config.RequiredPolice = 2

-- Stores locations with their coordinates, safe location, and robbery status
Config.Stores = {
    [1] = {
        coords = vector3(24.5, -1347.3, 29.5),
        safeCoords = vector3(28.2, -1339.2, 29.5),
        robbed = false
    },
    [2] = {
        coords = vector3(-3038.7, 584.2, 7.9),
        safeCoords = vector3(-3047.5, 585.7, 7.9),
        robbed = false
    },
    [3] = {
        coords = vector3(-3241.9, 1001.4, 12.8),
        safeCoords = vector3(-3250.0, 1004.4, 12.8),
        robbed = false
    },
    [4] = {
        coords = vector3(2557.4, 380.9, 108.6),
        safeCoords = vector3(2549.2, 384.9, 108.6),
        robbed = false
    },
    [5] = {
        coords = vector3(1163.5, -323.9, 69.2),
        safeCoords = vector3(1159.4, -314.1, 69.2),
        robbed = false
    },
    [6] = {
        coords = vector3(-706.0, -914.4, 19.2),
        safeCoords = vector3(-709.7, -904.1, 19.2),
        robbed = false
    },
    [7] = {
        coords = vector3(-47.5, -1759.0, 29.4),
        safeCoords = vector3(-43.4, -1748.4, 29.4),
        robbed = false
    },
    [8] = {
        coords = vector3(372.7, 326.3, 103.5),
        safeCoords = vector3(378.1, 333.4, 103.5),
        robbed = false
    },
    [9] = {
        coords = vector3(1135.6, -982.2, 46.4),
        safeCoords = vector3(1126.8, -980.1, 46.4),
        robbed = false
    },
    [10] = {
        coords = vector3(-1222.9, -907.0, 12.3),
        safeCoords = vector3(-1220.8, -915.5, 12.3),
        robbed = false
    },
    -- Add more stores as needed
}
