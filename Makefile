SHELL := /bin/bash

REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SKILLS := handoff pickup find-bugs plan-review
CLAUDE_ONLY_SKILLS := codex

CLAUDE_GLOBAL_DIR ?= $(HOME)/.claude/skills
CODEX_GLOBAL_DIR ?= $(HOME)/.agents/skills
PROJECT_DIR ?=

.PHONY: help install install-global install-global-claude install-global-codex \
	install-project install-project-claude install-project-codex install-template \
	check-project-dir

help:
	@echo "Claudey install targets"
	@echo
	@echo "Global installs:"
	@echo "  make install                    # install skills for Claude Code + Codex globally"
	@echo "  make install-global-claude      # install skills to $(HOME)/.claude/skills"
	@echo "  make install-global-codex       # install skills to $(HOME)/.agents/skills"
	@echo
	@echo "Project installs (requires PROJECT_DIR):"
	@echo "  make install-project PROJECT_DIR=/path/to/project"
	@echo "  make install-project-claude PROJECT_DIR=/path/to/project"
	@echo "  make install-project-codex PROJECT_DIR=/path/to/project"
	@echo "  make install-template PROJECT_DIR=/path/to/project"

install: install-global

install-global: install-global-claude install-global-codex
	@echo "Done: installed skills globally for Claude Code and Codex."

install-global-claude:
	@mkdir -p "$(CLAUDE_GLOBAL_DIR)"
	@for skill in $(SKILLS) $(CLAUDE_ONLY_SKILLS); do \
		ln -sfn "$(REPO_ROOT)/skills/$$skill" "$(CLAUDE_GLOBAL_DIR)/$$skill"; \
	done
	@echo "Done: Claude skills linked in $(CLAUDE_GLOBAL_DIR)"

install-global-codex:
	@mkdir -p "$(CODEX_GLOBAL_DIR)"
	@for skill in $(SKILLS); do \
		ln -sfn "$(REPO_ROOT)/skills/$$skill" "$(CODEX_GLOBAL_DIR)/$$skill"; \
	done
	@echo "Done: Codex skills linked in $(CODEX_GLOBAL_DIR)"

check-project-dir:
	@test -n "$(PROJECT_DIR)" || (echo "PROJECT_DIR is required. Example: make install-project PROJECT_DIR=/path/to/project" >&2; exit 1)
	@test -d "$(PROJECT_DIR)" || (echo "PROJECT_DIR does not exist: $(PROJECT_DIR)" >&2; exit 1)

install-project: install-project-claude install-project-codex install-template
	@echo "Done: installed Claude + Codex project links in $(PROJECT_DIR)"

install-project-claude: check-project-dir
	@mkdir -p "$(PROJECT_DIR)/.claude/skills"
	@for skill in $(SKILLS) $(CLAUDE_ONLY_SKILLS); do \
		ln -sfn "$(REPO_ROOT)/skills/$$skill" "$(PROJECT_DIR)/.claude/skills/$$skill"; \
	done
	@echo "Done: Claude project skills linked in $(PROJECT_DIR)/.claude/skills"

install-project-codex: check-project-dir
	@mkdir -p "$(PROJECT_DIR)/.agents/skills"
	@for skill in $(SKILLS); do \
		ln -sfn "$(REPO_ROOT)/skills/$$skill" "$(PROJECT_DIR)/.agents/skills/$$skill"; \
	done
	@echo "Done: Codex project skills linked in $(PROJECT_DIR)/.agents/skills"

install-template: check-project-dir
	@ln -sfn "$(REPO_ROOT)/AGENTS.md" "$(PROJECT_DIR)/AGENTS.md"
	@ln -sfn AGENTS.md "$(PROJECT_DIR)/CLAUDE.md"
	@echo "Done: CLAUDE.md and AGENTS.md linked in $(PROJECT_DIR)"
