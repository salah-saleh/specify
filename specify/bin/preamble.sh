#!/usr/bin/env bash
# Shared preamble for all specify-* skills.
# Source this at the top of each skill's preamble block.
_SKILL_DIR="$HOME/.claude/skills/specify"
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
_SPECIFY_DIR="$_REPO_ROOT/.specify"
_SPEC_DIR="$_REPO_ROOT/specs/$_BRANCH"

_UPD=$("$_SKILL_DIR/bin/specify-update-check" 2>/dev/null || true)

echo "BRANCH: $_BRANCH"
echo "REPO_ROOT: $_REPO_ROOT"
echo "SPECIFY_EXISTS: $([ -d "$_SPECIFY_DIR" ] && echo yes || echo no)"
echo "SPEC_EXISTS: $([ -f "$_SPEC_DIR/spec.md" ] && echo yes || echo no)"
echo "PLAN_EXISTS: $([ -f "$_SPEC_DIR/plan.md" ] && echo yes || echo no)"
echo "TASKS_EXISTS: $([ -f "$_SPEC_DIR/tasks.md" ] && echo yes || echo no)"
[ -n "$_UPD" ] && echo "UPDATE: $_UPD" || true
