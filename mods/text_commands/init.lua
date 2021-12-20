text_commands = {
    N = minetest.get_current_modname(),
    registered_text_commands = {}
}

function text_commands.register_text_command(name,def)
    text_commands.registered_text_commands[name] = def
end

function text_commands.unregister_text_command(name)
    text_commands.registered_text_commands[name] = nil
end


minetest.register_on_chat_message(function(name,msg)
    if msg:sub(1, 1) == "/" then
        return
    end
    minetest.after(0.2,function()
        for x,y in pairs(text_commands.registered_text_commands) do
            if y.privs then
                local can, missing =  minetest.check_player_privs(name, y.privs)
                if not can then
                    local p_str = ""
                    for _,z in pairs(missing) do
                        p_str = p_str .. " " .. z
                    end
                    minetest.chat_send_player(name,("-!- Text command failed (missing privs:%s)."):format(p_str))
                    break
                end
            end
            if msg:find(x) then
                local status, return_msg = y.func(name,msg)
                if status == false and return_msg == nil then
                    minetest.chat_send_player(name,"-!- Text command failed.")
                elseif return_msg ~= nil then
                    minetest.chattrue_send_player(name,tostring(return_msg))
                end
                return
            end
        end
    end)
end)

text_commands.register_text_command("help",{
    description = "Show a list of text commands",
    func = function(name,msg)
        local RSTR = "Text commands:"
        for x,y in pairs(text_commands.registered_text_commands) do
            RSTR = RSTR .. "\n" .. x .. ": " .. y.description or ""
        end
        return true, RSTR
    end
})
