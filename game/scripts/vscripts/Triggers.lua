require('libraries/notifications')

--causes issues where players are not killed if the entity is triggered by multiple players at the same time
--may need it because of killing players twice
--[[function LavaTrigger(trigger)
        local ent = trigger.activator
        if not ent:IsHero() then
            ent:ForceKill(true)
        end

        if not ent then return end
        ent:ForceKill(true)

    return 0.1
end]]

function Checkpoint1Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][1] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][1] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_1_2")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 1 Activated", duration = 5})
    end
end

function Checkpoint2Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][2] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][2] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_2")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 2 Activated", duration = 5})
    end
end

function Checkpoint2_2Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][2.2] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][2.2] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_2_2")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 2-2 Activated", duration = 5})
        Notifications:Bottom(ent:GetPlayerID(), {text="Avoid the shrapnel", duration = 5})
    end

    if not GameMode.zone2_2Active then
        --spawn kardel
        local spawn_loc_name = "spawn_kardel"
        --call function in gamemode.lua with GameMode:xxx
        GameMode:SpawnKardel(spawn_loc_name)
        GameMode.zone2_2Active = true
    end
end

function Checkpoint3Trigger(trigger)
    
    local ent = trigger.activator
    if not ent then return end

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][3] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][3] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_3")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 3 Activated", duration = 5})
    end


    if not GameMode.zone3Active then
        --spawn pudge
        for i = 1, 6 do
            local spawn_loc_name = string.format("spawn_pudge_%s", i)
            GameMode:SpawnPudge(spawn_loc_name)
        end
        GameMode.zone3Active = true
    end


    --kill kardel when everyone's finished
    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][3] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end
    if numTriggered == GameMode.numPlayers and GameMode.zone2_2Active then
        GameMode.spawns[2.2]["kardel"]:ForceKill(false)
        GameMode.zone2_2Active = false
    end
end

function Checkpoint4Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end 

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][4] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][4] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_4")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 4 Activated", duration = 5})
    end

    if not GameMode.zone4Active then
        --spawn earthshaker, left
        for i = 1, 5 do
            local spawn_loc_name = string.format("spawn_earthshaker_%s", i)
            local orientation = "left"
            GameMode:SpawnEarthshaker(spawn_loc_name, orientation)
        end

        --spawn earthshaker, right
        for i = 6, 10 do
            local spawn_loc_name = string.format("spawn_earthshaker_%s", i)
            local orientation = "right"
            GameMode:SpawnEarthshaker(spawn_loc_name, orientation)
        end
        GameMode.zone4Active = true
    end

    --kill pudge when everyone's finished
    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][4] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end
    if numTriggered == GameMode.numPlayers and GameMode.zone3Active then
        --use "pairs" for key, value
        --use "ipairs" for index, value
        for spawn_loc_name, pudge in pairs(GameMode.spawns[3]["pudges"]) do
            pudge:ForceKill(false)
        end
        GameMode.zone3Active = false
    end
end

function Checkpoint5Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end 

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][5] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][5] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_5")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 5 Activated", duration = 5})
    end

    if not GameMode.zone5Active then
        for i = 1, 4 do
            local spawn_loc_name = string.format("spawn_phoenix_%s", i)
            GameMode:SpawnPhoenix(spawn_loc_name)
        end
      
        --[[for i = 1, 10 do
            local spawn_loc_name = string.format("spawn_harpy_%s", i)
            GameMode:SpawnNeutral(spawn_loc_name, "harpy_scout", 600, 500)
        end]]
      
        --[[for i = 1, 8 do
            local spawn_loc_name = string.format("spawn_ghost_%s", i)
            GameMode:SpawnNeutral(spawn_loc_name, "ghost", 600, 500)
        end]]
      
        for i = 1, 4 do
            local spawn_loc_name = string.format("spawn_drow_%s", i)
            GameMode:SpawnDrow(spawn_loc_name)
        end
        GameMode.zone5Active = true
    end

    --kill earthshakers when everyone's finished
    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][5] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end
    if numTriggered == GameMode.numPlayers and GameMode.zone4Active then
        for spawn_loc_name, earthshaker in pairs(GameMode.spawns[4]["earthshakers"]) do
            earthshaker:ForceKill(false)
        end
        GameMode.zone4Active = false
    end
end

