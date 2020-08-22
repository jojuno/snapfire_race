modifier_attack_immune = class({})

function modifier_attack_immune:CheckState()
	local state = {
	[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	return state
end