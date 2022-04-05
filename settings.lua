local default_flame_node = mobs_balrog.has.fire and "mobs_balrog:flame" or "yl_commons:temp_flame"

mobs_balrog.settings = {
    -- spawn params
    max_light = tonumber(minetest.settings:get("mobs_balrog.max_light")) or 14,
    min_light = tonumber(minetest.settings:get("mobs_balrog.min_light")) or 0,
    spawn_interval = tonumber(minetest.settings:get("mobs_balrog.spawn_interval")) or 60,
    spawn_chance = tonumber(minetest.settings:get("mobs_balrog.spawn_chance")) or 500000,
    active_object_count = tonumber(minetest.settings:get("mobs_balrog.active_object_count")) or 1,
    min_height = tonumber(minetest.settings:get("mobs_balrog.min_height")) or -30912,
    max_height = tonumber(minetest.settings:get("mobs_balrog.max_height")) or -18000,
    spawn_in_nether = minetest.settings:get_bool("mobs_balrog.spawn_in_nether", true),

    -- attributes
    hp_min = tonumber(minetest.settings:get("mobs_balrog.hp_min")) or 200,
    hp_max = tonumber(minetest.settings:get("mobs_balrog.hp_max")) or 600,
    jump_height = tonumber(minetest.settings:get("mobs_balrog.jump_height")) or 10,  -- was 16
    walk_chance = tonumber(minetest.settings:get("mobs_balrog.walk_chance")) or 50,
    view_range = tonumber(minetest.settings:get("mobs_balrog.view_range")) or 32,
    fire_damage = tonumber(minetest.settings:get("mobs_balrog.fire_damage")) or 10,
    fleshy_damage = tonumber(minetest.settings:get("mobs_balrog.fleshy_damage")) or 10,
    pathfinding = tonumber(minetest.settings:get("mobs_balrog.pathfinding")) or 2,
    lifetimer = tonumber(minetest.settings:get("mobs_balrog.lifetimer")) or 5 * 60 * 60,
    explodes_on_death = minetest.settings:get_bool("mobs_balrog.explodes_on_death", true),
    whip_drop_chance = tonumber(minetest.settings:get("mobs_balrog.whip_drop_chance")) or 100,

    -- whip
    whip_power = tonumber(minetest.settings:get("mobs_balrog.whip_power")) or 0.5,
    whip_uses = tonumber(minetest.settings:get("mobs_balrog.whip_uses")) or 500,
    whip_fire_distance = tonumber(minetest.settings:get("mobs_balrog.whip_fire_distance")) or 50,
    whip_fire_radius = tonumber(minetest.settings:get("mobs_balrog.whip_fire_radius")) or 5,
    whip_fire_time = tonumber(minetest.settings:get("mobs_balrog.whip_fire_time")) or 5,
    flame_node = minetest.settings:get("mobs_balrog.flame_node") or default_flame_node,
}

mobs_balrog.settings.whip_tool_capabilities = {
    full_punch_interval = 1,
    max_drop_level = 3,
    damage_groups = {
        fleshy = mobs_balrog.settings.fleshy_damage,
        fire = mobs_balrog.settings.fire_damage,
    },
}

mobs_balrog.settings.fire_tool_capabilities = {
    full_punch_interval = 1,
    max_drop_level = 3,
    damage_groups = {
        fire = mobs_balrog.settings.fire_damage,
    },
}
