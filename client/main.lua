local QBCore = exports['qb-core']:GetCoreObject()

local spawnedWeed = 0
local spawnedChemical = 0
local spawnedCoca = 0
local weedPlants = {}
local chemicalBarrels = {}
local cocaLeaf = {}
local showing = false

local isPickingUp, isProcessing = false, false, false

-- Weed
RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoordsWeed()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 1000 then
		SpawnWeedPlants()
	end
end)

function CheckCoordsWeed()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 1000 then
				SpawnWeedPlants()
			end
			Wait(1 * 1000)
		end
	end)
end

-- Meth
RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoordsChemical()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.ChemicalField.coords, true) < 1000 then
		SpawnChemicalPlants()
	end
end)

function CheckCoordsChemical()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.ChemicalField.coords, true) < 1000 then
				SpawnChemicalPlants()
			end
			Wait(1 * 1000)
		end
	end)
end

-- Cocaine
RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoordsCoca()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.CocaField.coords, true) < 1000 then
		SpawnCocaPlants()
	end
end)

function CheckCoordsCoca()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.CocaField.coords, true) < 1000 then
				SpawnCocaPlants()
			end
			Wait(1 * 1000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoordsWeed()
		CheckCoordsChemical()
		CheckCoordsCoca()
	end
end)

CreateThread(function()
	while true do
		Wait(10)
		if showing == true then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local objectId = GetClosestObjectOfType(coords, 2.0, GetHashKey("prop_weed_02"), false)
			local objectId2 = GetClosestObjectOfType(coords, 2.0, GetHashKey("prop_barrel_01a"), false)
			local objectId3 = GetClosestObjectOfType(coords, 2.0, GetHashKey("prop_plant_01a"), false)
			if DoesEntityExist(objectId) == false and DoesEntityExist(objectId2) == false and DoesEntityExist(objectId3) == false then
				exports['qb-core']:HideText()
				showing = false
			end
		end
	end
end)

-- Weed
CreateThread(function()
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showing == false then
				exports['qb-core']:DrawText('[E] Pickup Cannabis', 'left')
				showing = true
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				exports['qb-core']:HideText()
				showing = false
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Cannabis..", 7500, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					DeleteObject(nearbyObject)
					table.remove(weedPlants, nearbyID)
					spawnedWeed = spawnedWeed - 1
					TriggerServerEvent('qb-weedpicking:pickedUpCannabis')
					isPickingUp = false
				end, function()
					ClearPedTasks(PlayerPedId())
					isPickingUp = false
				end)
			end
		else		
			Wait(500)
		end
	end
end)

-- Meth
CreateThread(function()
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #chemicalBarrels, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(chemicalBarrels[i]), false) < 1 then
				nearbyObject, nearbyID = chemicalBarrels[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showing == false then
				exports['qb-core']:DrawText('[E] Pickup Chemicals', 'left')
				showing = true
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				exports['qb-core']:HideText()
				showing = false
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Chemicals..", 7500, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					DeleteObject(nearbyObject)
					table.remove(chemicalBarrels, nearbyID)
					spawnedChemical = spawnedChemical - 1
					TriggerServerEvent('qb-weedpicking:pickedUpChemicals')
					isPickingUp = false
				end, function()
					ClearPedTasks(PlayerPedId())
					isPickingUp = false
				end)
			end
		else		
			Wait(500)
		end
	end
end)

-- Cocain
CreateThread(function()
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #cocaLeaf, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(cocaLeaf[i]), false) < 1 then
				nearbyObject, nearbyID = cocaLeaf[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showing == false then
				exports['qb-core']:DrawText('[E] Pickup Coca Leaf', 'left')
				showing = true
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				exports['qb-core']:HideText()
				showing = false
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Coca Leaf..", 7500, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					DeleteObject(nearbyObject)
					table.remove(cocaLeaf, nearbyID)
					spawnedCoca = spawnedCoca - 1
					TriggerServerEvent('qb-weedpicking:pickedUpCocas')
					isPickingUp = false
				end, function()
					ClearPedTasks(PlayerPedId())
					isPickingUp = false
				end)
			end
		else		
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			DeleteObject(nearbyObject)
		end
		for k, v in pairs(chemicalBarrels) do
			DeleteObject(nearbyObject)
		end
		for k, v in pairs(cocaLeaf) do
			DeleteObject(nearbyObject)
		end
	end
end)

