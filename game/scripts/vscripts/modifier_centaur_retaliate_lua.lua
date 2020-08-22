------------------------------------------------
--for future version
------------------------------------------------
modifier_centaur_retaliate_lua = class({})

function modifier_centaur_retaliate_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_centaur_retaliate_lua:OnTakeDamage( params )
    print("[modifier_centaur_retaliate_lua:OnTakeDamage] in the function")
    --print("[modifier_centaur_retaliate_lua:OnTakeDamage] printing params")
    PrintTable(params)
    print("[modifier_centaur_retaliate_lua:OnTakeDamage] attacker: ")
    PrintTable(params.attacker)
    print("[modifier_centaur_retaliate_lua:OnTakeDamage] attacker name: " .. params.attacker:GetUnitName())
    print("[modifier_centaur_retaliate_lua:OnTakeDamage] attacker team number " .. params.attacker:GetTeamNumber())
    
    print("[modifier_centaur_retaliate_lua:OnTakeDamage] unit: ")
    PrintTable(params.unit)
    print("[modifier_centaur_retaliate_lua:OnTakeDamage] unit name: " .. params.unit:GetUnitName())
    --print("[modifier_centaur_retaliate_lua:OnTakeDamage] printing params end")
    if IsServer() then
        --filter units that "OnTakeDamage" applies to
        --because trigger blocks have no names, if you call
        --"GetUnitName()" on it, it will throw an error
        if params.attacker.name == "lava" then
            return 0
        else
            --only return damage on "Touch Me"
            --else, this will fire on all creeps
            if params.unit:GetUnitName() == "Touch Me" then
                --to prevent zombies from not spawning when "denied" by spit creep
                if params.unit:GetUnitName() == params.attacker:GetUnitName() then
                    return 0
                else
                    --print("[modifier_centaur_retaliate_lua:OnTakeDamage] GetUnitName == 'Touch Me'")
                    
                    

                    local target = params.attacker
                    if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                        --[[print("[modifier_centaur_retaliate_lua:OnTakeDamage] in the 'damageTable' block")

                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] attacker: ")
                        PrintTable(params.attacker)
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] attacker's team number: ")
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] " .. target:GetTeamNumber())
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] attacker's name: ")
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] " .. target:GetUnitName())

                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] self:GetParent(): ")
                        PrintTable(self:GetParent())
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] self:GetParent()'s team number: ")
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] " .. self:GetParent():GetTeamNumber())
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] self:GetParent()'s name: ")
                        print("[modifier_centaur_retaliate_lua:OnTakeDamage] " .. self:GetParent():GetUnitName())
                        --when you get spat out, you are "denied"
                        local damageTable = {
                            victim = target,
                            attacker = target,
                            damage = 30000,
                            damage_type = DAMAGE_TYPE_PURE,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE --Optional.
                        }
                        ApplyDamage(damageTable)
                        return 0
                    end
                end]]
            end
        end
    end
end
