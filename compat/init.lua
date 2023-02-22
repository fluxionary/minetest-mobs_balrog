local has = mobs_balrog.has

if has.armor then
	mobs_balrog.dofile("compat", "armor")
end

if has.invisibility then
	mobs_balrog.dofile("compat", "invisibility")
end

if has.yl_cities then
	mobs_balrog.dofile("compat", "yl_cities")
end

if has.yl_events then
	mobs_balrog.dofile("compat", "yl_events")
end

if has.yl_speak_up then
	mobs_balrog.dofile("compat", "yl_speak_up")
end

mobs_balrog.dofile("compat", "other_mobs")
