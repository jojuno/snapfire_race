cookie_custom = class({})

function cookie_custom:OnSpellStart()
    local caster = self:GetCaster()
    --A linear projectile must have a table with projectile info
    local info = 
    {
        Ability = self,
        EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", -- particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 2000,
        fStartRadius = 64,
        fEndRadius = 64,
        Source = caster,
        --iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
        --iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        --iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 15.0,
        bDeleteOnHit = true,
        vVelocity = caster:GetForwardVector() * 1800,
        bProvidesvision = true,
        iVisionRadius = 500,
        iVisionTeamNumber = caster:GetTeamNumber()
    }


    ProjectileManager:CreateLinearProjectile(info)



end