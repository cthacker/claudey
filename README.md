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

All installs use symlinks so this repo remains the source of truth — updates here propagate immediately.

## Customization

- **CLAUDE.md** — Uncomment the commented-out sections and fill in your project's details (overview, tech stack, conventions). The active sections (debugging, git, testing) are ready to use as-is or can be tweaked.
- **Skills** — Each skill is a standalone `SKILL.md` file. Fork and modify them to fit your workflow.
