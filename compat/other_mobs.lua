

minetest.register_on_mods_loaded(function()
    for name, def in pairs(minetest.registered_entities) do
        local updated = false
        if def.armor then
            if type(def.armor) == "number" then
                def.armor = {
                    fleshy = def.armor,
                    fire = def.armor,
                }
                updated = true

            elseif type(def.armor) == "table" then
                if not def.armor.fire and def.armor.fleshy then
                    def.armor = table.copy(def.armor)
                    def.armor.fire = def.armor.fleshy
                    updated = true

                end
            end
        elseif def.armor_groups then
            if type(def.armor_groups) == "number" then
                def.armor_groups = {
                    fleshy = def.armor_groups,
                    fire = def.armor_groups,
                }
                updated = true

            elseif type(def.armor_groups) == "table" then
                if not def.armor_groups.fire and def.armor_groups.fleshy then
                    def.armor_groups = table.copy(def.armor_groups)
                    def.armor_groups.fire = def.armor_groups.fleshy
                    updated = true

                end
            end
        end
        if updated then
            mobs_balrog.log("action", "adding fire protection to %s", name)
        end
    end
end)
