# Claudey

My personal preferences and patterns for working with [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [Codex](https://openai.com/index/introducing-codex/). Includes a `CLAUDE.md` template with rules I've found work well for agent behavior, plus reusable skills for common workflows.

## What's Included

### Template

| File | Purpose |
|------|---------|
| `AGENTS.md` | All-in-one project context and agent instructions — project overview, debugging rules, git workflow, testing, and more |
| `CLAUDE.md` | Symlink to `AGENTS.md` for Claude Code compatibility (single source of truth) |

### Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `handoff` | `/handoff` (manual) | Surveys git state, summarizes work in progress, writes `HANDOFF.md` for session continuity |
| `pickup` | `/pickup` (manual) | Reads `HANDOFF.md`, verifies branch/commit state, resumes previous work |
| `find-bugs` | Auto-detected | Quick security/bug review of branch changes — attack surface mapping, data flow analysis, OWASP checklist (runs in subagent) |
| `plan-review` | `/plan-review` (manual) | Interactive review of implementation plans — architecture, code quality, tests, performance — with opinionated recommendations |
| `codex` | Auto-detected (Claude Code only) | Delegates a task to OpenAI Codex for independent analysis — code review, security audit, plan review, etc. Saves report to markdown |

I also recommend these from the plugin marketplace:
- [Anthropic official plugins](https://github.com/anthropics/claude-plugins-official) — `code-review`, `frontend-dev`, and `code-simplifier`
- [Sentry plugins](https://github.com/getsentry/skills) — `security-review` (thorough OWASP-based security audit with confidence-gated reporting)

## Setup

### Install this repo

```bash
# Clone the repo
git clone https://github.com/cameronthacker/claudey.git
cd claudey
```

### Use Make targets

```bash
# Show all install options
make help

# Install skills globally for both Claude Code and Codex
make install

# Install globally for only one tool
make install-global-claude
make install-global-codex

# Install into a specific project (skills + templates)
make install-project PROJECT_DIR=/path/to/project
```

Skill installs use symlinks so this repo remains the source of truth — updates here propagate immediately. Template install copies `AGENTS.md` into the target project and links `CLAUDE.md` to that local `AGENTS.md` so each repo can customize independently.

## Supply Chain Security — Minimum Release Age

All projects using this template **must** enforce a 14-day minimum release age on package installations. This is configured in `AGENTS.md` and should be applied to every project.

### Why?

Supply chain attacks on package registries (npm, PyPI, crates.io, etc.) have increased sharply. The attack pattern is consistent: a malicious version is published, and within hours it's pulled into CI pipelines and developer machines via automated installs. Most compromised packages are detected and yanked within days — but by then, the damage is done.

A 14-day cooldown means you never install a package version that the community hasn't had time to vet. This single setting blocks the majority of supply chain attacks with zero developer friction.

### Quick reference

| Package Manager | Config File | Setting |
|---|---|---|
| **npm** (v11.10+) | `.npmrc` | `min-release-age=14` |
| **pnpm** (v10.16+) | `pnpm-workspace.yaml` | `minimumReleaseAge: 20160` |
| **Yarn** (v4.10+) | `.yarnrc.yml` | `npmMinimalAgeGate: "14d"` |
| **uv** (v0.9.17+) | `pyproject.toml` | `exclude-newer = "14 days"` under `[tool.uv]` |
| **pip** (v26.0+) | CLI flag | `--uploaded-prior-to <date>` |

For cargo, Go, Bundler, Maven/Gradle, and Composer (no native support yet), pin exact versions in lock files and only update through reviewed PRs.

If the project uses **Dependabot** or **Renovate** for automated dependency updates, configure cooldowns there too — `minimumReleaseAge: "14 days"` (Renovate) or `cooldown.default-days: 14` (Dependabot). These gate when update PRs are *opened*, which is a separate layer from the install-time controls above.

## Customization

- **CLAUDE.md** — Uncomment the commented-out sections and fill in your project's details (overview, tech stack, conventions). The active sections (debugging, git, testing) are ready to use as-is or can be tweaked.
- **Skills** — Each skill is a standalone `SKILL.md` file. Fork and modify them to fit your workflow.
