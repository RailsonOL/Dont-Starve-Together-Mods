-- This information tells other players more about the mod
name = "Favorite Items DEV"
description = [[
Favorite your items in inventory, always remain in the chosen slot

- Hold the item and press V in the slot you want it to always be.
- Press V + Click again to quick remove item from favorite.
- Hold item and press V in slot with other favorite to replace.
- Press CTRL + SHIFT + Z to reset favorited items.

- You can favorite multiple items.
- Cant favorite in backpack.
]]

author = "ZeroHora"
version = "0.9.1"

icon_atlas = "modicon.xml"
icon = "modicon.tex"

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version_dst = 10

priority = 100

-- Only compatible with DST
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true


--This lets clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = true

--This determines whether it causes a server to be marked as modded (and shows in the mod list)
client_only_mod = false

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {""}

ScaleValues = {}
for i=1, 15 do
	ScaleValues[i] = {description = "" .. (i/10), data = (i/10)}
end

configuration_options =
{
    {
        name = "FI_SWITCH_KEY",
        label = "Button to favorite items",
        hover = "The key to favorite item in slot.",
        options = {
            {description = "R", data = "R"},
            {description = "T", data = "T"},
            {description = "O", data = "O"},
            {description = "P", data = "P"},
            {description = "G", data = "G"},
            {description = "H", data = "H"},
            {description = "J", data = "J"},
            {description = "K", data = "K"},
            {description = "L", data = "L"},
            {description = "Z", data = "Z"},
            {description = "X", data = "X"},
            {description = "C", data = "C"},
            {description = "V", data = "V"},
            {description = "B", data = "B"},
            {description = "N", data = "N"},
        },
        default = "V",
    }
}