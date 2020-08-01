function EndzoneTrigger(trigger)
    --finish the game
    --called in hammer
    --StopGlobalSound()
    --EmitSoundOnClient("snapfireOlympics.outro", PlayerResource:GetPlayer((trigger.activator):GetPlayerID()))
    --"Congratulations!"
    EmitGlobalSound("announcer_ann_custom_end_10")
    --snapfireOlympics.outro for the winner
    print("---------Endzone trigger activated---------")
    local ent = trigger.activator
    print("player that owns the winner via ent:GetPlayerOwner(): " .. tostring(ent:GetPlayerOwner()))
    print("player that owns the winner via PlayerResource:GetPlayer(ent:GetPlayerID()): " 
    .. tostring(PlayerResource:GetPlayer(ent:GetPlayerID())))
    --if there's no entity or the entity is not a real hero, don't execute furthur
    if not ent then return
    elseif not ent:IsRealHero() then return end
    --for the winner, emit "victory!"
    --for losers, emit "defeated!"
    for playerID = 0, 5 do
        if playerID == ent:GetPlayerID() then
            EmitSoundOnClient("announcer_ann_custom_end_02", PlayerResource:GetPlayer(ent:GetPlayerID()))
        else
            EmitSoundOnClient("announcer_ann_custom_end_04", PlayerResource:GetPlayer(ent:GetPlayerID()))
        end
    end
    --delay between end of game and printing the message
    local lapSeconds = (math.floor(GameRules:GetGameTime() - 21) * 10) / 10
    local lapMinutes = math.floor(lapSeconds/60)
    local lapString = ""
    local lapMinutesString = ""
    local lapSecondsString = ""
    if lapSeconds > 60 then
        lapSeconds = lapSeconds % 60
        lapSecondsString = tostring(lapSeconds)
        lapMinutesString = tostring(lapMinutes)
        if lapMinutes < 10 then
            lapMinutesString = string.format("0%s", tostring(lapMinutes))
        end
        if lapSeconds < 10 then
            lapSecondsString = string.format("0%s", tostring(lapSeconds))
        end
        lapString = string.format("%s WINS IN %s:%s!", tostring(PlayerResource:GetPlayerName(ent:GetPlayerID())),
        lapMinutesString, lapSecondsString)
    else
        lapSecondsString = tostring(lapSeconds)
        if lapSeconds < 10 then
            lapSecondsString = string.format("0%s", tostring(lapSeconds))
        end
        lapString = string.format("%s WINS IN 00:%s!", tostring(PlayerResource:GetPlayerName(ent:GetPlayerID())),
        lapSecondsString)
    end
    GameRules:SetCustomVictoryMessage(lapString)
    GameRules:SetGameWinner(ent:GetTeam())
    GameRules:SetSafeToLeave(true)

end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end



