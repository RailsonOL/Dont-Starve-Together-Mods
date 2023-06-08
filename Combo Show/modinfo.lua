name = "Combo Show"
description = [[
    This mod is able to show your sequence of hits without taking damage

    It has some customization options, including configuring animation and text size

    Utils so you don't have to keep counting in your head how many hits you've landed and make a perfect kiting
    Good for those who don't want to lose combat experience with mods that show the range of enemy attacks
]]

author = "ZeroHora"
version = "0.1.0"

icon_atlas = "modicon.xml"
icon = "modicon.tex"

forumthread = ""

api_version_dst = 10

priority = 100

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true

all_clients_require_mod = false

client_only_mod = true

server_filter_tags = {""}

TimeToResetComboOptions = {}
for i=1, 10 do
	TimeToResetComboOptions[i] = {description = i .. "s", data = i}
end

TextAnimSpeed = {}
for i=1, 5 do
	TextAnimSpeed[i] = {description = "" .. i, data = i}
end

TextAnimScaleTo = {}
for i=1, 5 do
	TextAnimScaleTo[i] = {description = "" .. i, data = i}
end

configuration_options =
{
    {
        name = "TIME_TO_RESET_COMBO",
        label = "Time to reset combo",
        hover = "Time to combo reset in seconds",
        options = TimeToResetComboOptions,
        default = 2,
    },
    {
        name = "NUMBER_FONT_SIZE",
        label = "Number font size",
        hover = "Font Size of the number in combo",
        options = { {description = "30", data = 30}, {description = "35", data = 35}, {description = "40", data = 40}, {description = "45", data = 45}, 
                    {description = "50", data = 50}, {description = "55", data = 55}, {description = "60", data = 60}},
        default = 45,
    },
    {
        name = "TEXT_FONT_SIZE",
        label = "Text font size",
        hover = "Font Size of the text in combo",
        options = { {description = "20", data = 20}, {description = "25", data = 25}, {description = "30", data = 30}, {description = "35", data = 35}, 
                    {description = "40", data = 40}, {description = "45", data = 45}, {description = "50", data = 50}},
        default = 25,
    },
    {
        name = "UI_LOCATION",
        label = "UI location in screen",
        hover = "Choose UI location in screen",
        options = { {description = "Top", data = "top"}, {description = "Right", data = "right"}},
        default = "top",
    },
    {
		name = "TEXT_ANIM",
		label = "Turn on/off text animations",
		options =	{
						{description = "On", data = true},
						{description = "Off", data = false},
					},
		default = true,
		hover = "Turn on/off text scale animations",
	},
    {
        name = "TEXT_ANIM_SPEED",
        label = "Text animation speed",
        hover = "Speed of the text animation",
        options = TextAnimSpeed,
        default = 2,
    },
    {
        name = "TEXT_ANIM_SCALE_FROM",
        label = "Text anim scale from",
        hover = "Need to be less than Text anim scale to",
        options = { {description = "0", data = 0}, {description = "1", data = 1}, {description = "2", data = 2}},
        default = 0,
    },
    {
        name = "TEXT_ANIM_SCALE_TO",
        label = "Text anim scale to",
        hover = "Need to be more than Text anim scale from",
        options = TextAnimScaleTo,
        default = 1,
    }
}	