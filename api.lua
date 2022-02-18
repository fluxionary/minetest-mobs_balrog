local whip_tool_capabilities = mobs_balrog.settings.whip_tool_capabilities
local fire_tool_capabilities = mobs_balrog.settings.fire_tool_capabilities
local explodes_on_death = mobs_balrog.settings.explodes_on_death
local whip_fire_time = mobs_balrog.settings.whip_fire_time
local whip_fire_radius = mobs_balrog.settings.whip_fire_radius
local whip_fire_distance = mobs_balrog.settings.whip_fire_distance
local flame_node = mobs_balrog.settings.flame_node
local fire_damage = mobs_balrog.settings.fire_damage
local min_power = 1 / (fire_damage - 1)

local function identify(object)
    if not object then
        return "nil"
    end
    object = object.object or object

    if object.is_player and object:is_player() then
        return object:get_player_name() or "unknown player"
    elseif object.get_luaentity and object:get_luaentity() and object:get_luaentity().name then
        return object:get_luaentity().name
    elseif object.get_entity_name then
        return object:get_entity_name() or ("unknown %s"):format(type(object))
    else
        return ("unknown %s"):format(type(object))
    end
end

function mobs_balrog.custom_attack(self, _, target_pos)
    target_pos = table.copy(target_pos)
    local own_pos = self.object:get_pos()

    target_pos.y = target_pos.y + .5
    own_pos.y = own_pos.y + .5

    if self:line_of_sight(target_pos, own_pos) then
        self.timer = 0
        self:set_animation("punch")
        -- play attack sound
        self:mob_sound(self.sounds.attack)

        -- punch player (or what player is attached to)
        local attached = self.attack:get_attach()

        if attached then
            self.attack = attached
        end

        mobs_balrog.whip_object(self.object, self.attack)

    else
        self.state = "walk"

    end
end

function mobs_balrog.do_custom(self, dtime)
    if self.state == "attack" and self.attack and math.random() < 0.05 then
        local own_pos = self.object:get_pos()
        local target_pos = self.attack:get_pos()

        if not own_pos or not target_pos then
            return true
        end

        target_pos.y = target_pos.y + 0.5
        own_pos.y = own_pos.y + 2.5

        local distance = vector.distance(own_pos, target_pos)

        if self:line_of_sight(target_pos, own_pos) and distance > 2 * self.reach then
            self.timer = 0
            self:set_animation("punch")
            self:mob_sound(self.sounds.attack)

            mobs_balrog.whip_air(
                self.object,
                own_pos,
                vector.direction(own_pos, target_pos),
                "mobs_balrog:balrog"
            )

            return false
        end
    end

    return true
end

local function explode(pos)
    local before = minetest.get_us_time()
    tnt.boom(pos, {
        name = "Balrog's Blast",
        radius = 6,
        damage_radius = 16,
        tiles = {""},
    })
    mobs_balrog.log("action", "explosion @ %s took %s us",
        minetest.pos_to_string(vector.round(pos)),
        minetest.get_us_time() - before)
end

function mobs_balrog.on_die(self, pos)
    self.object:remove()

    minetest.after(0.0, function()
        -- This has been taken from ../tnt/init.lua @243
        minetest.add_particlespawner({
            amount = 128,
            time = 0.1,
            minpos = vector.subtract(pos, 10 / 2),
            maxpos = vector.add(pos, 10 / 2),
            minvel = {x = -3, y = 0, z = -3},
            maxvel = {x = 3, y = 5, z = 3},
            minacc = {x = 0, y = -10, z = 0},
            maxacc = {x = 0, y = -10, z = 0},
            minexptime = 0.8,
            maxexptime = 2.0,
            minsize = 10 * 0.66,
            maxsize = 10 * 2,
            texture = "fire_basic_flame.png",
            collisiondetection = true,
        })
        if explodes_on_death then
            minetest.after(0, explode, pos)
        end
    end)
end

local function is_valid_target(source, target)
    local source_id = identify(source)
    local target_id = identify(target)
    if source_id == target_id then
        return false
    end
    if source_id:find("unknown ") then
        return false
    end
    local target_def = minetest.registered_entities[target_id]
    if target_def then
        if target_def.physical == false then
            return false
        end
        if target_def.collide_with_objects == false then
            return false
        end
        if target_def.pointable == false then
            return false
        end
    end

    return true
end

