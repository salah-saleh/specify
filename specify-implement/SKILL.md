---
name: specify-implement
version: 1.0.0
description: |
  Execute the implementation plan by working through tasks.md phase by phase.
  Reads spec, plan, and tasks, then implements each uncompleted task, marking
  them done as it goes. Respects parallel markers. Use when asked to "implement",
  "start implementing", "execute the plan", or "work through the tasks".
  Proactively suggest after tasks.md is written.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
---

# /specify-implement

Work through `tasks.md` and implement the feature.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `TASKS_EXISTS` is `no`: "No tasks found. Run `/specify-tasks` first." Stop.

---

## Step 1: Read all context

Read in parallel:
- `$_SPEC_DIR/spec.md` — acceptance criteria and user stories
- `$_SPEC_DIR/plan.md` — technical context, file structure, key decisions
- `$_SPEC_DIR/tasks.md` — the full task list
- `$_SPEC_DIR/research.md` (if present)
- `$_SPECIFY_DIR/memory/constitution.md` — principles to uphold

## Step 2: Identify next phase

Find the first phase with uncompleted tasks (`- [ ]`). Show the user:
> "Starting **Phase N: [name]** — N tasks, M parallelizable."

Ask: "Proceed with this phase? (yes / skip to next phase / stop)"

## Step 3: Execute tasks

For each uncompleted task in the phase:

1. Read the task description carefully — it includes the target file path
2. If `[P]` marked and independent of previous tasks in this phase, it can be done alongside others
3. Implement the task (create/edit the specified file)
4. Mark the task complete in `tasks.md`: change `- [ ]` to `- [x]`
5. Show a brief confirmation: "✓ T0XX — [task description]"

**On error:** If a task fails (file not found, missing dependency, etc.):
- Stop the phase
- Report what failed and why
- Ask: "A) Fix and retry  B) Skip this task  C) Stop"

## Step 4: Phase checkpoint

At each `**Checkpoint**` line, pause and verify:
- The phase goal is met (run any tests mentioned in the plan)
- No regressions introduced

Report: "**Checkpoint passed** — [phase name] complete." or flag issues found.

## Step 5: Continue

After each phase: show progress (`N/M tasks done`) and ask:
> "Phase [N] complete. Continue to Phase [N+1]? (yes / stop here)"

## Step 6: All done

When all tasks are marked `[x]`:
> "All tasks complete. Run `/specify-analyze` to verify consistency, or `/specify-taskstoissues` to create GitHub issues for any remaining work."

## Rules

- **Never skip the constitution check.** If an implementation decision violates a principle, pause and flag it.
- **Minimal changes.** Only touch files mentioned in the task. Don't refactor adjacent code.
- **Mark tasks done immediately** after completing them — don't batch updates.
- **Parallel tasks** (`[P]`) can be written in the same response when they touch different files.
