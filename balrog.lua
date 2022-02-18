local settings = mobs_balrog.settings

mobs:register_mob("mobs_balrog:balrog", {
    nametag = "",
    type = "monster",
    hp_min = settings.hp_min,
    hp_max = settings.hp_max,
    armor = {
        fleshy = 50,
        fire = 0,
    },
    lifetimer = settings.lifetimer,
    walk_velocity = 3.5,
    run_velocity = 5.2,
    walk_chance = settings.walk_chance,
    jump_height = 16,
    stepheight = 2.2,
    replace_rate = 1,
    replace_what = "air",
    replace_with = settings.flame_node,
    replace_offset = -2,
    view_range = settings.view_range,
    knock_back = false,
    immune_to = {
        {"mobs_balrog:balrog_whip"},
    },
    fear_height = 0,
    fall_damage = 0,
    water_damage = 7,
    lava_damage = 0,
    fire_damage = 0,
    light_damage = 0,
    suffocation = 0,
    floats = 0,
    reach = 5,
    attack_animals = true,
    attack_monsters = true,
    group_attack = true,
    attack_type = "dogfight",
    blood_amount = 0,
    pathfinding = settings.pathfinding,
    makes_footstep_sound = true,
    sounds = {
        war_cry = "mobs_balrog_howl",
        death = "mobs_balrog_howl",
        attack = "mobs_balrog_stone_death"
    },
    drops = {{
                 name = "mobs_balrog:balrog_whip",
                 chance = settings.whip_drop_chance,
                 min = 1,
                 max = 1
             }},
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
    custom_attack = mobs_balrog.api.custom_attack,
    on_die = mobs_balrog.api.on_die,
    do_custom = mobs_balrog.api.do_custom,
})

mobs:register_egg("mobs_balrog:balrog",
    "Balrog",
    "default_lava.png", -- the texture displayed for the egg in inventory
    1, -- egg image in front of your texture (1 = yes, 0 = no)
    false -- if set to true this stops spawn egg appearing in creative
)