function mobs_balrog.whip_air(source, pos, dir, cause, starting_power)
    if not starting_power then
        starting_power = 1
    end
    for i = 3, whip_fire_distance do
        local new_pos = vector.round(pos + (dir * i))
        local hit_obj = false
        local lb = vector.subtract(new_pos, 1.5)
        local ub = vector.add(new_pos, 1.5)

        for _, obj in ipairs(minetest.get_objects_in_area(lb, ub)) do
            if is_valid_target(source, obj) then
                mobs_balrog.log("action", "%s's air whip hit %s", identify(source), identify(obj))

                -- suck the victim towards the whip holder
                local vel = dir * -30
                vel.y = math.min(vel.y, 10) -- don't suck "up" too much
                obj:add_velocity(vel)
                mobs_balrog.whip_object(source, obj, starting_power)

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
        if node_name == "air"  then
            minetest.set_node(new_pos, {name = flame_node})
        elseif node_name == flame_node then
            -- do nothing, continue
        else
            break
        end
    end
end

function mobs_balrog.whip_node(pos, cause)
    for x = -whip_fire_radius, whip_fire_radius do
        for z = -whip_fire_radius, whip_fire_radius do
            if (x * x + z * z) <= (whip_fire_radius * whip_fire_radius) then
                for y = 10, -10, -1 do
                    local new_pos = pos + vector.new(x, y, z)
                    if not minetest.is_protected(new_pos, cause) then
                        local posu = new_pos - vector.new(0, 1, 0)

                        local node_name = minetest.get_node(new_pos).name
                        local nodeu_name = minetest.get_node(posu).name
                        local nodeu_def = minetest.registered_nodes[nodeu_name] or {}
                        local is_solid_under = (
                            nodeu_def.drawtype ~= "airlike" and
                            nodeu_def.drawtype ~= "plantlike" and
                            nodeu_def.drawtype ~= "firelike" and
                            nodeu_def.drawtype ~= "plantlike_rooted"
                        )

                        if node_name == "air" and is_solid_under then
                            minetest.set_node(new_pos, {name = flame_node})
                            break
                        end
                    end
                end
            end
        end
    end
end

local function puts_out_fire(pos)
    local node = minetest.get_node(pos)
    local node_name = node.name
    return (
        minetest.get_item_group(node_name, "water") > 0 or
        minetest.get_item_group(node_name, "cools_lava") > 0
    )
end

local function add_particles(target)
    minetest.add_particlespawner({
        amount = 40,
        time = 1,
        minpos = {x = -1, y = -1, z = -1},
        maxpos = {x = 1, y = 1, z = 1},
        minvel = {x = -2, y = -2, z = -2},
        maxvel = {x = 2, y = 2, z = 2},
        minacc = {x = -1, y = -1, z = -1},
        maxacc = {x = 1, y = 1, z = 1},
        minexptime = 1,
        maxexptime = 2,
        minsize = 1,
        maxsize = 3,
        attached = target,
        vertical = false,
        --  ^ vertical: if true faces player using y axis only
        texture = "fire_basic_flame.png",
    })
end

local function fire_hit(target, source, remaining_hits, starting_power)
    if not starting_power then
        starting_power = 1
    end
    if not target or not source then
        return
    end

    local pos = target:get_pos()
    if not pos then
        -- target died or unloaded or something
        return
    end

    if puts_out_fire(pos) or puts_out_fire(vector.subtract(pos, vector.new(0, 1, 0))) then
        -- in water or something
        return
    end

    add_particles(target)
    target:punch(source, starting_power, fire_tool_capabilities)

    local hp = target:get_hp()
    if target:get_pos() and hp > 0 and remaining_hits > 1 then
        minetest.after(1, fire_hit, target, source, remaining_hits - 1)
    end
end

function mobs_balrog.whip_object(source, target, starting_power)
    if not starting_power then
        starting_power = 1
    end

    if source.object then
        source = source.object
    end
    local spos = source:get_pos()
    local tpos = target.object and target.object:get_pos() or target:get_pos()

    local distance = vector.distance(spos, tpos)
    local power = math.max(min_power, math.min((whip_fire_distance - (distance or 0)) / whip_fire_distance, 1))

    add_particles(target)
    target:punch(source, power * starting_power, whip_tool_capabilities)

    local pos = target:get_pos()  -- returns nil if dead?
    local hp = target:get_hp()
    if pos and hp > 0 then
        minetest.after(1, fire_hit, target, source, whip_fire_time, starting_power)
    end
end
