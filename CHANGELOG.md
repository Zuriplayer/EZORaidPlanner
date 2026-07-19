# Changelog

## [0.0.2] - 2026-07-19

- Added one-time versus weekly recurring event schedule fields with date, weekday, and 24-hour time guidance.
- Added chat feedback and an active-event summary for event creation.
- Added local event deletion by active event ID.
- Increased the active event limit to 10 and added selectable event deletion.
- Removed the unused optional LibChatMessage dependency; chat feedback uses ESO's native chat system.

## [0.0.1] - Unreleased

- Initial scaffold: repository structure, TOC manifest, bilingual README, and module stubs for event management, player selection, and results tracking.
- Fixed early scaffold loading order, EZOCore dependency metadata, version validation metadata, and event persistence.
- Added optional Discord channel/thread link metadata for planned events.
- Classified the addon as development for EZOCore/LAM metadata and repository status.
