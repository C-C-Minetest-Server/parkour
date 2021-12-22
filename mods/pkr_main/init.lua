pkr_main = {
    S = minetest.get_translator(minetest.get_current_modname()),
    N = minetest.get_current_modname(),
    MP = minetest.get_modpath(minetest.get_current_modname()),
    state = false
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
        local news = now_set:get("news")
        if news == "" then
            news = nil
        end
        local locks = tonumber(now_set:get("locks")) or 0
        local description = now_set:get("description")
        if not description or description == "" then
            description = S("No description avaliable")
        end
        if not (x and y and z) then
            break
        end
        LVLS[now_lvl] = {
            pos = {x = tonumber(x), y = tonumber(y), z = tonumber(z)},
            description = description,
            locks = locks,
            news = news
        }
        for _, n in pairs({1, 2, 3, 4, 5, 6, 7, 8, 9}) do
            LVLS[now_lvl]["text_" .. n] = now_set:get("text_" .. n)
            LVLS[now_lvl]["goto_" .. n] = tonumber(now_set:get("goto_" .. n))
        end
        now_lvl = now_lvl + 1
    end
end
pkr_main.LEVELS = LVLS

function pkr_main.load_level(level)
    MS:set_int("top_level", MS:get_int("top_level") < level and level or MS:get_int("top_level"))
    if not LVLS[level] then
        log("warning", "Level " .. tostring(level) .. " does not exists!")
        return
    end
    pkr_main.level = level
    MS:set_int("level", level)
    pkr_init.state = false
    pkr_init.PLAYER:get_inventory():set_list("main", {})
    pkr_init.PLAYER:get_inventory():set_list("craft", {})
    pkr_init.PLAYER:get_inventory():set_list("craftpreview", {})
    c_details = {}
    c_details.unlocked = 0
    pkr_init.SEND(S("Going to level @1...", tostring(level)))
    freeze.freeze(pkr_init.PLAYER)
    minetest.delete_area({x = 0, y = 0, z = 0}, {x = 30, y = 30, z = 30})
    minetest.place_schematic({x = 0, y = 0, z = 0}, schems_prefix .. tostring(level) .. ".mts", 0, {}, true)
    freeze.release(pkr_init.PLAYER)
    pkr_init.PLAYER:set_pos(LVLS[level].pos)
    pkr_init.SEND(S("Level Description: @1", LVLS[level].description))
    pkr_init.state = true
    if LVLS[level].news then
        pkr_init.SEND(S("Level Tips: @1", LVLS[level].news))
    end
end

function pkr_main.end_level(force, no_repeat)
    if not force then
        if c_details.unlocked < LVLS[pkr_main.level].locks then
            pkr_init.SEND(S("Please unlock all locks!"))
            return false
        end
    end
    pkr_init.SEND(S("Level complete!"))
    local will_lvl = pkr_main.level + 1
    if not LVLS[will_lvl] then
        if no_repeat then
            pkr_init.SEND(S("You've been finshed all levels! Use /goto <level> to play any levels again."))
            will_lvl = 0
        else
            will_lvl = pkr_main.level
        end
    end
    pkr_main.load_level(will_lvl)
end

minetest.override_item(pkr_nodes.N .. ":end",{
    on_punch = function()
        pkr_main.end_level(false)
    end
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
        minetest.swap_node(pos, node)
        c_details.unlocked = c_details.unlocked + 1
        local remain = LVLS[pkr_main.level].locks - c_details.unlocked
        if remain == 0 then
            minetest.chat_send_all(S("All lock(s) unlocked! Go ahead!"))
        else
            minetest.chat_send_all(S("Lock unlocked, @1 locks remaining.", tostring(remain)))
        end
    end
})

minetest.register_abm({
    label = "Text blocks",
    nodenames = {"group:text"},
    chance = 1,
    interval = 1,
    min_y = 0,
    max_y = 30,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local TEXT_ID = minetest.registered_nodes[node.name].groups.text
        minetest.get_meta(pos):set_string("infotext", LVLS[pkr_main.level]["text_" .. TEXT_ID])
    end
})

minetest.register_abm({
    label = "Goto blocks",
    nodenames = {"group:_goto"},
    chance = 1,
    interval = 1,
    min_y = 0,
    max_y = 30,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local GOTO_ID = minetest.registered_nodes[node.name].groups._goto
        minetest.get_meta(pos):set_string("infotext", "Go to " .. LVLS[pkr_main.level]["goto_" .. GOTO_ID])
    end
})

for _, y in pairs({1, 2, 3, 4, 5, 6, 7, 8, 9}) do
    minetest.override_item(pkr_nodes.N .. ":goto_" .. y,{
        on_punch = function(pos)
            local GOTO = LVLS[pkr_main.level]["goto_" .. y]
            if not GOTO then
                return
            end
            pkr_main.load_level(GOTO)
        end
    })
end

minetest.register_on_joinplayer(function(ObjectRef, last_login)
    if ObjectRef:get_player_name() == "singleplayer" then
        minetest.after(0.2, pkr_main.load_level, pkr_main.level)
    end
end)

minetest.register_chatcommand("restart",{
    description = S("Restart the current level"),
    func = function(name, param)
        pkr_main.load_level(pkr_main.level)
        return true, S("Level restarted")
    end
})

cmd_alias.create_alias("restart", "re", "r")
text_commands.register_text_command("restart",{
    description = S("Restart the current level"),
    func = function(name, param)
        pkr_main.load_level(pkr_main.level)
        return true, S("Level restarted")
    end
})

minetest.register_chatcommand("goto",{
    description = S("Skip to a level"),
    param = "<level ID>",
    func = function(name, param)
        local level = tonumber(param)
        if level and level > MS:get_int("top_level") and pkr_init.GAMEMODE == 0 then
            return false, "You are not in cheating mode."
        end
        if LVLS[level] then
            pkr_main.load_level(level)
            return true, S("Level skipped!")
        end
        return false, S("Level skip failed!")
    end
})
cmd_alias.create_alias("goto", "g", "go", "to")

minetest.register_chatcommand("end",{
    description = S("End this level (cheating mode only)"),
    param = "[<force>]",
    func = function(name, param)
        if pkr_init.GAMEMODE == 0 then
            return false, "You are not in cheating mode."
        end
        pkr_main.end_level(param == "1" or param == "true")
    end
})
cmd_alias.create_alias("end", "e")

log("info", "Loaded")
