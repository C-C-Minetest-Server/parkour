pkr_init = {
    N = minetest.get_current_modname(),
    MP = minetest.get_modpath(minetest.get_current_modname())
}
local log = log_util.logger()

if not minetest.is_singleplayer() then
    error("This game can only play in singleplayer mode.")
end
minetest.set_mapgen_setting("mgname", "singlenode", true)
minetest.register_on_joinplayer(function(ObjectRef, last_login)
    if ObjectRef:get_player_name() == "singleplayer" then
        pkr_init.PLAYER = ObjectRef
        pkr_init.PLAYER:set_armor_groups({immoral=1})
    end
end)
log("info","Loaded")
