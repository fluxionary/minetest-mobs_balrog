--[[

   Mobs Balrog - Adds balrogs.
	Copyright © 2018-2019 Hamlet <hamlatmesehub@riseup.net>

   Authors of source code:
   -----------------------
   (LOTT-specific-mod)
   Original Author(s):
      PilzAdam (WTFPL)
         https://github.com/PilzAdam/mobs
   Modifications By:
      Copyright (C) 2016 TenPlus1 (MIT)
         https://github.com/tenplus1/mobs_redo
      BrandonReese (LGPL v2.1)
         https://github.com/Bremaweb/adventuretest
   LOTT Modifications By:
      Amaz (LGPL v2.1)
      lumidify (LGPL v2.1)
      fishyWET (LGPL v2.1)
         https://github.com/minetest-LOTR/Lord-of-the-Test/

   This program is free software; you can redistribute it and/or modify
   it under the terms of the Lesser GNU General Public License as published
   by the Free Software Foundation; either version 2.1 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.


]]--


-- Used for localization

local S = minetest.get_translator("mobs_balrog")


--
-- Balrog's spawn settings
--

local MAX_LIGHT = tonumber(minetest.settings:get("mobs_balrog_max_light"))
if (MAX_LIGHT == nil) then
	MAX_LIGHT = 14
end

local MIN_LIGHT = tonumber(minetest.settings:get("mobs_balrog_min_light"))
if (MIN_LIGHT == nil) then
	MIN_LIGHT = 0
end

local INTERVAL = tonumber(minetest.settings:get("mobs_balrog_interval"))
if (INTERVAL == nil) then
	INTERVAL = 60
end

local CHANCE = tonumber(minetest.settings:get("mobs_balrog_chance"))
if (CHANCE == nil) then
	CHANCE = 500000
end

local MAX_NUMBER = tonumber(minetest.settings:get("mobs_balrog_aoc"))
if (MAX_NUMBER == nil) then
	MAX_NUMBER = 1
end

local MIN_HEIGHT = tonumber(minetest.settings:get("mobs_balrog_min_height"))
if (MIN_HEIGHT == nil) then
	MIN_HEIGHT = -30912
end

local MAX_HEIGHT = tonumber(minetest.settings:get("mobs_balrog_max_height"))
if (MAX_HEIGHT == nil) then
	MAX_HEIGHT = -1800
end


--
-- Balrog's attributes
--

local MIN_HP = tonumber(minetest.settings:get("mobs_balrog_min_hp"))
if (MIN_HP == nil) then
	MIN_HP = 200
end

local MAX_HP = tonumber(minetest.settings:get("mobs_balrog_max_hp"))
if (MAX_HP == nil) then
	MAX_HP = 600
end

local WALK_CHANCE = tonumber(minetest.settings:get("mobs_balrog_walk_chance"))
if (WALK_CHANCE == nil) then
	WALK_CHANCE = 50
end

local VIEW_RANGE = tonumber(minetest.settings:get("mobs_balrog_view_range"))
if (VIEW_RANGE == nil) then
	VIEW_RANGE = 32
end

local DAMAGE = tonumber(minetest.settings:get("mobs_balrog_damage"))
if (DAMAGE == nil) then
	DAMAGE = 20
end

local PATH_FINDER = tonumber(minetest.settings:get("mobs_balrog_pathfinding"))
if (PATH_FINDER == nil) then
	PATH_FINDER = 1
end


--
-- Balrog entity
--

mobs:register_mob("mobs_balrog:balrog", {
	nametag = "",
	type = "monster",
	hp_min = MIN_HP,
	hp_max = MAX_HP,
	armor = 100,
	walk_velocity = 3.5,
	run_velocity = 5.2,
	walk_chance = WALK_CHANCE,
	jump_height = 16,
	stepheight = 2.2,
	view_range = VIEW_RANGE,
	damage = DAMAGE,
	knock_back = false,
	fear_height = 0,
	fall_damage = 0,
	water_damage = 7,
	lava_damage = 0,
	light_damage = 0,
	suffocation = false,
	floats = 0,
	reach = 5,
	attack_animals = true,
	group_attack = true,
	attack_type = "dogfight",
	blood_amount = 0,
	pathfinding = PATH_FINDER,
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_balrog_howl",
		death = "mobs_balrog_howl",
		attack = "mobs_balrog_stone_death"
	},
	drops = {
      {name = "mobs_balrog:balrog_whip",
		chance = 100,
		min = 1,
		max = 1}
	},
	visual = "mesh",
	visual_size = {x = 2, y = 2},
	collisionbox = {-0.8, -2.0, -0.8, 0.8, 2.5, 0.8},
	textures = {"mobs_balrog_balrog.png"},
	mesh = "mobs_balrog.b3d",
	rotate = 180,
	animation = {
      stand_start = 0,
      stand_end = 240,
      walk_start = 240,
      walk_end = 300,
		walk_speed = 30,
		run_speed = 45,
      punch_start = 300,
      punch_end = 380,
		punch_speed = 45,
	},
	on_die = function(self, pos)
		self.object:remove()

		minetest.after(0.0, function()
			-- This has been taken from ../tnt/init.lua @243
			minetest.add_particlespawner({
				amount = 128,
				time = 0.1,
				minpos = vector.subtract(pos, 10 / 2),
				maxpos = vector.add(pos, 10 / 2),
				minvel = {x = -3, y = 0, z = -3},
				maxvel = {x = 3, y = 5,  z = 3},
				minacc = {x = 0, y = -10, z = 0},
				maxacc = {x = 0, y = -10, z = 0},
				minexptime = 0.8,
				maxexptime = 2.0,
				minsize = 10 * 0.66,
				maxsize = 10 * 2,
				texture = "fire_basic_flame.png",
				collisiondetection = true,
			})
         --[[
			tnt.boom(pos, {
				name = "Balrog's Blast",
				radius = 6,
				damage_radius = 16,
				disable_drops = true,
				ignore_protection = false,
				ignore_on_blast = false,
				tiles = {""},
			})
         ]]--
		end)
	end,
})


