IconIntroTracker.RegisterEvent  = function() end
IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

local f = CreateFrame('frame')
f:SetScript('OnEvent', function(_, _, _, slotIndex, _)
    if not InCombatLockdown() then
        ClearCursor()
        PickupAction(slotIndex)
        ClearCursor()
    end
end)
f:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')