# Project Name
<!-- Replace "Project Name" with your actual project name -->

<!-- ## Project Overview -->
<!-- Brief description of what this project does and its purpose. -->

<!-- ## Tech Stack -->
<!-- - Language: -->
<!-- - Framework: -->
<!-- - Database: -->
<!-- - Other key dependencies: -->

<!-- ## Getting Started -->
<!-- ```bash -->
<!-- # Install dependencies -->
<!-- # Start development server -->
<!-- # Run tests -->
<!-- ``` -->

## Project Structure

<!-- Update to reflect your actual project layout -->
- `src/` — application source code
- `tests/` — test files
- `docs/` — documentation
- `scripts/` — build and utility scripts
- `config/` — configuration files

## Critical Thinking

- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.

## Docs & Tasks

- Read the docs in `docs/` to familiarize yourself with the repo before making changes.
- **Always update `docs/tasks.md`** when completing a task — mark items as `[x]` and add any relevant notes (credentials, decisions, etc.).
- Keep tasks atomic: update the task file as soon as a task is done, not in bulk at the end.
- `tasks.md` should stay a clean execution checklist, not a running journal or log.
- Keep notes short; update docs when behavior/API changes.

## Debugging & Failures

- **Always start with a repro.**
  For any bug or issue, spawn a subagent to create a *minimal* test that reproduces the issue. The test must fail first, then pass after the fix.

- **Limit blind retries.**
  If a fix attempt is still failing after **two** code changes/checks (or the same command fails twice), stop "trying stuff" and switch to root-cause analysis.

- **Root-cause analysis workflow:**
  - Trace the full code path end-to-end (entrypoint -> call stack -> dependencies -> side effects).
  - At each step, verify *expected vs actual* inputs/outputs and state transitions.
  - Identify the **first divergence** from expected behavior and focus there (not on downstream symptoms).

- If you're not **>90% confident** in the solution:
  - Add targeted logs or metrics around the suspected divergence.
  - Run the smallest focused test that reduces uncertainty.
  - Use appropriate inspection tools for the domain (browser devtools, network inspectors, debuggers, etc.).
  - Use **web search** in a subagent to research solutions.

## Git & GitHub

- Use `gh` CLI for GitHub-specific operations (creating repos, PRs, issues, etc.).
- Use `git` CLI for standard git operations (commits, branches, push, pull, etc.).
- Do NOT add "Co-Authored-By: Claude" lines to commit messages.
- Use convenctional commits and keep commits/PRs/messages concise and action‑oriented.
- PR descriptions should be minimal — a single sentence or short bullet list is sufficient.
- PR descriptions must use real newlines (no literal `\n` sequences). Use a short **Summary** section plus a **Testing** section.
- Before creating a PR, run `npm test` and `npm run build` (or the relevant test/build commands) and confirm they pass.
- Before merging, perform a code review of the PR (focus on correctness, regressions, and missing tests).
- After committing, push to origin.
- Do not commit directly to `main`.
- Create a branch per phase or large task
- After pushing a branch, create a PR with `gh pr create`.
- After PR is created, ask user if ready to squash and merge.
- Once merged, delete the old branch and pull main before starting the next phase branch.

## Do Not

- Do not commit directly to `main`.
- Do not skip tests/build before opening a PR.
- Do not commit secrets, tokens, or `.env*` files.
- Do not make behavior/API changes without updating docs and `docs/tasks.md`.
- Do not ignore failing checks; fix root cause or clearly document the blocker.

## Testing

<!-- Update framework and commands for your project -->

Commands:
- `<test-command>` — run all tests
- `<test-watch-command>` — watch mode
- `<test-coverage-command>` — with coverage report

<!-- Update naming conventions for your project -->
Naming convention: `*.test.*` for unit tests, `*.e2e.test.*` for e2e tests.

### Key Commands

<!-- Add your project-specific commands here -->
| Command | What It Does |
|---------|--------------|
| `<command>` | `<description>` |

<!-- ## Development Conventions -->
<!-- - Code style: -->
<!-- - Naming conventions: -->
<!-- - Branch strategy: -->
<!-- - PR process: -->

<!-- ## Important Notes -->
<!-- - Any gotchas, workarounds, or things Claude should know about. -->
