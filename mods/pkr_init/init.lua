pkr_init = {
    N = minetest.get_current_modname(),
    MP = minetest.get_modpath(minetest.get_current_modname()),
    VERSION = 2,
    SEND = minetest.chat_send_all
}
local log = log_util.logger()
local MS = minetest.get_mod_storage()
local CURRENTVERSION = MS:get_int("version")
CURRENTVERSION = CURRENTVERSION == 0 and 1 or CURRENTVERSION

if CURRENTVERSION ~= pkr_init.VERSION then
    log("warning",
        ("Version does not match, game == %d but world == %d"):format(CURRENTVERSION,pkr_init.VERSION))
    if pkr_init.VERSION - CURRENTVERSION ~= 1 then
        error(([[
        You are trying to upgrade a very old map (over 1 breaking changes) or
        loading a newer map.\n
        1. If you are trying to upgrade, download different versions step-by-step.
        Please download version %d to continue.\n
        2. If you are loading a newer map, upgrade your parkour game to version %d.\n
        3. If you think this is a bug, report it. (VERSION == %d)
        ]]):format(CURRENTVERSION + 1,CURRENTVERSION,pkr_init.VERSION))
    end
    log("warning","Upgrading map...")
    -- Upgrade code start here
    MS:set_int("mode",minetest.is_creative_enabled("singleplayer") and 1 or 0)
    -- Upgrade code end
    CURRENTVERSION = pkr_init.VERSION
    MS:set_int("version",pkr_init.VERSION)
end

log("info","Loading world version " .. CURRENTVERSION)
pkr_init.GAMEMODE = MS:get_int("mode")

if (minetest.is_creative_enabled("singleplayer") and 1 or 0) ~= pkr_init.GAMEMODE then
    error(("Game mode does not match! This world is created under %s mode."):format(
            pkr_init.GAMEMODE == 1 and "cheating" or "adventure"
        ))
end

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
