-- This function runs to save the location and particle spawn upon hero killed
function GameMode:HeroKilled(hero, attacker, ability)
    if GameMode.playerEnts[hero:GetPlayerID()]["hero"].respawnPosition ~= nil then
        GameMode.playerEnts[hero:GetPlayerID()]["hero"]:SetRespawnPosition(GameMode.playerEnts[hero:GetPlayerID()]["hero"].respawnPosition)
        hero:GetPlayerOwner():SetMusicStatus(0, 0)
    end
end