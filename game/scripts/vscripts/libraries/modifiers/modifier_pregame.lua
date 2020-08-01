modifier_pregame = class({})

function modifier_pregame:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end