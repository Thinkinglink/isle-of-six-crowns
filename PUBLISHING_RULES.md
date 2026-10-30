# Isle of Six Crowns: rules for anyone (or any AI) working on this repository

## PERMANENT RULE: GitHub is written at most once every 5 minutes
GitHub banned this account once for abuse (more than 5 updates within 60 seconds). From now on:

1. Never push, commit through the API, upload, or otherwise write to this repository more than once every 5 minutes. This includes game releases, admin control updates (control.json) and any player data.
2. Every release is ONE push. Group all files and the update.json into that single push.
3. Always push through the guard script `gh_guard.sh`. It checks the time of the newest commit on GitHub and waits until 5 minutes have passed. A local pre push hook blocks any other push made too soon.
4. Never retry a push in a loop. If a push fails, stop and tell the owner.
5. Never commit secrets: no OAuth client secrets, tokens, keys or passwords. The guard refuses to push files that contain them.

## Player data stays on the player's device
Player progress, stats and upgrades are saved only on each player's own device. The game never writes player data to GitHub.

## Admin control
The admin controls bans, account resets, balance (nerfs and boosts) and paused game modes through `control.json` in this repository.
* Players read it at most once every 5 minutes per device.
* The in game Admin panel publishes it as one write, and refuses to publish within 5 minutes of the last write to this repository.

These rules are permanent for this game. Do not remove or weaken them.
