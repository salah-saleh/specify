---
name: specify-checklist
version: 1.0.0
description: |
  Generate a feature-specific checklist from spec and plan context. Writes
  specs/{branch}/checklist-{type}.md. Items are tailored to the actual feature,
  not generic. Use when asked to "create a checklist", "generate a QA checklist",
  "deployment checklist", or "specify checklist [type]".
allowed-tools:
  - Bash
  - Read
  - Write
  - AskUserQuestion
---

# /specify-checklist

Generate a checklist tailored to the current feature.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `SPEC_EXISTS` is `no`: "No spec found. Run `/specify-spec [description]` first." Stop.

---

## Step 1: Determine type

If ARGUMENTS includes a type hint (e.g. "qa", "security", "deployment", "code-review", "pre-launch"): use it.
Otherwise ask: "What kind of checklist? (e.g. QA, security review, deployment, code review, pre-launch)"

## Step 2: Read context

Read `$_SPEC_DIR/spec.md` and `$_SPEC_DIR/plan.md` (if present).

## Step 3: Generate checklist

Create items tailored to **this specific feature** — reference actual components, flows, and edge cases from the spec. Not a generic template.

Examples by type:
- **QA**: test each acceptance scenario, edge cases from the spec, error states
- **Security**: auth boundaries, input validation, data exposure, API permissions
- **Deployment**: env vars needed, migrations, feature flags, rollback plan
- **Code review**: constitution compliance, test coverage, file paths match plan, no placeholders
- **Pre-launch**: all P1 stories verified, docs updated, monitoring in place

Use CHK001, CHK002... numbering. No sample/placeholder items.

## Step 4: Write

Write to `$_SPEC_DIR/checklist-{type}.md`.

Tell the user: "Checklist written to `specs/$_BRANCH/checklist-{type}.md` — {N} items."
