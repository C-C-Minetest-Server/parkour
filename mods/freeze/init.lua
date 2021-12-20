freeze = {
	N = minetest.get_current_modname(),
	MP = minetest.get_modpath(minetest.get_current_modname())
}
local victims = {}

-- Code extract from CTFv3
minetest.register_entity("freeze:freezer", {
	is_visible = false,
	physical = false,
	makes_footstep_sound = false,
	backface_culling = false,
	static_save = false,
	pointable = false,
	on_punch = function() return true end,
	})

	function freeze.freeze(player)
		local obj = minetest.add_entity(player:get_pos(), "freeze:freezer")
		if obj then
			player:set_attach(obj)
			victims[player:get_player_name()] = obj
			return true
		end
	end

	function freeze.release(player)
		if victims[player:get_player_name()] then
			victims[player:get_player_name()]:remove()
			victims[player:get_player_name()] = nil
			return true
		end
	end

	minetest.register_on_leaveplayer(freeze.release)
