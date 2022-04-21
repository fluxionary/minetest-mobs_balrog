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
   Rewrite:
       flux (C) 2022 (LGPL v2.1, i guess, i'd prefer AGPL)

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
local modname = minetest.get_current_modname()
local get_modpath = minetest.get_modpath
local modpath = minetest.get_modpath(modname)

mobs_balrog = {
    modname = modname,
    modpath = modpath,

    S = minetest.get_translator(modname),
    log = function(level, messagefmt, ...)
        minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
    end,
    has = {
        armor = get_modpath("3d_armor"),
        armor_monoid = get_modpath("armor_monoid"),
        ethereal = get_modpath("ethereal"),
        invisibility = get_modpath("invisibility"),
        nether = get_modpath("nether"),
        nether_mobs = get_modpath("nether_mobs"),
        pvpplus = get_modpath("pvpplus"),
        rainbow_ore = get_modpath("rainbow_ore"),
        shields = get_modpath("shields"),
        yl_cities = get_modpath("yl_cities"),
        yl_events = get_modpath("yl_events"),
        yl_speak_up = get_modpath("yl_speak_up"),
    },

	dofile = function(...)
		dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

mobs_balrog.dofile("settings")
mobs_balrog.dofile("api", "init")
mobs_balrog.dofile("entity")
mobs_balrog.dofile("spawn")
mobs_balrog.dofile("whip")

if mobs_balrog.settings.flame_node == "mobs_balrog:flame" then
    mobs_balrog.dofile("flame_node")
end

mobs_balrog.dofile("compat", "init")

mobs_balrog.dofile("aliases")
