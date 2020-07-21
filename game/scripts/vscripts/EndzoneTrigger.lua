function EndzoneTrigger(trigger)
    --finish the game
    --called in hammer
    print("---------Endzone trigger activated---------")
    local ent = trigger.activator
    if not ent then return end
    GameRules:SetGameWinner(ent:GetTeam())
    GameRules:SetSafeToLeave(true)
    --prints the time it took to finish the race
    GameRules:SetCustomVictoryMessage(string.format ("%s WINS!", tostring(PlayerResource:GetPlayerName(ent:GetPlayerID()))))
end