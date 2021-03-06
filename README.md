![OCAP](https://i.imgur.com/4Z16B8J.png)

# **Operation Capture And Playback 2**

![OCAP Screenshot](https://i.imgur.com/vIVW4BD.png)

**[Friday Night Fight Demo](http://aar.fridaynightfight.org/)**

**[Maps for OCAP (Google Drive)](https://drive.google.com/drive/folders/1qtT0Fr4Dfwd48ihZNc8YN-xgxHchKoiu)**

**[OCAP Development and Support on Discord](https://discord.gg/r98bDxgZbV)**

## What is it?

OCAP is a **game-changing** Arma 3 addon that allows serverside recording of missions in addition to easy playback on an interactive (web-based) map.

- Quantify personal and group performance in difficult missions
- Observe the role your teammates played in the overall battle
- Learn what tactics and strategies work and don't work against AI or players

## Feature Overview

* Windows & Linux, Arma 3 2.04+ support
* Interactive web-based playback. All you need is a browser.
* Captures positions of all units and vehicles throughout an operation.
* Captures events such as shots fired, kills, and hits.
* Captures all Arma 3 markers, both scripted and user placed.
* Event log displays events as they happened in realtime.
* Clicking on a unit lets you follow them.
* Server based capture - no mods required for clients.
* See *Detailed Features* and our [changelog](https://github.com/OCAP2/OCAP/blob/master/CHANGELOG.md) for more!

---

## Running OCAP

Capture automatically begins when the server reaches the configured minimum player count (see userconfig settings). The addon can also be set to automatically save the recorded when the mission is ended.

### **Configuration**
1. Configure `/web/setting.json` with your public-facing IP, port, and a custom secret.
1. Configure `/addon/addons/@ocap/OcapReplaySaver2.cfg.json` with matching IP/port destination and secret.
	> `newServerGameType` is used to "tag" uploaded recordings for better organization. this will be the default tag if one isn't provided to the ocap_fnc_exportData command in-game
	> `traceLog` set to `1` will cause the extension to log all calls for debugging purposes
1. Configure `/addon/userconfig/config.hpp` with desired values
	> `ocap_minPlayerCount` determines how many players must be connected before recording begins, useful for avoiding extra recordings of test tessions
	>
	> `ocap_minMissionTime` determines the minimum length of a mission -- if it's shorter, the recording will not be saved
	>
	> `ocap_frameCaptureDelay` sets how frequently the capture of all units and vehicles is run (in seconds)
	>
	> `ocap_saveMissionEnded` determines whether or not the recording should be saved automatically when the [`MPEnded`](https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#MPEnded) event handler fires
	>
	> `ocap_preferACEUnconscious` defaults true, assuming that you're using ACE Medical and their unconscious system. If you aren't, please set this to false, and we'll instead track Arma 3's vanilla revive/down system.
	>
	> `ocap_excludeClassFromRecord` blacklists object classnames that shouldn't be tracked by OCAP
	>
	> `ocap_excludeKindFromRecord` use isKindOf checking to exclude one or more hierarchies of objects from recording
	>
	> `ocap_excludeMarkerFromRecord` blacklists markers containing any of these strings in their name so they won't be captured -- used primarily for marker framework systems you don't want to include in recordings
	>
	> `ocap_trackTimes` determines whether or not periodic updates are recorded containing time data from in-world. This should be set to `true` if you run missions that use time acceleration or time skips, to ensure the accurate time is recorded rather than having inaccurate extrapolation.
	>
	> `ocap_trackTimeInterval` determines how often time data is saved. The default is every 10 frames, which would be 10\*ocap_frameCaptureDelay.
	>
	> `ocap_isDebug` will cause additional log items to be written in the 'ocaplog' files during recording. Useful for troubleshooting specific issues or getting more data on what takes place during a round.

### **Installation**

1. The `/web` folder contains the front-end playback system, the server for which can be launched using `ocap-webserver.exe` on Windows. A [Docker image](https://github.com/OCAP2/web/pkgs/container/web) is also available in the web repository and is Linux-compatible.
1. Add a firewall rule and port-forwarding if necessary. The default port is 5000 and can be customized in `web/setting.json`.
1. Copy the `addon/addons/@ocap` subfolder to the mod directory your Arma 3 server uses.
1. Add the **absolute path** as a `serverMod` parameter in your server start script.
	> for example:
	> `... -port 2302 "-serverMod=C:\Servers\Arma 3\Mods\@ocap" -cfg=myServer.cfg...`
1. Copy the `addon/userconfig` folder to your Arma 3 server's root directory. If a userconfig folder already exists, this will simply merge OCAP's configuration data. If not, this will create it. Doing this may change your existing file, so make a backup then load your customizations into the new format if it's changed.

### **Terrains**

A long list of Arma 3 terrains, both vanilla and modded, are provided in a link at the top of this ReadMe. To use one:
1. Download the .7zip or .zip file.
1. Extract the contents to your `web/maps` folder or Docker volume.

The compressed file contains a folder titled with the world name. This folder contains a set of subfolders with tiled map images & a `map.json` file inside of it. Past and future recordings uploaded to this server that were played on that terrain will now display properly. In the future, we will look to implement dynamically generated vector tiling that will greatly increase the terrain resolution at higher zooms.

*If someone tried to load a recording from a session played on a terrain that wasn't installed yet, the issue may persist even after installation. To fix this, they can clear their browser cache in order to force their system to re-download the terrain tiles from the server. This will be fixed in future versions.*

### **Usage**

To end a mission and export capture data, call the following (server-side):

```sqf
// simple message
["OPFOR Wins. Their enemies suffered heavy losses!"] call ocap_fnc_exportData;

// includes side who won
[east, "Their enemies suffered heavy losses!"] call ocap_fnc_exportData;

// includes a specific 'tag', which will be filterable in the playback menu.
// i.e. in playback menu, selecting "PvP" from the dropdown would make this and any other mission tagged "PvP" visible in the search
[east, "OPFOR triumphed over their enemy!", "PvP"] call ocap_fnc_exportData;
```

**Tip:** You can use the above function in a trigger.
e.g. Create a trigger that activates once all objectives complete. Then on activation:
```sqf
if (isServer) then {

	// Saves and uploads the recording to your server
	[east, "OPFOR has achieved all of their objectives!"] call ocap_fnc_exportData;

	// Ends mission for everyone
	"end1" call BIS_fnc_endMissionServer; 
};
```

> **WARNING**
>
> To ensure your recordings are saved and uploaded:
> 1. The mission should be ended using a `BIS_fnc_endMission`/`BIS_fnc_endMissionServer` function and configured to auto-save, or the `ocap_fnc_exportData` function should be called prior to it ending. 
> 1. The web server process should be running and able to accept incoming network connections.
>
> If the web component is not running, the upload will fail and a local copy of the compressed recording will be saved. Logs are available in the `Arma 3/ocaplog` directory to troubleshoot.


---

## Detailed Features

### -- Easy playback selection, low storage requirements --

Each recording is saved in a compressed file, which means hundreds to be saved with minimal space usage (<5MB each).

Recordings can be easily browsed and are filterable and searchable with custom tagging, mission name search, and recording date search windows.


### -- Units in Mission --

- OCAP2 tracks players, AI, and vehicles in a mission.
- Group names and roles a player was slotted as are displayed during playback.
- Players will remain in the list only while they're connected.
- Vehicles will show who is crewing them, if anyone.

### -- Events List --

A filterable list of game events is available during playback and will include the following items:

- Player connects/disconnects (can be filtered out)
- Kills/Deaths with information
- Hits/Injuries (filtered out by default)
- An optional scripted game ending description logged at end of recording, such as which faction won and how

**Now supports custom events!** Check out [the wiki](https://github.com/OCAP2/OCAP/wiki/Custom-Game-Events) for details.

### -- Markers --

This suite will track all marker types in the vanilla Arma 3 system, even those created via scripts. This includes elliptical and rectangular markers, and the [`BIS_fnc_moduleCoverMap`](https://community.bistudio.com/wiki/BIS_fnc_moduleCoverMap) module (when present) to more clearly define AOs.

> #### **Drawn Map Lines**
> Custom drawn map lines are now recorded as well, providing more context to the static icons previously tracked.

### -- Projectiles --

Lines are drawn each time a unit has shot, indicating where their bullet landed. If they hit another unit or vehicle, the target's icon will flash during playback.

Shot and thrown non-bullet projectiles are also tracked and will be displayed with the in-game icon where available -- other vehicular ammo such as tank shells and mortar rounds will appear as red triangles. **ACE3 advanced throwing** support is included.

> *Magazine icons are available for the following mods:*
> - *Vanilla Arma 3*
> - *ACE 3*
> - *RHS (all factions)*
> - *Iront Front (IFA)*

### -- Mines and Explosives --

ACE3-placed mines and explosives will be tracked from the time they're armed to the time they're detonated, with an `X` briefly appearing to indicate that they've been triggered. The player who placed it and the type of mine will also be labeled.


---

## Current Developers

* [IndigoFox](https://github.com/indig0fox) - SQF, Powershell, & JS/Leaflet, enhanced in-game recording & Leaflet playback functionality
* [Zealot111](https://github.com/Zealot111) - SQF marker framework, C++ extension development and expansion
* [Fank](https://github.com/Fank) - SQF, JS, Go, Linux build compatibility & DB interface
* [Tekig](https://github.com/tekig) - SQF foundation & optimization, Go, JS, web optimization and UI

## Credits

* [MisterGoodson](https://github.com/jamiegdsn) and the [3 Commando Brigade](http://www.3commandobrigade.com/) for original development and testing.
* [Leaflet](http://leafletjs.com/) - an awesome JS interactive map library.
* [Bohemia Interactive](https://www.bohemia.net/) for their continued work supporting mods like this with engine and API improvements.
