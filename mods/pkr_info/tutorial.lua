local S = pkr_info.S

local contents = {
    S("Punch the end block (the blue block with a circle)"),
    S("to end the game."),
    S("Note that the red simular one is the restart block,"),
    S("it's a trap!"),
    "",
    S("The semi-transparent block are bouncy."),
    S("There are two types, full (100%) and half (75%)."),
    "",
    S("Punch lock blocks to unlock them."),
    S("You have to unlock all of them to end the game."),
    "",
    S("Blocks with a cross inside a square are jump"),
    S("preventors. So be careful!"),
    "",
    S("Some blocks looks like a text editor."),
    S("Hover on it to look its text."),
    "",
    S("The block with 5 points plotted on its texture is the"),
    S("GOTO block. Punch it to jump to other level.")
}

return pkr_info.N .. ":tutorial", S("Tutorial"), contents
