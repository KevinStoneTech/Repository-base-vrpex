fx_version 'bodacious'
game 'gta5'

ui_page 'gui/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'lib/utils.lua',
	'base.lua',
	'queue.lua',
	'modules/gui.lua',
	'modules/group.lua',
	'modules/player_state.lua',
	'modules/business.lua',
	'modules/map.lua',
	'modules/money.lua',
	'modules/inventory.lua',
	'modules/identity.lua',
	'modules/aptitude.lua',
	'modules/basic_items.lua',
	'modules/basic_skinshop.lua',
	'modules/cloakroom.lua'
}

client_scripts {
	'lib/utils.lua',
	'client/base.lua',
	'client/basic_garage.lua',
	'client/iplloader.lua',
	'client/gui.lua',
	'client/player_state.lua',
	'client/survival.lua',
	'client/map.lua',
	'client/notify.lua',
	'client/identity.lua',
	'client/police.lua'
}

files {
	'lib/Tunnel.lua',
	'lib/Proxy.lua',
	'lib/Luaseq.lua',
	'lib/Tools.lua',
	'gui/index.html',
	'gui/design.css',
	'gui/main.js',
	'gui/Menu.js',
	'gui/WPrompt.js',
	'gui/RequestManager.js',
	'gui/Div.js',
	'gui/dynamic_classes.js',
	'gui/bebas.ttf',
	'loading/index.html',
    'loading/lalala.mp3',
    'loading/css/bootstrap.min.css',
    'loading/css/css.css',
    'loading/css/fontawesome-all.min.css',
    'loading/css/colors/yellow-2.css',
    'loading/css/style-dark.css',
    'loading/img/film-grain.png',
    'loading/img/logo-light.png',
    'loading/js/main.js',
    'loading/js/plugins.js',
    'loading/webfonts/fa-brands-400.eot',
    'loading/webfonts/fa-brands-400.svg',
    'loading/webfonts/fa-brands-400.ttf',
    'loading/webfonts/fa-brands-400.woff',
    'loading/webfonts/fa-brands-400.woff2',
    'loading/webfonts/fa-light-300.eot',
    'loading/webfonts/fa-light-300.svg',
    'loading/webfonts/fa-light-300.ttf',
    'loading/webfonts/fa-light-300.woff',
    'loading/webfonts/fa-light-300.woff2',
    'loading/webfonts/fa-regular-400.eot',
    'loading/webfonts/fa-regular-400.svg',
    'loading/webfonts/fa-regular-400.ttf',
    'loading/webfonts/fa-regular-400.woff',
    'loading/webfonts/fa-regular-400.woff2',
    'loading/webfonts/fa-solid-900.eot',
    'loading/webfonts/fa-solid-900.svg',
    'loading/webfonts/fa-solid-900.ttf',
    'loading/webfonts/fa-solid-900.woff',
    'loading/webfonts/fa-solid-900.woff2'
}

loadscreen 'loading/index.html'

server_export 'AddPriority'
server_export 'RemovePriority'