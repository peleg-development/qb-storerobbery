fx_version 'cerulean'
game 'gta5'
-- test
description 'QB-Core Enhanced Store Robbery Script with Shooting Initiation and Safe Targeting'

shared_script {
    '@qb-core/import.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'safecracker', -- The safe cracking minigame resource https://github.com/thelindat/safecracker
    'qb-phone',    -- For police alerts
    'qb-target',   -- For interactive targets
}
