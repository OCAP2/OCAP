# Using OCAP

OCAP has two usage layers: **mission integration** (SQF/CBA API for controlling recording from within a mission) and **playback** (the web UI for watching recordings).

---

## Part 1: Mission Integration

### Auto-Start

When `OCAP_settings_autoStart` is enabled (default), recording begins automatically after the briefing screen once the minimum player count (`OCAP_settings_minPlayerCount`, default 15) is connected. No mission-side scripting is required.

When recording starts, every connected player receives a diary entry under **OCAPInfo** confirming the start time (elapsed in-mission time and UTC system time).

If the minimum player count is never reached, recording does not start automatically. Use the `OCAP_record` CBA event or the admin diary controls to start it manually — see [Manual Recording Control](#manual-recording-control).

See [Configuration Reference](configuration.md) for the relevant settings.

### Ending a Mission and Exporting

Call `OCAP_recorder_fnc_exportData` server-side to end the recording and upload it to the web server. All parameters are optional.

```sqf
// No args — records "Mission ended"
[] call OCAP_recorder_fnc_exportData;

// Winning side only
[west] call OCAP_recorder_fnc_exportData;

// Side + outcome message
[east, "OPFOR controlled all sectors!"] call OCAP_recorder_fnc_exportData;

// Side + message + tag (filterable in the recording selector)
[east, "OPFOR controlled all sectors!", "PvP"] call OCAP_recorder_fnc_exportData;
```

**Typical trigger pattern** — create a trigger that fires when objectives are complete, then in its On Activation field:

```sqf
if (isServer) then {
    [east, "OPFOR has achieved all of their objectives!"] call OCAP_recorder_fnc_exportData;
    "end1" call BIS_fnc_endMissionServer;
};
```

**Async save flow:** `OCAP_recorder_fnc_exportData` is non-blocking. Players see an interim "saving…" screen notification immediately. The extension writes and uploads the recording in the background; once it finishes, a final diary entry confirms success or failure.

**Minimum duration:** Recordings shorter than the configured minimum (default 20 minutes) are not saved. If the recording is too short, export is skipped and a diary entry explains why. Recording continues, so the mission can still be saved once the threshold is met — or bypass it with the `OCAP_exportData` CBA event (see [Manual Recording Control](#manual-recording-control)).

> **Note:** If `OCAP_settings_saveMissionEnded` or `OCAP_settings_saveOnEmpty` is true, `OCAP_recorder_fnc_exportData` is called automatically on the `MPEnded` event or when the server empties. See [Configuration Reference](configuration.md).

### Manual Recording Control

Three CBA server events let you control recording from scripts or admin diary controls. All require the caller to be a server admin or to have their Steam UID listed in `OCAP_administratorList`.

| Event | Effect |
|-------|--------|
| `["OCAP_record"] call CBA_fnc_serverEvent;` | Start or resume recording |
| `["OCAP_pause"] call CBA_fnc_serverEvent;` | Pause recording (data preserved; resume with `OCAP_record`) |
| `["OCAP_exportData", [Side, String, String]] call CBA_fnc_serverEvent;` | Stop and save — **always bypasses minimum duration** |

Examples:

```sqf
// Start recording manually (e.g. when a specific mission phase begins)
["OCAP_record"] call CBA_fnc_serverEvent;

// Pause recording (e.g. during a long mid-mission briefing)
["OCAP_pause"] call CBA_fnc_serverEvent;

// Force-save with side and message, ignoring minimum duration
["OCAP_exportData", [west, "BLUFOR completed the objectives!", "TvT"]] call CBA_fnc_serverEvent;
```

**When to use CBA events vs. `OCAP_recorder_fnc_exportData`:**
- Use `OCAP_recorder_fnc_exportData` in normal mission-end triggers — it respects minimum duration and is the standard mission-end path.
- Use the `OCAP_exportData` CBA event when you need to force-save regardless of duration (admin manual export, server restart).
- Use `OCAP_record` / `OCAP_pause` to gate recording around specific phases (e.g. don't record while players are slotting in).

### Custom Events

Fire custom events from any server-side script to add entries to the Events tab in the playback UI.

**General event** — freeform text entry:
```sqf
["OCAP_customEvent", ["generalEvent", "Player reached the extraction zone"]] call CBA_fnc_serverEvent;
```

**Sector captured** — structured event with sector name, owning side, and world position:
```sqf
["OCAP_customEvent", ["captured", ["sector", "Sector Alpha", str west, getPosASL _sector]]] call CBA_fnc_serverEvent;
```

**Sector contested** — sector is being fought over (no owning side yet):
```sqf
["OCAP_customEvent", ["contested", ["sector", "Sector Alpha", "", getPosASL _sector]]] call CBA_fnc_serverEvent;
```

**End mission event** — log a mission-end message as a timeline event (separate from `OCAP_recorder_fnc_exportData`):
```sqf
// With winning side
["OCAP_customEvent", ["endMission", [str west, "BLUFOR controlled all sectors!"]]] call CBA_fnc_serverEvent;

// Message only
["OCAP_customEvent", ["endMission", "Mission complete!"]] call CBA_fnc_serverEvent;
```

> See the [OCAP wiki](https://github.com/OCAP2/OCAP/wiki/Custom-Game-Events) for extended custom event documentation.

### Score Counters

Track side-specific scores or ticket counts. Values appear as a live counter overlay in the playback UI.

Initialize once at mission start:
```sqf
["OCAP_counterInit", [
    [west, 0],
    [east, 0]
]] call CBA_fnc_serverEvent;
```

Update whenever the score changes:
```sqf
// Set BLUFOR score to 3
["OCAP_counterEvent", [west, 3]] call CBA_fnc_serverEvent;
```

This system is independent of `BIS_fnc_respawnTickets`. Wire it to whatever scoring or ticket logic your mission uses.

### Focus Windows

Mark a sub-range of the recording as the key phase. The focused range is highlighted on the timeline scrubber in the playback UI.

Set the in-point at the current capture frame:
```sqf
["OCAP_setFocusStart"] call CBA_fnc_serverEvent;
```

Set the out-point at the current capture frame:
```sqf
["OCAP_setFocusEnd"] call CBA_fnc_serverEvent;
```

Or specify explicit frame numbers:
```sqf
["OCAP_setFocusStart", [120]] call CBA_fnc_serverEvent;
["OCAP_setFocusEnd", [850]] call CBA_fnc_serverEvent;
```

The focus range can also be set interactively in the playback UI using the `I` and `O` keyboard shortcuts — see [Focus Mode](#focus-mode) in the Playback section below.

### Admin Controls (In-Game Diary)

Players who are server admins, or whose Steam UID is in `OCAP_administratorList`, automatically receive an **OCAP Admin** tab in their briefing diary. It provides three clickable controls:

- **Start/Resume Recording** — fires `OCAP_record`
- **Pause Recording** — fires `OCAP_pause`
- **Stop and Export Recording** — fires `OCAP_exportData`, bypassing minimum duration

The tab is added on player connect and removed if the player logs out of admin. No mission-side scripting is needed — set `OCAP_administratorList` in CBA settings to grant specific UIDs access regardless of admin status.

---

## Part 2: Playback

### Finding a Recording

Navigate to the web server address in any browser. The recording selector lists all uploaded missions with their name, upload date, and tag.

- Use the **search box** to filter by mission name.
- Use the **tag dropdown** to filter by tag (set via `OCAP_recorder_fnc_exportData` or `OCAP_settings_saveTag`).
- Use the **map filter** to narrow by terrain or world name.

Click any recording to open it in the playback view.

### Playback Controls

The bottom bar contains the main controls:

- **Play/Pause button** — starts or stops playback.
- **Timeline scrubber** — click or drag to jump to any point in the recording. If a focus range was set, it is highlighted on the scrubber.

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Space` | Toggle play/pause |
| `E` | Toggle side panel visibility |
| `←` / `→` | Step back / forward 1 frame |
| `Shift+←` / `Shift+→` | Step back / forward 10 frames |
| `,` | Jump to previous kill event |
| `.` | Jump to next kill event |
| `I` | Set focus in-point (focus edit mode only) |
| `O` | Set focus out-point (focus edit mode only) |
| `Escape` | Cancel focus edit |

### Following a Unit

Click any unit icon on the map to lock the camera to that unit. The map pans to keep the unit centered as the recording plays. A follow indicator appears in the UI. Click the map background or a different unit to change or release the follow lock.

### Side Panel

The side panel on the left has three tabs. Press `E` to hide it and maximize the map view.

**Units** — all players, AI, and vehicles in the mission. Shows alive/dead state, group name, and slotted role. Click a unit to follow them on the map.

**Events** — a chronological, filterable log of game events: kills, deaths, hits, player connects/disconnects, and any custom events fired via `OCAP_customEvent`. Click any event to jump to that frame. Use the filter controls to show or hide event types (e.g. hide hits to reduce noise).

**Stats** — kill counts and mission summary statistics.

### Focus Mode

To set a focus range interactively while watching a recording:

1. Click the focus toolbar button to enter focus edit mode.
2. Navigate to the desired start point, then press `I`.
3. Navigate to the desired end point, then press `O`.
4. Press `Escape` to cancel without saving.

The focus range is a visual highlight on the timeline — it does not trim the recording.

If the mission set a focus range server-side via `OCAP_setFocusStart` / `OCAP_setFocusEnd`, it appears automatically when you open the recording.

### Counter Display

If the mission used `OCAP_counterInit`, a score counter appears on-screen during playback showing the tracked values for each side as they changed over time.
