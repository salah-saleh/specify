---
name: specify-plan
version: 1.0.0
description: |
  Write an implementation plan for the current feature. Creates specs/{branch}/plan.md
  and research.md. Reads the spec, constitution, and existing codebase. Gates on spec
  existing first. Use when asked to "plan this", "write a plan", or "specify plan".
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - AskUserQuestion
---

# /specify-plan

Write an implementation plan for the current branch.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

Handle `UPDATE` line same as specify-init.

If `SPEC_EXISTS` is `no`: "No spec found for branch `$_BRANCH`. Run `/specify-spec [description]` first." Stop.

---

## Step 1: Read all context

Read in parallel:
- `$_SPEC_DIR/spec.md` — the feature spec
- `$_SPECIFY_DIR/memory/constitution.md` — project principles
- `CLAUDE.md` and `README.md` — tech stack
- Relevant existing source files (models, APIs, services this feature touches)

## Step 2: Research phase

Think through and write `$_SPEC_DIR/research.md`:
- What already exists that can be reused?
- Minimal data model for this feature
- API contracts / interfaces needed
- Key risks or unknowns

## Step 3: Write the plan

Fill in the plan template. No `[BRACKET]` placeholders left behind. Must include:
- Technical context (language, deps, storage, testing)
- Constitution check — does anything violate project principles? If yes, justify.
- Concrete project structure (real file paths, no "Option A / Option B" labels)
- Key decisions with rationale
- Risks / unknowns

Write to `$_SPEC_DIR/plan.md`.

## Step 4: Present and confirm

Summarize: tech context, project structure, key decisions. Ask:
> "Does this plan look right? (yes / tell me what to change)"

Tell the user: "Plan written to `specs/$_BRANCH/plan.md`. Run `/specify-tasks` when ready."
