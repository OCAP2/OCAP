# OCAP Configuration Reference

This document covers all configuration for the three OCAP components: the Arma 3 addon, the recorder extension DLL, and the web server.

---

## File Placement Summary

| Component | Config File | Location | Controls |
|---|---|---|---|
| Addon | *(none — in-game only)* | `Options > Addon Options > OCAP` | Recording behaviour, exclusions, auto-save |
| Extension | `ocap_recorder.cfg.json` | Alongside the DLL inside `@ocap/` | Storage backend, API endpoint, log level |
| Web server | `setting.json` | Working directory of the `ocap-webserver` binary | Listen address, authentication, database path, UI customisation |

> **Important:** `setting.json` → `secret` and `ocap_recorder.cfg.json` → `api.apiKey` must be set to the same value. The extension authenticates to the web server using this shared secret.

---

## Addon: CBA Settings

Settings are configured entirely in-game at **Options > Addon Options > OCAP**. There is no file to edit. All settings are server-side and automatically synchronised to all clients in multiplayer.

Settings marked **Requires Restart** take effect only after restarting the mission.

### Core

| Setting (variable name) | Type | Default | Description |
|---|---|---|---|
| `OCAP_enabled` | Boolean | `true` | Turns on or off most recording functionality. Will not reset anything from existing session, will just stop recording most new data. Note: For record/pause switching, use the CBA events! |
| `OCAP_isDebug` | Boolean | `false` | Enables increased logging of addon actions. |
| `OCAP_administratorList` | Stringified array | `"[]"` | An array or server-visible variable referencing one that is a list of playerUIDs. Additional briefing diary or UI elements may be available for more accessible control over OCAP's features. Takes effect on player server connection. Format: `[]` OR `myAdminPUIDs`. Example: `"['76561198000000000', '76561198000000001']"` |

### Auto-start Settings

| Setting (variable name) | Type | Default | Description |
|---|---|---|---|
| `OCAP_settings_autoStart` | Boolean | `true` | Automatically start OCAP recordings at session start. **Requires Restart.** |
| `OCAP_settings_minPlayerCount` | Number (1–150) | `15` | Auto-start will begin once this player count is reached. |

### Capture

*In-game these settings appear under the **Core** category.*

| Setting (variable name) | Type | Default | Description |
|---|---|---|---|
| `OCAP_settings_frameCaptureDelay` | Number (0.10–10.00) | `1` | Positioning, medical status, and crew states of units and vehicles will be captured every X amount of seconds. **Requires Restart.** |
| `OCAP_settings_preferACEUnconscious` | Boolean | `true` | If true, will check ACE3 medical status on units. If false, or ACE3 is not loaded, fall back to vanilla. |

### Exclusions

| Setting (variable name) | Type | Default | Description |
|---|---|---|---|
| `OCAP_settings_excludeClassFromRecord` | Stringified array | `"['ACE_friesAnchorBar','WeaponHolderSimulated']"` | Array of object classnames that should be excluded from recording. Use single quotes. Example: `"['ACE_friesAnchorBar']"` |
| `OCAP_settings_excludeKindFromRecord` | Stringified array | `"['WeaponHolder']"` | Array of classnames which, along with all child classes, should be excluded from recording. Use single quotes. Example: `"['WeaponHolder']"` |
| `OCAP_settings_excludeMarkerFromRecord` | Stringified array | `"['SystemMarker_','ACE_BFT_','RscAttribute']"` | Array of prefixes. Any markers matching these prefixes will be excluded from recording. Use single quotes. |

### Extra Tracking

| Setting (variable name) | Type | Default | Description |
|---|---|---|---|
| `OCAP_settings_trackTickets` | Boolean | `true` | Will track respawn ticket counts for missionNamespace and each playable faction every 30th frame. |
| `OCAP_settings_trackTimes` | Boolean | `false` | Will continuously track in-game world time during a mission. Useful for accelerated/skipped time scenarios. |
| `OCAP_settings_trackTimeInterval` | Number (5–25) | `10` | If time tracking is enabled, it will be checked every X capture frames. |
| `OCAP_settings_trackSectors` | Boolean | `true` | Automatically record sector capture events when ModuleSector_F ownership changes. |

### Save/Export Settings

