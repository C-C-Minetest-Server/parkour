log_util = {
    N = minetest.get_current_modname(),
    MP = minetest.get_modpath(minetest.get_current_modname())
}

function log_util.log(level,message,mod)
    minetest.log(level,"[" .. mod .. "] " .. message)
end

function log_util.logger(mod)
    if not mod then mod = minetest.get_current_modname() end
    return function(level,message)
        log_util.log(level,message,mod)
    end
end
