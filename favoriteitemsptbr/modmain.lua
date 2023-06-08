GLOBAL.MOD_FAVORITE_ITEM = {}

GLOBAL.MOD_FAVORITE_ITEM.INVENTORY_UPDATE_TIME = GLOBAL.tonumber(GetModConfigData("INVENTORY_UPDATE_TIME"))
GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED = false
GLOBAL.FAVORITED_ITEMS = {}

GLOBAL.FAVITSAVE = "FAVORITEITEMS"
GLOBAL.SHOWTABLE = ""

function TableToString(table)
	local uniqueString = ""
	for k, v in pairs(table) do
		uniqueString = uniqueString .. tostring(v.item) .. "," .. tostring(v.slot) .. ";"
	end

	return uniqueString
end

function StringToTable(s)
	local result = {}
	for key, value in pairs(StringSplit(s, ";")) do
		if (value ~= "") then
			table.insert(
				result, {
					item = StringSplit(value, ",")[1],
					slot = math.floor(StringSplit(value, ",")[2])
				})
		end
	end

	return result
end

function StringSplit(s, delimiter)
	local result = {}
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

function SavePersistentData(name, data)
	local tstring = TableToString(data)

	GLOBAL.TheSim:SetPersistentString(name, tstring, false)
end

function ContainsItemInTable(table, item)
	if (table[1] == nil) then return false end

	for k, v in pairs(table) do
		if (v.item == item) then return k end
	end

	return false
end

function SlotIsBusy(table, slot)
	if (table[1] == nil) then return false end

	for k, v in pairs(table) do
		if (v.slot == slot) then return k end
	end

	return false
end

function ReturnItemToFavoritedSlot(player, item, slot)
	local inventory = player and player.components.inventory or nil
	-- local backpack = inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.PACK) or inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BACK) or inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)

	-- if not backpack or not backpack.components or not backpack.components.container then
	-- 	backpack = nil
	-- else
	-- 	backpack = backpack.components.container
	-- end

	if item == nil and slot == nil then return end

	local hasActiveItem = inventory.activeitem ~= nil

	if hasActiveItem then
		if inventory.activeitem.prefab == item then
			return
		end
	end

	local itemFoundInventory = inventory:FindItem(function(i) return i.prefab == item end)

	if itemFoundInventory then
		local itemFoundSlot = inventory:GetItemSlot(itemFoundInventory)

		if inventory:GetItemInSlot(slot) ~= nil then
			local itemInPersistentSlot = inventory:GetItemInSlot(slot)

			if itemInPersistentSlot.prefab ~= item then
				inventory:RemoveItemBySlot(slot)
				inventory:RemoveItemBySlot(itemFoundSlot)

				inventory:GiveItem(itemFoundInventory, slot)
				inventory:GiveItem(itemInPersistentSlot, itemFoundSlot)
			end
		else
			inventory:RemoveItemBySlot(itemFoundSlot)
			inventory:GiveItem(itemFoundInventory, slot)
		end
	end
end