-- Weed
function SpawnWeedPlants()
	while spawnedWeed < 20 do
		Wait(1)
		local weedCoords = GenerateWeedCoords()

		local model = GetHashKey("prop_weed_02")
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Wait(1)
        end

        obj = CreateObject(model, weedCoords.x, weedCoords.y, weedCoords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		table.insert(weedPlants, obj)
		spawnedWeed = spawnedWeed + 1

		--QBCore.Functions.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
		--	PlaceObjectOnGroundProperly(obj)
		--	FreezeEntityPosition(obj, true)
		--	table.insert(weedPlants, obj)
		--	spawnedWeed = spawnedWeed + 1
		--end)
	end
	Wait(45 * 60000)
end

-- Meth
function SpawnChemicalPlants()
	while spawnedChemical < 20 do
		Wait(1)
		local ChemicalCoords = GenerateChemicalCoords()

		local model = GetHashKey("prop_barrel_01a")
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Wait(1)
        end

        obj = CreateObject(model, ChemicalCoords.x, ChemicalCoords.y, ChemicalCoords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		table.insert(chemicalBarrels, obj)
		spawnedChemical = spawnedChemical + 1
	end
	Wait(45 * 60000)
end

-- Cocaine
function SpawnCocaPlants()
	while spawnedCoca < 20 do
		Wait(1)
		local CocaCoords = GenerateCocaCoords()

		local model = GetHashKey("prop_plant_01a")
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Wait(1)
        end

        obj = CreateObject(model, CocaCoords.x, CocaCoords.y, CocaCoords.z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		table.insert(cocaLeaf, obj)
		spawnedCoca = spawnedCoca + 1
	end
	Wait(45 * 60000)
end

-- Weed
function ValidateWeedCoord(plantCoord)
	if spawnedWeed > 0 then
		local validate = true
		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

-- Meth
function ValidateChemicalCoord(chemicalCoord)
	if spawnedChemical > 0 then
		local validate = true
		for k, v in pairs(chemicalBarrels) do
			if GetDistanceBetweenCoords(chemicalCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(chemicalCoord, Config.CircleZones.ChemicalField.coords, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

-- Coca
function ValidateCocaCoord(cocaCoord)
	if spawnedCoca > 0 then
		local validate = true
		for k, v in pairs(cocaLeaf) do
			if GetDistanceBetweenCoords(cocaCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(cocaCoord, Config.CircleZones.CocaField.coords, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

-- Weed
function GenerateWeedCoords()
	while true do
		Wait(1)
		local weedCoordX, weedCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)
		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY
		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)
		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

-- Meth
function GenerateChemicalCoords()
	while true do
		Wait(1)
		local chemicalCoordX, chemicalCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)
		chemicalCoordX = Config.CircleZones.ChemicalField.coords.x + modX
		chemicalCoordY = Config.CircleZones.ChemicalField.coords.y + modY
		local coordZ = GetCoordZChemical(chemicalCoordX, chemicalCoordY)
		local coord = vector3(chemicalCoordX, chemicalCoordY, coordZ)
		if ValidateChemicalCoord(coord) then
			return coord
		end
	end
end

-- Cocaine
function GenerateCocaCoords()
	while true do
		Wait(1)
		local cocaCoordX, cocaCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)
		cocaCoordX = Config.CircleZones.CocaField.coords.x + modX
		cocaCoordY = Config.CircleZones.CocaField.coords.y + modY
		local coordZ = GetCoordZCoca(cocaCoordX, cocaCoordY)
		local coord = vector3(cocaCoordX, cocaCoordY, coordZ)
		if ValidateCocaCoord(coord) then
			return coord
		end
	end
end

-- Weed
function GetCoordZWeed(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

-- Meth
function GetCoordZChemical(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

-- Cocaine
function GetCoordZCoca(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0, 300.0, 310.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

-- Weed
CreateThread(function()
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 5 then

			if isProcessing == false and GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 1.5 then
				exports['qb-core']:DrawText('[E] Process Cannbis', 'left')
			else
				exports['qb-core']:HideText()
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBag = false		
				local s1 = false
				local hasWeed = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasWeed = result
					s1 = true
				end, 'weed')

				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag = result
					s2 = true
				end, 'zip_baggie')

				while(not s2) do
					Wait(100)
				end

				if (hasWeed and hasBag) then
					Processweed()
					isProcessing = true
				elseif (hasWeed) then
					QBCore.Functions.Notify('You dont have enough ziploc bags.', 'error')
					isProcessing = false
				elseif (hasBag) then
					QBCore.Functions.Notify('You dont have enough cannabis.', 'error')
					isProcessing = false
				else
					QBCore.Functions.Notify('You dont have enough cannabis and plastic bags.', 'error')
					isProcessing = false
				end
			end
		else
			Wait(500)
		end
	end
end)

-- Meth
CreateThread(function()
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MethProcessing.coords, true) < 5 then

			if isProcessing == false and GetDistanceBetweenCoords(coords, Config.CircleZones.MethProcessing.coords, true) < 1.5 then
				exports['qb-core']:DrawText('[E] Process Chemicals', 'left')
			else
				exports['qb-core']:HideText()
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBaggie = false		
				local s1 = false
				local hasChemicals = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasChemicals = result
					s1 = true
				end, 'chemicals')

				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBaggie = result
					s2 = true
				end, 'plastic_baggie')

				while(not s2) do
					Wait(100)
				end

				if (hasChemicals and hasBaggie) then
					Processchemicals()
					isProcessing = true
				elseif (hasChemicals) then
					QBCore.Functions.Notify('You dont have enough plastic bags.', 'error')
					isProcessing = false
				elseif (hasBaggie) then
					QBCore.Functions.Notify('You dont have enough chemicals.', 'error')
					isProcessing = false
				else
					QBCore.Functions.Notify('You dont have enough chemicals and plastic bags.', 'error')
					isProcessing = false
				end
			end
		else
			Wait(500)
		end
	end
end)

