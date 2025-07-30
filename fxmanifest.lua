fx_version 'cerulean'
game 'gta5'

description 'Máquinas expendedoras de soda y café - echo por U-PROYECT'

author 'U-PROYECT'
version '1.0.0'

lua54 'yes'

dependencies {
    'ox_lib',
    'qb-target',
    'qb-menu',
}
shared_scripts {
    'config.lua',
    'server/locale.lua'
}

client_scripts {
    '@ox_lib/init.lua',
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}
