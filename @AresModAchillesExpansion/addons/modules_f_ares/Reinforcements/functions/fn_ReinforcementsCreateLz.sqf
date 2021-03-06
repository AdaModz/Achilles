#include "\achilles\modules_f_ares\module_header.h"

if (isNil "Ares_ReinforcementLzCount") then { Ares_ReinforcementLzCount = 0 };

_deleteModuleOnExit = false;

private _targetPhoneticName = [Ares_ReinforcementLzCount] call Ares_fnc_GetPhoneticName;
private _target_name = format ["LZ %1", _targetPhoneticName];
private _dialogResult =
[
	localize "STR_AMAE_CREATE_NEW_LZ",
	[
		[localize "STR_AMAE_NAME", "", _target_name, true]
	]
] call Ares_fnc_showChooseDialog;
if (_dialogResult isEqualTo []) exitWith {_deleteModuleOnExit = true};
_target_name = _dialogResult select 0;
_logic setName _target_name;
_logic setVariable ["SortOrder", Ares_ReinforcementLzCount];
[objNull, format ["Created LZ '%1'", _target_name]] call bis_fnc_showCuratorFeedbackMessage;
Ares_ReinforcementLzCount = Ares_ReinforcementLzCount + 1;
publicVariable "Ares_ReinforcementLzCount";

// create a LZ object for AI
private _h_pad = "Land_HelipadEmpty_F" createVehicle position _logic;
_h_pad attachTo [_logic,[0,0,0]];
[_logic, _h_pad] spawn {waitUntil {sleep 10; isNull (_this select 0)}; deleteVehicle (_this select 1);};

#include "\achilles\modules_f_ares\module_footer.h"
