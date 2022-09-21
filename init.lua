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
