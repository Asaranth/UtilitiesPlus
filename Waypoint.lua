SLASH_Waypoint1 = '/way'

function Waypoint_HelpText()
  print('------ UtilitiesPlus - Waypoint Help ------')
  print('Command requires 2 numbers between 0 - 100')
  print('For example: /way 25 30')
  print('To remove existing waypoint use: /way clear')
  print('-------------------------------------------')
end

function SplitStr(str)
  local tbl = {}
  for x in str:gmatch('%d+') do
    table.insert(tbl, x)
  end
  return tbl
end

function Waypoint_Set(cords)
  if (#cords == 2 and cords[1] <= 1 and cords[2] <= 1) then
    local location = C_Map.GetBestMapForUnit('player')
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(location, cords[1], cords[2]))
    local link = C_Map.GetUserWaypointHyperlink()
    print(string.format('Waypoint created at (x: %d, y: %d) : ', (cords[1] * 100), (cords[2] * 100)) .. link)
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
  else
    Waypoint_HelpText()
  end
end

function SlashCmdList.Waypoint(msg)
  if msg == 'clear' then
    C_Map.ClearUserWaypoint()
    C_SuperTrack.SetSuperTrackedUserWaypoint(false)
    print('Clearing active waypoint.')
  else
    local options = {}
    local terms = SplitStr(msg)
    for _, value in pairs(terms) do
      value = value:gsub('%.', ''):gsub('%,', ''):match('^(%d+)$')
      if value then
        if value:find('%.') or value:find('%,') then
          value = (value / (10 ^ value:len()))
        else
          value = (value / (10 ^ 2))
        end
        table.insert(options, value)
      end
    end
    Waypoint_Set(options)
  end
end