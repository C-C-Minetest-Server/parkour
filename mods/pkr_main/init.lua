pkr_main = {
    S = minetest.get_translator(minetest.get_current_modname()),
    N = minetest.get_current_modname(),
    MP = minetest.get_modpath(minetest.get_current_modname()),
    state = false,
}
local S = pkr_main.S
local MS = minetest.get_mod_storage()
local schems_prefix = pkr_main.MP .. "/schems/"
local config_prefix = pkr_main.MP .. "/config/"
local log = log_util.logger()
local c_details = {}

pkr_main.level = MS:get_int("level")
print(pkr_main.level)

-- minetest.place_schematic(pos, schematic, rotation, replacements, force_placement, flags)
local LVLS = {}
do
    local now_lvl = 0
    while true do
        local now_set = Settings(config_prefix .. tostring(now_lvl) .. ".conf")
        local x = now_set:get("x")
        local y = now_set:get("y")
        local z = now_set:get("z")
        local locks = tonumber(now_set:get("locks")) or 0
        local description = now_set:get("description")
        if not description or description == "" then
            description = S("No description avaliable")
        end
        if not (x and y and z) then
            break
        end
        LVLS[now_lvl] = {pos = {x=tonumber(x),y=tonumber(y),z=tonumber(z)},description = description,locks=locks}
        now_lvl = now_lvl + 1
    end
end


function pkr_main.load_level(level)
    if not LVLS[level] then
        log("warning","Level " .. tostring(level) .. " does not exists!")
        return
    end
    pkr_main.level = level
    MS:set_int("level",level)
    pkr_init.state = false
    c_details = {}
    minetest.chat_send_all(S("Going to level @1...",tostring(level)))
    freeze.freeze(pkr_init.PLAYER)
    minetest.delete_area({x=0,y=0,z=0}, {x=30,y=30,z=30})
    minetest.place_schematic({x=0,y=0,z=0}, schems_prefix .. tostring(level) .. ".mts",
        0,{},true)
    freeze.release(pkr_init.PLAYER)
    pkr_init.PLAYER:set_pos(LVLS[level].pos)
    minetest.chat_send_all(S("Level Description: @1",LVLS[level].description))
    pkr_init.state = true
end

function pkr_main.end_level(force)
    if not force then
        if c_details.unlocked == nil or c_details.unlocked < LVLS[pkr_main.level].locks then
            minetest.chat_send_all(S("Please unlock all locks!"))
            return false
        end
    end
    minetest.chat_send_all(S("Level complete!"))
    local will_lvl = pkr_main.level
    if LVLS[pkr_main.level + 1] then
        will_lvl = pkr_main.level + 1
    end
    pkr_main.load_level(will_lvl)
end


minetest.override_item(pkr_nodes.N .. ":end",{
    on_punch = function()
        pkr_main.end_level(false)
    end,
})

minetest.override_item(pkr_nodes.N .. ":restart",{
    on_punch = function()
        minetest.chat_send_all(S("Performing Restart..."))
        pkr_main.load_level(pkr_main.level)
    end
})

minetest.override_item(pkr_nodes.N .. ":lock_locked",{
    on_punch = function(pos)
        local node = minetest.get_node(pos)
        node.name = pkr_nodes.N .. ":lock_unlocked"
        minetest.swap_node(pos,node)
        if not c_details.unlocked then c_details.unlocked = 0 end
        c_details.unlocked = c_details.unlocked + 1
        local remain = LVLS[pkr_main.level].locks - c_details.unlocked
        if remain == 0 then
            minetest.chat_send_all(S("All lock(s) unlocked! Go ahead!"))
        else
            minetest.chat_send_all(S("Lock unlocked, @1 locks remaining.",tostring(remain)))
        end
    end
})

minetest.register_on_joinplayer(function(ObjectRef, last_login)
    if ObjectRef:get_player_name() == "singleplayer" then
        minetest.after(0.2,pkr_main.load_level,pkr_main.level)
    end
end)

minetest.register_chatcommand("restart",{
    description = S("Restart the current level"),
    func = function(name,param)
        pkr_main.load_level(pkr_main.level)
        return true, S("Level restarted")
    end
})
cmd_alias.create_alias("restart","re","r")

minetest.register_chatcommand("goto",{
    description = S("Skip to a level"),
    func = function(name,param)
        level = tonumber(param)
        if LVLS[level] then
            pkr_main.load_level(level)
            return true, S("Level skipped!")
        end
        return false, S("Level skip failed!")
    end
})
cmd_alias.create_alias("goto","g","go","to")

log("info","Loaded")
