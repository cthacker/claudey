# Claudey: Structured Development with Claude Code Agents

Specialized Claude Code agents for structured, spec-driven development workflows that minimize context usage while maximizing development quality and success rates.

<<<<<<< HEAD
I think most people are experimenting with spec-driven design to keep the AI on task and help minimize rule follow errors or other problems. I will keep this up to date with what I find are the current best practices.
=======
## Architecture

```
               CLAUDEY AGENT SYSTEM
              Structured Development
┌───────────────────────────────────────────────────────┐
│                       Two Workflow Paths              │
├─────────────────────┬─────────────────────────────────┤
│    PRODUCT-FIRST    │         ENGINEERING-FIRST       │
│   (User Features)   │         (Technical Tasks)       │
│                     │                                 │
│  ┌─────────────┐    │        ┌─────────────┐          │
│  │     PRD     │    │        │   PLANNER   │          │
│  │ (Product    │    │        │ (EARS       │          │
│  │ Manager)    │    │        │ Requirements│          │
│  └─────────────┘    │        │ Analyst)    │          │
│         │           │        └─────────────┘          │
│         ▼           │               │                 │
│  ┌─────────────┐    │               ▼                 │
│  │ TASKER_PRD  │    │        ┌─────────────┐          │
│  │ (Product    │◄───┼────────┤    ARCH     │          │
│  │ Task Gen)   │    │        │ (Software   │          │
│  └─────────────┘    │        │ Architect)  │          │
│         │           │        └─────────────┘          │
│         ▼           │               │                 │
│  ┌─────────────┐    │               ▼                 │
│  │             │    │        ┌─────────────┐          │
│  │   CODER     │◄───┼────────┤   TASKER    │          │
│  │ (Task       │    │        │ (Task       │          │
│  │ Executor)   │    │        │ Generator)  │          │
│  └─────────────┘    │        └─────────────┘          │
│                     │               │                 │
│                     │               ▼                 │
├─────────────────────┴─────────────────────────────────┤
│                      Common Components                │
│                                                       │
│  • Context efficiency - Fresh start per agent         │
│  • Role specialization - Focused instructions         │
│  • Quality standards - Built-in testing & review      │
│  • Iterative refinement - Improve over time           │
└───────────────────────────────────────────────────────┘
```
>>>>>>> aed4b18 (add diagram to README)

## Why Sub-Agents?

Claude Code's sub-agent system allows you to create specialized agents with focused roles and custom instructions. This approach provides:

- **Context efficiency** - Each agent starts fresh with only relevant context for its specific task
- **Role specialization** - Agents can be optimized for specific development phases (planning, architecture, implementation)
- **Consistent quality** - Predefined agent instructions ensure consistent output format and quality standards
- **Iterative refinement** - You can improve agent instructions over time based on real usage patterns
- **Reduced cognitive load** - Clear handoffs between agents eliminate decision fatigue about what to do next

## Two Approaches

**Product-First** (`prd` → `arch` → `tasker_prd` → `coder`)
For user-facing features. Starts with product requirements, user stories, and success metrics.

**Engineering-First** (`planner` → `arch` → `tasker` → `coder`)
For technical improvements. Starts with EARS-format technical requirements and system specifications.

## Agents

| Agent | Role | Purpose |
|-------|------|---------|
| `prd.md` | Product Manager | Transform ideas into Product Requirements Documents |
| `planner.md` | Requirements Analyst | Create EARS-format technical requirements |
| `arch.md` | Software Architect | Design technical architecture and standards |
| `tasker.md` | Task Generator | Break requirements into coding tasks |
| `tasker_prd.md` | Product Task Generator | Break PRDs into user-focused coding tasks |
| `coder.md` | Task Executor | Implement tasks with quality assurance |

## Installation

```bash
git clone <repository-url>
cd claudey
./install.sh
```

Installs agents as symlinks to `~/.claude/agents/` - updates to this repo automatically apply.

## Usage

### Product-First Workflow
```
Use the prd agent to create a PRD for [feature idea]
Use the tasker_prd agent to break this into implementation tasks
Use the coder agent to implement the first task
```

### Engineering-First Workflow
```
Use the planner agent to create requirements for [technical concept]
Use the tasker agent to break this into implementation tasks
Use the coder agent to implement the first task
```

## Benefits

- **Reduced context length** - Each agent focuses on specific tasks
- **Higher success rates** - Specialized agents with clear responsibilities
- **Better quality** - Structured workflows with built-in testing and review
- **Flexible approach** - Choose product-first or engineering-first based on your needs

---

*This repository represents evolving best practices for Claude Code development workflows.*
