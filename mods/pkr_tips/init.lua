pkr_tips = {
    S = minetest.get_translator(minetest.get_current_modname()),
    N = minetest.get_current_modname()
}
local S = pkr_tips.S

local log = log_util.logger()

function pkr_tips.SEND(tips)
    pkr_init.SEND(S("Tips: @1",tips))
end

-- Restart! (FAQ and the reason I failed the jam)
local was_alerted_restart = false
local keep_ground_time = 0
minetest.register_globalstep(function(dtime)
    if was_alerted_restart then return end
    if not pkr_init.PLAYER then return end
    local pos = pkr_init.PLAYER:get_pos()
    if pos.y <= 1 then
        keep_ground_time = keep_ground_time + dtime
        if keep_ground_time > 5 then
            log("action","Tips: You can use the /restart command if you get stuck.")
            pkr_tips.SEND(S("You can use the /restart command if you get stuck."))
            was_alerted_restart = true
        end
    else
        keep_ground_time = 0
    end
end)
