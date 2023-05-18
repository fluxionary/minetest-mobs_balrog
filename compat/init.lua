local has = mobs_balrog.has

if has["3d_armor"] then
	mobs_balrog.dofile("compat", "armor")
end

if has.invisibility then
	mobs_balrog.dofile("compat", "invisibility")
end

mobs_balrog.dofile("compat", "other_mobs")
