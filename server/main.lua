local QBCore = exports['qb-core']:GetCoreObject()

-- Weed
RegisterServerEvent('qb-weedpicking:pickedUpCannabis', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up some Cannabis!", "Success", 1000) then
		  Player.Functions.AddItem('weed', 1)
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['weed'], "add")
	    end
end)

-- Meth
RegisterServerEvent('qb-weedpicking:pickedUpChemicals', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up some Chemicals!", "Success", 1000) then
		  Player.Functions.AddItem('chemicals', 1)
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['chemicals'], "add")
	    end
end)

-- Cocaine
RegisterServerEvent('qb-weedpicking:pickedUpCocas', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up some Coca Leafs!", "Success", 1000) then
		  Player.Functions.AddItem('cocaleaf', 1)
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['cocaleaf'], "add")
	    end
end)

-- Weed
RegisterServerEvent('qb-weedpicking:processweed', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local weed = Player.Functions.GetItemByName("weed")
    local zip_baggie = Player.Functions.GetItemByName("zip_baggie")

    if weed ~= nil and zip_baggie ~= nil then
        if Player.Functions.RemoveItem('weed', 3) and Player.Functions.RemoveItem('zip_baggie', 1) then
            Player.Functions.AddItem('weed_baggie', 1)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['weed'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['zip_baggie'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['weed_baggie'], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Cannabis Processed successfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
    end
end)

-- Meth
RegisterServerEvent('qb-weedpicking:processchemicals', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chemicals = Player.Functions.GetItemByName("chemicals")
    local plastic_baggie = Player.Functions.GetItemByName("plastic_baggie")

    if chemicals ~= nil and plastic_baggie ~= nil then
        if Player.Functions.RemoveItem('chemicals', 2) and Player.Functions.RemoveItem('plastic_baggie', 1) then
            Player.Functions.AddItem('meth', 1)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['chemicals'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['plastic_baggie'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['meth'], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Chemicals Processed successfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
    end
end)

-- Cocaine
RegisterServerEvent('qb-weedpicking:processcocas', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cocaleaf = Player.Functions.GetItemByName("cocaleaf")
    local plastic_baggie = Player.Functions.GetItemByName("plastic_baggie")

    if cocaleaf ~= nil and plastic_baggie ~= nil then
        if Player.Functions.RemoveItem('cocaleaf', 2) and Player.Functions.RemoveItem('plastic_baggie', 1) then
            Player.Functions.AddItem('cocaine', 1)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['cocaleaf'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['plastic_baggie'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['cocaine'], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Coca Leafs Processed successfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
    end
end)

function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('qb-weedpicking:cancelProcessing', function()
	CancelProcessing(source)
end)
