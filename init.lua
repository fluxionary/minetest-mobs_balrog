futil.check_version({ year = 2023, month = 11, day = 1 }) -- is_player

mobs_balrog = fmod.create()

mobs_balrog.settings.whip_tool_capabilities = {
	full_punch_interval = 1,
	max_drop_level = 3,
	damage_groups = {
		fleshy = mobs_balrog.settings.fleshy_damage,
		fire = mobs_balrog.settings.fire_damage,
	},
}

mobs_balrog.settings.fire_tool_capabilities = {
	full_punch_interval = 1,
	max_drop_level = 3,
	damage_groups = {
		fire = mobs_balrog.settings.fire_damage,
	},
}

mobs_balrog.dofile("api", "init")
mobs_balrog.dofile("entity")
mobs_balrog.dofile("spawn")
mobs_balrog.dofile("whip")

if mobs_balrog.settings.flame_node == "mobs_balrog:flame" then
	mobs_balrog.dofile("flame_node")
end

mobs_balrog.dofile("compat", "init")

mobs_balrog.dofile("aliases")

if mobs_balrog.settings.debug then
	mobs_balrog.dofile("debug")
end
