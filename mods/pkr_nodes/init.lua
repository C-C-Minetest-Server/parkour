pkr_nodes = {
    S = minetest.get_translator(minetest.get_current_modname()),
    N = minetest.get_current_modname()
}
local S = pkr_nodes.S
local log = minetest.global_exists("log_util") and log_util.logger() or function() return end

function pkr_nodes.register_base_node(color,display_name,modname)
    if not display_name then display_name = color end
    if not modname then modname = minetest.get_current_modname() end
    log("action","Registering base node of " .. color)
    minetest.register_node(modname .. ":" .. color .. "_light",{
        description = S("@1 Base Node (Light)",display_name),
        tiles = {"pkr_nodes_base.png^[colorize:#" .. color .. ":40"},
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
        is_ground_content = false,
    })
    minetest.register_alias(modname .. ":" .. color,modname .. ":" .. color .. "_light")
    minetest.register_node(modname .. ":" .. color .. "_dark",{
        description = S("@1 Base Node (Dark)",display_name),
        tiles = {"pkr_nodes_base.png^[colorize:#" .. color .. ":80"},
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
        is_ground_content = false,
    })
    minetest.register_node(modname .. ":" .. color .. "_light_half",{
        description = S("@1 Base Node (Half Light)",display_name),
        tiles = {"pkr_nodes_base.png^[colorize:#" .. color .. ":80"},
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
        light_source = minetest.LIGHT_MAX / 2,
        paramtype = "light",
        is_ground_content = false,
    })
    minetest.register_node(modname .. ":" .. color .. "_light_full",{
        description = S("@1 Base Node (Full Light)",display_name),
        tiles = {"pkr_nodes_base.png^[colorize:#" .. color .. ":80"},
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
        light_source = minetest.LIGHT_MAX,
        paramtype = "light",
        is_ground_content = false,
    })
    minetest.register_node(modname .. ":" .. color .. "_glass",{
        description = S("@1 Base Node (Glasslike)",display_name),
        tiles = {"pkr_nodes_transparent.png^[colorize:#" .. color .. ":80"},
        drawtype = "glasslike",
        use_texture_alpha = "blend",
        sunlight_propagates = true,
        paramtype = "light",
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
        is_ground_content = false,
    })
end

for x,y in pairs({
    ["FFFFFF"] = S("White"),
    ["FF0000"] = S("Red"),
    ["00FF00"] = S("Green"),
    ["0000FF"] = S("Blue"),
}) do
    pkr_nodes.register_base_node(x,y)
end

minetest.register_node(pkr_nodes.N .. ":barrier",{
    description = S("Barrier"),
    drawtype = "airlike",
    groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
    inventory_image = "air.png",
    wield_image = "air.png",
    sunlight_propagates = true,
    paramtype = "light",
    is_ground_content = false,
})

minetest.register_node(pkr_nodes.N .. ":end",{
    description = S("End Point"),
    tiles = {"pkr_nodes_base.png^[colorize:#0000FF:80^pkr_nodes_end.png"},
    groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
    is_ground_content = false,
})

minetest.register_node(pkr_nodes.N .. ":restart",{
    description = S("Restart Point"),
    tiles = {"pkr_nodes_base.png^[colorize:#FF0000:80^pkr_nodes_end.png"},
    groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 },
    is_ground_content = false,
})

--Extract from block in blocks, and h-v-smacker's technic fork's trampoline code
minetest.register_node(pkr_nodes.N .. ":bounce_half", {
	description = S("Half Bouncy Block"),
	drawtype = "mesh",
	mesh = "block_in_block.obj",
	tiles = {"pkr_nodes_base.png^[colorize:#00FF00:80", "pkr_nodes_transparent.png^[colorize:#00FF00:70"},
	paramtype = "light",
	is_ground_content = false,
	groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1, bouncy = 75, fall_damage_add_percent = -100},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},
    use_texture_alpha = "blend",
    is_ground_content = false,
})

minetest.register_node(pkr_nodes.N .. ":bounce_full", {
	description = S("Full Bouncy Block"),
	drawtype = "mesh",
	mesh = "block_in_block.obj",
	tiles = {"pkr_nodes_base.png^[colorize:#00FF00:80", "pkr_nodes_transparent.png^[colorize:#00FF00:70"},
	paramtype = "light",
	is_ground_content = false,
	groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1, bouncy = 100, fall_damage_add_percent = -100},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},
    use_texture_alpha = "blend",
})

-- Facedir codes extracted from mtg furnace
minetest.register_node(pkr_nodes.N .. ":lock_locked", {
	description = S("Lock Block"),
	tiles = {"pkr_nodes_transparent.png^[colorize:#FF0000:70^pkr_nodes_lock.png"},
	is_ground_content = false,
	groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
})

local _ = S("Unlocked Lock Block") -- i18n.py workaround
minetest.register_node(pkr_nodes.N .. ":lock_unlocked", {
	description = S("YOU HACKER YOU! @1",S("Unlocked Lock Block")),
	tiles = {"pkr_nodes_transparent.png^[colorize:#FF0000:70^pkr_nodes_lock_open.png"},
	is_ground_content = false,
	groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1, not_in_creative_inventory = 1},
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
})

log("info","Loaded")
