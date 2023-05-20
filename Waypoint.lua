local _ = ...;

SLASH_UtilitiesPlus1 = '/way';

function Waypoint_HelpText()
  print('Command requires 2 numbers between 0 - 100')
  print('For example: /way 25 30')
  print('To remove existing waypoint use: /way clear')
end

function SplitStr(str)
  local t = {}
  for s in str.gmatch(str, '([^%s]+)') do
    table.insert(t, s)
  end
  return t
end

function Waypoint_Set(cords)
  if (#cords == 2 and cords[1] <= 1 and cords[2] <= 1) then
    local location = C_Map.GetBestMapForUnit('player')
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(location, cords[1], cords[2]))
    local link = C_Map.GetUserWaypointHyperLink()
    print(string.format('Waypoint created at (x: %i, y: %i) : %s', (cords[1] * 100), (cords[2] * 100), link))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  else
    Waypoint_HelpText()
  end
end

function SlashCmdList.Waypoint(msg, _)
  if msg == 'clear' then
    C_Map.ClearUserWaypoint()
    C_SuperTrack.SetSuperTrackedUserWaypoint(false)
    print('Clearing active waypoint.')
  else
    local options = {}
    local terms = SplitStr(msg)
    for _, value in pairs(terms) do
      value = value:gsub('%.', '')
      value = value:gsub('%,', '')
      value = string.match(value, '^(%d+)$')
      if value then
        if string.find(value, '%.') or string.find(value, '%.') then
          value = (value / (10 ^ string.len(value)))
        else
          value(value / (10 ^ 2))
        end
        table.insert(options, value)
      end
    end
    Waypoint_Set(options)
  end
end