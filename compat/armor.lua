local has = mobs_balrog.has

armor:register_armor_group("fire", 100)

local function add_fire_protection(name, amount)
    local def = minetest.registered_items[name]
    if not def then
        mobs_balrog.log("warning", "no def for %s", name)
        return
    end
    if not def.armor_groups then
        error(("no armor_groups for %s"):format(name))
    end
    local armor_groups = table.copy(def.armor_groups)
    armor_groups.fire = amount
    minetest.override_item(name, {armor_groups = armor_groups})
    mobs_balrog.log("action", "adding fire protection to %s", name)
end

add_fire_protection("3d_armor:boots_admin", 200)
add_fire_protection("3d_armor:chestplate_admin", 200)
add_fire_protection("3d_armor:helmet_admin", 200)
add_fire_protection("3d_armor:leggings_admin", 200)
if has.shields then
    -- errors out, because it has no armor groups defined :\
    --add_fire_protection("shields:shield_admin", 200)
    minetest.override_item("shields:shield_admin", {
        armor_groups = {
            fleshy = 1000,
            fire = 200,
        }
    })
end

if has.ethereal then
    add_fire_protection("3d_armor:boots_crystal", 10)
    add_fire_protection("3d_armor:chestplate_crystal", 10)
    add_fire_protection("3d_armor:helmet_crystal", 10)
    add_fire_protection("3d_armor:leggings_crystal", 10)
    if has.shields then
        add_fire_protection("shields:shield_crystal", 10)
    end
end

if has.nether then
    add_fire_protection("3d_armor:boots_nether", 15)
    add_fire_protection("3d_armor:chestplate_nether", 15)
    add_fire_protection("3d_armor:helmet_nether", 15)
    add_fire_protection("3d_armor:leggings_nether", 15)
    if has.shields then
        add_fire_protection("shields:shield_nether", 15)
    end
end

if has.nether_mobs then
    add_fire_protection("nether_mobs:dragon_boots", 50)
    add_fire_protection("nether_mobs:dragon_chestplate", 50)
    add_fire_protection("nether_mobs:dragon_helmet", 50)
    add_fire_protection("nether_mobs:dragon_leggings", 50)
    if has.shields then
        add_fire_protection("nether_mobs:dragon_shield", 50)
    end
end

if has.rainbow_ore then
    if has.shields then
        add_fire_protection("shields:shield_rainbow", 20)
    end
end
