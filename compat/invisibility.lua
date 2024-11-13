--[[
	remove invisibility from invisible players.

	-- TODO: make this part of an external API? it should just be part of invisibility, honestly
]]

-- Function was renamed https://codeberg.org/tenplus1/invisibility/issues/1
local invisible = invisible or invisibility.invisible

-- TODO: configurable?
local sense_phrases = {
	"Fee fie foe fum, I smell the blood of an adventurer...",
	"I sense thee...",
	"I thought I felt *something*",
	"I sense thee, although thou hide...",
	"Well now, who is this, who creeps along in the shadows?",
}

-- TODO: configurable?
local reveal_phrases = {
	"Become visible!",
	"Be made visible!",
	"Be seen, be dead!",
	"Be seen!",
	"You are exposed!",
	"There they are, attack!",
	"Show Yourself!",
}

mobs_balrog.api.register_on_do_custom(function(self, dtime)
	self.player_invisibility_target = self.player_invisibility_target or ""
	self.invisibility_sensor = (self.invisibility_sensor or 0) + dtime

	if self.invisibility_sensor > 3 then
		self.invisibility_sensor = 0

		local p = self.object and self.object:get_pos()
		if not p then
			-- we don't actually exist, give up
			return
		end

		local players = minetest.get_connected_players()
		for i = 1, #players do
			local player = players[i]
			if p:distance(player:get_pos()) <= mobs_balrog.settings.invisibility_radius then
				local pname = player:get_player_name()
				local is_staff = minetest.check_player_privs(pname, { staff = true })
				local is_invisible = invisibility[pname]
				local is_target = self.player_invisibility_target == pname

				if is_invisible and not is_target and not is_staff then
					local str = sense_phrases[math.random(1, #sense_phrases)]
					minetest.chat_send_player(pname, str)
					self.player_invisibility_target = pname
				elseif is_invisible and is_target then
					local str = reveal_phrases[math.random(1, #reveal_phrases)]
					minetest.chat_send_player(pname, str)
					if minetest.global_exists("invisible") then
						invisible(player, false)
					else
						invisibility[pname] = nil
					end
				end
			end
		end
	end
end)
