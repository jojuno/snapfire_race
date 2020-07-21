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
-- ai_modifier.lua is where you can specify how the non-player controlled units will behave
require('libraries/modifiers/modifier_ai')

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
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  print("[ON_HERO_IN_GAME] inside the function.")
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  local item = CreateItem("item_ultimate_scepter", hero, hero)
  hero:AddItem(item)

  --can't use 'i' as the variable for the loop

  --get ability
  --set its level to max
  --index starts from 0
  local abil = hero:GetAbilityByIndex(0)
  abil:SetLevel(4)
  local abil = hero:GetAbilityByIndex(1)
  abil:SetLevel(4)
  local abil = hero:GetAbilityByIndex(2)
  abil:SetLevel(4)
  --offset because of scepter
  local abil = hero:GetAbilityByIndex(5)
  abil:SetLevel(3)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]


end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  print("[BAREBONES] The game has officially begun")
  --undo SetCameraTarget
  for playerID = 0, 9 do
    print('[INIT_GAME_MODE] in the undoing of the SetCameraTarget loop.')
    PlayerResource:SetCameraTarget(playerID, nil)
  end


  
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  print('[GAMEMODE] in InitGameMode function')
  GameMode = self
  --make file in modifiers folder
  --link it to the class (this is the modifier for neutral creeps' AI)
  LinkLuaModifier("modifier_ai", "libraries/modifiers/modifier_ai.lua", LUA_MODIFIER_MOTION_NONE)

  
  

  --call this which is located in the internal/gamemode file to initialize the basic settings provided by barebones 
  GameMode:_InitGameMode()

  print( "Loading AI Testing Game Mode." )
  -- SEEDING RNG IS VERY IMPORTANT
  math.randomseed(Time())

  -- Set up a table to hold all the units we want to spawn
  self.UnitThinkerList = {}

  -- Spawn units via "info_target" in entity
  -- spawn zone 1 mobs

  --[[print('spawning mud golems.')
  for i = 1,19 do
    spawn_loc_name =  string.format("spawn_loc_test_1_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "mud_golem")
  end

  print('spawning harpy scouts.')
  -- spawn zone 1 cliff mobs
  for i = 1,7 do
    spawn_loc_name =  string.format("spawn_loc_test_1_c_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "harpy_scout")
  end

  print('spawning centaur khans.')
  -- spawn zone 2 mobs
  for i = 1,23 do
    spawn_loc_name =  string.format("spawn_loc_test_2_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "centaur_khan")
  end

  print('spawning black drakes.')
  -- spawn zone 3 mobs
  for i = 1,22 do
    spawn_loc_name =  string.format("spawn_loc_test_3_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "black_drake")
  end

  print('spawning furbolgs.')
  -- spawn zone 4 mobs
  for i = 1,25 do
    spawn_loc_name =  string.format("spawn_loc_test_4_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "polar_furbolg_ursa_warrior")
  end]]

  print('spawning black dragons.')
  -- spawn zone 5 type 1 mobs (gobble immune)
  for i = 1,9 do
    spawn_loc_name =  string.format("spawn_loc_test_5_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "black_dragon")
  end

  print('spawning kobolds.')
  -- spawn zone 5 type 2 mobs (not gobble immune)
  for i = 1,10 do
    spawn_loc_name =  string.format("spawn_loc_test_5_k_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "kobold")
  end

  print('spawning ghosts for zone 5 hills.')
  -- spawn zone 5 type 3 mobs (hills for slow)
  --must be killable in a hit of scatterblast
  for i = 1,2 do
    spawn_loc_name =  string.format("spawn_loc_test_5_h_%s", tostring(i))
    self:SpawnNeutral(spawn_loc_name, "ghost")
  end

  
  --set up items on map
  
  --pregame
  print('spawning cheese.')
  for i = 1, 3 do
    local spawnVectorEnt = Entities:FindByName(nil, string.format("spawn_pregame_item_%s", tostring(i)))
    local spawnVector = spawnVectorEnt:GetAbsOrigin()
    --create the item
    local item = CreateItem("item_cheese", nil, nil)
    CreateItemOnPositionSync(spawnVector, item)
  end

  --game
  --bkb
  print('spawning bkb.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_bkb")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  --create the item
  local item = CreateItem("item_black_king_bar", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)

  --orchid
  print('spawning orchid.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_orchid")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_orchid", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)

  --[[--force staff
  print('spawning force staff.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_force_staff")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_force_staff", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)
  ]]

  --[[--rapier
  print('spawning rapier.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_rapier")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_rapier", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)
  ]]

  --phase boots
  print('spawning phase boots.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_phase")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_phase_boots", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)

  --aether lens
  print('spawning aether lens.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_aether_lens")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_aether_lens", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)
  
  --[[--rod
  print('spawning rod.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_rod")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_rod_of_atos", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)
  ]]
  
  --euls
  print('spawning euls.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_euls")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_cyclone", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)
  
  --blink
  print('spawning blink.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_blink")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_blink", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)


  --scythe
  print('spawning scythe.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_scythe")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_sheepstick", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)

  --abyssal
  print('spawning abyssal.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_abyssal")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_abyssal", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)

  --skadi
  print('spawning skadi.')
  local spawnVectorEnt = Entities:FindByName(nil, "spawn_skadi")
  local spawnVector = spawnVectorEnt:GetAbsOrigin()
  local item = CreateItem("item_skadi", nil, nil)
  CreateItemOnPositionSync(spawnVector, item)
  

  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:SpawnNeutral(spawn_loc_name, spawn_name)
  --Start an iteration finding each entity with this name
  --If you've named everything with a unique name, this will return your entity on the first go
  --dynamically assign spawn to entity location via argument passed into the function
  print('[GameMode:SpawnAIUnitWanderer] spawning ' .. spawn_name)

  local spawnVectorEnt = Entities:FindByName(nil, spawn_loc_name)

  -- GetAbsOrigin() is a function that can be called on any entity to get its location
  local spawnVector = spawnVectorEnt:GetAbsOrigin()

  -- Spawn the unit at the location on the dire team
  -- if set to neutral team, when hero dies, their death timer gets added 26 seconds to the fixed resurrection time
  local spawnedUnit = CreateUnitByName(string.format("npc_dota_neutral_%s", spawn_name), spawnVector, true, nil, nil, DOTA_TEAM_NEUTRALS)
  
  -- Add some variables to the spawned unit so we know its intended behaviour
  -- You can store anything here, and any time you get this entity the information will be intact
  
  -- only need the AI for centaur khan for now
  if spawnedUnit:GetUnitName() == "npc_dota_neutral_centaur_khan" then
      spawnedUnit.CastAbilityIndex = spawnedUnit:GetAbilityByIndex(0):entindex()
  end

  -- Add a random amount to the game time to randomise the behaviour a bit
  spawnedUnit.NextOrderTime = GameRules:GetGameTime() + math.random(5, 10) 

  -- set the angle it's facing
  -- (0, 0, 0) = faces to the endzone
  --(pitch (100 = facing down), yaw (100 = facing left), roll)
  spawnedUnit:SetAngles(0, 180, 0)

  --set its AI
  print('the modifiers for this unit ')
  print(tostring(spawnedUnit:GetModifierCount()))
  spawnedUnit:AddNewModifier(nil, nil, "modifier_ai", { aggroRange = 600, leashRange = 600 });
  print('num modifiers after adding "modifier_ai"' ..tostring(spawnedUnit:GetModifierCount()))

  -- finally, insert the unit into the table
  table.insert(self.UnitThinkerList, spawnedUnit)
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

