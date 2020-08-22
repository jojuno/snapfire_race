-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end


-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')



-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('internal/util')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
-- core_mechanics.lua is where you can specify how the game works
require('core_mechanics')
-- modifier_ai.lua is where you can specify how the non-player controlled units will behave
require('libraries/modifiers/modifier_ai')
-- modifier_ai_ult_creep specifies how the creeps in the last zone will behave
require('libraries/modifiers/modifier_ai_ult_creep')
-- modifier_ai_ult_creep specifies how drow will behave
require('libraries/modifiers/modifier_ai_drow')
-- modifier_stunned.lua stuns the entity on creation
require('libraries/modifiers/modifier_stunned')
-- modifier_invulnerable.lua adds the invulnerability modifier
require('libraries/modifiers/modifier_invulnerable')
-- modifier_invulnerable.lua adds the magic immunity modifier
require('libraries/modifiers/modifier_magic_immune')
-- modifier_silenced.lua adds the silenced modifier
require('libraries/modifiers/modifier_silenced')
-- modifier_attack_immune.lua adds the attack immunity modifier
require('libraries/modifiers/modifier_attack_immune')
-- modifier_attack_immune.lua adds the bloodlust modifier that speeds up the hero when it kills another hero
require('modifier_fiery_soul_on_kill_lua')

-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]


