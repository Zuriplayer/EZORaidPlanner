# Discord automation notes (maintainers)

This addon follows the same optional GitHub Actions + Discord webhook
pattern used by other EZO addons (see `Zuriplayer/EZOGroupFrames` and
`Zuriplayer/EZOAddonsUtility`): workflow_dispatch jobs build a clean zip
and post status/release/beta messages to dedicated Discord channels via
repository secrets.

## Ported automation

The following files were ported from `Zuriplayer/EZOGroupFrames` and
adjusted for EZORaidPlanner:

- `scripts/ezo/build-addon-package.ps1`
- `scripts/ezo/publish-status.ps1`, `publish-beta.ps1`, `publish-release.ps1`,
  `publish-announcement.ps1`, `publish-download.ps1`, `publish-codex-log.ps1`,
  `publish-discord.ps1`
- `tools/bump-version.ps1`
- `.github/workflows/ezo-beta.yml`, `ezo-release.yml`, `ezo-status.yml`,
  `ezo-discord-webhook-audit.yml`

## Required repository secrets

Configure these under Settings > Secrets and variables > Actions:

- `CODEX_LOG`
- `EZO_CODEX_ANNOUNCER`
- `EZO_CODEX_BETA_BUILDS`
- `EZO_CODEX_BUG_REPORTS`
- `EZO_CODEX_DOWNLOADS`
- `EZO_CODEX_RELEASES`
- `EZO_CODEX_STATUS`

Each secret holds a Discord webhook URL for its matching channel. The
workflows only ever reference these via `${{ secrets.NAME }}`; the actual
webhook values are never committed to the repository.