-- Cocaine
CreateThread(function()
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CocaProcessing.coords, true) < 5 then

			if isProcessing == false and GetDistanceBetweenCoords(coords, Config.CircleZones.CocaProcessing.coords, true) < 1.5 then
				exports['qb-core']:DrawText('[E] Process Coca Leafs', 'left')
			else
				exports['qb-core']:HideText()
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBaggie = false		
				local s1 = false
				local hasCocas = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasCocas = result
					s1 = true
				end, 'cocaleaf')

				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBaggie = result
					s2 = true
				end, 'plastic_baggie')

				while(not s2) do
					Wait(100)
				end

				if (hasCocas and hasBaggie) then
					Processcocas()
					isProcessing = true
				elseif (hasCocas) then
					QBCore.Functions.Notify('You dont have enough plastic bags.', 'error')
					isProcessing = false
				elseif (hasBaggie) then
					QBCore.Functions.Notify('You dont have enough coca leafs.', 'error')
					isProcessing = false
				else
					QBCore.Functions.Notify('You dont have enough coca leafs and plastic bags.', 'error')
					isProcessing = false
				end
			end
		else
			Wait(500)
		end
	end
end)

-- Weed
function Processweed()
	exports['qb-core']:HideText()
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 285.0)

	QBCore.Functions.Progressbar("search_register", "Processing Cannabis..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-weedpicking:processweed')

		local timeLeft = Config.Delays.Processing / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-weedpicking:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end, function()
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end) -- Cancel
end

-- Meth
function Processchemicals()
	exports['qb-core']:HideText()
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 90.0)

	QBCore.Functions.Progressbar("search_register", "Processing Chemicals..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-weedpicking:processchemicals')

		local timeLeft = Config.Delays.Processing / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.MethProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-weedpicking:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end, function()
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end) -- Cancel
end

-- Cocaine
function Processcocas()
	exports['qb-core']:HideText()
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 0.0)

	QBCore.Functions.Progressbar("search_register", "Processing Coca Leafs..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-weedpicking:processcocas')

		local timeLeft = Config.Delays.Processing / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CocaProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-weedpicking:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end, function()
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end) -- Cancel
end
