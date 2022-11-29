for name, _ in pairs(minetest.registered_entities) do
	if name:match("^yl_cities:") then
		mobs_balrog.api.blacklist_target(name)
	end
end
