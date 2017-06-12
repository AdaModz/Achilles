[
	"Util",
	"Promote to Moderator",
	{
		_moderator = _this select 1;
		_curator_logic_group = group (getAssignedCuratorLogic player);
		comment "[_moderator] join player;";
		[[_moderator, _curator_logic_group],
		{
			_moderator = _this select 0;
			_curator_logic_group = _this select 1;
			_moderator_pos = getPos _moderator;
			KEX_var_moderator_module = _curator_logic_group createUnit ["ModuleCurator_F",_moderator_pos , [], 0, ""]; 
			_moderator assignCurator KEX_var_moderator_module;
			"You were promoted to moderator!" remoteExec ['hint', _moderator];
		}] remoteExec ['BIS_fnc_spawn',2];
	}
] call Ares_fnc_RegisterCustomModule;