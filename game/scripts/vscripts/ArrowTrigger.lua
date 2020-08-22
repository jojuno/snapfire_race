------------------------------------------------
--for future version
------------------------------------------------
function ArrowTrigger(trigger)
    --summon miranas
    --start shooting sacred arrows
    --print("---------arrow trigger activated---------")
    --"xxx crossed the half way point!"
    local ent = trigger.activator
    --if the trigger wasn't set off by a hero, don't activate
    if not ent then return end

    --miranas
    print('spawning miranas, left, first.')
    spawn_loc_name = "spawn_m_1"
    local orientation = "left"
    local order = "first"
    GameMode:SpawnMirana(spawn_loc_name, orientation, order)
  
    print('spawning miranas, left, rest.')
    for i = 2,3 do
      spawn_loc_name = string.format("spawn_m_%s", tostring(i))
      local orientation = "left"
      local order = "rest"
      GameMode:SpawnMirana(spawn_loc_name, orientation, order)
    end
  
    print('spawning miranas, left, last.')
    spawn_loc_name = "spawn_m_4"
    local orientation = "left"
    local order = "last"
    GameMode:SpawnMirana(spawn_loc_name, orientation, order)
  
    print('spawning miranas, right, first.')
    spawn_loc_name = "spawn_m_5"
    local orientation = "right"
    local order = "first"
    GameMode:SpawnMirana(spawn_loc_name, orientation, order)
  
    print('spawning miranas, right, rest.')
    for i = 6,7 do
      spawn_loc_name = string.format("spawn_m_%s", tostring(i))
      local orientation = "right"
      local order = "rest"
      GameMode:SpawnMirana(spawn_loc_name, orientation, order)
    end
  
    print('spawning miranas, right, last.')
    spawn_loc_name = "spawn_m_8"
    local orientation = "right"
    local order = "last"
    GameMode:SpawnMirana(spawn_loc_name, orientation, order)


    return
end




