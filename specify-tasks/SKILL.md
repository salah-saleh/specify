---
name: specify-tasks
version: 1.0.0
description: |
  Generate a phased task list from spec and plan. Creates specs/{branch}/tasks.md
  organized by user story, with parallel markers and file paths. Gates on both
  spec.md and plan.md existing. Use when asked to "generate tasks", "create tasks",
  or "specify tasks".
allowed-tools:
  - Bash
  - Read
  - Write
  - AskUserQuestion
---

# /specify-tasks

Generate an implementation task list for the current branch.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `SPEC_EXISTS` is `no`: "No spec found. Run `/specify-spec [description]` first." Stop.
If `PLAN_EXISTS` is `no`: "No plan found. Run `/specify-plan` first." Stop.

---

## Step 1: Determine file paths

**If `SPEC_STYLE` is `flat`:**
- Spec file: `$_FLAT_SPEC_FILE`
- Plan file: `$_SPEC_DIR/$_SPEC_BASE-plan.md`
- Research file: `$_SPEC_DIR/$_SPEC_BASE-research.md` (if present)
- Tasks file: `$_SPEC_DIR/$_SPEC_BASE-tasks.md`

**If `SPEC_STYLE` is `branch`:**
- Tasks file: `$_SPEC_DIR/tasks.md`

## Step 2: Read all docs

Read the spec, plan, and research files (paths from Step 1).

## Step 3: Generate tasks

Rules:
- **One phase per user story** (P1 → P2 → P3), preceded by Setup and Foundation phases
- **Every task has a concrete file path** — "create X in `src/models/y.py`" not "create model"
- **Mark `[P]`** on tasks that can run in parallel (different files, no shared dependencies)
- **Mark `[USN]`** on each task to show which user story it belongs to
- **Foundation phase** blocks all stories — must complete first
- **Each story phase ends with a checkpoint**
- Tests are included only if the spec or plan explicitly requests them

Write to the tasks file (path from Step 1).

## Step 4: Present

Show tasks grouped by phase. Tell the user the path the tasks were written to, and:
> "Start Phase 1 (Setup) → Phase 2 (Foundation) → then stories in priority order. Run `/specify-implement` to begin executing."
