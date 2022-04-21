-- Taken from basic fire mod
-- https://github.com/minetest/minetest_game/tree/master/mods/fire

minetest.register_node("mobs_balrog:flame", {
    description = "Fire",
    drawtype = "firelike",
    tiles = {{
         name = "mobs_balrog_flame_animated.png",
         animation = {
             type = "vertical_frames",
             aspect_w = 16,
             aspect_h = 16,
             length = 1
         }
     }},
    inventory_image = "fire_basic_flame.png",
    paramtype = "light",
    light_source = 13,
    walkable = false,
    buildable_to = true,
    sunlight_propagates = true,
    floodable = true,
    damage_per_second = 4,
    groups = {igniter = 2, dig_immediate = 3, fire = 1, not_in_creative_inventory = 1},
    drop = "",
    on_flood = function(pos, _, newnode)
        -- Play flame extinguish sound if liquid is not an 'igniter'
        if minetest.get_item_group(newnode.name, "igniter") == 0 then
            minetest.sound_play("fire_extinguish_flame",
                {pos = pos, max_hear_distance = 16, gain = 0.15}, true)
        end
        -- Remove the flame
        return false
    end,
    on_timer = function(pos)
        -- https://gitea.your-land.de/your-land/bugtracker/issues/1264
        minetest.remove_node(pos)
        return
    end,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(30, 60))
    end
})

if mobs_balrog.has.armor then
    table.insert(armor.fire_nodes, {"mobs_balrog:flame", 4, 4})
end
