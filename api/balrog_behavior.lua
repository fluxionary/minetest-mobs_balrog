local api = mobs_balrog.api
local settings = mobs_balrog.settings

local explodes_on_death = settings.explodes_on_death
local explode_radius = settings.explode_radius
local explode_damage_radius = settings.explode_damage_radius

local function explode(pos)
	local before = minetest.get_us_time()

	tnt.boom(pos, {
		name = "Balrog's Blast",
		radius = explode_radius,
		damage_radius = explode_damage_radius,
		tiles = { "mobs_balrog_flame.png" },
	})

	mobs_balrog.log(
		"action",
		"explosion @ %s took %s us",
		minetest.pos_to_string(vector.round(pos)),
		minetest.get_us_time() - before
	)

	api.whip_node(pos, "mobs_balrog:balrog")
end

--[[
    balrog's whip attack
]]
function api.whip_attack(self, dtime)
	self.time_since_whip = (self.time_since_whip or 0) + dtime

	-- TODO: configurable time between whippings
	if self.state == "attack" and self.attack and self.time_since_whip > 3 and math.random() < 0.5 then
		local own_pos = self.object:get_pos()
		local target_pos = self.attack:get_pos()

		if not own_pos or not target_pos then
			return
		end

		target_pos.y = target_pos.y + 0.5
		own_pos.y = own_pos.y + 2.5

		local distance = vector.distance(own_pos, target_pos)

		if self:line_of_sight(own_pos, target_pos) and distance > 2 * self.reach then
			self.timer = 0
			self:set_animation("punch")
			self:mob_sound(self.sounds.attack)

			self.time_since_whip = 0

			api.whip_air(self.object, own_pos, vector.direction(own_pos, target_pos), "mobs_balrog:balrog", 1)
		end
	end
end

function api.destroy_obstructions(self, dtime)
	self.time_since_obstruct_check = (self.time_since_obstruct_check or 0) + dtime

	if self.state == "attack" and self.attack and self.time_since_obstruct_check > 3 then
		local cur_pos = self.object:get_pos()
		local target_pos = self.attack:get_pos()
		local last_obstruct_pos = self.last_obstruct_pos

		if
			cur_pos
			and last_obstruct_pos
			and target_pos
			and vector.distance(cur_pos, last_obstruct_pos) < 1
			and not (
				self:line_of_sight(cur_pos, vector.add(target_pos, vector.new(0, 1, 0)))
				and self:line_of_sight(vector.add(cur_pos, vector.new(0, 2, 0)), target_pos)
			)
		then
			local boom_pos = vector.add(
				vector.add(cur_pos, vector.new(0, 2, 0)),
				vector.multiply(vector.direction(cur_pos, target_pos), 2)
			)

			explode(boom_pos)
		end

		self.last_obstruct_pos = cur_pos
		self.time_since_obstruct_check = 0
	end
end

function api.on_die(self, pos)
	self.object:remove()

	minetest.add_particlespawner({
		amount = 128,
		time = 0.1,
		minpos = vector.subtract(pos, 10 / 2),
		maxpos = vector.add(pos, 10 / 2),
		minvel = { x = -3, y = 0, z = -3 },
		maxvel = { x = 3, y = 5, z = 3 },
		minacc = { x = 0, y = -10, z = 0 },
		maxacc = { x = 0, y = -10, z = 0 },
		minexptime = 1.8,
		maxexptime = 4.0,
		minsize = 10 * 0.66,
		maxsize = 10 * 2,
		texture = "mobs_balrog_flame.png",
		collisiondetection = true,
	})

	if explodes_on_death then
		minetest.after(0, explode, pos)
	end
end

local heal_rate = 5
function api.heal(self, dtime)
	if self.state == "attack" or self.health == self.hp_max then
		self.time_since_heal = 0
	else
		self.time_since_heal = (self.time_since_heal or 0) + dtime
		if self.time_since_heal > heal_rate then
			self.health = math.min(self.hp_max, self.health + math.round(self.time_since_heal / heal_rate))
			self.time_since_heal = 0
		end
	end
end

api.on_do_custom = {}
function api.register_on_do_custom(callback)
	api.on_do_custom[#api.on_do_custom + 1] = callback
end

function api.do_custom(self, dtime)
	for _, callback in ipairs(api.on_do_custom) do
		callback(self, dtime)
	end

	api.heal(self, dtime)

	api.whip_attack(self, dtime)
	api.destroy_obstructions(self, dtime)

	return true
end

function api.custom_attack(self, _, target_pos)
	target_pos = table.copy(target_pos)
	local own_pos = table.copy(self.object:get_pos())

	if
		self:line_of_sight(own_pos, vector.add(target_pos, vector.new(0, 1, 0)))
		or self:line_of_sight(vector.add(own_pos, vector.new(0, 2, 0)), target_pos)
	then
		self.timer = 0
		self:set_animation("punch")
		-- play attack sound
		self:mob_sound(self.sounds.attack)

		-- punch player (or what player is attached to)
		local attached = self.attack:get_attach()

		if attached then
			self.attack = attached
		end

		api.whip_object(self.object, self.attack)
		self.last_obstruct_pos = nil
	else
		self.state = "walk"
	end
end

function api.on_blast(self, damage)
	return false, false, {}
end
