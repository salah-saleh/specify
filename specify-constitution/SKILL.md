---
name: specify-constitution
version: 1.0.0
description: |
  Create or update the project constitution — the core principles that all specs
  and plans must respect. Writes .specify/memory/constitution.md. Use when asked
  to "create a constitution", "update project principles", or "specify constitution".
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# /specify-constitution

Create or update the project constitution.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `SPECIFY_EXISTS` is `no`: "No `.specify/` found. Run `/specify-init` first." Stop.

---

## Step 1: Check existing

```bash
[ -f "$_SPECIFY_DIR/memory/constitution.md" ] && echo "EXISTS" || echo "NEW"
```

If EXISTS: read it and show the user a summary of current principles. Ask: "Update it, or start fresh?"

## Step 2: Gather principles

Ask the user:
> "Describe your 3-7 core principles for this project. Give them as a list, or just describe your philosophy and I'll extract the principles.
> Examples: 'test-first', 'library-first', 'no external dependencies', 'API stability', 'offline-capable', 'performance budget under 100ms'."

## Step 3: Write constitution

Generate a well-structured constitution. Each principle must have:
- A name and number (e.g. "I. Test-First")
- What it means in practice
- At least one concrete rule that follows from it

Write to `$_SPECIFY_DIR/memory/constitution.md`.

Tell the user: "Constitution written. All future `/specify-plan` runs will check against these principles."
