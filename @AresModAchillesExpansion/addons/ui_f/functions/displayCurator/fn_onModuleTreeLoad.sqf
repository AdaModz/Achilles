////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	AUTHOR: Kex (based on Anton Struyk's version)
//	DATE: 7/18/16
//	VERSION: 2.0
//	FILE: achilles\ui_f\functions\displayCurator\fn_OnModuleTreeLoad.sqf
//  DESCRIPTION: Integrates Ares Modules in Curator Interface Tree
//
//	ARGUMENTS:
//	_this select 0:		BOOL	- load custom modules only (true: append new custom module; false: load entire tree)
//
//	RETURNS:
//	nothing (procedure)
//
//	Example:
//	[false] call Achilles_fnc_OnModuleTreeLoad;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

private ["_display","_ctrl","_category_list","_all_modules","_subCategories","_categoryName","_tvData","_tvBranch","_moduleClassName","_categoryIndex","_newPath"];

disableSerialization;

// Get function  arguments
_custom_only = param [0,false,[false]];

// Get the UI control
_display = findDisplay IDD_RSCDISPLAYCURATOR;
_ctrl = _display displayCtrl IDC_RSCDISPLAYCURATOR_CREATE_MODULES;


//prepare lists
_category_list = [];
_all_modules = (getArray (configFile >> "cfgPatches" >> "achilles_modules_f_ares" >> "units"));
_all_modules append (getArray (configFile >> "cfgPatches" >> "achilles_modules_f_achilles" >> "units"));

diag_log format ["LOGGER 1: %1", _all_modules];

// Get all Vanilla Categories
for "_i" from 0 to ((_ctrl tvCount []) - 1) do
{
	_categoryName = _ctrl tvText [_i];
	_category_list pushBack _categoryName;
};
diag_log format ["LOGGER 2: %1", _category_list];
if (not _custom_only) then
{
	// Add Ares modules
	{
		_moduleClassName = _x;
		_categoryName = gettext (configFile >> "CfgVehicles" >> _moduleClassName >> "subCategory");
		_moduleDisplayName = gettext (configFile >> "CfgVehicles" >> _moduleClassName >> "displayName");
		_moduleIcon = gettext (configFile >> "CfgVehicles" >> _moduleClassName >> "icon");
		diag_log format ["LOGGER 3: %1", _x];
		_category_list = [_ctrl,_category_list,_categoryName,_moduleDisplayName,_moduleClassName,_forEachIndex,_moduleIcon] call Achilles_fnc_AppendToModuleTree;
	} forEach _all_modules;
};
diag_log format ["LOGGER 4: %1", _category_list];

// Add Custom modules
if (not isNil "Ares_Custom_Modules") then
{
	{
		_categoryName = _x select 0;
		_moduleDisplayName = _x select 1;
		_moduleClassName = format ["Ares_Module_User_Defined_%1", _forEachIndex];
		
		_category_list = [_ctrl,_category_list,_categoryName,_moduleDisplayName,_moduleClassName,_forEachIndex] call Achilles_fnc_AppendToModuleTree;
	} forEach Ares_Custom_Modules;
};

//Sort category and module list
_ctrl tvSort [[], false];
for "_i" from 0 to ((_ctrl tvCount []) - 1) do {_ctrl tvSort [[_i], false];};

//get module list
_category_list sort true;
Ares_category_list = _category_list;