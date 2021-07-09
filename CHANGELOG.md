# CHANGELOG

## v1.0.0

### FIXES
- [#4] respawned units no longer 'flicker' after respawning when corpse + new unit have same ocapID
- changes 'side' tracking methodology to maintain tracked side of a player post-respawn
- adds http:// prefix to links generated using Share button

### CHANGES

#### Platform
- improvements to both extension and webserver builds
- now supports Windows x64 & Linux
- adds tag param in SQF export function allowing you to define the recording's 'tag' at mission end
- removes hardcoded 'tag' defintions in web/option.json, allowing you to use any tag for missions and use them to filter by in playback selection

#### Markers
- adapted for use with A3 vanilla marker system -- SWT will be reintegrated in future
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