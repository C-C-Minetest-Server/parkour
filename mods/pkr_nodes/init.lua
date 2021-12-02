pkr_nodes = {
    S = minetest.get_translator(minetest.get_current_modname()),
    N = minetest.get_current_modname()
}
S = pkr_nodes.S
function pkr_nodes.register_base_node(color,display_name,modname)
    if not display_name then display_name = color end
    if not modname then modname = minetest.get_current_modname() end
    minetest.register_node(modname .. ":" .. color .. "_light",{
        description = S("@1 Base Node (Light)",display_name),
        tiles = {"pkr_nodes_base.png^[colorize:#" .. color .. ":40"},
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 }
    })
    minetest.register_alias(modname .. ":" .. color,modname .. ":" .. color .. "_light")
    minetest.register_node(modname .. ":" .. color .. "_dark",{
        description = S("@1 Base Node (Dark)",display_name),
        tiles = {"pkr_nodes_base.png^[colorize:#" .. color .. ":80"},
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 }
    })
    minetest.register_node(modname .. ":" .. color .. "_glass",{
        description = S("@1 Base Node (Glasslike)",display_name),
        tiles = {"pkr_nodes_transparent.png^[colorize:#" .. color .. ":80"},
        drawtype = "glasslike",
        use_texture_alpha = "blend",
        sunlight_propagates = true,
        groups = { oddly_breakable_by_hand = 3, pkr_nodes = 1 }
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
    wield_image = "air.png"
})
