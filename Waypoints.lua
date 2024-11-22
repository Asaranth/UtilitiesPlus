local Waypoint = UtilitiesPlus:NewModule('Waypoint', 'AceConsole-3.0', 'AceEvent-3.0')

local waypointQueue = {}
local activeWaypoint

local function showPopupMessage(msg)
    local frame = RaidWarningFrame
    frame.messageTime = 2

    local function removeMessage()
        frame:SetScript("OnUpdate", nil)
        frame.slot1:SetText("")
        frame.slot2:SetText("")
    end

    frame:SetScript("OnUpdate", function(_, elapsed)
        frame.messageTime = frame.messageTime - elapsed
        if frame.messageTime <= 0 then
            removeMessage()
        end
    end)

    RaidNotice_AddMessage(frame, msg, ChatTypeInfo['RAID_WARNING'])
end

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
            UtilitiesPlus:Print(string.format('Waypoint added to queue at position %d (zone: %s, x: %.1f, y: %.1f)', #waypointQueue, locationName, xCoord, yCoord))
        end
    end
end

function Waypoint:OnPlayerStoppedMoving()
    if not C_SuperTrack.IsSuperTrackingUserWaypoint() then
        return
    end
    local location = C_Map.GetBestMapForUnit('player')
    local playerPosition = C_Map.GetPlayerMapPosition(location, 'player')
    local waypoint = C_Map.GetUserWaypoint()
    local meX, meY = playerPosition:GetXY()
    local wayX, wayY = C_Map.GetUserWaypointPositionForMap(waypoint.uiMapID):GetXY()
    local diffX = math.abs(meX - wayX)
    local diffY = math.abs(meY - wayY)

    if diffX <= 0.009 and diffY <= 0.009 then
        local message = UtilitiesPlus.db.global.WaypointReachedMessage
        if UtilitiesPlus.db.global.MessageDisplayType == 'warning' then
            showPopupMessage(message)
        else
            UtilitiesPlus:Print(message)
        end

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
    local mapID = coords[1]
    local xCoord = coords[2]
    local yCoord = coords[3]

    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, xCoord, yCoord))
    local link = C_Map.GetUserWaypointHyperlink()
    local mapInfo = C_Map.GetMapInfo(mapID)
    local locationName = mapInfo and mapInfo.name or tostring(mapID)
    UtilitiesPlus:Print(string.format('Waypoint created at (zone: %s, x: %.1f, y: %.1f): ', locationName, (xCoord * 100), (yCoord * 100)) .. link)
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    activeWaypoint = { mapID, xCoord, yCoord }
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