UtilitiesPlusSettings = {
    name = 'UtilitiesPlus',
    handler = UtilitiesPlus,
    type = 'group',
    args = {
        modules = {
            type = 'group',
            name = 'Modules',
            args = {
                ClearQuestsToggle = {
                    type = 'toggle',
                    name = 'Enable ClearQuests',
                    desc = 'Enable or disable the ClearQuests module.',
                    order = 0,
                    set = function(_, val)
                        UtilitiesPlus.db.global.EnabledModules.ClearQuests = val
                        if val then
                            UtilitiesPlus:GetModule('ClearQuests'):Enable()
                        else
                            UtilitiesPlus:GetModule('ClearQuests'):Disable()
                        end
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.EnabledModules.ClearQuests
                    end,
                },
                WaypointsToggle = {
                    type = 'toggle',
                    name = 'Enable Waypoints',
                    desc = 'Enable or disable the Waypoints module.',
                    order = 1,
                    set = function(_, val)
                        UtilitiesPlus.db.global.EnabledModules.Waypoints = val
                        if val then
                            UtilitiesPlus:GetModule('Waypoint'):Enable()
                        else
                            UtilitiesPlus:GetModule('Waypoint'):Disable()
                        end
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.EnabledModules.Waypoints
                    end,
                },
                ClearActionBarsToggle = {
                    type = 'toggle',
                    name = 'Enable ClearActionBars',
                    desc = 'Enable or disable the ClearActionBars module.',
                    order = 2,
                    set = function(_, val)
                        UtilitiesPlus.db.global.EnabledModules.ClearActionBars = val
                        if val then
                            UtilitiesPlus:GetModule('ClearActionBars'):Enable()
                        else
                            UtilitiesPlus:GetModule('ClearActionBars'):Disable()
                        end
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.EnabledModules.ClearActionBars
                    end,
                },
                MinimapSocialsToggle = {
                    type = 'toggle',
                    name = 'Enable MinimapSocials',
                    desc = 'Enable or disable the MinimapSocials module.',
                    order = 3,
                    set = function(_, val)
                        UtilitiesPlus.db.global.EnabledModules.MinimapSocials = val
                        if val then
                            UtilitiesPlus:GetModule('MinimapSocials'):Enable()
                        else
                            UtilitiesPlus:GetModule('MinimapSocials'):Disable()
                        end
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.EnabledModules.MinimapSocials
                    end,
                },
            },
        },
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
                },
                AutoRemoveWaypoints = {
                    type = 'toggle',
                    name = 'Auto Remove Waypoints',
                    desc =
                    'Remove waypoints when reaching them automatically. (When off queues will continue to remove waypoints when reached until the last waypoint is active)',
                    order = 2,
                    width = 'full',
                    set = function(_, val)
                        UtilitiesPlus.db.global.AutoRemoveWaypoints = val
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.AutoRemoveWaypoints
                    end
                }
            }
        },
        minimapSocials = {
            type = 'group',
            name = 'Minimap Socials',
            args = {
                textSize = {
                    type = 'range',
                    name = 'Text Size',
                    min = 8,
                    max = 24,
                    step = 1,
                    order = 1,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.textSize = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.textSize or 12
                    end,
                },
                font = {
                    type = 'select',
                    dialogControl = 'LSM30_Font',
                    name = 'Font',
                    order = 2,
                    values = AceGUIWidgetLSMlists.font,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.font = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.font or 'Friz Quadrata TT'
                    end,
                },
                outline = {
                    type = 'select',
                    name = 'Outline Type',
                    order = 3,
                    values = {
                        NONE = 'None',
                        OUTLINE = 'Outline',
                        THICKOUTLINE = 'Thick Outline',
                    },
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.outline = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.outline or 'NONE'
                    end,
                },
                shadow = {
                    type = 'toggle',
                    name = 'Enable Shadow',
                    desc = 'Toggles text shadow for better visibility.',
                    order = 4,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.shadow = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.shadow
                    end,
                },
                headerColors = {
                    type = 'header',
                    name = 'Colors',
                    order = 5,
                },
                valueColor = {
                    type = 'color',
                    name = 'Value Color',
                    desc = 'Color for the numeric value.',
                    order = 6,
                    hasAlpha = false,
                    set = function(_, r, g, b)
                        UtilitiesPlus.db.global.MinimapSocials.valueColor = { r = r, g = g, b = b }
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        local c = UtilitiesPlus.db.global.MinimapSocials.valueColor or { r = 1, g = 1, b = 1 }
                        return c.r, c.g, c.b
                    end,
                },
                valueColorOverride = {
                    type = 'toggle',
                    name = 'Use Class Color',
                    desc = 'Use your class color for the numeric value text.',
                    order = 7,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.valueColorOverride = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.valueColorOverride
                    end,
                },
                labelColor = {
                    type = 'color',
                    name = 'Label Color',
                    desc = 'Color for the label text.',
                    order = 8,
                    hasAlpha = false,
                    set = function(_, r, g, b)
                        UtilitiesPlus.db.global.MinimapSocials.labelColor = { r = r, g = g, b = b }
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        local c = UtilitiesPlus.db.global.MinimapSocials.labelColor or { r = 1, g = 1, b = 1 }
                        return c.r, c.g, c.b
                    end,
                },
                labelColorOverride = {
                    type = 'toggle',
                    name = 'Use Class Color',
                    desc = 'Use your class color for the label text (Guild/Friends).',
                    order = 9,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.labelColorOverride = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.labelColorOverride
                    end,
                },
                positionHeader = {
                    type = 'header',
                    name = 'Position Offsets',
                    order = 10,
                },
                guildX = {
                    type = 'range',
                    name = 'Guild X Offset',
                    order = 11,
                    min = -200,
                    max = 200,
                    step = 1,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.guildX = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.guildX or -30
                    end,
                },
                guildY = {
                    type = 'range',
                    name = 'Guild Y Offset',
                    order = 12,
                    min = -200,
                    max = 200,
                    step = 1,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.guildY = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.guildY or 40
                    end,
                },
                friendsX = {
                    type = 'range',
                    name = 'Friends X Offset',
                    order = 13,
                    min = -200,
                    max = 200,
                    step = 1,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.friendsX = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.friendsX or 30
                    end,
                },
                friendsY = {
                    type = 'range',
                    name = 'Friends Y Offset',
                    order = 14,
                    min = -200,
                    max = 200,
                    step = 1,
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.friendsY = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.friendsY or 40
                    end,
                },
                guildAlign = {
                    type = 'select',
                    name = 'Guild Text Alignment',
                    order = 15,
                    values = {
                        LEFT = 'Left',
                        CENTER = 'Center',
                        RIGHT = 'Right',
                    },
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.guildAlign = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.guildAlign or 'CENTER'
                    end,
                },
                friendsAlign = {
                    type = 'select',
                    name = 'Friends Text Alignment',
                    order = 16,
                    values = {
                        LEFT = 'Left',
                        CENTER = 'Center',
                        RIGHT = 'Right',
                    },
                    set = function(_, val)
                        UtilitiesPlus.db.global.MinimapSocials.friendsAlign = val
                        UtilitiesPlus:GetModule('MinimapSocials'):UpdateTexts()
                    end,
                    get = function()
                        return UtilitiesPlus.db.global.MinimapSocials.friendsAlign or 'CENTER'
                    end,
                },
            },
        }
    }
}
