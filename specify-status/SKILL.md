---
name: specify-status
version: 1.0.0
description: |
  Show the current branch's spec-driven development status — which artifacts exist
  and task completion progress. Use when asked to "specify status", "what's the
  spec status", or "how far along is the spec".
allowed-tools:
  - Bash
  - AskUserQuestion
---

# /specify-status

Show spec-driven development status for the current branch.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

---

## Report

```bash
echo "Branch:  $_BRANCH"
echo "Spec:    $([ -f "$_SPEC_DIR/spec.md" ]   && echo "✓ exists" || echo "✗ missing")"
echo "Plan:    $([ -f "$_SPEC_DIR/plan.md" ]   && echo "✓ exists" || echo "✗ missing")"
echo "Tasks:   $([ -f "$_SPEC_DIR/tasks.md" ]  && echo "✓ exists" || echo "✗ missing")"
if [ -f "$_SPEC_DIR/tasks.md" ]; then
  DONE=$(grep -c '^\- \[x\]' "$_SPEC_DIR/tasks.md" 2>/dev/null || echo 0)
  TOTAL=$(grep -c '^\- \[' "$_SPEC_DIR/tasks.md" 2>/dev/null || echo 0)
  echo "Progress: $DONE / $TOTAL tasks done"
fi
ls "$_SPEC_DIR"/checklist-*.md 2>/dev/null | while read f; do
  echo "Checklist: $(basename "$f")"
done
```

Display the output clearly. Then ask: "What would you like to do next?"

Suggest the next logical step based on what's missing:
- No spec → "Run `/specify-spec [description]` to write the spec"
- Spec but no plan → "Run `/specify-plan` to write the implementation plan"
- Plan but no tasks → "Run `/specify-tasks` to generate the task list"
- Tasks exist → "Run `/specify-implement` to start working through tasks"
