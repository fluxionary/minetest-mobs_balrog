local api = mobs_balrog.api
local has = mobs_balrog.has
local settings = mobs_balrog.settings

local whip_tool_capabilities = settings.whip_tool_capabilities
local fire_tool_capabilities = settings.fire_tool_capabilities
local whip_fire_time = settings.whip_fire_time
local whip_fire_radius = settings.whip_fire_radius
local whip_fire_distance = settings.whip_fire_distance
local flame_node = settings.flame_node
local fire_damage = settings.fire_damage
local min_power = 1 / (fire_damage - 1)

-- keep track of player death; resets when hit by a whip
local has_died = {}
minetest.register_on_dieplayer(function(player, reason)
	has_died[player:get_player_name()] = true
end)

local target_blacklist = {
	["mobs_balrog:balrog"] = true,
}
function api.blacklist_target(target)
	target_blacklist[target] = true
end

--[[
    identify(object)

    *always* returns a string
    tries to get a name for players, or the kind for other objects
    -- TODO should this return the name for "named" objects?
]]
local function identify(object)
	if not object then
		return "nil"
	end
	object = object.object or object
	local ent = object.get_luaentity and object:get_luaentity()

	if minetest.is_player(object) then
		return object:get_player_name() or "unknown player"
	elseif object.name then
		return object.name
	elseif ent and ent.name then
		return ent.name
	elseif object.get_entity_name then
		return object:get_entity_name() or ("unknown %s"):format(type(object))
	else
		return ("unknown %s"):format(type(object))
	end
end

local function is_valid_target(source, target)
	local source_id = identify(source)
	local target_id = identify(target)
	if source_id == target_id then
		return false
	end
	if source_id == "nil" or target_id == "nil" or source_id:find("unknown ") or target_id:find("unknown ") then
		return false
	end
	if target_blacklist[target_id] then
		return false
	end
	local target_def = minetest.registered_entities[target_id]
	if target_def then
		if
			target_def.physical == false
			or target_def.collide_with_objects == false
			or target_def.pointable == false
		then
			return false
		end
	end

	if has.pvpplus then
		if minetest.is_player(source) and minetest.is_player(target) then
			return pvpplus.is_pvp(source:get_player_name()) and pvpplus.is_pvp(target:get_player_name())
		end
	end
	return true
end

local function puts_out_fire(pos)
	local node = minetest.get_node(pos)
	local node_name = node.name
	return (minetest.get_item_group(node_name, "water") > 0 or minetest.get_item_group(node_name, "cools_lava") > 0)
end

local function is_in_water(target)
	local target_pos = (target.object or target):get_pos()
	local target_in_node = minetest.get_node(target_pos)
	return minetest.get_item_group(target_in_node.name, "water") > 0
end

local function add_particles(target)
	minetest.add_particlespawner({
		amount = 40,
		time = 1,
		minpos = { x = -1, y = -1, z = -1 },
		maxpos = { x = 1, y = 1, z = 1 },
		minvel = { x = -2, y = -2, z = -2 },
		maxvel = { x = 2, y = 2, z = 2 },
		minacc = { x = -1, y = -1, z = -1 },
		maxacc = { x = 1, y = 1, z = 1 },
		minexptime = 1,
		maxexptime = 2,
		minsize = 1,
		maxsize = 3,
		attached = target,
		vertical = false,
		--  ^ vertical: if true faces player using y axis only
		texture = "mobs_balrog_flame.png",
	})
end

local function fire_tick(target, source, remaining_hits, starting_power)
	if not is_valid_target(source, target) then
		return
	end
	if minetest.is_player(target) and has_died[target:get_player_name()] then
		return
	end

	if not starting_power then
		starting_power = 1
	end

	local pos = target:get_pos()
	if not pos then
		-- target died or unloaded or something
		return
	end

	local pos_below = vector.subtract(pos, vector.new(0, 1, 0))
	if puts_out_fire(pos) or puts_out_fire(pos_below) then
		-- in water or something
		return
	end

	add_particles(target)
	target:punch(source.object or source, starting_power, fire_tool_capabilities)

	local hp = target:get_hp()
	if target:get_pos() and hp > 0 and remaining_hits > 1 then
		minetest.after(1, fire_tick, target, source, remaining_hits - 1)
	end
