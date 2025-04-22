UtilitiesPlus = LibStub('AceAddon-3.0'):NewAddon('UtilitiesPlus', 'AceConsole-3.0', 'AceEvent-3.0')

local settings = UtilitiesPlusSettings

function UtilitiesPlus:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('UtilitiesPlusDB', {
        global = {
            EnabledModules = {
                ClearQuests = true,
                Waypoints = true,
                ClearActionBars = true,
                MinimapSocials = true
            },
            DisableAutoAddSpells = true,
            AutoRemoveWaypoints = true,
            MinimapSocials = {
                textSize = 12,
                font = 'Friz Quadrata TT',
                outline = 'NONE',
                shadow = true,
                valueColor = { r = 1, g = 1, b = 1 },
                labelColor = { r = 1, g = 1, b = 1 },
                guildX = -30,
                guildY = 40,
                friendsX = 30,
                friendsY = 40,
                valueColorOverride = false,
                labelColorOverride = false,
                guildAlign = 'CENTER',
                friendsAlign = 'CENTER'
            }
        },
    }, true)

    self:LoadEnabledModules()

    SetCVar('AutoPushSpellToActionBar', self.db.global.DisableAutoAddSpells and '0' or '1')
    _G['MAX_EQUIPMENT_SETS_PER_PLAYER'] = 100

    LibStub('AceConfig-3.0'):RegisterOptionsTable('UtilitiesPlus', settings)
    self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('UtilitiesPlus', 'UtilitiesPlus')

    self:RegisterChatCommand('up', 'HandleSlashCommands')
end

function UtilitiesPlus:LoadEnabledModules()
    for moduleName, isEnabled in pairs(self.db.global.EnabledModules) do
        local module = self:GetModule(moduleName, true)
        if module then
            if isEnabled then
                module:Enable(true)
            else
                module:Disable()
            end
        end
    end
end

function UtilitiesPlus:HandleSlashCommands(input)
    if not input or input:trim() == '' then
        LibStub('AceConfigDialog-3.0'):Open('UtilitiesPlus')
    elseif input == 'help' then
        self:PrintHelp()
    else
        LibStub('AceConfigCmd-3.0'):HandleCommand('up', 'UtilitiesPlus', input)
    end
end

function UtilitiesPlus:PrintHelp()
    local commands = {
        { command = '/up help',            description = 'Displays this help message.' },
        { command = '/up',                 description = 'Opens the configuration menu.' },
        { command = '/way clear',          description = 'Clears the current waypoint.' },
        { command = '/way clear all',      description = 'Clears all waypoints.' },
        { command = '/way {x} {y}',        description = 'Sets a waypoint at the specified coordinates or adds it to the queue if another waypoint is active (e.g. /way 45.3 67.8).' },
        { command = '/way #mapId {x} {y}', description = 'Sets a waypoint at the specified map ID and coordinates (e.g. /way #1 45.3 67.8).' },
        { command = '/clearbars',          description = 'Clears all spells and items from your action bars.' },
        { command = '/clearquests',        description = 'Clears all quests in the quest log.' }
    }
    self:Print('Available commands:')
    for _, cmd in ipairs(commands) do
        self:Print(string.format('%s - %s', cmd.command, cmd.description))
    end
end
