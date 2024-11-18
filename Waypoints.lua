local Waypoint = UtilitiesPlus:NewModule('Waypoint', 'AceConsole-3.0', 'AceEvent-3.0')

local waypointQueue = {}
local activeWaypoint = nil

function Waypoint:OnInitialize()
  self:RegisterChatCommand('way', 'HandleWaypointCommands')
  self:RegisterEvent('PLAYER_STOPPED_MOVING', 'OnPlayerStoppedMoving')
end

function Waypoint:HandleWaypointCommands(input)
  local commands = self:SplitStr(input)
  if #commands > 0 and commands[1] == 'clear' then
    self:ClearWaypoint()
    activeWaypoint = nil
    if #commands > 1 and commands[2] == 'all' then
      waypointQueue = {}
      UtilitiesPlus:Print('Clearing all waypoints.')
    else
      if #waypointQueue > 0 then
        self:SetWaypoint(table.remove(waypointQueue, 1))
      end
      UtilitiesPlus:Print('Clearing active waypoint and moving to the next waypoint, if any.')
    end
  else
    local options = {}
    for _, value in ipairs(commands) do
      value = value:gsub(',', ''):match('%d+%.?%d*')
      if value then
        value = value / 100
        table.insert(options, value)
      end
    end
    table.insert(waypointQueue, options)
    if not activeWaypoint then
      self:SetWaypoint(table.remove(waypointQueue, 1))
    else
      UtilitiesPlus:Print(string.format('Waypoint added to queue at position %d (x: %.1f, y: %.1f)', #waypointQueue, options[1] * 100, options[2] * 100))
    end
  end
end

function Waypoint:OnPlayerStoppedMoving()
  if not C_SuperTrack.IsSuperTrackingUserWaypoint() then return end
  local location = C_Map.GetBestMapForUnit('player')
  local playerPosition = C_Map.GetPlayerMapPosition(location, 'player')
  local waypoint = C_Map.GetUserWaypoint()
  local meX, meY = playerPosition:GetXY()
  local wayX, wayY = C_Map.GetUserWaypointPositionForMap(waypoint.uiMapID):GetXY()
  local diffX = math.abs(meX - wayX)
  local diffY = math.abs(meY - wayY)

  if diffX <= 0.009 and diffY <= 0.009 then
    UtilitiesPlus:Print(UtilitiesPlus.db.global.WaypointReachedMessage)
    if #waypointQueue > 0 then
      self:SetWaypoint(table.remove(waypointQueue, 1))
    else
      if UtilitiesPlus.db.global.AutoRemoveWaypoints then
        self:ClearWaypoint()
        activeWaypoint = nil
      end
    end
  end
end

function Waypoint:SetWaypoint(coords)
  local location = C_Map.GetBestMapForUnit('player')
  C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(location, coords[1], coords[2]))
  local link = C_Map.GetUserWaypointHyperlink()
  UtilitiesPlus:Print(string.format('Waypoint created at (x: %.1f, y: %.1f): ', (coords[1] * 100), (coords[2] * 100)) .. link)
  C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  activeWaypoint = coords
end

function Waypoint:ClearWaypoint()
  C_Map.ClearUserWaypoint()
  C_SuperTrack.SetSuperTrackedUserWaypoint(false)
end

function Waypoint:SplitStr(str)
  local tbl = {}
  for x in str:gmatch('%S+') do
    table.insert(tbl, x)
  end
  return tbl
end