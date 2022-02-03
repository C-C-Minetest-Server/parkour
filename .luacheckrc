-- This file and luacheck workflow by CTF team
unused_args = false

globals = {
	"cmd_alias", "freeze", "log_util", "pkr_hands", "pkr_init", "pkr_main",
	"pkr_nodes", "player_api", "text_commands", "pkr_info", "sfinv_info", "sfinv",
    "pkr_tips",

	"vector",
	math = {
		fields = {
			"round",
			"hypot",
			"sign",
			"factorial",
			"ceil",
		}
	},

	"minetest", "core",
}

read_globals = {
	"DIR_DELIM",
	"dump", "dump2",
	"VoxelManip", "VoxelArea",
	"PseudoRandom", "PcgRandom",
	"ItemStack",
	"Settings",
	"unpack",

	table = {
		fields = {
			"copy",
			"indexof",
			"insert_all",
			"key_value_swap",
			"shuffle",
			"random",
		}
	},

	string = {
		fields = {
			"split",
			"trim",
		}
	},
}
