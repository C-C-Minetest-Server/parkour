pkr_info = {
    S = minetest.get_translator(minetest.get_current_modname()),
    N = minetest.get_current_modname(),
    MP = minetest.get_modpath(minetest.get_current_modname())
}

function pkr_info.make_from_table(name,title,contents)
    for i = 1, #contents do
        contents[i] = minetest.formspec_escape(contents[i])
    end
    local txt = table.concat(contents, ",")
    sfinv_info.register(name,title,txt)
end

local pages = {
    "tutorial",
    "credits",
}

for _,y in ipairs(pages) do
    pkr_info.make_from_table(dofile(pkr_info.MP .. "/" .. y .. ".lua"))
end