--
-- Balrog's whip
--

minetest.register_tool("mobs_balrog:balrog_whip", {
   description = minetest.colorize("orange", S("Balrog Whip")) ..
      minetest.get_background_escape_sequence("darkred"),
   inventory_image = "mobs_balrog_balrog_whip.png^[transform3",
   on_use = function(itemstack, user, pointed_thing)
      if pointed_thing.type == "nothing" then
         local dir = user:get_look_dir()
         local pos = user:get_pos()
         for i = 1, 50 do
            local new_pos = {
               x = pos.x + (dir.x * i),
               y = pos.y + (dir.y * i),
               z = pos.z + (dir.z * i),
            }
            if minetest.get_node(new_pos).name == "air"  and
            not minetest.is_protected(new_pos, user:get_player_name()) then
               minetest.set_node(new_pos, {name = "yl_commons:temp_flame"})
            end
         end
         if not minetest.setting_getbool("creative_mode") then
            itemstack:add_wear(65535/49)
            return itemstack
         end
      elseif pointed_thing.type == "object" then
         local obj = pointed_thing.ref
         minetest.add_particlespawner({
            amount = 40,
            time = 6,
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
            attached = obj,
            vertical = false,
            --  ^ vertical: if true faces player using y axis only
            texture = "fire_basic_flame.png",
         })
         obj:punch(user, 1, itemstack:get_tool_capabilities())
         for i = 1, 5 do
            minetest.after(i, function()
               if obj and user and itemstack then
                  obj:punch(user, 1, itemstack:get_tool_capabilities())
               end
            end)
         end
         if not minetest.setting_getbool("creative_mode") then
            itemstack:add_wear(65535/499)
            return itemstack
         end
      elseif pointed_thing.type == "node" then
         local pos = user:get_pos()
         local radius = 5
         for x = -radius, radius do
         for z = -radius, radius do
         for y = 10, -10, -1 do
            local new_pos = {
               x = pos.x + x,
               y = pos.y + y,
               z = pos.z + z,
            }

            local node =  minetest.get_node(new_pos)
            local nodeu = minetest.get_node({x = new_pos.x, y = new_pos.y - 1, z = new_pos.z})
            local value = x * x + z * z
            if value <= radius * radius + 1
            and node.name == "air" and nodeu.name ~= "air"
            and not minetest.is_protected(new_pos, user:get_player_name()) then
               minetest.set_node(new_pos, {name = "yl_commons:temp_flame"})
               break
            end
         end
         end
         end
         if not minetest.setting_getbool("creative_mode") then
            itemstack:add_wear(65535/49)
            return itemstack
         end
      end
   end,
   tool_capabilities = {
      full_punch_interval = 0.25,
      max_drop_level=2,
      groupcaps={
         snappy={times={[1]=1.60, [2]=1.30, [3]=0.90}, uses=50, maxlevel=3},
      },
      damage_groups = {fleshy=5},
   },
   on_die = function(self, pos)
		self.object:remove()

		-- This has been taken from ../tnt/init.lua @243
		minetest.add_particlespawner({
			amount = 128,
			time = 0.1,
			minpos = vector.subtract(pos, 10 / 2),
			maxpos = vector.add(pos, 10 / 2),
			minvel = {x = -3, y = 0, z = -3},
			maxvel = {x = 3, y = 5,  z = 3},
			minacc = {x = 0, y = -10, z = 0},
			maxacc = {x = 0, y = -10, z = 0},
			minexptime = 0.8,
			maxexptime = 2.0,
			minsize = 10 * 0.66,
			maxsize = 10 * 2,
			texture = "fire_basic_flame.png",
			collisiondetection = true,
		})
	end,
	on_blast = function(self, damage)
		return false, false, {}
	end,
        light_source = 14,
})


--
-- Barlog's spawner
--


mobs:spawn({name = "mobs_balrog:balrog",
	nodes = {"group:cracky"},
	max_light = MAX_LIGHT,
	min_light = MIN_LIGHT,
	interval = INTERVAL,
	chance = CHANCE,
	active_object_count = MAX_NUMBER,
	min_height = MIN_HEIGHT,
	max_height = MAX_HEIGHT,
})

mobs:register_egg("mobs_balrog:balrog",
	"Balrog",
	"default_lava.png", -- the texture displayed for the egg in inventory
	1, -- egg image in front of your texture (1 = yes, 0 = no)
	false -- if set to true this stops spawn egg appearing in creative
)

mobs:alias_mob("mobs:balrog", "mobs_balrog:balrog")


--
-- Minetest engine debug logging
--

if (minetest.settings:get("debug_log_level") == nil)
or (minetest.settings:get("debug_log_level") == "action")
or	(minetest.settings:get("debug_log_level") == "info")
or (minetest.settings:get("debug_log_level") == "verbose")
then

	minetest.log("action", "[Mod] Mobs Balrog [v0.4.0] loaded.")
end
