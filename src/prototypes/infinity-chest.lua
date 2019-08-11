local table = require('__stdlib__/stdlib/utils/table')
local chest_data = {
    ['active-provider'] = {s=0, t={218,115,255}, o='ab'},
    ['passive-provider'] = {s=0, t={255,141,114}, o='ac'},
    ['storage'] = {s=1, t={255,220,113}, o='ad'},
    ['buffer'] = {s=30, t={114,255,135}, o='ae'},
    ['requester'] = {s=30, t={114,236,255}, o='af'}
}
local tess_chest_data = {
    [''] = {t={255,255,255}, o='ba'},
    ['passive-provider'] = {t={255,141,114}, o='bb'},
    ['storage'] = {t={255,220,113}, o='bc'}
}

-- ------------------------------------------------------------------------------------------
-- ITEMS

-- modify existing infinity-chest item
local ic_item = data.raw['item']['infinity-chest']
ic_item.subgroup = 'im-inventories'
ic_item.order = 'aa'
ic_item.stack_size = 50
ic_item.flags = {}
register_recipes{'infinity-chest'}

-- create logistic chest items
ic_item = table.deepcopy(data.raw['item']['infinity-chest'])
for lm,d in pairs(chest_data) do
    local chest = table.deepcopy(ic_item)
    chest.name = 'infinity-chest-' .. lm
    chest.localised_description = {'item-description.infinity-chest'}
    chest.icons = {{icon=chest.icon, tint = d.t}}
    chest.place_result = 'infinity-chest-' .. lm
    chest.order = d.o
    chest.flags = {}
    data:extend{chest}
    register_recipes{'infinity-chest-'..lm}
end

-- compilatron chest does not have an item, so we must define our own icon here
local comp_chest_icon = '__base__/graphics/icons/compilatron-chest.png'

-- create tesseract chest items
for lm,d in pairs(tess_chest_data) do
    local suffix = lm == '' and lm or '-'..lm
    local chest = table.deepcopy(ic_item)
    chest.name = 'tesseract-chest'..suffix
    chest.localised_description = {'', '[img=utility/danger_icon] [color=255,57,48]', {'item-description.tesseract-chest-warning'}, '[/color]\n', {'item-description.tesseract-chest'}}
    chest.icons = {{icon=comp_chest_icon, tint=d.t}}
    chest.place_result = 'tesseract-chest'..suffix
    chest.order = d.o
    data:extend{chest}
    register_recipes{'tesseract-chest'..suffix}
end

-- ------------------------------------------------------------------------------------------
-- ENTITIES

data.raw['infinity-container']['infinity-chest'].inventory_size = 100
data.raw['infinity-container']['infinity-chest'].gui_mode = 'all'

local ic_entity = table.deepcopy(data.raw['infinity-container']['infinity-chest'])
local inf_chest_picture = table.deepcopy(ic_entity.picture)
local inf_chest_icon = table.deepcopy(ic_entity.icon)

for lm,d in pairs(chest_data) do
    local chest = table.deepcopy(data.raw['logistic-container']['logistic-chest-' .. lm])
    chest.type = 'infinity-container'
    chest.name = 'infinity-chest-' .. lm
    chest.order = d.o
    chest.subgroup = 'im-inventories'
    chest.icons = {{icon=inf_chest_icon, tint=d.t}}
    chest.erase_contents_when_mined = true
    chest.picture = table.deepcopy(inf_chest_picture)
    chest.picture.layers[1].tint = d.t
    chest.picture.layers[1].hr_version.tint = d.t
    chest.animation = nil
    chest.logistic_slots_count = d.s
    chest.minable.result = 'infinity-chest-' .. lm
    chest.render_not_in_network_icon = true
    chest.inventory_size = 100
    chest.next_upgrade = nil
    chest.flags = {'player-creation'}
    data:extend{chest}
end

-- tesseract chests
-- create the chests here to let other mods modify them. increase inventory size in data-final-fixes
local compilatron_chest = data.raw['container']['compilatron-chest']
local comp_chest_picture = table.deepcopy(compilatron_chest.picture)
for lm,d in pairs(tess_chest_data) do
    local suffix = lm == '' and lm or '-'..lm
    local chest = table.deepcopy(data.raw['infinity-container']['infinity-chest'..suffix])
    chest.name = 'tesseract-chest'..suffix
    chest.order = d.o
    chest.icons = {{icon=comp_chest_icon, tint=d.t}}
    chest.picture = table.deepcopy(comp_chest_picture)
    chest.picture.layers[1].tint = d.t
    chest.picture.layers[1].hr_version.tint = d.t
    chest.logistic_slots_count = 0
    chest.enable_inventory_bar = false
    chest.flags = {'player-creation', 'hide-alt-info'}
    data:extend{chest}
end