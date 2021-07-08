// Stratis kerama pja307 Beketov Altis Intro Sara SaraLite utes Abel Cain Desert_Island Noe Sara_DBE1
_worlds = "true" configClasses (configFile >> "CfgWorldList");
worldArray = "";
{
	_x = configFile >> "CfgWorlds" >> (configName _x);
	worldArray = worldArray + " " + configName _x;
} forEach _worlds;