| Setting (variable name) | Type | Default | Description |
|---|---|---|---|
| `OCAP_settings_saveTag` | String | `"TvT"` | If not overridden by the `exportData` CBA event or if a mission is auto-saved, this will be used to categorize and filter the recording in the database and web list of missions. |
| `OCAP_settings_saveMissionEnded` | Boolean | `true` | If true, automatically save and export the mission when the MPEnded event fires. |
| `OCAP_settings_saveOnEmpty` | Boolean | `true` | Will automatically save recording when there are 0 players on the server and existing data accounts for more time than the minimum save duration setting. |
| `OCAP_settings_minMissionTime` | Number (1–120 min) | `20` | A recording must be at least this long (in minutes) to auto-save. Calling an `ocap_exportData` CBA server event will override this restriction. **Requires Restart.** |

---

## Extension: `ocap_recorder.cfg.json`

Place this file alongside the DLL inside the `@ocap/` mod directory. Copy from `ocap_recorder.cfg.json.example` and adjust for your environment.

```json
{
  "logLevel": "info",
  "logsDir": "./ocaplogs",
  "defaultTag": "TvT",
  "api": {
    "serverUrl": "http://127.0.0.1:5000",
    "apiKey": "same-secret",
    "uploadTimeout": "10m"
  },
  "storage": {
    "type": "memory",
    "memory": {
      "outputDir": "./recordings",
      "compressOutput": true
    },
    "sqlite": {
      "dumpInterval": "3m"
    },
    "postgres": {
      "host": "127.0.0.1",
      "port": "5432",
      "username": "postgres",
      "password": "postgres",
      "database": "ocap"
    }
  }
}
```

### Top-level fields

| Field | Default | Description |
|---|---|---|
| `logLevel` | `"info"` | Log verbosity. One of `debug`, `info`, `warn`, `error`. |
| `logsDir` | `"./ocaplogs"` | Directory where log files are written. |
| `defaultTag` | `"TvT"` | Default mission type tag used when no tag is provided by the addon at save time. |

### `api`

| Field | Default | Description |
|---|---|---|
| `serverUrl` | `"http://127.0.0.1:5000"` | Base URL of the OCAP web server that will receive uploaded recordings. |
| `apiKey` | `"same-secret"` | Shared secret used to authenticate uploads to the web server. Must match `setting.json` → `secret`. |
| `uploadTimeout` | `"10m"` | Maximum time to wait for an upload to complete before aborting. |

### `storage.type`

Controls which storage backend is used. Allowed values:

| Value | Description |
|---|---|
| `memory` | Records entirely in memory and exports gzipped JSON files on mission end. |
| `sqlite` | Uses an in-memory SQLite database with periodic disk dumps. |
| `postgres` | Persists data to a PostgreSQL database. |
| `websocket` | Streams recording data in real time to the OCAP web server. |

### `storage.memory`

Active when `storage.type` is `"memory"`.

| Field | Default | Description |
|---|---|---|
| `outputDir` | `"./recordings"` | Directory where exported JSON recording files are written. |
| `compressOutput` | `true` | Whether to gzip-compress exported recording files. |

### `storage.sqlite`

Active when `storage.type` is `"sqlite"`.

| Field | Default | Description |
|---|---|---|
| `dumpInterval` | `"3m"` | How often the in-memory SQLite database is flushed to disk. |

### `storage.postgres`

Active when `storage.type` is `"postgres"`.

| Field | Default | Description |
|---|---|---|
| `host` | `"127.0.0.1"` | PostgreSQL server hostname or IP. |
| `port` | `"5432"` | PostgreSQL server port. |
| `username` | `"postgres"` | Database user. |
| `password` | `"postgres"` | Database password. |
| `database` | `"ocap"` | Database name. |

---

## Web Server: `setting.json`

Place this file in the working directory of the `ocap-webserver` binary. Copy from `setting.json.example` and adjust for your environment.

Any field can be overridden via an `OCAP_<KEY>` environment variable. For nested keys, uppercase and concatenate the key path (e.g. `auth.steamApiKey` becomes `OCAP_AUTH_STEAMAPIKEY`).

```json
{
	"listen": "127.0.0.1:5000",
	"prefixURL": "",
	"secret": "change-me",
	"db": "data.db",
	"data": "data",
	"static": "",
	"markers": "assets/markers",
	"ammo": "assets/ammo",
	"fonts": "assets/fonts",
	"maps": "maps",
	"logger": false,
	"customize": {
		"disableKillCount": false,
		"enabled": false,
		"headerSubtitle": "",
		"headerTitle": "",
		"websiteLogo": "",
		"websiteLogoSize": "32px",
		"websiteURL": "",
		"cssOverrides": {}
	},
	"conversion": {
		"batchSize": 1,
		"chunkSize": 300,
		"enabled": false,
		"interval": "5m",
		"retryFailed": false
	},
	"streaming": {
		"enabled": false,
		"pingInterval": "30s",
		"pingTimeout": "10s"
	},
	"auth": {
		"sessionTTL": "24h",
		"adminSteamIds": [],
		"steamApiKey": ""
	},
	"httpServer": {
		"readTimeout": "120s",
		"readHeaderTimeout": "30s",
		"writeTimeout": "120s",
		"idleTimeout": "120s"
	}
}
```

