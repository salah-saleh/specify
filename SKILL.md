---
name: specify
version: 1.0.0
description: |
  Spec-driven development — entry point. Routes to the right specify-* subskill
  based on what you say. Use for any spec/plan/tasks work. Say "specify init",
  "write a spec for X", "create a plan", "generate tasks", "clarify the spec", etc.
  Proactively suggest when the user is about to implement a non-trivial feature
  without a written spec or plan.
allowed-tools:
  - Bash
  - AskUserQuestion
---

# /specify — Spec-Driven Development

This is the entry point. Based on what you asked, invoke the right subskill:

| What you said | Skill to invoke |
|---------------|----------------|
| "specify init" | `/specify-init` |
| "write a spec for X" / "specify X" | `/specify-spec` |
| "write a plan" / "specify plan" | `/specify-plan` |
| "generate tasks" / "specify tasks" | `/specify-tasks` |
| "implement" / "execute the plan" | `/specify-implement` |
| "clarify the spec" | `/specify-clarify` |
| "analyze" / "check consistency" | `/specify-analyze` |
| "create a checklist" | `/specify-checklist` |
| "update constitution" | `/specify-constitution` |
| "tasks to issues" | `/specify-taskstoissues` |
| "specify status" | `/specify-status` |
| "upgrade specify" | `/specify-upgrade` |

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

## If no subskill is clear from ARGUMENTS

Run `/specify-status` to show what exists, then ask what the user wants to do.
