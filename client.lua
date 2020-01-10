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

local DoingBreak			        = false
local GUI                     = {}   
ESX                           = nil  
GUI.Time                      = 0    
local PlayerData              = {}   
local showPro                 = false
local stealing                = false
local peeking                 = false
local ESXLoaded               = false
local chancePoliceNoti        = 100  
local useBlip                 = false
local useInteractSound        = false

local text = "~g~[E]~w~ Lockpick" 
local searchText = "~g~[E]~w~ Search" 
local emptyMessage = "There is nothing here!" 
local emptyMessage3D = "~r~Empty" 

local lockpickQuestionText = "Do you want to lockpick the door?" 
local noLockpickText = "You don't have any lockpicks" 
local yesText = "Yes"
local noText = "No"
local youFound = "You found"
local burglaryDetected = "A burglary has been detected at"

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

RegisterNetEvent('property_rob:setFrozen')
AddEventHandler('property_rob:setFrozen', function(house, status)
    Config.burglaryPlaces[house].door.Frozen = status
    local door = GetClosestObjectOfType(Config.burglaryPlaces[house].door.Coords, 2.0, GetHashKey(Config.burglaryPlaces[house].door.Object), false, 0, 0)
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
  for i = 1, #Config.burglaryPlaces do        
      ESX.TriggerServerCallback('property_rob:getDoorFreezeStatus', function(frozen)
          Config.burglaryPlaces[i].door.Frozen = frozen
          local door = GetClosestObjectOfType(Config.burglaryPlaces[i].door.Coords, 2.0, GetHashKey(Config.burglaryPlaces[i].door.Object), false, 0, 0)
          FreezeEntityPosition(door, Config.burglaryPlaces[i].door.Frozen)
      end, i)      
  end
  while true do
      local player = PlayerPedId()
      local coords = GetEntityCoords(player)
      for i = 1, #Config.burglaryPlaces do
          Wait(0)
          local v = Config.burglaryPlaces[i]
          local d = v.door
          local door = GetClosestObjectOfType(d.Coords, 2.0, GetHashKey(d.Object), false, 0, 0)            
          if door ~= nil then
              FreezeEntityPosition(door, d.Frozen)
              if d.Frozen then
                  SetEntityHeading(door, d.Heading)
              end
          end          
      end
      Wait(50)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    for k,v in pairs(Config.burglaryPlaces) do
      local playerPed = PlayerPedId()
      local house = k
      local coords = GetEntityCoords(playerPed)
      local dist   = GetDistanceBetweenCoords(v.pos.x, v.pos.y, v.pos.z, coords.x, coords.y, coords.z, false)
      if dist <= 30.0 and DoingBreak == false then
        if dist <= 1.2 and DoingBreak == false then
          if v.locked then
            DrawText3D(v.pos.x, v.pos.y, v.pos.z, text, 0.4)                  
              if IsControlJustPressed(0, Keys["E"]) then
                confMenu(house)
              end
          end        
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
    while stealing == false do
      Citizen.Wait(5)
      for k,v in pairs(Config.burglaryInside) do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist   = GetDistanceBetweenCoords(v.x, v.y, v.z, coords.x, coords.y, coords.z, false)
        if dist <= 1.2 and v.amount > 0 then
            DrawText3D(v.x, v.y, v.z, searchText, 0.4)
            if dist <= 0.5 and IsControlJustPressed(0, Keys["E"]) then
              steal(k)
            end
        elseif v.amount < 1 and dist <= 1.2 then
          DrawText3D(v.x, v.y, v.z, emptyMessage3D, 0.4)
          if IsControlJustPressed(0, Keys["E"]) and dist <= 0.5 then 
            ESX.ShowNotification(emptyMessage)
          end
        end
      end
    end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(6)
    if showPro == true then
      local playerPed = PlayerPedId()
		  local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
	end
end)

RegisterNetEvent('property_rob:msgPolice')
AddEventHandler('property_rob:msgPolice', function(coords)    
	  ESX.ShowNotification("A ~r~house alarm ~w~was set off by an intruder", 7000)
    while true do
        local name = GetCurrentResourceName() .. math.random(999)
        AddTextEntry(name, '~INPUT_CONTEXT~ ' .. 'Set a waypoint to the house' .. '\n~INPUT_FRONTEND_RRIGHT~ ' .. 'Close this box')
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

function confMenu(house)
  local v = GetHouseValues(house, Config.burglaryPlaces)
  Citizen.CreateThread(function()
  ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conf_menu',
		{
			title = lockpickQuestionText,
			align = 'center',
			elements = {
        {label = yesText, value = 'yes'},
        {label = noText, value = 'no'}
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
          HouseBreak(house)
          v.locked = false
          Citizen.Wait(math.random(15000,30000))
          local random = math.random(0, 100)
          if random <= chancePoliceNoti then                  
            TriggerServerEvent('property_rob:alarm', { x = v.pos.x, y = v.pos.y, z = v.pos.z })
          end
        else 
          ESX.ShowNotification(noLockpickText)
        end

		  elseif data.current.value == 'no' then 
			
	    end
    end)  
  end)
end

function steal(k)
    local values = GetHouseValues(k, Config.burglaryInside)
    local playerPed = PlayerPedId()
    stealing = true
    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(2000)
    procent(50)
    if values.amount >= 2 then
      local rndm = math.random(1,2)
      TriggerServerEvent('property_rob:Add', values.item, rndm)
        ESX.ShowNotification( 'You found something' )
        values.amount = values.amount - rndm
    else
      TriggerServerEvent('property_rob:Add', values.item, 1)
        ESX.ShowNotification( 'You found something' )
        values.amount = values.amount - 1
    end
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    stealing = false
end

function HouseBreak(house)
  local v = GetHouseValues(house, Config.burglaryPlaces)
  local playerPed = PlayerPedId()
  DoingBreak = true
  FreezeEntityPosition(playerPed, true)
  SetEntityCoords(playerPed, v.animPos.x, v.animPos.y, v.animPos.z - 0.98)
  SetEntityHeading(playerPed, v.animPos.h)
  loaddict("mini@safe_cracking")
  TaskPlayAnim(playerPed, "mini@safe_cracking", "idle_base", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
  if useInteractSound then
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.7)
  end
  procent(70)
  TriggerServerEvent('property_rob:Remove', 'lockpick', 1)
  ClearPedTasks(playerPed)
  FreezeEntityPosition(playerPed, false)
  TriggerServerEvent('property_rob:setDoorFreezeStatus', house, false)
end


function SetCoords(playerPed, x, y, z)
  SetEntityCoords(playerPed, x, y, z)
  Citizen.Wait(100)
  SetEntityCoords(playerPed, x, y, z)
end

function fade()
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  DoScreenFadeIn(1000)
end

function loaddict(dict)
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

function procent(time)
  showPro = true
  TimeLeft = 0
  repeat
  TimeLeft = TimeLeft + 1        -- thank you (github.com/Loffes)
  Citizen.Wait(time)
  until(TimeLeft == 100)
  showPro = false
end

function GetHouseValues(house, pair)
    for k,v in pairs(pair) do
        if k == house then
            return v
        end
    end
end

if useBlip then
  Citizen.CreateThread(function()
    for k,v in pairs(Config.burglaryPlaces) do
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

RegisterNetEvent('property_rob:Sound')
AddEventHandler('property_rob:Sound', function(sound1, sound2)
  PlaySoundFrontend(-1, sound1, sound2)
end)