-- luacheck: globals minetest
local ent_def = minetest.registered_entities["mobs_balrog:balrog"]

local old_get_staticdata = ent_def.get_staticdata

function ent_def.get_staticdata(self)
	mobs_balrog.log("action", "[debug] get_staticdata -> %s", dump(self))
	return old_get_staticdata(self)
end
