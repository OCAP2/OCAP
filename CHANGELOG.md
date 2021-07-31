# CHANGELOG

## v1.1.0

### Fixes

#### Addon
- [[OCAP/#32]](https://github.com/OCAP2/OCAP/issues/32) Adds submunition ammo type handling for projectile tracking
- [[OCAP/#33]](https://github.com/OCAP2/OCAP/issues/33) Marker creation time was displayed ~2sec later during playback
- [[OCAP/#36]](https://github.com/OCAP2/OCAP/issues/36) Grenades, any other thrown object and fire lines were not shown after unit respawn

#### Web
- [[OCAP/#14]](https://github.com/OCAP2/OCAP/issues/14) Prevent markers from appearing if they should not be visible
- [[web/#21]](https://github.com/OCAP2/web/pull/21) Fixed group list is not filtered on first load

### Changes

#### Addon
- [[addon/#25]](https://github.com/OCAP2/addon/pull/25)
	- Adds support for "isKindOf" object recording exclusion
	- Checks for ACE modules before running monitors that depend on them
	- Positions now tracked in ASL for future surprises :)
	- Addon and extension versions now recorded in JSON
	- Adds descriptions to userconfig/config.hpp settings
- [[OCAP/#45]](https://github.com/OCAP2/OCAP/issues/45) Adds diary entry in-game showing about and status of addon, plus versions
- [[OCAP/#34]](https://github.com/OCAP2/OCAP/issues/34) Adds support for ArmA3 unconscious state
- [[OCAP/#38]](https://github.com/OCAP2/OCAP/issues/38) Disconnect now hides the controlled unit
- [[OCAP/#39]](https://github.com/OCAP2/OCAP/issues/39) Hit/Killed events now brought into parity & sharing more accurate tracking
- [[addon/#17]](https://github.com/OCAP2/addon/pull/17) Reduce network traffic by checking configured marker exclusions clientside
- [[addon/#22]](https://github.com/OCAP2/addon/pull/22) Projectile markers now reflect the direction of travel
- [[web/#29]](https://github.com/OCAP2/web/pull/29) Show kill reason as disconnect, when disconnected at the same time

#### Web
- [[OCAP/#42]](https://github.com/OCAP2/OCAP/issues/42) Adds CUP Maps markers
- [[OCAP/#41]](https://github.com/OCAP2/OCAP/issues/41) Adds 3CB Factions markers
- [[OCAP/#46]](https://github.com/OCAP2/OCAP/issues/46) Adds ability to hide killcount info during playback
- [[OCAP/#28]](https://github.com/OCAP2/OCAP/issues/25) Updates 'share' button icon
- [[OCAP/#8]](https://github.com/OCAP2/OCAP/issues/8) Adds ability to switch between time elapsed, in-world time, and system time, if available
- [[OCAP/#7]](https://github.com/OCAP2/OCAP/issues/7) Adds support for new custom event [`capture`](https://github.com/OCAP2/OCAP/wiki/Custom-Game-Events#captured-captured)
- [[OCAP/#28]](https://github.com/OCAP2/OCAP/issues/27) Re adds customizing for own logo and link, like as it existed in the old OCAP
- [[OCAP/#12]](https://github.com/OCAP2/OCAP/issues/12) Killing units of the same side will now decrease kill count
- [[web/#18]](https://github.com/OCAP2/web/pull/18) Increases left panel width for recent role addition
- [[web/#33]](https://github.com/OCAP2/web/pull/33) Enables caching for static marker icons & map tiles

## [v1.0.0](https://github.com/OCAP2/OCAP/releases/tag/v1.0.0)

### Fixes
- [[addon/#3]](https://github.com/OCAP2/addon/pull/3) respawned units no longer 'flicker' after respawning when corpse + new unit have same ocapID
- [[addon/#1]](https://github.com/OCAP2/addon/pull/1) changes 'side' tracking methodology to maintain tracked side of a player post-respawn
- [[OCAP/#17]](https://github.com/OCAP2/OCAP/issues/17) Fixed zoom parameter were ignored in share link
- adds http:// prefix to links generated using Share button

### Changes

#### Platform
- improvements to both extension and webserver builds
- now supports Windows x64 & Linux x64
- adds tag param in SQF export function allowing you to define the recording's 'tag' at mission end
- removes hardcoded 'tag' definitions in web/option.json, allowing you to use any tag for missions and use them to filter by in playback selection

#### Markers
- adapted for use with A3 vanilla marker system -- SWT will be reintegrated in future [[addon/#5]](https://github.com/OCAP2/addon/issues/5)
- now tracks RECTANGLE, ELLIPSE, and POLYLINE markers correctly, including those made via scripted commands
- now tracks direction, size, alpha (opacity), and markerBrush (for area markers) for more accurate display
- adds base game, RHS, ACE, IFA map marker icons
	- future plans to integrate VK marker icons
- integrated support for BIS_fnc_moduleCoverMap usage
- backwards compatibility maintained for older recordings

#### Projectile Tracking
- now tracks non-bullet projectiles, ACE throwing, and ACE mine (place > arm > detonate)
- adds base game, CUP Weapons, RHS, ACE, IFA projectile images in both default & IFA/FOW compatible colors

#### Maps
- base maps removed, available in external GDrive
- terrain generation automation improved -- looking to change render method which will make this obsolete

#### Web
- adds 'type' tag column in playback selection
- adds total kill count to players in ORBAT column at left
- adds tracking of selected-weapon of killer when in a vehicle (events column)
- [[OCAP/#4]](https://github.com/OCAP2/OCAP/issues/4) show role information as prefix before the players name
