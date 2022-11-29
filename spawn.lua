local has = mobs_balrog.has
local settings = mobs_balrog.settings

mobs:spawn({
	name = "mobs_balrog:balrog",
	nodes = { "group:stone" },
	max_light = settings.max_light,
	min_light = settings.min_light,
	interval = settings.spawn_interval,
	chance = settings.spawn_chance,
	active_object_count = settings.active_object_count,
	min_height = settings.min_height,
	max_height = settings.max_height,
})

mobs:spawn({
	name = "mobs_balrog:balrog",
	nodes = { "group:stone" },
	max_light = settings.max_light,
	min_light = settings.min_light,
	interval = settings.spawn_interval,
	chance = settings.spawn_chance * 2,
	active_object_count = settings.active_object_count,
	min_height = settings.min_height,
	max_height = (3 * settings.min_height + settings.max_height) / 4,
})

if has.nether and settings.spawn_in_nether then
	mobs:spawn({
		name = "mobs_balrog:balrog",
		nodes = { "nether:rack", "nether:rack_deep" },
		max_light = settings.max_light,
		min_light = settings.min_light,
		interval = settings.spawn_interval,
		chance = settings.spawn_chance,
		active_object_count = settings.active_object_count,
		min_height = nether.DEPTH_FLOOR,
		max_height = nether.DEPTH_CEILING,
	})
end