function Checkpoint6Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end 

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][6] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][6] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_6")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 6 Activated", duration = 5})
    end

    if not GameMode.zone6Active then
        for position = 1, 5 do
            local spawn_loc_name = string.format("spawn_mirana_%s", position)
            GameMode:SpawnMirana(spawn_loc_name)
        end
        GameMode.zone6Active = true
    end

    --[[if not GameMode.zone6Active then
        --to the right
        --downward
        for position = 1, 13 do
            local orientation = "right"
            local spawn_loc_name = string.format("spawn_touch_me_%s", position)
            GameMode:SpawnTouchMe(spawn_loc_name, orientation)
        end
        for position = 14, 21 do
            local orientation = "down"
            local spawn_loc_name = string.format("spawn_touch_me_%s", position)
            GameMode:SpawnTouchMe(spawn_loc_name, orientation)
        end
        GameMode.zone6Active = true
    end]]

    --[[if not GameMode.zone6Active then
        --spawn invoker
        local spawn_loc_name = "spawn_lina_1"
        --call function in gamemode.lua with GameMode:xxx
        GameMode:SpawnInvoker(spawn_loc_name)
        GameMode.zone6Active = true
    end]]
    
    --kill creeps from zone 5 when everyone's finished
    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][6] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end
    if numTriggered == GameMode.numPlayers and GameMode.zone5Active then
        --[[for spawn_loc_name, ghost in pairs(GameMode.spawns[5]["ghosts"]) do
            ghost:ForceKill(false)
            ghost.active = false
        end]]
        --[[for spawn_loc_name, harpy_scout in pairs(GameMode.spawns[5]["harpy_scouts"]) do
            harpy_scout:ForceKill(false)
            harpy_scout.active = false
        end]]
        for spawn_loc_name, drow in pairs(GameMode.spawns[5]["drows"]) do
            drow:ForceKill(false)
            drow.active = false
        end
        for spawn_loc_name, phoenix in pairs(GameMode.spawns[5]["phoenixes"]) do
            phoenix:ForceKill(false)
            phoenix.active = false
        end
        GameMode.zone5Active = false
    end
end

function Checkpoint7Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end 
    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][7] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][7] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_7")
        
        --[[--spawn feed me for players
        GameMode:SpawnFeedMe(ent:GetPlayerID())]]
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 7 Activated", duration = 5})
        --[[--shows on the next line
        Notifications:Bottom(ent:GetPlayerID(), {text="Use your creep to stun lina", duration = 10})]]
        Notifications:Bottom(ent:GetPlayerID(), {text="Use your cookie to stun lina", duration = 10})
    end

    if not GameMode.zone7Active then
        for i = 1, 5 do
            local spawn_loc_name = string.format("spawn_lina_%s", i)
            GameMode:SpawnLina(spawn_loc_name)
        end
        GameMode.zone7Active = true
    end

    --[[--kill "touch me"s when everyone's finished
    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][7] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end

    if numTriggered == GameMode.numPlayers and GameMode.zone6Active then
        for spawn_loc_name, touch_me in pairs(GameMode.spawns[6]["touch_mes"]) do
            touch_me:ForceKill(false)
            touch_me.active = false
        end
        GameMode.zone6Active = false
    end]]

    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][7] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end

    if numTriggered == GameMode.numPlayers and GameMode.zone6Active then
        for spawn_loc_name, mirana in pairs(GameMode.spawns[6]["miranas"]) do
            mirana:ForceKill(false)
            mirana.active = false
        end
        GameMode.zone6Active = false
    end
end

function Checkpoint8Trigger(trigger)
    local ent = trigger.activator
    if not ent then return end 

    if not GameMode.zone8Active then
        for i = 1,48 do
            local spawn_loc_name = string.format("spawn_ult_creep_%s", i)
            GameMode:SpawnUltCreep(spawn_loc_name)
        end
        GameMode.zone8Active = true
    end

    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][8] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"][8] = true
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_8")
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[ent:GetPlayerID()]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
        Notifications:Bottom(ent:GetPlayerID(), {text="Checkpoint 8 Activated", duration = 5})
    end

    --kill linas when everyone's finished
    local numTriggered = 0
    for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
        if player["zoneTriggered"][8] == false then
            break
        else
            numTriggered = numTriggered + 1
        end
    end
    if numTriggered == GameMode.numPlayers and GameMode.zone7Active then
        for spawn_loc_name, lina in pairs(GameMode.spawns[7]["linas"]) do
            lina:ForceKill(false)
            lina.active = false
        end
        GameMode.zone7Active = false
    end
