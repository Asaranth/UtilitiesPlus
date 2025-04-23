local MinimapSocials = UtilitiesPlus:NewModule('MinimapSocials', 'AceEvent-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local guildText, friendsText
local DEFAULT_FONT = 'Friz Quadrata TT'
local DEFAULT_ALIGN = 'CENTER'
local DEFAULT_TEXT_SIZE = 12
local TYPE_GUILD = 'GUILD'
local TYPE_FRIEND = 'FRIEND'
local TOOLTIP_TITLE_GUILD = 'Guild Members Online'
local TOOLTIP_TITLE_FRIENDS = 'Friends Online'

local function GetClassColor(class)
    if not class then return 1, 1, 1 end
    class = class:gsub("%s+", ""):upper()
    local c = RAID_CLASS_COLORS[class]
    if not c then return 1, 1, 1 end
    return c.r, c.g, c.b
end

local function CalculateTextWidthForFont(text, size)
    return string.len(text) * size * 0.6
end

local function AddTooltipLinesForGuild()
    GameTooltip:AddLine(TOOLTIP_TITLE_GUILD, 1, 1, 1)
    local numTotal = GetNumGuildMembers()
    for i = 1, numTotal do
        local name, _, _, _, _, zone, _, _, online, _, class = GetGuildRosterInfo(i)
        if online then
            local shortName = name and name:match("^[^%-]+") or 'Unknown'
            local r, g, b = GetClassColor(class)
            GameTooltip:AddDoubleLine(shortName, zone or 'Unknown', r, g, b, 0.8, 0.8, 0.8)
        end
    end
end

local function AddTooltipLinesForFriends()
    GameTooltip:AddLine(TOOLTIP_TITLE_FRIENDS, 1, 1, 1)
    for i = 1, C_FriendList.GetNumFriends() do
        local info = C_FriendList.GetFriendInfoByIndex(i)
        if info and info.connected then
            local r, g, b = GetClassColor(info.className)
            GameTooltip:AddDoubleLine(info.name or 'Unknown', info.area or 'Unknown', r, g, b, 0.8, 0.8, 0.8)
        end
    end
end

local function AddBattleNetFriendTooltipLines()
    for i = 1, BNGetNumFriends() do
        local friendInfo = C_BattleNet.GetFriendAccountInfo(i)
        local game = friendInfo and friendInfo.gameAccountInfo
        if game and game.isOnline and game.clientProgram == "WoW" then
            local charName = game.characterName or friendInfo.accountName or 'Unknown'
            local r, g, b = GetClassColor(game.className)
            GameTooltip:AddDoubleLine(charName, game.areaName or 'Unknown', r, g, b, 0.8, 0.8, 0.8)
        end
    end
end

local function CreateSocialText(name, type)
    local db = UtilitiesPlus.db.global.MinimapSocials or {}
    local frame = CreateFrame('Frame', name, Minimap)
    frame.text = frame:CreateFontString(nil, 'OVERLAY')
    frame.type = type
    frame:EnableMouse(true)
    frame:SetMouseClickEnabled(true)
    frame:SetFrameStrata('MEDIUM')

    frame:SetScript('OnEnter', function(self)
        GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM')
        GameTooltip:ClearLines()
        if self.type == TYPE_GUILD then
            AddTooltipLinesForGuild()
        else
            AddTooltipLinesForFriends()
            AddBattleNetFriendTooltipLines()
        end
        GameTooltip:Show()
    end)

    frame:SetScript('OnLeave', function() GameTooltip:Hide() end)
    frame:SetScript('OnMouseUp', function(_, button)
        if frame.type == TYPE_GUILD then
            ToggleGuildFrame()
        elseif frame.type == TYPE_FRIEND then
            ToggleFriendsFrame()
        end
    end)

    local initialText = type == TYPE_GUILD and '### Guild' or '### Friends'
    local size = db.textSize or DEFAULT_TEXT_SIZE
    frame:SetSize(CalculateTextWidthForFont(initialText, size), size)

    frame.text:SetAllPoints(frame)
    frame.text:SetAlpha(1)
    frame.text:SetJustifyH(db[type == TYPE_GUILD and 'guildAlign' or 'friendsAlign'] or DEFAULT_ALIGN)
    frame:Show()
    return frame
end

local function UpdateFontSettings()
    local db = UtilitiesPlus.db.global.MinimapSocials or {}
    local font = LSM:Fetch('font', db.font or DEFAULT_FONT)
    local outline = db.outline or 'NONE'
    local size = db.textSize or DEFAULT_TEXT_SIZE

    if guildText and guildText.text then
        guildText.text:SetFont(font, size, outline)
        guildText.text:SetShadowOffset(db.shadow and 1 or 0, db.shadow and -1 or 0)
    end

    if friendsText and friendsText.text then
        friendsText.text:SetFont(font, size, outline)
        friendsText.text:SetShadowOffset(db.shadow and 1 or 0, db.shadow and -1 or 0)
    end
end

local function Apply(f, label, count, isValue, extraInfo)
    if not f or not f.text then return end

    local db = UtilitiesPlus.db.global.MinimapSocials or {}
    local font = LSM:Fetch('font', db.font or DEFAULT_FONT)
    local size = db.textSize or DEFAULT_TEXT_SIZE
    local outline = db.outline or 'NONE'

    local function GetClassColorOrDefault(isValue)
        if isValue and db.valueColorOverride then
            local _, class = UnitClass('player')
            return GetClassColor(class)
        elseif not isValue and db.labelColorOverride then
            local _, class = UnitClass('player')
            return GetClassColor(class)
        else
            return db.valueColor.r or 1, db.valueColor.g or 1, db.valueColor.b or 1
        end
    end

    local colorValR, colorValG, colorValB = GetClassColorOrDefault(isValue)
    local lblColorR, lblColorG, lblColorB = GetClassColorOrDefault(false)

    local text = string.format('|cff%02x%02x%02x%d |cff%02x%02x%02x%s|r',
        colorValR * 255, colorValG * 255, colorValB * 255, count or 0,
        lblColorR * 255, lblColorG * 255, lblColorB * 255, label)

    if extraInfo then
        text = text .. string.format(' - |cffAAAA00%s|r', extraInfo)
    end

    f.text:SetFont(font, size, outline)
    f.text:SetText(text)
    f.text:SetShadowOffset(db.shadow and 1 or 0, db.shadow and -1 or 0)
end

local function UpdateTextValues()
    local db = UtilitiesPlus.db.global.MinimapSocials or {}
    local guildOnline = 0
    local friendsOnline = 0
    local battleNetInGame = 0

    for i = 1, GetNumGuildMembers() do
        local _, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i)
        if online then guildOnline = guildOnline + 1 end
    end

    for i = 1, C_FriendList.GetNumFriends() do
        local info = C_FriendList.GetFriendInfoByIndex(i)
        if info and info.connected then friendsOnline = friendsOnline + 1 end
    end

    for i = 1, BNGetNumFriends() do
        local info = C_BattleNet.GetFriendAccountInfo(i)
        if info and info.gameAccountInfo and info.gameAccountInfo.isOnline and info.gameAccountInfo.clientProgram == "WoW" then
            battleNetInGame = battleNetInGame + 1
        end
    end

    Apply(guildText, 'Guild', guildOnline, true)
    Apply(friendsText, 'Friends', friendsOnline + battleNetInGame, true)

    guildText:SetPoint(DEFAULT_ALIGN, Minimap, DEFAULT_ALIGN, db.guildX or -30, db.guildY or 40)
    friendsText:SetPoint(DEFAULT_ALIGN, Minimap, DEFAULT_ALIGN, db.friendsX or 30, db.friendsY or 40)
