local ClearQuests = UtilitiesPlus:NewModule('ClearQuests', 'AceConsole-3.0')

StaticPopupDialogs['CONFIRM_CLEAR_ALL_QUESTS'] = {
    text = "Do you want to clear all quests?\nType 'CONFIRM' into the field to confirm.",
    button1 = 'Yes',
    button2 = 'No',
    OnShow = function(self)
        self.button1:Disable()
    end,
    EditBoxOnTextChanged = function(self)
        if self:GetText():lower() == 'confirm' then
            self:GetParent().button1:Enable()
        else
            self:GetParent().button1:Disable()
        end
    end,
    OnAccept = function()
        for i = 1, C_QuestLog.GetNumQuestLogEntries() do
            C_QuestLog.SetSelectedQuest(C_QuestLog.GetInfo(i).questID)
            C_QuestLog.SetAbandonQuest()
            C_QuestLog.AbandonQuest()
        end
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

function ClearQuests:Enable(init)
    if not self._enabled then
        self:RegisterChatCommand('clearquests', 'ClearQuests')
        self._enabled = true
        if not init then UtilitiesPlus:Print('ClearQuests module |cff00ff00enabled|r.') end
    end
end

function ClearQuests:Disable()
    if self._enabled then
        self:UnregisterChatCommand('clearquests')
        self._enabled = false
        UtilitiesPlus:Print('ClearQuests module |cffff0000disabled|r.')
    end
end

function ClearQuests:ClearQuests()
    StaticPopup_Show('CONFIRM_CLEAR_ALL_QUESTS')
end
