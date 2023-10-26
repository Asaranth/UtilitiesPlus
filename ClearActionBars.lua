SLASH_ClearActionBars1 = '/clearbars'

StaticPopupDialogs['CONFIRM_CLEAR_ALL_BARS'] = {
  text = 'Do you want to clear all action bars?\nType "CONFIRM" into the field to confirm.',
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

function SlashCmdList.ClearActionBars()
  StaticPopup_Show('CONFIRM_CLEAR_ALL_BARS')
end