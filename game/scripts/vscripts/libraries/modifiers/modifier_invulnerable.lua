modifier_invulnerable = class({})

function modifier_invulnerable:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end