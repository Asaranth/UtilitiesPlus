local ClearActionBars = UtilitiesPlus:NewModule('ClearActionBars', 'AceConsole-3.0')

StaticPopupDialogs['CONFIRM_CLEAR_ALL_BARS'] = {
    text = "Do you want to clear all action bars?\nType 'CONFIRM' into the field to confirm.",
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
        for i = 1, 120 do
            PickupAction(i)
            PutItemInBackpack()
            ClearCursor()
        end
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

function ClearActionBars:Enable(init)
    if not self._enabled then
        self:RegisterChatCommand('clearbars', 'CLearActionBars')
        self._enabled = true
        if not init then UtilitiesPlus:Print('ClearActionBars module |cff00ff00enabled|r.') end
    end
end

function ClearActionBars:Disable()
    if self._enabled then
        self:UnregisterChatCommand('clearbars')
        self._enabled = false
        UtilitiesPlus:Print('ClearActionBars module |cffff0000disabled|r.')
    end
end

function ClearActionBars:ClearActionBars()
    StaticPopup_Show('CONFIRM_CLEAR_ALL_BARS')
end
