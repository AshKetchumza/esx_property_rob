local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

ESX                           = nil  
local GUI                     = {}   
GUI.Time                      = 0    
local Robbing			            = false
local GUI                     = {}   
local PlayerData              = {}   
local ShowPercentage          = false
local Stealing                = false
local ESXLoaded               = false
local PlayerData              = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('property_rob:setLocked')
AddEventHandler('property_rob:setLocked', function(property, status)
    Config.Properties[property].door.locked = status
    local door = GetClosestObjectOfType(Config.Properties[property].door.coords, 2.0, GetHashKey(Config.Properties[property].door.obj), false, 0, 0)
    FreezeEntityPosition(door, status)
end)

Citizen.CreateThread(function()
  while not NetworkIsSessionStarted() do
      Wait(0)
  end
  while not ESXLoaded do
      Wait(0)
  end
  Wait(50)
  for i = 1, #Config.Properties do        
      ESX.TriggerServerCallback('property_rob:doorStatusSet', function(locked)
          Config.Properties[i].door.locked = locked
          local door = GetClosestObjectOfType(Config.Properties[i].door.coords, 2.0, GetHashKey(Config.Properties[i].door.obj), false, 0, 0)
          FreezeEntityPosition(door, Config.Properties[i].door.locked)
      end, i)      
  end
  while true do
      local player = PlayerPedId()
      local coords = GetEntityCoords(player)
      for i = 1, #Config.Properties do
          Wait(0)
          local v = Config.Properties[i]
          local d = v.door
          local door = GetClosestObjectOfType(d.Coords, 2.0, GetHashKey(d.Object), false, 0, 0)            
          if door ~= nil then
              FreezeEntityPosition(door, d.locked)
              if d.locked then
                  SetEntityHeading(door, d.heading)
              end
          end          
      end
      Wait(50)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    for k,v in pairs(Config.Properties) do
      local playerPed = PlayerPedId()
      local property = k
      local coords = GetEntityCoords(playerPed)
      local dist   = GetDistanceBetweenCoords(v.pos.x, v.pos.y, v.pos.z, coords.x, coords.y, coords.z, false)
      if dist <= 30.0 and Robbing == false then
        if dist <= 1.2 and Robbing == false then
          if v.locked then
            DrawText3D(v.pos.x, v.pos.y, v.pos.z, "~g~[E]~w~ Lockpick", 0.4)                  
              if IsControlJustPressed(0, Keys["E"]) then
                LockPickMenu(property)
              end
          end        
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
    while Stealing == false do
      Citizen.Wait(5)
      for k,v in pairs(Config.burglaryInside) do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist   = GetDistanceBetweenCoords(v.x, v.y, v.z, coords.x, coords.y, coords.z, false)
        if dist <= 1.2 and v.amount > 0 then
            DrawText3D(v.x, v.y, v.z, "~g~[E]~w~ Search", 0.4)
            if dist <= 0.5 and IsControlJustPressed(0, Keys["E"]) then
              SearchForItems(k)
            end
        elseif v.amount < 1 and dist <= 1.2 then
          DrawText3D(v.x, v.y, v.z, "~r~Empty", 0.4)
          if IsControlJustPressed(0, Keys["E"]) and dist <= 0.5 then 
            ESX.ShowNotification("There is nothing here")
          end
        end
      end
    end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(6)
    if ShowPercentage == true then
      local playerPed = PlayerPedId()
		  local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z, perc .. '~g~%', 0.4)
    end
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    for k,v in pairs(Config.PawnShops) do
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      local dist = GetDistanceBetweenCoords(v.pos.x, v.pos.y, v.pos.z, coords.x, coords.y, coords.z, false)
      if dist <= 4 then
        DrawMarker(25, v.pos.x, v.pos.y, v.pos.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 1.0, 255, 255, 255, 155, false, false, 2, false)
        DrawText3D(v.pos.x, v.pos.y, v.pos.z, '~g~[E]~w~ Sell Items', 0.4)
        if dist <= 0.5 and IsControlJustPressed(0, Keys["E"]) then
          PawnShopMenu()
        end
      end
    end
  end
end)

RegisterNetEvent('property_rob:msgPolice')
AddEventHandler('property_rob:msgPolice', function(coords)    
	  ESX.ShowNotification("An ~r~alarm ~w~was set off by an intruder", 7000)
    while true do
        local name = GetCurrentResourceName() .. math.random(999)
        AddTextEntry(name, '~INPUT_CONTEXT~ ' .. 'Set a waypoint to the property' .. '\n~INPUT_FRONTEND_RRIGHT~ ' .. 'Close this box')
        DisplayHelpTextThisFrame(name, false)
        if IsControlPressed(0, 38) then
            SetNewWaypoint(coords.x, coords.y)
            return
        elseif IsControlPressed(0, 194) then
            return
        end
        Wait(0)
    end
end)