end

function api.whip_pull(source, target, dir)
	if (not is_valid_target(source, target)) or is_in_water(target) then
		return
	end
	local vel = vector.multiply(dir, -30) -- TODO make configurable
	vel.y = math.min(vel.y, 10) -- don't suck "up" too much  -- TODO make configurable
	target:add_velocity(vel)
end

function api.whip_air(source, pos, dir, cause, starting_power)
	if not starting_power then
		starting_power = 1
	end
	for i = 3, whip_fire_distance do
		local new_pos = vector.round(vector.add(pos, vector.multiply(dir, i)))
		local hit_obj = false
		local lb = vector.subtract(new_pos, 1.5)
		local ub = vector.add(new_pos, 1.5)

		for _, obj in ipairs(minetest.get_objects_in_area(lb, ub)) do
			if is_valid_target(source, obj) then
				mobs_balrog.log("action", "%s's air whip hit %s", identify(source), identify(obj))

				-- suck the victim towards the whip holder
				api.whip_pull(source, obj, dir)
				api.whip_object(source, obj, starting_power)

				hit_obj = true
				break
			end
		end
		if hit_obj then
			break
		end
		if minetest.is_protected(new_pos, cause) then
			break
		end
		local node = minetest.get_node(new_pos)
		local node_name = node.name
		if node_name == "air" then
			minetest.set_node(new_pos, { name = flame_node })
		elseif node_name ~= flame_node then
			break
		end
	end
end

function api.whip_node(pos, cause)
	for x = -whip_fire_radius, whip_fire_radius do
		for z = -whip_fire_radius, whip_fire_radius do
			if (x * x + z * z) <= (whip_fire_radius * whip_fire_radius) then
				for y = (whip_fire_radius * 2), -(whip_fire_radius * 2), -1 do
					local new_pos = vector.add(pos, vector.new(x, y, z))
					if not minetest.is_protected(new_pos, cause) then
						local posu = vector.subtract(new_pos, vector.new(0, 1, 0))

						local node_name = minetest.get_node(new_pos).name
						local nodeu_name = minetest.get_node(posu).name
						local nodeu_drawtype = (minetest.registered_nodes[nodeu_name] or {}).drawtype
						local is_solid_under = (
							nodeu_drawtype ~= "airlike"
							and nodeu_drawtype ~= "plantlike"
							and nodeu_drawtype ~= "firelike"
							and nodeu_drawtype ~= "plantlike_rooted"
						)

						if node_name == "air" and is_solid_under then
							minetest.set_node(new_pos, { name = flame_node })
							break
						end
					end
				end
			end
		end
	end
end

function api.whip_object(source, target, starting_power)
	if has.pvpplus and source and target and minetest.is_player(source) and minetest.is_player(target) then
		local source_name = source:get_player_name()
		local target_name = target:get_player_name()
		if not (pvpplus.is_pvp(source_name) and pvpplus.is_pvp(target_name)) then
			return
		end
	end

	if not starting_power then
		starting_power = 1
	end

	if source.object then
		source = source.object
	end

	local spos = source:get_pos()
	local tpos = target.object and target.object:get_pos() or target:get_pos()

	if not (spos and tpos) then
		-- somebody doesn't exist, cancel the action
		return
	end

	local distance = vector.distance(spos, tpos)
	local power = starting_power
		* math.max(min_power, math.min((whip_fire_distance - (distance or 0)) / whip_fire_distance, 1))

	add_particles(target)
	target:punch(source.object or source, power, whip_tool_capabilities)

	local pos = target:get_pos() -- returns nil if dead?
	local hp = target:get_hp()
	if pos and hp > 0 then
		if minetest.is_player(target) then
			has_died[target:get_player_name()] = false
		end

		minetest.after(1, fire_tick, target, source, whip_fire_time, starting_power)
	end
end
