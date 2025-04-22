local Waypoints = UtilitiesPlus:NewModule('Waypoints', 'AceConsole-3.0', 'AceEvent-3.0')

local waypointQueue = {}
local activeWaypoint

function Waypoints:HandleWaypointCommands(input)
    local commands = self:SplitStr(input)
    if #commands > 0 and commands[1] == 'clear' then
        self:ClearWaypoint()
        activeWaypoint = nil
        if #commands > 1 and commands[2] == 'all' then
            waypointQueue = {}
            UtilitiesPlus:Print('All waypoints cleared.')
        else
            UtilitiesPlus:Print('Waypoint cleared.')
            if #waypointQueue > 0 then
                self:SetWaypoint(table.remove(waypointQueue, 1))
            end
        end
    else
        local locationId, xCoord, yCoord = nil, nil, nil
        local withMapIdPattern = "#(%d+)%s+([%d%.]+)[,%s]+([%d%.]+)"
        local withoutMapIdPattern = "([%d%.]+)[,%s]+([%d%.]+)"

        local matchedInput = false

        if input:match("^#%d+") then
            locationId, xCoord, yCoord = input:match(withMapIdPattern)
            matchedInput = true
        end

        if not matchedInput then
            xCoord, yCoord = input:match(withoutMapIdPattern)
        end

        xCoord = tonumber(xCoord)
        yCoord = tonumber(yCoord)
        locationId = tonumber(locationId) or C_Map.GetBestMapForUnit('player')

        if not xCoord or not yCoord then
            UtilitiesPlus:Print('Invalid coordinates provided.')
            return
        end

        local options = { locationId, xCoord / 100, yCoord / 100 }

        table.insert(waypointQueue, options)
        if not activeWaypoint then
            self:SetWaypoint(table.remove(waypointQueue, 1))
        else
            local mapInfo = C_Map.GetMapInfo(locationId)
            local locationName = mapInfo and mapInfo.name or tostring(locationId)
            UtilitiesPlus:Print(string.format('Waypoint added to queue at position %d (zone: %s, x: %.1f, y: %.1f)',
                #waypointQueue, locationName, xCoord, yCoord))
        end
    end
end

function Waypoints:OnNavigationDestinationReached()
    if #waypointQueue > 0 then
        self:SetWaypoint(table.remove(waypointQueue, 1))
    else
        if UtilitiesPlus.db.global.AutoRemoveWaypoints then
            self:ClearWaypoint()
            activeWaypoint = nil
        end
    end
end

function Waypoints:SetWaypoint(coords)
    local mapID = coords[1]
    local xCoord = coords[2]
    local yCoord = coords[3]

    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, xCoord, yCoord))
    local link = C_Map.GetUserWaypointHyperlink()
    local mapInfo = C_Map.GetMapInfo(mapID)
    local locationName = mapInfo and mapInfo.name or tostring(mapID)
    UtilitiesPlus:Print(string.format('Waypoint created at (zone: %s, x: %.1f, y: %.1f): ', locationName, (xCoord * 100),
        (yCoord * 100)) .. link)
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    activeWaypoint = { mapID, xCoord, yCoord }
end

function Waypoints:ClearWaypoint()
    C_Map.ClearUserWaypoint()
    C_SuperTrack.SetSuperTrackedUserWaypoint(false)
end

function Waypoints:SplitStr(str)
    local tbl = {}
    for x in str:gmatch('%S+') do
        table.insert(tbl, x)
    end
    return tbl
end

function Waypoints:Enable(init)
    if not self._enabled then
        self:RegisterChatCommand('way', 'HandleWaypointCommands')
        self:RegisterEvent('NAVIGATION_DESTINATION_REACHED', 'OnNavigationDestinationReached')
        self._enabled = true
        if not init then UtilitiesPlus:Print('Waypoint module |cff00ff00enabled|r.') end
    end
end

function Waypoints:Disable()
    if self._enabled then
        self:UnregisterChatCommand('way')
        self:UnregisterEvent('NAVIGATION_DESTINATION_REACHED')
        self._enabled = false
        UtilitiesPlus:Print('Waypoint module |cffff0000disabled|r.')
    end
end
