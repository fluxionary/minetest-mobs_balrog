local S = mobs_balrog.S

local whip_uses = mobs_balrog.settings.whip_uses
local wear_amount = math.ceil(65535 / whip_uses)
local whip_tool_capabilities = mobs_balrog.settings.whip_tool_capabilities
local whip_power = mobs_balrog.settings.whip_power

local function on_rightclick(itemstack, placer, pointed_thing)
    if pointed_thing.type == "nothing" then
        mobs_balrog.api.whip_air(
            placer,
            vector.add(placer:get_pos(), vector.new(0, 1, 0)),
            placer:get_look_dir(),
            placer:get_player_name(),
            whip_power
        )

    elseif pointed_thing.type == "node" then
        mobs_balrog.api.whip_node(pointed_thing.above, placer:get_player_name())

    elseif pointed_thing.type == "object" then
        mobs_balrog.api.whip_object(placer, pointed_thing.ref, whip_power)
    end

    itemstack:add_wear(wear_amount)

    return itemstack
end

local function on_use(itemstack, user, pointed_thing)
    if pointed_thing.type == "object" then
        mobs_balrog.api.whip_object(user, pointed_thing.ref, whip_power)
        itemstack:add_wear(wear_amount)
    end

    return itemstack
end

-- for to prevent whip from being destroyed in explosion
local function on_blast(self, damage)
    return false, false, {}
end

minetest.register_tool("mobs_balrog:balrog_whip", {
    description = minetest.colorize("orange", S("Balrog Whip")) ..
        minetest.get_background_escape_sequence("darkred"),
    inventory_image = "mobs_balrog_balrog_whip.png^[transform3",
    light_source = 14,
    range = 6,
    tool_capabilities = whip_tool_capabilities,
    on_use = on_use,
    on_place = on_rightclick,
    on_secondary_use = on_rightclick,
    on_blast = on_blast,
})
