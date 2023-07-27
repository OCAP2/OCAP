/*
	{
		"name": "Isla Duala 3",
		"worldName": "isladuala3",
		"worldSize": 10240,
		"imageSize": 16384,
		"multiplier": 1.6
	}
*/
_newMap = {
	params ["_configName", "_displayName"];
	_str = format ['
		{
			"name": %1,
			"worldName": %2,
			"worldSize": %3,
			"imageSize": 16384,
			"multiplier": -1
		}
		',
		str _displayName,
		str _configName,
		_displayName call BIS_fnc_mapSize
	];
	_str
};
_worlds = "true" configClasses (configFile >> "CfgWorldList");
worldArray = [];
{
	_x = configFile >> "CfgWorlds" >> (configName _x);
	worldArray pushBack ([configName _x, getText (_x >> "description")] call _newMap);
} forEach _worlds;
copyToClipBoard ([worldArray] call CBA_fnc_encodeJSON);