### Core fields

| Field | Default | Description |
|---|---|---|
| `listen` | `"127.0.0.1:5000"` | Address and port the HTTP server listens on. |
| `prefixURL` | `""` | URL prefix for all routes. Useful when hosted behind a reverse proxy at a sub-path. |
| `secret` | `"change-me"` | Shared secret for authenticating mission uploads from the extension. Must match `ocap_recorder.cfg.json` → `api.apiKey`. |
| `db` | `"data.db"` | Path to the SQLite database file used for mission metadata. |
| `data` | `"data"` | Directory where mission recording files are stored. |
| `static` | `""` | Optional path to a custom static files directory to override the embedded frontend. |
| `markers` | `"assets/markers"` | Directory containing unit/vehicle marker icon assets. |
| `ammo` | `"assets/ammo"` | Directory containing ammunition/equipment icon assets. |
| `fonts` | `"assets/fonts"` | Directory containing font assets. |
| `maps` | `"maps"` | Directory containing map tile data. |
| `logger` | `false` | Enable HTTP request logging. |

### `auth`

| Field | Default | Description |
|---|---|---|
| `steamApiKey` | `""` | Steam Web API key used to validate Steam OpenID logins. Required for authentication features. |
| `adminSteamIds` | `[]` | List of Steam64 IDs that are granted administrator access. |
| `sessionTTL` | `"24h"` | How long a user session remains valid after login. |

### `conversion`

Background worker that converts uploaded JSON recordings to chunked Protobuf format. This chunked format enables faster browser-side streaming by loading only the chunks needed on demand, rather than fetching the entire recording at once. Enable this worker if you want efficient playback of large recordings.

| Field | Default | Description |
|---|---|---|
| `enabled` | `false` | Enable the background conversion worker. |
| `batchSize` | `1` | Number of recordings to convert per batch. |
| `chunkSize` | `300` | Number of frames processed per conversion chunk. |
| `interval` | `"5m"` | How often the conversion worker checks for unconverted recordings. |
| `retryFailed` | `false` | Whether to retry recordings that previously failed conversion. |

### `streaming`

Real-time WebSocket streaming of live recording data to connected clients.

> **Note:** For the server to actually stream data, the extension's `storage.type` must also be set to `"websocket"` in `ocap_recorder.cfg.json`.

| Field | Default | Description |
|---|---|---|
| `enabled` | `false` | Enable live streaming support. |
| `pingInterval` | `"30s"` | How often the server sends WebSocket ping frames to connected clients. |
| `pingTimeout` | `"10s"` | How long to wait for a pong response before closing the connection. |

### `customize`

UI customisation options shown in the web frontend.

| Field | Default | Description |
|---|---|---|
| `enabled` | `false` | Enable UI customisation. When false, all other `customize` fields are ignored. |
| `headerTitle` | `""` | Custom title text shown in the site header. |
| `headerSubtitle` | `""` | Custom subtitle text shown in the site header. |
| `websiteURL` | `""` | URL linked from the site logo/title. |
| `websiteLogo` | `""` | URL or path to a custom logo image. |
| `websiteLogoSize` | `"32px"` | CSS size value for the logo image. |
| `disableKillCount` | `false` | When true, hides kill count displays in the frontend. |
| `cssOverrides` | `{}` | Map of CSS variable names to values for fine-grained style overrides. |

### `httpServer`

Timeouts for the underlying HTTP server. All values are Go duration strings (e.g. `"120s"`, `"2m"`).

| Field | Default | Description |
|---|---|---|
| `readTimeout` | `"120s"` | Maximum duration for reading an entire request, including the body. |
| `readHeaderTimeout` | `"30s"` | Maximum duration for reading request headers. |
| `writeTimeout` | `"120s"` | Maximum duration before timing out a response write. |
| `idleTimeout` | `"120s"` | Maximum time to wait for the next request on a keep-alive connection. |

> **Security note:** Increasing `readTimeout` or `idleTimeout` beyond the defaults raises exposure to [Slowloris](https://en.wikipedia.org/wiki/Slowloris_(cyber_attack))-style attacks. Keep the defaults unless you have a specific reason to raise them (e.g. very large file uploads).
