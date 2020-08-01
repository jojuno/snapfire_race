function FissureTrigger(trigger)
    --summon earthshakers
    --start creating fissure walls
    --print("---------Fissure trigger activated---------")
    --"xxx crossed the half way point!"
    local ent = trigger.activator
    --if the trigger wasn't set off by a hero, don't activate
    if not ent then return end

    --earthshakers
    print('spawning earthshakers, first, left.')
    local spawn_loc_name = "spawn_loc_earthshaker_1"
    local orientation = "left"
    local order = "first"
    --call function in gamemode.lua with GameMode:xxx
    GameMode:SpawnEarthshaker(spawn_loc_name, orientation, order)

    print('spawning earthshakers, rest, left.')
    for i = 2,3 do
        local  spawn_loc_name = string.format("spawn_loc_earthshaker_%s", tostring(i))
        local  orientation = "left"
        local  order = "rest"
        GameMode:SpawnEarthshaker(spawn_loc_name, orientation, order)
    end

    print('spawning earthshakers, last, left.')
    local spawn_loc_name = "spawn_loc_earthshaker_4"
    local orientation = "left"
    local order = "last"
    GameMode:SpawnEarthshaker(spawn_loc_name, orientation, order)

    print('spawning earthshakers, first, right.')
    local spawn_loc_name = "spawn_loc_earthshaker_5"
    local orientation = "right"
    local order = "first"
    GameMode:SpawnEarthshaker(spawn_loc_name, orientation, order)

    print('spawning earthshakers, right.')
    for i = 6,7 do
        local  spawn_loc_name = string.format("spawn_loc_earthshaker_%s", tostring(i))
        local  orientation = "right"
        local  order = "rest"
        GameMode:SpawnEarthshaker(spawn_loc_name, orientation, order)
    end

    print('spawning earthshakers, last, right.')
    local spawn_loc_name = "spawn_loc_earthshaker_8"
    local orientation = "right"
    local order = "last"
    GameMode:SpawnEarthshaker(spawn_loc_name, orientation, order)


    return
end




