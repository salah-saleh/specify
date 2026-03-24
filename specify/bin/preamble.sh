#!/usr/bin/env bash
# Shared preamble for all specify-* skills.
# Source this at the top of each skill's preamble block.
_SKILL_DIR="$HOME/.claude/skills/specify"
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
_SPECIFY_DIR="$_REPO_ROOT/.specify"

# Detect flat file convention: specs/NN-name.md (no branch subdir)
# A project uses flat files if specs/ exists but specs/{branch}/ does not,
# and there are numbered spec files in specs/ directly.
_BRANCH_SPEC_DIR="$_REPO_ROOT/specs/$_BRANCH"
_FLAT_SPEC=$(ls "$_REPO_ROOT/specs"/[0-9]*.md 2>/dev/null | head -1)

if [ -d "$_BRANCH_SPEC_DIR" ]; then
  # Branch-based layout (standard)
  _SPEC_STYLE="branch"
  _SPEC_DIR="$_BRANCH_SPEC_DIR"
elif [ -n "$_FLAT_SPEC" ]; then
  # Flat numbered layout: find the latest spec file
  _SPEC_STYLE="flat"
  _LATEST_SPEC=$(ls "$_REPO_ROOT/specs"/[0-9]*.md 2>/dev/null | grep -v '\-plan\|\-tasks\|\-research' | tail -1)
  _SPEC_DIR="$_REPO_ROOT/specs"
  _FLAT_SPEC_FILE="$_LATEST_SPEC"
  # Derive companion file paths from the latest spec filename base
  _SPEC_BASE=$(basename "${_LATEST_SPEC%.md}")
  echo "SPEC_STYLE: flat"
  echo "FLAT_SPEC_FILE: $_FLAT_SPEC_FILE"
else
  # No specs yet — default to branch layout
  _SPEC_STYLE="branch"
  _SPEC_DIR="$_BRANCH_SPEC_DIR"
fi

echo "BRANCH: $_BRANCH"
echo "REPO_ROOT: $_REPO_ROOT"
echo "SPEC_STYLE: ${_SPEC_STYLE:-branch}"
echo "SPECIFY_EXISTS: $([ -d "$_SPECIFY_DIR" ] && echo yes || echo no)"

if [ "$_SPEC_STYLE" = "flat" ]; then
  echo "SPEC_EXISTS: $([ -n "$_LATEST_SPEC" ] && echo yes || echo no)"
  echo "PLAN_EXISTS: $([ -f "$_REPO_ROOT/specs/${_SPEC_BASE}-plan.md" ] && echo yes || echo no)"
  echo "TASKS_EXISTS: $([ -f "$_REPO_ROOT/specs/${_SPEC_BASE}-tasks.md" ] && echo yes || echo no)"
else
  echo "SPEC_EXISTS: $([ -f "$_SPEC_DIR/spec.md" ] && echo yes || echo no)"
  echo "PLAN_EXISTS: $([ -f "$_SPEC_DIR/plan.md" ] && echo yes || echo no)"
  echo "TASKS_EXISTS: $([ -f "$_SPEC_DIR/tasks.md" ] && echo yes || echo no)"
fi
