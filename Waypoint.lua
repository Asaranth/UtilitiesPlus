SLASH_Waypoint1 = '/way'

local waypointQueue = {}

function Waypoint_HelpText()
  print('------ UtilitiesPlus - Waypoint Help ------')
  print('Command requires 2 numbers between 0 - 100')
  print('For example: /way 36.6 71.6')
  print('To remove existing waypoint use: /way clear')
  print('-------------------------------------------')
end

function SplitStr(str)
  local tbl = {}
  for x in str:gmatch('%S+') do
    table.insert(tbl, x)
  end
  return tbl
end

function Waypoint_Set(cords)
  if (#cords == 2 and cords[1] <= 1 and cords[2] <= 1) then
    local location = C_Map.GetBestMapForUnit('player')
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(location, cords[1], cords[2]))
    local link = C_Map.GetUserWaypointHyperlink()
    print(string.format('Waypoint created at (x: %.1f, y: %.1f): ', (cords[1] * 100), (cords[2] * 100)) .. link)
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  else
    Waypoint_HelpText()
  end
end

function Waypoint_Clear()
  C_Map.ClearUserWaypoint()
  C_SuperTrack.SetSuperTrackedUserWaypoint(false)
end

function SlashCmdList.Waypoint(msg)
  local commands = SplitStr(msg)
  if #commands > 0 and commands[1] == 'clear' then
    Waypoint_Clear()
    if #commands > 1 and commands[2] == 'all' then
      waypointQueue = {}
      print('Clearing all waypoints.')
    else
      table.remove(waypointQueue, 1)
      if #waypointQueue > 0 then
        Waypoint_Set(waypointQueue[1])
      end
      print('Clearing active waypoint and moving to the next waypoint, if any.')
    end
  else
    local options = {}
    local terms = SplitStr(msg)
    for _, value in pairs(terms) do
      value = value:gsub('%,', ''):match('%d+%.?%d*')
      if value then
        value = value / 100
        table.insert(options, value)
      end
    end
    table.insert(waypointQueue, options)
    if #waypointQueue == 1 then
      Waypoint_Set(options)
    else
      print(string.format('Waypoint added to queue at position %d (x: %.1f, y: %.1f)', #waypointQueue, options[1] * 100, options[2] * 100))
    end
  end
end

local f = CreateFrame('frame')
f:SetScript('OnEvent', function()
  if not C_SuperTrack.IsSuperTrackingUserWaypoint() then return end

  local location = C_Map.GetBestMapForUnit('player')
  local playerPosition = C_Map.GetPlayerMapPosition(location, "player")
  local waypoint = C_Map.GetUserWaypoint()
  local meX, meY = playerPosition:GetXY()
  local wayX, wayY = C_Map.GetUserWaypointPositionForMap(waypoint.uiMapID):GetXY()
  local diffX = math.abs(meX - wayX)
  local diffY = math.abs(meY - wayY)

  if diffX <= 0.009 and diffY <= 0.009 then
    print("Waypoint reached.")
    table.remove(waypointQueue, 1)

    if #waypointQueue > 0 then
      Waypoint_Set(waypointQueue[1])
    else
      Waypoint_Clear()
      print("Clearing active waypoint.")
    end
  end
end)
f:RegisterEvent('PLAYER_STOPPED_MOVING')