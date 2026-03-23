---
name: specify-spec
version: 1.0.0
description: |
  Write or update a feature specification. Creates specs/{branch}/spec.md from
  a natural-language description. Reads the project constitution and existing code
  for context. Use when asked to "write a spec", "specify this feature", or
  "create a spec for [description]".
  Proactively suggest when the user describes a feature without a written spec.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
---

# /specify-spec

Write a feature specification for the current branch.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

Handle `UPDATE` line same as specify-init.

If `SPECIFY_EXISTS` is `no`: tell the user "No `.specify/` found. Run `/specify-init` first to set up the project." Then stop.

---

## Step 1: Determine spec directory

```bash
mkdir -p "$_SPEC_DIR"
```

If `SPEC_EXISTS` is `yes`: ask "A spec already exists for branch `$_BRANCH`. Overwrite it, or update it?"

## Step 2: Gather context

Read in parallel:
- `$_SPECIFY_DIR/memory/constitution.md` — project principles
- `README.md` (repo root, if present)
- `CLAUDE.md` (repo root, if present) — tech stack
- Any existing `specs/*/spec.md` files — understand the pattern in this project
- Relevant source files touched by this feature

## Step 3: Write the spec

Use the description from ARGUMENTS plus all gathered context. Fill in every `[BRACKET]` with real content. No placeholders left behind.

The spec must have:
- At least one P1 user story with acceptance scenarios in Given/When/Then format
- Functional requirements (FR-001+)
- Edge cases
- Success criteria

Write to `$_SPEC_DIR/spec.md`.

## Step 4: Present and confirm

Show a summary: user stories + key requirements. Ask:
> "Does this capture what you want? (yes / tell me what to change)"

Iterate until approved. Tell the user: "Spec written to `specs/$_BRANCH/spec.md`. Run `/specify-plan` when ready."