AddClassPostConstruct("widgets/invslot", function(invslot)
	local nClick = invslot.Click

	invslot.Click = function(invslot, stack_mod)
		local res = nClick(invslot, stack_mod)

		local highlight_scale = 5
		local base_scale = 5

		--print("clicou")

		if GLOBAL.TheInput:IsKeyDown(GetModConfigData("FI_SWITCH_KEY"):lower():byte()) then
			--invslot.bgimage:SetTint(1,1,1,1)
			if (tostring(invslot.container) ~= tostring(GLOBAL.ThePlayer.replica.inventory)) then return end

			if invslot.tile and invslot.tile.item then
				local clickedSlotNumber = invslot.num
				local selectedItem = invslot.tile.item

				local existsItem = ContainsItemInTable(GLOBAL.FAVORITED_ITEMS, selectedItem.prefab)
				local itemInSlotBusy = SlotIsBusy(GLOBAL.FAVORITED_ITEMS, clickedSlotNumber)

				if GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED ~= nil and existsItem ~= false then
					if (itemInSlotBusy ~= false) then
						if (itemInSlotBusy == existsItem) then
							table.remove(GLOBAL.FAVORITED_ITEMS, itemInSlotBusy)
							GLOBAL.ThePlayer.components.talker:Say(tostring(selectedItem.name) ..
							" foi removido do slot " .. tostring(clickedSlotNumber))
						else
							GLOBAL.FAVORITED_ITEMS[existsItem].slot = clickedSlotNumber
							table.remove(GLOBAL.FAVORITED_ITEMS, itemInSlotBusy)
							GLOBAL.ThePlayer.components.talker:Say(tostring(selectedItem.name) ..
							" substituiu o item no slot " .. tostring(clickedSlotNumber))
						end
					else
						GLOBAL.FAVORITED_ITEMS[existsItem].slot = clickedSlotNumber

						GLOBAL.ThePlayer.components.talker:Say(tostring(selectedItem.name) ..
						" foi movido para o slot " .. tostring(clickedSlotNumber))
					end
				else
					if (itemInSlotBusy ~= false) then
						GLOBAL.FAVORITED_ITEMS[itemInSlotBusy].item = selectedItem.prefab

						GLOBAL.ThePlayer.components.talker:Say(tostring(selectedItem.name) ..
						" substituiu o item no slot " .. tostring(clickedSlotNumber))
					else
						table.insert(GLOBAL.FAVORITED_ITEMS, {
							item = selectedItem.prefab,
							slot = clickedSlotNumber
						})

						GLOBAL.ThePlayer.components.talker:Say(tostring(selectedItem.name) ..
						" foi favoritado no slot " .. tostring(clickedSlotNumber))
					end
				end

				GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED = true

				GLOBAL.SHOWTABLE = TableToString(GLOBAL.FAVORITED_ITEMS)

				GLOBAL.TheSim:GetPersistentString(GLOBAL.FAVITSAVE,
					function(load_success, str)
						if load_success then
							if (GLOBAL.FAVORITED_ITEMS ~= StringToTable(str)) then
								SavePersistentData(GLOBAL.FAVITSAVE, GLOBAL.FAVORITED_ITEMS)
							end
						else
							SavePersistentData(GLOBAL.FAVITSAVE, GLOBAL.FAVORITED_ITEMS)
						end
					end)
			end
		end
		return res
	end
end)

AddModRPCHandler(modname, "fiRemoteTask", function(player, item, slot)
	ReturnItemToFavoritedSlot(player, item, slot)
end)

local function runTask()
	if not (GLOBAL.TheFrontEnd:GetActiveScreen() and
			GLOBAL.TheFrontEnd:GetActiveScreen().name and
			type(GLOBAL.TheFrontEnd:GetActiveScreen().name) == "string" and
			GLOBAL.TheFrontEnd:GetActiveScreen().name == "HUD") then
		return
	end
	-- Server-side

	if GLOBAL.TheNet:GetIsServer() then
		if GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED ~= nil then
			for k, v in pairs(GLOBAL.FAVORITED_ITEMS) do
				ReturnItemToFavoritedSlot(GLOBAL.ThePlayer, v.item, v.slot)
			end
		end

		-- Client-side
	else
		if GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED ~= nil then
			for k, v in pairs(GLOBAL.FAVORITED_ITEMS) do
				SendModRPCToServer(MOD_RPC[modname]["fiRemoteTask"], v.item, v.slot)
			end
		end
	end
end

function Dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

AddPlayerPostInit(function(inst)
	GLOBAL.FAVITSAVE = GLOBAL.FAVITSAVE

	--inst:DoPeriodicTask(GLOBAL.MOD_FAVORITE_ITEM.INVENTORY_UPDATE_TIME, runTask, math.random()*2, dt)

	inst:ListenForEvent("itemget", runTask)
	inst:ListenForEvent("itemlose", runTask)
	inst:ListenForEvent("gotnewitem", runTask)
	inst:ListenForEvent("dropitem", runTask)
	inst:ListenForEvent("equip", runTask)
	inst:ListenForEvent("unequip", runTask)
	inst:ListenForEvent("newactiveitem", runTask)

	GLOBAL.TheSim:GetPersistentString(GLOBAL.FAVITSAVE,
		function(load_success, str)
			if load_success then
				local sTable = StringToTable(str)

				--print(Dump(sTable))

				GLOBAL.FAVORITED_ITEMS = sTable
				GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED = true
			end
		end)
end)

GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_Z, function()
	if GLOBAL.TheInput:IsKeyDown(GLOBAL.KEY_CTRL) and GLOBAL.TheInput:IsKeyDown(GLOBAL.KEY_SHIFT) then
		GLOBAL.MOD_FAVORITE_ITEM.HAVE_FAVORITED = false
		GLOBAL.FAVORITED_ITEMS = {}

		GLOBAL.TheSim:ErasePersistentString(GLOBAL.FAVITSAVE)
	end
end)