function LockPickMenu(property)
  local v = GetPropertyValues(property, Config.Properties)
  Citizen.CreateThread(function()
  ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lockpick_menu',
		{
			title = 'Do you want to lockpick the door?',
			align = 'center',
			elements = {
        {label = 'Yes', value = 'yes'},
        {label = 'Cancel', value = 'no'}
			}
		},
		function(data, menu)
			menu.close()

      if data.current.value == 'yes' then 
        local inventory = ESX.GetPlayerData().inventory
        local LockpickAmount = nil
        for i=1, #inventory, 1 do                          
            if inventory[i].name == 'lockpick' then
                LockpickAmount = inventory[i].count
            end
        end
        if LockpickAmount > 0 then
          BreakIntoProperty(property)
          v.locked = false
          Citizen.Wait(math.random(15000,30000))
          local random = math.random(0, 100)
          if random <= Config.PoliceNotiChance then                  
            TriggerServerEvent('property_rob:alarm', { x = v.pos.x, y = v.pos.y, z = v.pos.z })
          end
        else 
          ESX.ShowNotification("You don't have any lockpicks")
        end

		  elseif data.current.value == 'no' then 
			
	    end
    end)  
  end)
end

function PawnShopMenu()  
  Citizen.CreateThread(function()
    local elements = {}
    for k, v in pairs(ESX.GetPlayerData().inventory) do   
      if Config.Items[v.name] ~= nil then
        local price = Config.Items[v.name].price
        if v.count > 0 then
            table.insert(elements, {label = v.label .. ' $' .. tostring(Config.Items[v.name].price), value = Config.Items[v.name]})
        end
      end    
    end 
    table.insert(elements, {label = 'Close', value = 'close'})
    if #elements > 1 then
      ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pawnshop_menu',
        {
          title = 'What would you like to sell?',
          align = 'bottom-right',
          elements = elements
        },
        function(data, menu)
          menu.close()

          if data.current.value == 'close' then 
            print('Closed')
          else
            TriggerServerEvent('property_rob:sellItemToPawnShop', data.current.value.item, 1, data.current.value.price)
          end
        end)
    else
      ESX.ShowNotification("You have nothing of value to sell here")
    end  
  end)  
end

function SearchForItems(k)
    local propInfo = GetPropertyValues(k, Config.burglaryInside)
    local playerPed = PlayerPedId()
    Stealing = true
    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(2000)
    GetPercentage(50)
    if propInfo.amount >= 2 then
      local rndm = math.random(1,2)
      TriggerServerEvent('property_rob:addItemToInventory', propInfo.item, rndm)
        ESX.ShowNotification( 'You found something' )
        propInfo.amount = propInfo.amount - rndm
    else
      TriggerServerEvent('property_rob:addItemToInventory', propInfo.item, 1)
        ESX.ShowNotification( 'You found something' )
        propInfo.amount = propInfo.amount - 1
    end
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    Stealing = false
end

function BreakIntoProperty(property)
  local v = GetPropertyValues(property, Config.Properties)
  local playerPed = PlayerPedId()
  Robbing = true
  FreezeEntityPosition(playerPed, true)
  SetEntityCoords(playerPed, v.animPos.x, v.animPos.y, v.animPos.z - 0.98)
  SetEntityHeading(playerPed, v.animPos.h)
  LoadAnim("mini@safe_cracking")
  TaskPlayAnim(playerPed, "mini@safe_cracking", "idle_base", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)  
  GetPercentage(70)
  TriggerServerEvent('property_rob:removeItemFromInventory', 'lockpick', 1)
  ClearPedTasks(playerPed)
  FreezeEntityPosition(playerPed, false)
  TriggerServerEvent('property_rob:doorStatusGet', property, false)
end

function SetCoords(playerPed, x, y, z)
  SetEntityCoords(playerPed, x, y, z)
  Citizen.Wait(100)
  SetEntityCoords(playerPed, x, y, z)
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end
  
function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function GetPercentage(time)
  ShowPercentage = true
  perc = 0
  repeat
  perc = perc + 1
  Citizen.Wait(time)
  until(perc == 100)
  ShowPercentage = false
end

function GetPropertyValues(property, pair)
    for k,v in pairs(pair) do
        if k == property then
            return v
        end
    end
end

if Config.ShowMapBlip then
  Citizen.CreateThread(function()
    for k,v in pairs(Config.Properties) do
    local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
    SetBlipSprite (blip, 40)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 39)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Burglary')
    EndTextCommandSetBlipName(blip)
    end
  end)
end

if Config.ShowPawnShopBlip then
  Citizen.CreateThread(function()
    for k,v in pairs(Config.PawnShops) do
    local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
    SetBlipSprite (blip, 431)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7)
    SetBlipColour (blip, 70)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Pawn Shop')
    EndTextCommandSetBlipName(blip)
    end
  end)
end