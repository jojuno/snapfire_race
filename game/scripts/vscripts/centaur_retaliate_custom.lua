------------------------------------------------
--for future version
------------------------------------------------
centaur_retaliate_custom = class ({})
LinkLuaModifier("modifier_centaur_retaliate_lua", LUA_MODIFIER_MOTION_NONE )

--must put this to make it work
function centaur_retaliate_custom:GetIntrinsicModifierName()
	return "modifier_centaur_retaliate_lua"
end
