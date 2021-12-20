# Parkour Game for [Minetest](https://minetest.net)!
## Our goal
1. Make everything simple
2. Let our players enjoy our game
3. And of couse... [Money prizes!](https://forum.minetest.net/viewtopic.php?t=27512)

## File structures
* Mods startred by `pkr_` are only for parkour game.
  * The only exception is `pkr_nodes`, you can use it anywhere, but all nodes are only decorations outside of this game. This feature can be used to make levels.
* Other mods are designed as APIs, and can be extraced to be a standalone mod.

## How to make a new level
1. Create a new `singlenode` world in the [`void` game](https://content.minetest.net/packages/Linuxdirk/void/).
   * You will start drop into the void once you started this world. Make sure to grant yourself `fly`, `fast` and `noclip`, then open the fly mode.
2. Load [`worldedit`](https://content.minetest.net/packages/sfan5/worldedit/) and an inventory mod (I suggest [`i3`](https://content.minetest.net/packages/jp/i3/))
3. Load your world. Place a node at **excally** `(0,0,0)`.
4. Start from that node, build anything at the X+ Y+ side.
   * Don't make a level larger than 30x30x30.
   * Use blocks (I suggest white glass blocks) to make a border of the map.
   * You can load an existing level then design your own level inside it.
5. After finishing the level design, **test it**. Do not make levels that is unable to pass.
6. Use worldedit to select the two edge of your level. Save it by using `//mtschemecreate level`.
   * Remember the position of the map's spawnpoint.
7. Find your level's ID. If the largest ID among all existing levels is `7`, then your level's ID is `8`. **Do not change other level's ID once they have been pushed to the master**, since this will break the backward compatibility.
8. Move your scheme file to `parkour/mods/pkr_main/schems/<ID>.mts`.
9. Create a key-value file at `parkour/mods/pkr_main/config/<ID>.conf`. It contains:
   * `x`, `y`, `z` contains the spawnpoint of your level.
   * `description` contains the name of the map.
   * If you placed any locks in the level, set `lock` to the number of locks.
   * Place tips in `news`.
10. **Test it again in the `parkour` game** to ensure your level is working.

## Credits
* All codes: Me (Inspired by Minecraft YouTubers)
* Media: Me (Inspired by `void` game)
* Money (if any): GreenXenith and others
* GitHub workflows: Minetest Team > Capturetheflag Team
