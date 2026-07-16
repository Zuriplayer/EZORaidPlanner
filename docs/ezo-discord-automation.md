# Discord automation notes (maintainers)

This addon is meant to follow the same optional GitHub Actions + Discord
webhook pattern used by other EZO addons (see `Zuriplayer/EZOGroupFrames`
and `Zuriplayer/EZOAddonsUtility`): workflow_dispatch jobs build a clean
zip and post status/release/beta messages to dedicated Discord channels via
repository secrets.

Pending ports for EZORaidPlanner (intentionally left as a to-do rather than
retyped by hand here, to avoid transcription errors in release/publishing
automation):

- `scripts/ezo/build-addon-package.ps1`
- `scripts/ezo/publish-status.ps1`, `publish-beta.ps1`, `publish-release.ps1`,
  `publish-announcement.ps1`, `publish-download.ps1`, `publish-codex-log.ps1`,
  `publish-discord.ps1`
- `tools/bump-version.ps1`
- `.github/workflows/ezo-beta.yml`, `ezo-release.yml`, `ezo-status.yml`,
  `ezo-discord-webhook-audit.yml`

Copy these from an existing EZO addon repo and adjust the addon name and
env vars, then configure the matching repository secrets under
Settings > Secrets and variables > Actions.
