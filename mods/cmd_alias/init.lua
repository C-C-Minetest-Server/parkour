cmd_alias = {
	N = minetest.get_current_modname(),
	MP = minetest.get_modpath(minetest.get_current_modname()),
	S = minetest.get_translator(minetest.get_current_modname()),
}
local S = cmd_alias.S
local log = log_util.logger()

function cmd_alias.create_alias(orig,...)
	if not minetest.registered_chatcommands[orig] then
		log("error","Attempt to register alias of not exist command " .. orig)
		return false
	end
	local CM = table.copy(minetest.registered_chatcommands[orig])
	CM.description = S("@1 (An alia of @2)",minetest.registered_chatcommands[orig].description,orig)
	for x,y in pairs({...}) do
		minetest.register_chatcommand(y,CM)
		log("action","Registered alias of " .. orig .. " as " .. y)
	end
end
