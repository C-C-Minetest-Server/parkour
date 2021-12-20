## parkour games world structure
```
world
├── map_meta.txt
├── mod_storage
│   ├── pkr_init
│   └── pkr_main
└── world.mt
```
### `mod_storage`
Included `pkr_init`(Gamemode data and map version) and `pkr_main`(Max reached level and playing level).

### `map_meta.txt`
Using `singlenode` mapgen

### `world.mt`
Using `dummy` backend for world and `sqlite3` for the others.
