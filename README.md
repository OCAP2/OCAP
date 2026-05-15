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

## Getting Started

### Installation

OCAP requires two components: the **`@ocap/` server mod** (installed on your Arma 3 server) and the **web server** (hosted separately to receive recordings and serve the playback UI).

1. Download the latest release from [GitHub Releases](https://github.com/OCAP2/OCAP/releases) — choose `windows.zip` or `linux.tar.gz` to match your Arma 3 server's OS.
2. Install `@ocap/` on your Arma 3 server as a `-serverMod`. [CBA_A3](https://steamcommunity.com/workshop/filedetails/?id=450814997) is required. Clients do not need to install anything.
3. Deploy the web server using the binary, Docker Compose, or a Pterodactyl/Pelican panel egg.

→ See the **[Installation Guide](docs/installation.md)** for step-by-step instructions.

### Configuration

OCAP's settings are split across three places: in-game CBA options (addon), `ocap_recorder.cfg.json` (extension), and `setting.json` (web server). The extension and web server share a secret key that must match.

→ See the **[Configuration Reference](docs/configuration.md)** for all options.

### Usage

For mission integration (SQF/CBA API, custom events, score counters, focus windows, admin controls) and a guide to the web playback UI, see the **[Usage Guide](docs/usage.md)**.

### Terrains

A long list of Arma 3 terrains, both vanilla and modded, are provided in a link at the top of this ReadMe. To use one:
1. Download the .7zip or .zip file.
1. Extract the contents to your `web/maps` folder or Docker volume.

The compressed file contains a folder titled with the world name. This folder contains a set of subfolders with tiled map images & a `map.json` file inside of it. Past and future recordings uploaded to this server that were played on that terrain will now display properly. In the future, we will look to implement dynamically generated vector tiling that will greatly increase the terrain resolution at higher zooms.

*If someone tried to load a recording from a session played on a terrain that wasn't installed yet, the issue may persist even after installation. To fix this, they can clear their browser cache in order to force their system to re-download the terrain tiles from the server. This will be fixed in future versions.*

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