end

function MinimapSocials:UpdateTexts()
    local db = UtilitiesPlus.db.global.MinimapSocials or {}
    local size = db.textSize or DEFAULT_TEXT_SIZE
    UpdateFontSettings()
    UpdateTextValues()
    guildText:SetSize(CalculateTextWidthForFont('### Guild', size), size)
    friendsText:SetSize(CalculateTextWidthForFont('### Friends', size), size)
    guildText.text:SetJustifyH(db.guildAlign or DEFAULT_ALIGN)
    friendsText.text:SetJustifyH(db.friendsAlign or DEFAULT_ALIGN)
end

function MinimapSocials:Enable(init)
    if not self._enabled then
        guildText = CreateSocialText('GuildTextFrame', TYPE_GUILD)
        friendsText = CreateSocialText('FriendsTextFrame', TYPE_FRIEND)

        self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateTexts')
        self:RegisterEvent('FRIENDLIST_UPDATE', 'UpdateTexts')
        self:RegisterEvent('GUILD_ROSTER_UPDATE', 'UpdateTexts')
        self:RegisterEvent('PLAYER_GUILD_UPDATE', 'UpdateTexts')
        self:RegisterEvent('GROUP_ROSTER_UPDATE', 'UpdateTexts')

        C_Timer.After(1, function()
            C_FriendList.ShowFriends()
            self:UpdateTexts()
        end)

        self._enabled = true
        if not init then UtilitiesPlus:Print('MinimapSocials module |cff00ff00enabled|r.') end
    end
end

function MinimapSocials:Disable()
    if self._enabled then
        if self._enabled then
            self:UnregisterEvent('PLAYER_ENTERING_WORLD')
            self:UnregisterEvent('FRIENDLIST_UPDATE')
            self:UnregisterEvent('GUILD_ROSTER_UPDATE')
            self:UnregisterEvent('PLAYER_GUILD_UPDATE')
            self:UnregisterEvent('GROUP_ROSTER_UPDATE')

            if guildText then
                guildText:Hide()
                guildText = nil
            end

            if friendsText then
                friendsText:Hide()
                friendsText = nil
            end

            self._enabled = false
            UtilitiesPlus:Print('MinimapSocials module |cffff0000disabled|r.')
        end
    end
end
