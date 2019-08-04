-- ------------------------------------------------------------------------------------------
-- ITEMS

data:extend{
    {
        type = 'item',
        name = 'infinity-loader',
        localised_name = {'entity-name.infinity-loader'},
        icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}},
        stack_size = 50,
        place_result = 'infinity-loader',
        subgroup = 'im-misc',
        oreder = 'aa'
    }
}

register_recipes{'infinity-loader'}

-- ------------------------------------------------------------------------------------------
-- ENTITIES

local empty_sheet = {
    filename = "__core__/graphics/empty.png",
    priority = "very-low",
    width = 1,
    height = 1,
    frame_count = 1,
}

-- inserter
data:extend{
    {
        type = 'inserter',
        name = 'infinity-loader-inserter',
        localised_name = {'entity-name.infinity-loader'},
        icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}},
        minable = {mining_time=0.1, result='infinity-loader'},
        collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
        -- collision_mask = base_entity.collision_mask,
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        selection_priority = 50,
        allow_custom_vectors = true,
        energy_per_movement = ".0000001J",
        energy_per_rotation = ".0000001J",
        energy_source = {type='void'},
        extension_speed = 1,
        rotation_speed = 0.5,
        pickup_position = {0, -0.2},
        insert_position = {0, 0.8},
        draw_held_item = false,
        platform_picture = empty_sheet,
        hand_base_picture = empty_sheet,
        hand_open_picture = empty_sheet,
        hand_closed_picture = empty_sheet,
        draw_inserter_arrow = false,
        flags = {'hide-alt-info'}
    }
}

local underneathy_base = table.deepcopy(data.raw['underground-belt']['underground-belt'])
for n,t in pairs(underneathy_base.structure) do
    apply_infinity_tint(t.sheet)
    apply_infinity_tint(t.sheet.hr_version)
    if n ~= 'back_patch' and n ~= 'front_patch' then
        t.sheet.filename = '__InfinityMode__/graphics/entity/infinity-loader.png'
        t.sheet.hr_version.filename = '__InfinityMode__/graphics/entity/hr-infinity-loader.png'
    end
end
underneathy_base.icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}}

-- underground belt
local function create_underneathy(base_underground)
    local entity = table.deepcopy(data.raw['underground-belt'][base_underground])
    -- adjust pictures and icon
    entity.structure = underneathy_base.structure
    entity.icons = underneathy_base.icons
    -- basic data
    local suffix = entity.name:gsub('%-?underground%-belt', '')
    entity.name = 'infinity-loader' .. (suffix ~= '' and '-'..suffix or '')
    entity.next_upgrade = nil
    entity.max_distance = 0
    entity.order = 'a'
    data:extend{entity}
end

for n,_ in pairs(table.deepcopy(data.raw['underground-belt'])) do
    create_underneathy(n)
end