---
name: specify-analyze
version: 1.0.0
description: |
  Read-only cross-artifact consistency check. Compares spec, plan, and tasks for
  gaps, contradictions, and constitution violations. Never modifies files — report only.
  Use when asked to "analyze the spec", "check consistency", or "review my artifacts".
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
---

# /specify-analyze

Non-destructive consistency check across all spec artifacts.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

---

## Step 1: Read everything available

Read whatever exists for the current branch: `spec.md`, `plan.md`, `tasks.md`, `research.md`.
Also read `$_SPECIFY_DIR/memory/constitution.md`.

## Step 2: Cross-check

**Spec ↔ Plan:**
- Does the plan address every functional requirement (FR-XXX) from the spec?
- Are there plan decisions that contradict spec requirements?
- Does the plan cover all user stories?

**Plan ↔ Tasks:**
- Does every task map to a component in the plan's project structure?
- Are there plan components with no corresponding tasks?
- Do task file paths match the plan's directory structure?

**Spec ↔ Tasks:**
- Do tasks collectively cover all user story acceptance scenarios?
- Are all P1 story tasks in Phase 3, P2 in Phase 4, etc.?

**Constitution compliance:**
- Do any plan decisions violate principles in the constitution?
- Does the project structure respect any architectural principles?

**Completeness:**
- Any `[BRACKET]` placeholders still present?
- Missing sections (e.g., spec has no edge cases, plan has no risks)?
- Empty acceptance criteria?

**Consistency:**
- Terminology drift (same concept called different names)?
- Version/dependency conflicts between plan and tasks?

## Step 3: Report

```
ANALYSIS REPORT — specs/{branch}/
══════════════════════════════════
Overall: GOOD | NEEDS ATTENTION | ISSUES FOUND

Spec ↔ Plan:
  ✓ ...
  ⚠ ...

Plan ↔ Tasks:
  ✓ ...
  ⚠ ...

Constitution:
  ✓ ...
  ⚠ ...

Issues:
  1. [specific issue — artifact:section]
  2. ...

Recommendations:
  - [action]
══════════════════════════════════
```

**This command never modifies any file.** If issues are found, tell the user which command to run to fix them (e.g., "Run `/specify-clarify` to address the missing acceptance criteria").
