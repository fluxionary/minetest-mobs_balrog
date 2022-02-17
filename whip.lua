local S = mobs_balrog.S

local whip_uses = mobs_balrog.settings.whip_uses
local wear_amount = math.ceil(65535 / whip_uses)
local whip_tool_capabilities = mobs_balrog.settings.whip_tool_capabilities
local whip_power = mobs_balrog.settings.whip_power

local function on_place(itemstack, placer, pointed_thing)
    if pointed_thing.type == "nothing" then
        mobs_balrog.whip_air(
            placer,
            vector.add(placer:get_pos(), vector.new(0, 1, 0)),
            placer:get_look_dir(),
            placer:get_player_name(),
            whip_power
        )

    elseif pointed_thing.type == "node" then
        mobs_balrog.whip_node(pointed_thing.above, placer:get_player_name())

    elseif pointed_thing.type == "object" then
        mobs_balrog.whip_object(placer, pointed_thing.ref, whip_power)
    end

    itemstack:add_wear(wear_amount)

    return itemstack
end

minetest.register_tool("mobs_balrog:balrog_whip", {
    description = minetest.colorize("orange", S("Balrog Whip")) ..
        minetest.get_background_escape_sequence("darkred"),
    inventory_image = "mobs_balrog_balrog_whip.png^[transform3",
    light_source = 14,
    range = 6,
    tool_capabilities = whip_tool_capabilities,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "object" then
            mobs_balrog.whip_object(user, pointed_thing.ref, whip_power)
        end

        itemstack:add_wear(wear_amount)

        return itemstack
    end,
    on_place = on_place,
    on_secondary_use = on_place,
    on_blast = function(self, damage)
        -- prevent whip from being destroyed in explosion
        return false, false, {}
    end,
})
