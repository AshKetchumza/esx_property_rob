ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local win1 = 100 
local win2 = 1200
local win3 = 2500

local winText = "You won ~g~$"
local ticketEmpty = "You won ~r~nothing"

ESX.RegisterServerCallback('property_rob:getDoorFreezeStatus', function(source, cb, house)
    cb(Config.burglaryPlaces[house].door.Frozen)
end)

RegisterServerEvent('property_rob:setDoorFreezeStatus')
AddEventHandler('property_rob:setDoorFreezeStatus', function(house, status)
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
        if cops >= Config.burglaryPlaces[house].cops then
            Config.burglaryPlaces[house].door.Frozen = status
        else
            sendNotification(src, 'There aren\'t enough cops online!', 'error', 3500)
        end
    else
        Config.burglaryPlaces[house].door.Frozen = status
    end
    TriggerClientEvent('property_rob:setFrozen', -1, house, Config.burglaryPlaces[house].door.Frozen)
end)

RegisterServerEvent('property_rob:Add')
AddEventHandler('property_rob:Add', function(item, qtty)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addInventoryItem(item, qtty)
end)

RegisterServerEvent('property_rob:Remove')
AddEventHandler('property_rob:Remove', function(item, qtty)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeInventoryItem(item, qtty)
end)

ESX.RegisterUsableItem('lotteryticket', function(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local rndm = math.random(1,11)
	xPlayer.removeInventoryItem('lotteryticket', 1)

	if rndm == 1 then
		xPlayer.addMoney(win1)
		TriggerClientEvent('property_rob:Sound', src, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
		TriggerClientEvent('esx:showNotification', src, winText .. win1)
	end

	if rndm == 2 then
		xPlayer.addMoney(win2)
		TriggerClientEvent('property_rob:Sound', src, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
		TriggerClientEvent('esx:showNotification', src, winText .. win2)
	end

	if rndm == 3 then
		xPlayer.addMoney(win3)
		TriggerClientEvent('property_rob:Sound', src, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
		TriggerClientEvent('esx:showNotification', src, winText .. win3)
	end

	if rndm >= 4 then
		TriggerClientEvent('property_rob:Sound', src, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		TriggerClientEvent('esx:showNotification', src, ticketEmpty)
	end

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