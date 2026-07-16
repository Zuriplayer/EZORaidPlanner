# EZORaidPlanner

Prefer English? You are reading it. Spanish version: README.es.md

EZORaidPlanner is an early-development addon for The Elder Scrolls Online, part of the EZO family. It helps raid leaders plan dungeon and trial events: schedule, assign a leader, pick players, and record the outcome.

Support, bug reports, and suggestions: EZO Discord (see server invite pinned in #ezo-core).

## Status

EZORaidPlanner is in early development (concept stage). Nothing described below is final; the scope may change before the first public beta.

## Planned Scope

- Event management: trial/dungeon, day, time, and leader.
- Maximum of 5 active events per leader.
- Player selection: manual by @account, from the current group, and from the guild roster when the API allows it comfortably.
- Final result: completed/not completed, score, time, vitality, and optional notes.

## Version Metadata

- Addon version: `0.0.1`
- AddOnVersion: `10000`
- APIVersion: `101049 101050`
- Status: concept / early development

## Requirements

- The Elder Scrolls Online PC client.
- LibAddonMenu-2.0.
- Optional: EZOCore as a shared service layer.

## Installation

Not yet published. Once a first build is available:

1. Download or clone the addon.
2. Place the folder in your ESO AddOns directory: `Documents\Elder Scrolls Online\live\AddOns`
3. Make sure the final path is: `AddOns\EZORaidPlanner`
4. Enable EZORaidPlanner in the ESO Add-Ons menu.
5. Run `/reloadui`.

## Documentation

- Roadmap ideas: `docs/IDEAS.md`

## License

MIT License. See LICENSE.
