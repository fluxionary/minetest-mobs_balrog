local has = mobs_balrog.has

armor.registered_groups.fire = 100

local function add_fire_protection(name, amount)
    local def = minetest.registered_items[name]
    if not def then
        error(("no def for %s"):format(name))
    end
    if not def.armor_groups then
        error(("no armor_groups for %s"):format(name))
    end
    local armor_groups = table.copy(def.armor_groups)
    armor_groups.fire = amount
    minetest.override_item(name, {armor_groups = armor_groups})
end

add_fire_protection("3d_armor:boots_admin", 200)
add_fire_protection("3d_armor:chestplate_admin", 200)
add_fire_protection("3d_armor:helmet_admin", 200)
add_fire_protection("3d_armor:leggings_admin", 200)
if has.shields then
    --add_fire_protection("shields:shield_admin", 200)
end

if has.ethereal then
    add_fire_protection("3d_armor:boots_crystal", 20)
    add_fire_protection("3d_armor:chestplate_crystal", 20)
    add_fire_protection("3d_armor:helmet_crystal", 20)
    add_fire_protection("3d_armor:leggings_crystal", 20)
    if has.shields then
        add_fire_protection("shields:shield_crystal", 20)
    end
end

if has.nether then
    add_fire_protection("3d_armor:boots_nether", 20)
    add_fire_protection("3d_armor:chestplate_nether", 20)
    add_fire_protection("3d_armor:helmet_nether", 20)
    add_fire_protection("3d_armor:leggings_nether", 20)
    if has.shields then
        add_fire_protection("shields:shield_nether", 20)
    end
end

if has.nether_mobs then
    add_fire_protection("nether_mobs:dragon_boots", 100)
    add_fire_protection("nether_mobs:dragon_chestplate", 100)
    add_fire_protection("nether_mobs:dragon_helmet", 100)
    add_fire_protection("nether_mobs:dragon_leggings", 100)
    if has.shields then
        add_fire_protection("nether_mobs:dragon_shield", 100)
    end
end

if has.rainbow_ore then
    if has.shields then
        add_fire_protection("shields:shield_rainbow", 20)
    end
end
