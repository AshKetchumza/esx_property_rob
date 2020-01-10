ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('property_rob:doorStatusSet', function(source, cb, property)
    cb(Config.Properties[property].door.locked)
end)

RegisterServerEvent('property_rob:doorStatusGet')
AddEventHandler('property_rob:doorStatusGet', function(property, status)
    if status == false then
        local src = source
        local cops = 0
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                cops = cops + 1
            end
        end
        if cops >= Config.Properties[property].cops then
            Config.Properties[property].door.locked = status
        else
            sendNotification(src, "There needs to be at least " .. Config.Properties[property].cops .. " in the city", 'error', 3500)
        end
    else
        Config.Properties[property].door.locked = status
    end
    TriggerClientEvent('property_rob:setLocked', -1, property, Config.Properties[property].door.locked)
end)

RegisterServerEvent('property_rob:addItemToInventory')
AddEventHandler('property_rob:addItemToInventory', function(item, count)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addInventoryItem(item, count)
end)

RegisterServerEvent('property_rob:removeItemFromInventory')
AddEventHandler('property_rob:removeItemFromInventory', function(item, count)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeInventoryItem(item, count)
end)

RegisterServerEvent('property_rob:sellItemToPawnShop')
AddEventHandler('property_rob:sellItemToPawnShop', function(item, count, price)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeInventoryItem(item, count)
	xPlayer.addMoney(price)
	TriggerClientEvent('esx:showNotification', src, 'Sold ' .. item .. ' for ~g~$' .. price)
end)

RegisterServerEvent('property_rob:alarm')
AddEventHandler('property_rob:alarm', function(coords)
    local src = source
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('property_rob:msgPolice', xPlayer.source, coords, src)
        end
    end
end)