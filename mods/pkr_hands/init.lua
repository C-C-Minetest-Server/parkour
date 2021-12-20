pkr_hands = {
	N = minetest.get_current_modname()
}

minetest.register_item(':', {
	type = 'none',
	wield_image = "pkr_nodes_base.png^[colorize:#00FF00:40",
	wield_scale = {x = 0.5, y = 1, z = 4},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			diggable = {
				times = {[1] = 0.70},
				uses = 0,
				},
				},
				damage_groups = {},
			}
			})
