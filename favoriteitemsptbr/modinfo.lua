-- This information tells other players more about the mod
name = "Favoritar Itens (PT-BR)"
description = [[
Versao traduzida do mod Favorite Items

Favorite os seu itens para que eles sempre voltem para o slot que voce escolheu.

Como usar:
    - Segure o item com o mouse e apertando V, clique no slot que voce deseja salvar.
    - Aperte V + Clique de novo para remover.
    - Segure um item e aperte V + Clique em outro slot para mover ele.
    - Aperte CTRL + SHIFT + Z para limpar todos os items favoritos. (util se estiver bugando)

- É possivel favoritar multiplos itens, cada um em um slot.
- Mas nao e possivel favoritar na mochila.
]]

author = "ZeroHora"
version = "0.9.2"

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
        label = "Botão para favoritar",
        hover = "Escolha o botão que você quer usar para favoritar os itens.",
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