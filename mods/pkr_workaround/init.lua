minetest.register_on_respawnplayer(function()
    minetest.chat_send_all(minetest.translate("pkr_main","Performing Restart..."))
    minetest.after(0,pkr_main.load_level,pkr_main.level)
    return true
end)
