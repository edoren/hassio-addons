# Claude Instructions

## Commits

- Use conventional commits (`fix:`, `feat:`, `docs:`, `chore:`, etc.)
- Do not add any Claude signature or link to the chat session in commit messages or branch names

## Addon Versioning

- Do not bump the version in `config.yaml` — the publish workflow handles this automatically when triggered
- The publish workflow is triggered manually with the addon name and next version (must be the next semver patch/minor/major bump)
- Tags follow the format `v{version}-{addon}` (e.g. `v1.0.4-atuin`) and are created by the publish workflow
- When updating `CHANGELOG.md`, follow the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format already in use
- The CHANGELOG must have a `## [v{next_version}]` entry (e.g. `## [v1.0.4]`) before the publish workflow runs — it validates this