end

function CheckpointFinishTrigger(trigger)
    local ent = trigger.activator

    local numTriggered = 0
    
    --player finished the lap
    if not GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"]["endzone"] then
        GameMode.playerEnts[ent:GetPlayerID()]["zoneTriggered"]["endzone"] = true
        --check how many people finished the lap
        for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
            if player["zoneTriggered"]["endzone"] == false then goto continue
            else
                numTriggered = numTriggered + 1
            end
            ::continue::
        end
        GameMode.playerEnts[ent:GetPlayerID()]["laps"][GameMode.playerEnts[ent:GetPlayerID()]["currentLap"]]["finished"] = true
        GameMode.playerEnts[ent:GetPlayerID()]["laps"][GameMode.playerEnts[ent:GetPlayerID()]["currentLap"]]["place"] = numTriggered
        Notifications:Bottom(ent:GetPlayerID(), {text="Finished!", duration = 5, style={color="red"}})
        Notifications:Bottom(ent:GetPlayerID(), {text=string.format("You ranked %s", numTriggered), duration = 5})
    end
    

    --for future version
    --ent:AddNewModifier(nil, nil, "modifier_stunned", {})
    --ent:AddNewModifier(nil, nil, "modifier_invulnerable", {})

    --if everyone finished
    if numTriggered == GameMode.numPlayers and GameMode.zone8Active then
        --kill ult creeps
        for spawn_loc_name, ult_creep in pairs(GameMode.spawns[8]["ult_creeps"]) do
            ult_creep:ForceKill(false)
            ult_creep.active = false
        end
        GameMode.zone8Active = false

        --for future version
        --countdown seconds
        --alert finish
        --assign scores
        --put everyone back to the starting line
        --Timers:CreateTimer({
            --endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
            --callback = function()
                --for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
                    --print("[CheckpointFinishTrigger] inside the finishing lap 1 function")
                    --assign score
                    --player["score"] = player["score"] + GameMode.scoreChart[player["laps"][player["currentLap"]]["place"]]
                    --Say(ent, string.format("My score is %s", player["score"]), false)
                    --find the corresponding spawn point by place
                    --local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_1")
                    --local respawnPosition = respawnEnt:GetAbsOrigin()
                    
                    --GameMode.playerEnts[playerID]["hero"].respawnPosition = respawnEnt:GetAbsOrigin()
                    --GameMode:Restore(player["hero"])

                    --local spawnEnt = Entities:FindByName(nil, string.format("spawn_player_start_%s", player["laps"][player["currentLap"]]["place"]))
                    --local spawnPosition = spawnEnt:GetAbsOrigin()
                    
                    --player["hero"]:SetAbsOrigin(spawnPosition)
                    --PlayerResource:SetCameraTarget(playerID, heroEntity)
                    --PlayerResource:GetSelectedHeroEntity(playerID):AddNewModifier(nil, nil, "modifier_invulnerable", { duration = 4})
                    --PlayerResource:GetSelectedHeroEntity(playerID):AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
                    --player["currentLap"] = player["currentLap"] + 1

                    --Timers:CreateTimer(1, function()
                    --    print("[CheckpointFinishTrigger] in the undoing of the camera block")
                    --    PlayerResource:SetCameraTarget(playerID, nil)
                    --    return nil
                    --end)
                --end
            --end
          --})
        --Say(nil, "Get ready for the next lap...", false)
        --GameMode.currentLap = GameMode.currentLap + 1

        --for version 4
        local winner = nil
        for playerID, player in ipairs(GameMode.playerEnts), GameMode.playerEnts, -1 do
            --assign score
            player["score"] = player["score"] + GameMode.scoreChart[player["laps"][player["currentLap"]]["place"]]
            if player["score"] == 10 then        
                winner = player["hero"]
            end
        end
        GameRules:SetCustomVictoryMessage(string.format("%s WINS!", tostring(PlayerResource:GetPlayerName(winner:GetPlayerID()))))
        GameRules:SetGameWinner(winner:GetTeam())
        GameRules:SetSafeToLeave(true)
    end
end

