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
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

mobs_balrog = {
    modname = modname,
    modpath = modpath,

    S = minetest.get_translator(modname),
    log = function(level, messagefmt, ...)
        minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
    end,
    has = {
        armor = minetest.get_modpath("3d_armor"),
        armor_monoid = minetest.get_modpath("armor_monoid"),
        shields = minetest.get_modpath("shields"),
        ethereal = minetest.get_modpath("ethereal"),
        nether_mobs = minetest.get_modpath("nether_mobs"),
        nether = minetest.get_modpath("nether"),
        rainbow_ore = minetest.get_modpath("rainbow_ore"),

        fire = minetest.get_modpath("fire"),
        yl_commons = minetest.get_modpath("yl_commons"),

        invisibility = minetest.get_modpath("invisibility"),
    }
}

dofile(modpath .. "/settings.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/balrog.lua")
dofile(modpath .. "/spawn.lua")
dofile(modpath .. "/whip.lua")

if mobs_balrog.settings.flame_node == "mobs_balrog:flame" then
    if mobs_balrog.has.fire then
        dofile(modpath .. "/flame_node.lua")
    else
        error("mobs_balrog needs either fire or yl_commons")
    end
end
if mobs_balrog.has.armor then
    dofile(modpath .. "/compat/armor.lua")
end
dofile(modpath .. "/compat/other_mobs.lua")

dofile(modpath .. "/aliases.lua")
