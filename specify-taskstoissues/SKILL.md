---
name: specify-taskstoissues
version: 1.0.0
description: |
  Convert uncompleted tasks in tasks.md to GitHub issues via the gh CLI.
  One issue per task, with phase label and spec context. Use when asked to
  "create github issues", "tasks to issues", or "specify taskstoissues".
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
---

# /specify-taskstoissues

Convert tasks.md into GitHub issues.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `TASKS_EXISTS` is `no`: "No tasks found. Run `/specify-tasks` first." Stop.

---

## Step 1: Check gh CLI

```bash
gh --version 2>/dev/null && echo "GH_AVAILABLE" || echo "GH_MISSING"
```

If `GH_MISSING`: "GitHub CLI (`gh`) is required. Install with: `brew install gh`" Stop.

## Step 2: Read tasks

Read `$_SPEC_DIR/tasks.md`. Count uncompleted tasks (`- [ ]`).

Also read `$_SPEC_DIR/spec.md` for user story context to include in issue bodies.

## Step 3: Confirm

Show the user:
- Total uncompleted tasks: N
- Phases they span

Ask: "Create {N} GitHub issues? Each task becomes one issue with its phase as a label. (yes / no)"

## Step 4: Create issues

For each uncompleted task:
- **Title:** task description (strip `[P]`, `[USN]` markers)
- **Body:** include the user story it belongs to + relevant acceptance criteria from spec.md
- **Labels:** phase label (e.g. `phase-1-setup`, `phase-3-us1`) — create label if it doesn't exist

```bash
gh issue create \
  --title "[task title]" \
  --body "[context from spec]" \
  --label "[phase-label]"
```

## Step 5: Done

Tell the user: "Created {N} GitHub issues. View them: `gh issue list`"
