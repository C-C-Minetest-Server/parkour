sfinv_info = {
	S = minetest.get_translator(minetest.get_current_modname()),
	N = minetest.get_current_modname()
}

function sfinv_info.register(name, title, content)
	sfinv.register_page(name, {
		title = title,
		get = function(self, player, context)
return sfinv.make_formspec(player, context,
"textlist[0,0;7.85,8.5;help;" .. content .. "]", false)
		end
	})
end