function GameMode:OnAllPlayersLoaded()



  --for the countdown function
  function round (num)
    return math.floor(num + 0.5)
  end

  local COUNT_DOWN_FROM = 27
  local endTime = round(GameRules:GetGameTime() + COUNT_DOWN_FROM)

  self.damageRanking = {}
  self.damageList = {}
  GameRules:GetGameModeEntity():SetThink(function ()
    
    local delta = round(endTime - GameRules:GetGameTime())

    --starting message
    if delta == 26 then
      Notifications:TopToAll({text="Pregame: Bang 'em up to seed first!" , duration= 5.0, style={["font-size"] = "45px", color = "red"}})
      return 1

    elseif delta > 7 then
      --sets the amount of seconds until SetThink is called again
      return 1

    elseif delta == 7 then
      Notifications:BottomToAll({text="Get ready!" , duration= 5.0, style={["font-size"] = "45px", color = "red"}})
      for playerID = 0, 9 do
        if PlayerResource:IsValidPlayerID(playerID) then
          heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
          heroEntity:ForceKill(true)
        end
      end
      return 3


    --play the starting sound
    --calculate the damage dealt for every hero against each other
    --rank them in descending order
    --highest rank gets placed first; lowest rank gets placed last at the starting line
    elseif delta == 4 then
      EmitGlobalSound('snapfireOlympics.introAndBackground3')

      
      for playerID = 0, 9 do
        --check if playerID exists
        if PlayerResource:IsValidPlayerID(playerID) then
          heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
          

          --calculate the damage dealt for every hero against each other
          damageDone = 0
          for victimID = 0, 9 do
            if PlayerResource:IsValidPlayerID(victimID) then
              if victimID == playerID then goto continue
              else
                damageDone = damageDone + PlayerResource:GetDamageDoneToHero(playerID, victimID)
              end
              ::continue::
            end
          end
          self.damageList[playerID] = damageDone
        end
      end

      function spairs(t, order)
        -- collect the keys
        local keys = {}
        for k in pairs(t) do keys[#keys+1] = k end
    
        -- if order function given, sort by it by passing the table and keys a and b
        -- otherwise just sort the keys 
        if order then
            table.sort(keys, function(a,b) return order(t, a, b) end)
        else
            table.sort(keys)
        end
    
        -- return the iterator function
        local i = 0
        return function()
            i = i + 1
            if keys[i] then
                return keys[i], t[keys[i]]
            end
        end
      end
    
      -- this uses a custom sorting function ordering by damageDone, descending
      rank = 1
      for k,v in spairs(self.damageList, function(t,a,b) return t[b] < t[a] end) do
        self.damageRanking[rank] = k 
        rank = rank + 1
      end

      for rank, playerID in pairs(self.damageRanking) do
        heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)


        heroEntity:Stop()
        heroEntity:ForceKill(false)
        GameMode:Restore(heroEntity)
        -- cannot purge fiery soul
        --heroEntity:RemoveModifierByName("modifier_fiery_soul_on_kill_lua")
        
        local respawnEnt = Entities:FindByName(nil, "respawn_checkpoint_1")
        local respawnVector = respawnEnt:GetAbsOrigin()
        --set it as a field so that it can be accessed in "core_mechanics" "HeroKilled"
        GameMode.playerEnts[heroEntity:GetPlayerID()]["hero"].respawnPosition = respawnVector
        GameMode.playerEnts[heroEntity:GetPlayerID()]["currentLap"] = GameMode.playerEnts[heroEntity:GetPlayerID()]["currentLap"] + 1
        GameMode.playerEnts[heroEntity:GetPlayerID()]["laps"][GameMode.playerEnts[heroEntity:GetPlayerID()]["currentLap"]] = {}
        GameMode.playerEnts[heroEntity:GetPlayerID()]["laps"][GameMode.playerEnts[heroEntity:GetPlayerID()]["currentLap"]]["finished"] = false
        GameMode.playerEnts[heroEntity:GetPlayerID()]["laps"][GameMode.playerEnts[heroEntity:GetPlayerID()]["currentLap"]]["place"] = nil

        --force staff happens because it's queued on the list of orders
        local startEnt = Entities:FindByName(nil, string.format("spawn_player_start_%s", rank))
        -- GetAbsOrigin() is a function that can be called on any entity to get its location
        local startPosition = startEnt:GetAbsOrigin()
        heroEntity:SetAbsOrigin(startPosition)

        --[[--for testing
        local startEnt = Entities:FindByName(nil, "respawn_checkpoint_6")
        -- GetAbsOrigin() is a function that can be called on any entity to get its location
        local startPosition = startEnt:GetAbsOrigin()
        heroEntity:SetAbsOrigin(startPosition)]]

        --set camera to hero because when the hero is relocated, the camera stays still
        --use global variable 'PlayerResource' to call the function
        PlayerResource:SetCameraTarget(playerID, heroEntity)
        --must delay the undoing of the SetCameraTarget by a second; if they're back to back, the camera will not move
        --set entity to 'nil' to undo setting the camera
        PlayerResource:GetSelectedHeroEntity(playerID):AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
      end
      return 1
    elseif delta == 3 then
      for rank, playerID in pairs(self.damageRanking) do
        PlayerResource:SetCameraTarget(playerID, nil)
      end
      return 3
    elseif delta == 0 then
      Notifications:TopToAll({text="Start!" , duration= 5.0, style={["font-size"] = "45px", color = "red"}})

    end
  end)
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  local item = CreateItem("item_ultimate_scepter", hero, hero)
  hero:AddItem(item)
  local item = CreateItem("item_force_staff", hero, hero)
  hero:AddItem(item)

  --for future version
  --hero:GetPlayerOwner():SetMusicStatus(0, 0)
  


  --get ability
  --set its level to max
  --index starts from 0
  local abil = hero:GetAbilityByIndex(0)
  abil:SetLevel(4)
  abil = hero:GetAbilityByIndex(1)
  abil:SetLevel(4)
  abil = hero:GetAbilityByIndex(2)
  abil:SetLevel(4)
  --offset because of scepter
  abil = hero:GetAbilityByIndex(5)
  abil:SetLevel(3)
  abil = hero:GetAbilityByIndex(6)
  abil:SetLevel(1)
  abil = hero:GetAbilityByIndex(7)
  abil:SetLevel(4)
  hero:SetBaseHealthRegen(50)
  
  GameMode.playerEnts[hero:GetPlayerID()] = {}
  GameMode.playerEnts[hero:GetPlayerID()]["hero"] = hero
  GameMode.playerEnts[hero:GetPlayerID()]["hero"].hasCreep = false
  GameMode.playerEnts[hero:GetPlayerID()]["laps"] = {}
  GameMode.playerEnts[hero:GetPlayerID()]["currentLap"] = 0
  GameMode.playerEnts[hero:GetPlayerID()]["score"] = 0
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"] = {}
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][2] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][3] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][4] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][5] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][6] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][7] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"][8] = false
  GameMode.playerEnts[hero:GetPlayerID()]["zoneTriggered"]["endzone"] = false
  --heroes will respawn from the place they spawn by default
  GameMode.playerEnts[hero:GetPlayerID()]["hero"].respawnPosition = nil
  GameMode.numPlayers = GameMode.numPlayers + 1
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  --use "print" and "PrintTable" to print messages in the debugger
  DebugPrint("[BAREBONES] The game has officially begun")
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  --make file in modifiers folder
  --link it to the class (this is the modifier for neutral creeps' AI)
  LinkLuaModifier("modifier_ai", "libraries/modifiers/modifier_ai.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_ai_ult_creep", "libraries/modifiers/modifier_ai_ult_creep.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_ai_drow", "libraries/modifiers/modifier_ai_drow.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_stunned", "libraries/modifiers/modifier_stunned.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_invulnerable", "libraries/modifiers/modifier_invulnerable.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_silenced", "libraries/modifiers/modifier_silenced.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_attack_immune", "libraries/modifiers/modifier_attack_immune.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_magic_immune", "libraries/modifiers/modifier_magic_immune.lua", LUA_MODIFIER_MOTION_NONE)
  --change game title in addon_english.txt
  --remove items in shops.txt to remove them from the shop
  --remove items completely by disabling them in npc_abilities_custom.txt
  
  --disable the in game announcer
  --GameMode:SetAnnouncerDisabled(true)
  --GameMode:SetBuybackEnabled(false)

  

  
  

  --call this which is located in the internal/gamemode file to initialize the basic settings provided by barebones 
  GameMode:_InitGameMode()


  -- SEEDING RNG IS VERY IMPORTANT
  math.randomseed(Time())
  
  GameMode.playerEnts = {}
  GameMode.spawns = {}
  GameMode.spawns[2] = {}
  GameMode.spawns[3] = {}
  GameMode.spawns[3]["pudges"] = {}
  GameMode.spawns[4] = {}
  GameMode.spawns[4]["earthshakers"] = {}
  GameMode.spawns[5] = {}
  GameMode.spawns[5]["phoenixes"] = {}
  GameMode.spawns[5]["drows"] = {}
  GameMode.spawns[5]["harpy_scouts"] = {}
  GameMode.spawns[5]["ghosts"] = {}
  GameMode.spawns[6] = {}
  GameMode.spawns[6]["zombies"] = {}
  GameMode.spawns[7] = {}
  GameMode.spawns[7]["linas"] = {}
  GameMode.spawns[8] = {}
  GameMode.spawns[8]["ult_creeps"] = {}
  GameMode.numPlayers = 0
  GameMode.linaCounter = 1000000
  GameMode.currentLap = 0

  GameMode.zone2Active = false
  GameMode.zone3Active = false
  GameMode.zone4Active = false
  GameMode.zone5Active = false
  GameMode.zone6Active = false
  GameMode.zone7Active = false
  GameMode.zone8Active = false

  GameMode.scoreChart = {}
  GameMode.scoreChart[1] = 10
  GameMode.scoreChart[2] = 9
  GameMode.scoreChart[3] = 8
  GameMode.scoreChart[4] = 7
  GameMode.scoreChart[5] = 6
  GameMode.scoreChart[6] = 5
  GameMode.scoreChart[7] = 4
  GameMode.scoreChart[8] = 3

  --[[DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')]]
end

function GameMode:SpawnNeutral(spawn_loc_name, spawn_name, aggro_range, leash_range)
  --Start an iteration finding each entity with this name
  --If you've named everything with a unique name, this will return your entity on the first go
  --dynamically assign spawn to entity location via argument passed into the function

  local spawnVectorEnt = Entities:FindByName(nil, spawn_loc_name)

  -- GetAbsOrigin() is a function that can be called on any entity to get its location
  local spawnVector = spawnVectorEnt:GetAbsOrigin()

  -- Spawn the unit at the location on the dire team
  -- if set to neutral team, when hero dies, their death timer gets added 26 seconds to the fixed resurrection time
  local spawnedUnit = CreateUnitByName(string.format("npc_dota_neutral_%s", spawn_name), spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)

  spawnedUnit.spawn_loc_name = spawn_loc_name
  spawnedUnit.spawn_name = spawn_name
  spawnedUnit.aggro_range = aggro_range
  spawnedUnit.leash_range = leash_range
  spawnedUnit.spawnVector = spawnVector
  spawnedUnit.active = true

  -- set the angle it's facing
  -- (0, 0, 0) = faces to the endzone
  --(pitch (100 = facing down), yaw (100 = facing left), roll (0 = normal))
  spawnedUnit:SetAngles(0, 0, 0)

  --set its AI
  spawnedUnit:AddNewModifier(nil, nil, "modifier_ai", { aggroRange = aggro_range, leashRange = leash_range });

  spawnedUnit:SetThink("NeutralThinker", self)
  if spawn_name == "harpy_scout" then
    self.spawns[5]["harpy_scouts"][spawn_loc_name] = spawnedUnit
  elseif spawn_name == "ghost" then
    self.spawns[5]["ghosts"][spawn_loc_name] = spawnedUnit
  end
end

--cannot overlap entities
function GameMode:SpawnKardel(spawn_loc_name)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("kardel", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  spawnedUnit.castAngleDegrees = 210
  spawnedUnit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
  spawnedUnit:SetThink("KardelThinker", self)
  self.spawns[2]["kardel"] = spawnedUnit
end

function GameMode:SpawnPudge(spawn_loc_name)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("pudge", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  spawnedUnit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
  spawnedUnit:SetThink("PudgeThinker", self)
  self.spawns[3]["pudges"][spawn_loc_name] = spawnedUnit
end

--for future version
--[[function GameMode:SpawnMirana(spawn_loc_name, orientation, order)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("mirana", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  --spawnedUnit:SetAngles(0, 0, 0)
  spawnedUnit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
  spawnedUnit.orientation = orientation
  spawnedUnit.order = order
  spawnedUnit:SetThink("MiranaThinker", self)
end]]

function GameMode:SpawnEarthshaker(spawn_loc_name, orientation)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("earthshaker", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  spawnedUnit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
  spawnedUnit.orientation = orientation
  spawnedUnit:SetThink("EarthshakerThinker", self)
  GameMode.spawns[4]["earthshakers"][spawn_loc_name] = spawnedUnit 
end

function GameMode:SpawnPhoenix(spawn_loc_name)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("phoenix", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  --to set its respawn position when it's dead
  spawnedUnit.spawn_loc_name = spawn_loc_name
  spawnedUnit.spawnVector = spawnVector
  spawnedUnit.active = true
  spawnedUnit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
  spawnedUnit:SetThink("PhoenixThinker", self)
  GameMode.spawns[5]["phoenixes"][spawn_loc_name] = spawnedUnit 
end

function GameMode:SpawnDrow(spawn_loc_name)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("drow", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  --to set its respawn position when it's dead
  spawnedUnit.spawn_loc_name = spawn_loc_name
  spawnedUnit.spawnVector = spawnVector 
  spawnedUnit.active = true
  spawnedUnit:AddNewModifier(nil, nil, "modifier_ai_drow", { aggroRange = 700, leashRange = leash_range });
  spawnedUnit:AddNewModifier(nil, nil, "modifier_magic_immune", {})
  spawnedUnit:SetThink("DrowThinker", self)
  GameMode.spawns[5]["drows"][spawn_loc_name] = spawnedUnit 
end

function GameMode:SpawnZombie(spawn_loc_name, position)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("Touch Me", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  spawnedUnit.spawn_loc_name = spawn_loc_name
  spawnedUnit.position = position
  spawnedUnit.active = true
  spawnedUnit:SetThink("ZombieThinker", self)
  GameMode.spawns[6]["zombies"][spawn_loc_name] = spawnedUnit
end

function GameMode:SpawnFeedMe(playerID)
  local spawnedUnit = CreateUnitByName("Feed Me!", self.playerEnts[playerID]["hero"]:GetAbsOrigin(), true, nil, nil, self.playerEnts[playerID]["hero"]:GetTeam())
  spawnedUnit:SetControllableByPlayer(self.playerEnts[playerID]["hero"]:GetPlayerID(), true)
  self.playerEnts[playerID]["hero"].hasCreep = true
  spawnedUnit.ownerID = playerID
  spawnedUnit:SetThink("FeedMeThinker", self)
end

function GameMode:SpawnLina(spawn_loc_name)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("lina", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  spawnedUnit.repelCast = false
  spawnedUnit.spawnVector = spawnVector
  spawnedUnit.spawn_loc_name = spawn_loc_name
  spawnedUnit.active = true
  spawnedUnit:SetThink("LinaThinker", self)
  GameMode.spawns[7]["linas"][spawn_loc_name] = spawnedUnit
end

function GameMode:SpawnUltCreep(spawn_loc_name)
  local spawnEnt = Entities:FindByName(nil, spawn_loc_name)
  local spawnVector = spawnEnt:GetAbsOrigin()
  local spawnedUnit = CreateUnitByName("npc_dota_neutral_gnoll_assassin", spawnVector, true, nil, nil, DOTA_TEAM_BADGUYS)
  spawnedUnit.spawn_loc_name = spawn_loc_name 
  spawnedUnit.spawnPos = spawnVector
  spawnedUnit.active = true
  spawnedUnit:AddNewModifier(nil, nil, "modifier_ai_ult_creep", { aggroRange = 600, leashRange = 10000})
  spawnedUnit:SetThink("UltCreepThinker", self)
  GameMode.spawns[8]["ult_creeps"][spawn_loc_name] = spawnedUnit
end





-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end



---------Thinkers

--kardel to shrapnel randomly throughout zone 2
function GameMode:KardelThinker(unit)
  local abil = unit:FindAbilityByName("shrapnel_custom")
  local pos = unit:GetAbsOrigin()
  if unit:IsAlive() then
    math.randomseed(GameRules:GetGameTime())
    local radius = 500 + 500 * math.random(1, 4)
    local anglerad = math.rad(GameMode.spawns[2]["kardel"].castAngleDegrees)
    GameMode.spawns[2]["kardel"].castAngleDegrees = GameMode.spawns[2]["kardel"].castAngleDegrees - 30
    if GameMode.spawns[2]["kardel"].castAngleDegrees < 90 then
      GameMode.spawns[2]["kardel"].castAngleDegrees = GameMode.spawns[2]["kardel"].castAngleDegrees + 150
    end
    --math.cos and math.sin determine where in the circle to point
    --cos = adjacent, sin = opposite
    --0 radians makes them point to the right (east)
    --pi/2 (90 degrees) radians makes them point to the north
    --pi (180) degrees) radians makes them point to the west
    --3pi/2 (270 degrees) radians makes them point to the south
    --2pi (360 degrees) radians makes them point to the east
    local castpos = Vector(pos.x + radius*math.cos(anglerad), pos.y + radius*math.sin(anglerad), pos.z)
    unit:CastAbilityOnPosition(castpos, abil, -1)
    return 1
  else
    return nil
  end
end



--pudge to randomly and periodically hook
function GameMode:PudgeThinker(unit)
  local abil = unit:FindAbilityByName("pudge_hook_custom")
  local pos = unit:GetAbsOrigin()
  local r = 1000
  if unit:IsAlive() then
    local anglerad = math.rad(RandomFloat(70, 110))
    local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
    unit:CastAbilityOnPosition(castpos, abil, -1)
    math.randomseed(GameRules:GetGameTime())
    return RandomFloat(1, 3)
  else
    return nil
  end
end

--This function is the thinker for mirana to randomly and periodically arrow
--[[function GameMode:MiranaThinker(unit)
  print("Thinker has started on mirana (", unit:GetEntityIndex(), ")")
  --unit:SetForwardVector(Vector(0, -1, 0))
  local abil = unit:FindAbilityByName("mirana_arrow_custom")
  local pos = unit:GetAbsOrigin()
  local r = 1000
  Timers:CreateTimer(1, function()
    if IsValidEntity(unit) then
      --first or not
      if unit.order == "first" then
        --left or right side
        if unit.orientation == "left" then
          --calculates in circles
          --math.rad converts degrees into radians
          --circle = 2pi
          local anglerad = math.rad(RandomFloat(270, 315))
          --pos.y + r*math.sin to point downward across the path
          local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
          unit:CastAbilityOnPosition(castpos, abil, -1)
          return 8
        else
          local anglerad = math.rad(RandomFloat(45, 90))
          --pos.y + r*math.sin to point upward across the path
          local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
          unit:CastAbilityOnPosition(castpos, abil, -1)
          return 9
        end
      elseif unit.order == "rest" then
        --left or right side
        if unit.orientation == "left" then
          --calculates in circles
          local anglerad = math.rad(RandomFloat(240, 300))
          --pos.y + r*math.sin to point downward across the path
          --r*math.sin(anglerad) is negative
          local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
          unit:CastAbilityOnPosition(castpos, abil, -1)
          return 7
        else
          local anglerad = math.rad(RandomFloat(60, 120))
          --pos.y + r*math.sin to point upward across the path
          local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
          unit:CastAbilityOnPosition(castpos, abil, -1)
          return 8
        end
      --last ones
      else
        --left or right side
        --can go a little more right than earthshaker because there's room
        if unit.orientation == "left" then
          --calculates in circles
          local anglerad = math.rad(RandomFloat(225, 280))
          --pos.y + r*math.sin to point downward across the path
          local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
          unit:CastAbilityOnPosition(castpos, abil, -1)
          return 7
        else
          local anglerad = math.rad(RandomFloat(70, 135))
          --pos.y + r*math.sin to point upward across the path
          local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
          unit:CastAbilityOnPosition(castpos, abil, -1)
          return 9
        end
      end
    else
      return
    end
  end)
end]]

--This function is the thinker for earthshaker to randomly and periodically fissure
function GameMode:EarthshakerThinker(unit)
  local abil = unit:FindAbilityByName("fissure_custom")
  local pos = unit:GetAbsOrigin()
  local r = 1000
  if unit:IsAlive() then
    math.randomseed(GameRules:GetGameTime())
    if unit.orientation == "left" then
      --calculates in circles
      --0 or 2pi radians faces to the right (positive x-axis)
      --local anglerad = math.rad(RandomFloat(70, 110))
      local anglerad = math.rad(90)
      local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
      unit:CastAbilityOnPosition(castpos, abil, -1)
      return 3
    else
      local anglerad = math.rad(270)
      local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
      unit:CastAbilityOnPosition(castpos, abil, -1)

      return 3
    end
  else
    return nil
  end
end



--This function is the thinker for phoenix to ult
function GameMode:PhoenixThinker(unit)
  local abil = unit:GetAbilityByIndex(0)
  local pos = unit:GetAbsOrigin()
  Timers:CreateTimer(0, function()
    if not unit.active then
      return nil
    --if phoenix is alive
    elseif unit:IsAlive() then
      unit:CastAbilityOnPosition(Vector(pos.x + 100, pos.y, pos.z), abil, -1)
      unit:SetAbsOrigin(unit.spawnVector)
    --else, phoenix is dead
    else
      --spawn new phoenix
      Timers:CreateTimer({
        endTime = 4, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
        callback = function()
          GameMode:SpawnPhoenix(unit.spawn_loc_name)
        end
      })
      --stop the thinker
      return nil
    end
    --set this to a little more than the duration of the supernova 
    --so it has a bit of time to "settle" and immediately cast the spell again
    return 6
  end)
end

--This function is the thinker for drow who pushes players back
function GameMode:DrowThinker(unit)
  if not unit.active then
    return nil
  elseif unit:IsAlive() then
    return 1
  else
    --spawn new drow
    Timers:CreateTimer({
      endTime = 4, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
      callback = function()
        GameMode:SpawnDrow(unit.spawn_loc_name)
      end
    })
    --stop the thinker
    return nil
  end
end


function GameMode:NeutralThinker(unit)
  --if the creep's stage is not active anymore
  if not GameMode.zone5Active then
    --kill the creep
    unit:ForceKill(false)
    --stop the thinker
    return nil
  --if creep is alive
  elseif unit:IsAlive() then
    --continue
    return 1
  else
    --spawn new creep
    -- 5 seconds delayed, run once using gametime (respect pauses)
    Timers:CreateTimer({
      endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
      callback = function()
        GameMode:SpawnNeutral(unit.spawn_loc_name, unit.spawn_name, unit.aggro_range, unit.leash_range)
      end
    })
    --stop the thinker
    return nil
  end
end

--This function is the thinker for the zombies to patrol 
function GameMode:ZombieThinker(unit)
  local pos = unit:GetAbsOrigin()
  local waypoint1Ent = Entities:FindByName(nil, string.format("waypoint%s_1", unit.position))
  local waypoint2Ent = Entities:FindByName(nil, string.format("waypoint%s_2", unit.position))
  -- GetAbsOrigin() is a function that can be called on any entity to get its location
  local waypoint1Position = waypoint1Ent:GetAbsOrigin()
  local waypoint2Position = waypoint2Ent:GetAbsOrigin()
  if not unit.active then
    --stop the thinker
    return nil
  elseif unit:IsAlive() then
      if GridNav:FindPathLength(waypoint1Ent:GetAbsOrigin(), unit:GetAbsOrigin()) < 100 then
        unit:MoveToPosition(waypoint2Position)
      elseif GridNav:FindPathLength(waypoint2Ent:GetAbsOrigin(), unit:GetAbsOrigin()) < 100 then
        unit:MoveToPosition(waypoint1Position)
      end
      return 3
  else
    --spawn new creep
    Timers:CreateTimer({
      endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
      callback = function()
        GameMode:SpawnZombie(unit.spawn_loc_name, unit.position)
      end
    })
    --stop the thinker
    return nil
  end
end

--This function is the thinker for the feed me! creep
function GameMode:FeedMeThinker(unit)
  if (not PlayerResource:GetSelectedHeroEntity(unit:GetMainControllingPlayer()):IsAlive()) then
    unit:ForceKill(false)
    self.playerEnts[unit.ownerID]["hero"].hasCreep = false
    return 1
  elseif self.playerEnts[unit.ownerID]["zoneTriggered"][8] then
    unit:ForceKill(false)
    self.playerEnts[unit.ownerID]["hero"].hasCreep = false
    return nil
  elseif unit:IsAlive() then
    return 1
  else
    self.playerEnts[unit.ownerID]["hero"].hasCreep = false
    Timers:CreateTimer({
      endTime = 2, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
      callback = function()
        GameMode:SpawnFeedMe(unit.ownerID)
      end
    })
    return nil
  end
end

--This function is the thinker for lina
function GameMode:LinaThinker(unit)
  if not unit.active then
    return nil
  elseif unit:IsAlive() then
  --in case it gets moved due to something like cookie
    if unit:GetAbsOrigin() ~= unit.spawnVector then
      unit:SetAbsOrigin(unit.spawnVector)
    end
    local light_strike_array = unit:GetAbilityByIndex(0)
    local pos = unit:GetAbsOrigin()
    unit:CastAbilityOnPosition(pos, light_strike_array, -1)
    local repel = unit:GetAbilityByIndex(1)
    if unit.repelCast == false then
      unit:CastAbilityOnTarget(unit, repel, -1)
      unit.repelCast = true
    end
    self.linaCounter = self.linaCounter - 1
    if self.linaCounter == 0 then
      unit.repelCast = false
    end
    return 1
  else
    --spawn new creep
    Timers:CreateTimer({
      endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
      callback = function()
        GameMode:SpawnLina(unit.spawn_loc_name)
      end
    })
    --stop the thinker
    return nil
  end
end


function GameMode:UltCreepThinker(unit)
  if not GameMode.zone8Active then
    if unit:IsAlive() then
      unit:ForceKill(false)
    end
    return nil
  --if creep is alive
  elseif unit:IsAlive() then
    --continue
    return 1
  else
    --spawn new creep
    -- 7 seconds delayed, run once using gametime (respect pauses)
    Timers:CreateTimer({
    endTime = 7, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      GameMode:SpawnUltCreep(unit.spawn_loc_name)
    end
    })
    --stop the thinker
    return nil
  end
end



function GameMode:Restore(hero)
  --Purge stuns and debuffs from pregame
  --set "bFrameOnly" to maintain the purged state
  hero:Purge(true, true, false, true, true)
  --heal health and mana to full
  hero:Heal(8000, nil)
  hero:GiveMana(8000)
  if not hero:IsAlive() then
    hero:RespawnHero(false, false)
  end
end
