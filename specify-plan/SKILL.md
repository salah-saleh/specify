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

## Step 1: Determine companion file paths

**If `SPEC_STYLE` is `flat`:**
- Spec file: `$_FLAT_SPEC_FILE` (e.g. `specs/26-04-03-export-session-pdf.md`)
- Plan file: `$_SPEC_DIR/$_SPEC_BASE-plan.md` (e.g. `specs/26-04-03-export-session-pdf-plan.md`)
- Research file: `$_SPEC_DIR/$_SPEC_BASE-research.md`

**If `SPEC_STYLE` is `branch`:**
- Plan file: `$_SPEC_DIR/plan.md`
- Research file: `$_SPEC_DIR/research.md`

## Step 2: Read all context

Read in parallel:
- The spec file (path from Step 1)
- `$_SPECIFY_DIR/memory/constitution.md` — project principles
- `CLAUDE.md` and `README.md` — tech stack
- Relevant existing source files (models, APIs, services this feature touches)

## Step 3: Research phase

Think through and write to the research file (path from Step 1):
- What already exists that can be reused?
- Minimal data model for this feature
- API contracts / interfaces needed
- Key risks or unknowns

## Step 4: Write the plan

Fill in the plan template. No `[BRACKET]` placeholders left behind. Must include:
- Technical context (language, deps, storage, testing)
- Constitution check — does anything violate project principles? If yes, justify.
- Concrete project structure (real file paths, no "Option A / Option B" labels)
- Key decisions with rationale
- Risks / unknowns

Write to the plan file (path from Step 1).

## Step 5: Present and confirm

Summarize: tech context, project structure, key decisions. Ask:
> "Does this plan look right? (yes / tell me what to change)"

Tell the user the path the plan was written to, and: "Run `/specify-tasks` when ready."
