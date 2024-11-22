UtilitiesPlus = LibStub('AceAddon-3.0'):NewAddon('UtilitiesPlus', 'AceConsole-3.0', 'AceEvent-3.0')

local options = {
    name = 'UtilitiesPlus',
    handler = UtilitiesPlus,
    type = 'group',
    args = {
        general = {
            type = 'group',
            name = 'General',
            args = {
                DisableAutoAddSpells = {
                    type = 'toggle',
                    name = 'Disable Auto Add Spells',
                    desc = 'Prevent spells from being added to the actionbars automatically.',
                    order = 1,
                    width = 'full',
                    set = function(_, val)
                        UtilitiesPlus.db.global.DisableAutoAddSpells = val
                        SetCVar('AutoPushSpellToActionBar', val and '0' or '1')
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.DisableAutoAddSpells
                    end,
                }
            }
        },
        waypoints = {
            type = 'group',
            name = 'Waypoints',
            args = {
                WaypointReachedMessage = {
                    type = 'input',
                    name = 'Waypoint Reached Message',
                    desc = 'Custom message to display when reaching a waypoint.',
                    order = 1,
                    width = 'full',
                    set = function(_, val)
                        UtilitiesPlus.db.global.WaypointReachedMessage = val
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.WaypointReachedMessage
                    end
                },
                AutoRemoveWaypoints = {
                    type = 'toggle',
                    name = 'Auto Remove Waypoints',
                    desc = 'Remove waypoints when reaching them automatically. (When off queues will continue to remove waypoints when reached until the last waypoint is active)',
                    order = 2,
                    width = 'full',
                    set = function(_, val)
                        UtilitiesPlus.db.global.AutoRemoveWaypoints = val
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.AutoRemoveWaypoints
                    end
                },
                MessageDisplayType = {
                    type = 'select',
                    name = 'Waypoint Reached Message Display Type',
                    desc = 'Choose whether the Waypoint Reached message is displayed in the chat or as a raid warning.',
                    order = 3,
                    width = 'full',
                    values = { ['chat'] = 'Chat', ['warning'] = 'Raid Warning' },
                    set = function(_, val)
                        UtilitiesPlus.db.global.MessageDisplayType = val
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MessageDisplayType
                    end
                }
            }
        }
    }
}

function UtilitiesPlus:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('UtilitiesPlusDB', {
        global = {
            DisableAutoAddSpells = true,
            AutoRemoveWaypoints = true,
            WaypointReachedMessage = 'Waypoint reached.',
            MessageDisplayType = 'chat'
        },
    }, true)

    SetCVar('AutoPushSpellToActionBar', self.db.global.DisableAutoAddSpells and '0' or '1')
    _G['MAX_EQUIPMENT_SETS_PER_PLAYER'] = 100

    LibStub('AceConfig-3.0'):RegisterOptionsTable('UtilitiesPlus', options)
    self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('UtilitiesPlus', 'UtilitiesPlus')

    self:RegisterChatCommand('up', 'HandleSlashCommands')
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
        { command = '/up help', description = 'Displays this help message.' },
        { command = '/up', description = 'Opens the configuration menu.' },
        { command = '/way clear', description = 'Clears the current waypoint.' },
        { command = '/way clear all', description = 'Clears all waypoints.' },
        { command = '/way {x} {y}', description = 'Sets a waypoint at the specified coordinates or adds it to the queue if another waypoint is active (e.g. /way 45.3 67.8).' },
        { command = '/way #mapId {x} {y}', description = 'Sets a waypoint at the specified map ID and coordinates (e.g. /way #1 45.3 67.8).' },
        { command = '/clearbars', description = 'Clears all spells and items from your action bars.' },
        { command = '/clearquests', description = 'Clears all quests in the quest log.' }
    }
    self:Print('Available commands:')
    for _, cmd in ipairs(commands) do
        self:Print(string.format('%s - %s', cmd.command, cmd.description))
    end
end