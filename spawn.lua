local settings = mobs_balrog.settings

mobs:spawn({name = "mobs_balrog:balrog",
    nodes = {"group:stone"},
    max_light = settings.max_light,
    min_light = settings.min_light,
    interval = settings.spawn_interval,
    chance = settings.spawn_chance,
    active_object_count = settings.active_object_count,
    min_height = settings.min_height,
    max_height = settings.max_height,
})
