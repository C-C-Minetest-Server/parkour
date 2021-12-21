local S = pkr_info.S

local contents = {
    S("Credits:"),
    S("All: Emojiminetest"),
    S("Supports: My family members"),
    S("Idea: Minecraft YouTubers"),
    S("Money Price (if any): GreenXenith and others"),
    "",
    "Links:",
    "  " .. "ContentDB:",
    "  " .. "https://content.minetest.net/packages/",
    "  " .. "Emojiminetest/parkour/",
    "  " .. "GitHub:",
    "  " .. "https://github.com/C-C-Minetest-Server/parkour",
    "",
    "Facing issues? report it to",
    "https://github.com/C-C-Minetest-Server/parkour/issues",
}

return pkr_info.N .. ":credits", S("Credits"), contents
