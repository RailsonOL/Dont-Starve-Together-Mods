local Text = require "widgets/text"
local comboCounter = 0
local lastHitTime = nil
ComboText = nil

local modInit = false

local timeToResetCombo = GetModConfigData("TIME_TO_RESET_COMBO")
local numberFontSize = GetModConfigData("NUMBER_FONT_SIZE")
local textFontSize = GetModConfigData("TEXT_FONT_SIZE")
local uiLocation = GetModConfigData("UI_LOCATION")
local textAnim = GetModConfigData("TEXT_ANIM")
local textAnimSpeed = GetModConfigData("TEXT_ANIM_SPEED")
local textAnimScaleFrom = GetModConfigData("TEXT_ANIM_SCALE_FROM")
local textAnimScaleTo = GetModConfigData("TEXT_ANIM_SCALE_TO")

if(textAnimScaleFrom > textAnimScaleTo) then
	textAnimScaleFrom = textAnimScaleTo
end

local function AddHitToCombo()
	if not modInit then
		modInit = true
	end

	if GLOBAL.ThePlayer.replica.combat._laststartattacktime == nil then return end

	comboCounter = comboCounter + 1
	lastHitTime = GLOBAL.GetTime()

	UpdateUIText()

	--GLOBAL.ThePlayer.components.talker:Say(tostring("Combo: " .. comboCounter))
end

local function ResetCombo()
	if not modInit then return end

	comboCounter = 0
	lastHitTime = nil
	ComboText:Hide()
	--GLOBAL.ThePlayer.components.talker:ShutUp()
end

function InitComboUI(inventorybar)

	local text = Text(GLOBAL.CHATFONT_OUTLINE, numberFontSize, "")
	inventorybar:AddChild(text)

	if uiLocation == "top" then
		text:SetVAlign(GLOBAL.ANCHOR_MIDDLE)
		text:SetHAlign(GLOBAL.ANCHOR_TOP)
		text:SetVAnchor(GLOBAL.ANCHOR_TOP)
		text:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
		text:SetPosition(0,-125,0)
	elseif uiLocation == "right" then
		text:SetHAnchor(GLOBAL.ANCHOR_RIGHT)
		text:SetVAnchor(0.1)
		text:Nudge(GLOBAL.Vector3(-90, 130, 0))
	end

	local comboUI = text:AddChild(Text(GLOBAL.CHATFONT_OUTLINE, textFontSize, "Hits"))
	comboUI:SetColour(254,206,0,1)
	comboUI:Nudge(GLOBAL.Vector3(0, -30, 0))

	text:Hide()

	ComboText = text
end

function UpdateUIText()
    if ComboText ~= nil then
        ComboText:SetString(comboCounter)
		ComboText:Show()

		if textAnim then
			ComboText:ScaleTo(textAnimScaleFrom, textAnimScaleTo, textAnimSpeed)
		end
    end
end

local oldVarValue = nil

AddPlayerPostInit(function(inst)
	--inst:ListenForEvent("onhitother", AddHitToCombo) -- only for no caves world or DS

	inst:DoPeriodicTask(0.45, function()
		if GLOBAL.ThePlayer.replica.combat._laststartattacktime == nil then return end
		if GLOBAL.ThePlayer.replica.combat._laststartattacktime == oldVarValue then return end

		oldVarValue = GLOBAL.ThePlayer.replica.combat._laststartattacktime

		AddHitToCombo()
	end)

	inst:DoPeriodicTask(1, function()
		if lastHitTime ~= nil and GLOBAL.GetTime() - lastHitTime >= timeToResetCombo then
			ResetCombo()
		end
	end)

	inst:ListenForEvent("attacked", ResetCombo)
end)

AddClassPostConstruct("widgets/inventorybar", InitComboUI)