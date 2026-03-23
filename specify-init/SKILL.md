---
name: specify-init
version: 1.0.0
description: |
  Initialize spec-driven development in any repo. Creates the .specify/ scaffold
  (memory/constitution.md, templates/) and optionally defines project principles.
  Run once per project. Use when asked to "specify init" or starting spec-driven work
  in a repo that has no .specify/ directory yet.
allowed-tools:
  - Bash
  - Read
  - Write
  - AskUserQuestion
---

# /specify-init

Bootstrap spec-driven development in the current repo.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `UPDATE` line contains `JUST_UPGRADED <old> <new>`: tell the user "Running specify v{new} (just updated from v{old})."
If `UPDATE` line contains `UPGRADE_AVAILABLE <old> <new>`: tell the user "spec-kit **v{new}** available (tracking v{old}). Run `/specify-upgrade` to update."

---

## Step 1: Check existing

If `SPECIFY_EXISTS` is `yes`: ask "`.specify/` already exists. Re-initialize? This won't overwrite existing specs or constitution."
If they say no: stop.

## Step 2: Create scaffold

```bash
mkdir -p "$_SPECIFY_DIR/memory"
mkdir -p "$_SPECIFY_DIR/templates"
```

Write `$_SPECIFY_DIR/init-options.json` (overwrite):
```json
{
  "ai": "claude",
  "speckit_version": "<contents of ~/.claude/skills/specify/VERSION>",
  "created_at": "<ISO timestamp>"
}
```

## Step 3: Write templates (only if not present)

Write the following files to `$_SPECIFY_DIR/templates/` — skip any that already exist:
- `spec-template.md` — from the **Upstream Template: spec** section below
- `plan-template.md` — from the **Upstream Template: plan** section below
- `tasks-template.md` — from the **Upstream Template: tasks** section below
- `constitution-template.md` — from the **Upstream Template: constitution** section below
- `checklist-template.md` — from the **Upstream Template: checklist** section below

## Step 4: Constitution

If `$_SPECIFY_DIR/memory/constitution.md` already exists: skip this step.

Ask the user:
> "What are 2-3 core principles for this project? (e.g. 'test-first', 'library-first', 'API stability', 'offline-capable') — or press Enter to use a blank template."

If they provide principles: generate a filled-in constitution using the constitution template below.
If they skip: write the blank constitution template as-is.

Write to `$_SPECIFY_DIR/memory/constitution.md`.

## Step 5: Done

Tell the user: "`.specify/` ready. Run `/specify-spec [feature description]` to write your first spec."

---

## Upstream Template: spec

```markdown
# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Created**: [DATE]
**Status**: Draft
**Input**: User description: "$ARGUMENTS"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:
1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:
1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### Edge Cases

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST [specific capability]
- **FR-002**: System MUST [specific capability]

### Key Entities

- **[Entity]**: [what it represents, key attributes]

## Success Criteria

- **SC-001**: [measurable outcome]
- **SC-002**: [measurable outcome]
```

## Upstream Template: plan

```markdown
# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

## Summary

[Primary requirement + chosen technical approach in 2-3 sentences]

## Technical Context

**Language/Version**: [e.g., Python 3.12]
**Primary Dependencies**: [e.g., FastAPI, SQLAlchemy]
**Storage**: [if applicable]
**Testing**: [e.g., pytest]
**Target Platform**: [e.g., Linux server, iOS 15+]
**Project Type**: [e.g., web-service/mobile-app/cli/library]
**Performance Goals**: [domain-specific or N/A]
**Constraints**: [domain-specific or N/A]

## Constitution Check

[Does this violate any project principles? If yes, justify.]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md
├── research.md
├── data-model.md
└── tasks.md
```

### Source Code

```text
[concrete file tree — no option labels, real paths only]
```

**Structure Decision**: [why this layout]

## Key Decisions

- [decision and rationale]

## Risks / Unknowns

- [risk]
```

## Upstream Template: tasks

```markdown
# Tasks: [FEATURE NAME]

**Spec**: specs/[branch]/spec.md | **Plan**: specs/[branch]/plan.md

## Format: `[ID] [P?] [Story] Description`
- **[P]**: Can run in parallel
- **[Story]**: Which user story (US1, US2, US3...)
- Include exact file paths

## Phase 1: Setup

- [ ] T001 Create project structure per plan
- [ ] T002 [P] Initialize dependencies

---

## Phase 2: Foundation ⚠️ Blocks all stories

- [ ] T010 [foundational task with file path]
- [ ] T011 [P] [parallelizable foundational task]

**Checkpoint**: Foundation ready — stories can begin in parallel.

---

## Phase 3: User Story 1 — [Title] (P1) 🎯 MVP

**Goal**: [what this story delivers]
**Independent Test**: [how to verify on its own]

- [ ] T020 [P] [US1] [task — src/path/to/file.py]
- [ ] T021 [US1] [task — src/path/to/file.py]

**Checkpoint**: US1 independently functional and tested.

---

## Phase 4: User Story 2 — [Title] (P2)

- [ ] T030 [P] [US2] [task]

**Checkpoint**: US2 independently functional and tested.

---

## Phase N: Polish

- [ ] TXXX [P] Documentation
- [ ] TXXX Code cleanup
```

## Upstream Template: constitution

```markdown
# [PROJECT_NAME] Constitution

## Core Principles

### [PRINCIPLE_1_NAME]
[PRINCIPLE_1_DESCRIPTION]

### [PRINCIPLE_2_NAME]
[PRINCIPLE_2_DESCRIPTION]

### [PRINCIPLE_3_NAME]
[PRINCIPLE_3_DESCRIPTION]

## Governance

Constitution supersedes all other practices. All plans must be checked against
these principles before implementation begins.

**Version**: 1.0 | **Ratified**: [DATE] | **Last Amended**: [DATE]
```

## Upstream Template: checklist

```markdown
# [CHECKLIST TYPE] Checklist: [FEATURE NAME]

**Purpose**: [Brief description of what this checklist covers]
**Created**: [DATE]
**Feature**: specs/[branch]/spec.md

## [Category 1]

- [ ] CHK001 [specific item referencing the feature]
- [ ] CHK002 [specific item]

## [Category 2]

- [ ] CHK003 [specific item]
- [ ] CHK004 [specific item]

## Notes

- Check items off as completed: `[x]`
- Add findings inline
- Items are numbered sequentially for easy reference
```
