-- This function runs to save the location and particle spawn upon hero killed
function GameMode:HeroKilled(hero, attacker, ability)
    --save position of killed hero
    --respawn at that position
    -- Saves position of killed hero into table
    print('[CORE_MECHANICS] in Hero Killed')
    local playerIdx = hero:GetEntityIndex()
    hero.deadHeroPos = hero:GetAbsOrigin()
    local respawnLoc = hero.deadHeroPos
    if respawnLoc ~= hero:GetAbsOrigin() then
        hero:SetRespawnPosition(hero:GetAbsOrigin())
    else
        hero:SetRespawnPosition(hero.deadHeroPos)
    end
    hero:Stop()
    hero.deadHeroPos = nil
end