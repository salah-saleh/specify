---
name: specify-upgrade
version: 1.0.0
description: |
  Upgrade the /specify skill to match the latest spec-kit release from github/spec-kit.
  Fetches new templates, rewrites embedded content in all specify-* SKILL.md files.
  Use when asked to "upgrade specify", "update specify", or when UPGRADE_AVAILABLE is shown.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# /specify-upgrade

Upgrade the `/specify` skill suite to match the latest spec-kit release.

## What this does

spec-kit releases new template versions at `github/spec-kit`. This skill:
1. Fetches the latest release tag and changelog from GitHub
2. Downloads the new templates (spec, plan, tasks, constitution, checklist)
3. Rewrites the embedded templates in the relevant `specify-*` SKILL.md files
4. Updates `VERSION` to match the new spec-kit release
5. Writes a `~/.gstack/specify-just-upgraded-from` marker so the next preamble shows `JUST_UPGRADED`

## Step 1: Check current state

```bash
_SKILL_DIR="$HOME/.claude/skills/specify"
_LOCAL=$(cat "$_SKILL_DIR/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown")
_UPD=$("$_SKILL_DIR/bin/specify-update-check" --force 2>/dev/null || true)
echo "LOCAL: $_LOCAL"
echo "UPDATE_CHECK: $_UPD"
```

If `UPDATE_CHECK` is empty or `UP_TO_DATE`: tell the user "Already on the latest spec-kit release (v$_LOCAL). Nothing to do."

## Step 2: Ask confirmation

Use AskUserQuestion:
- Show: "spec-kit **v{new}** is available (currently tracking v{old}). This will update the embedded templates in all `/specify-*` skills to match the new spec-kit release. Proceed?"
- Options: A) Yes, upgrade  B) Not now

If B: write snooze state and exit.
```bash
echo "{new} 1 $(date +%s)" > ~/.gstack/specify-update-snoozed
```

## Step 3: Fetch release info

```bash
# Get changelog for the release
curl -sf --max-time 10 \
  "https://api.github.com/repos/github/spec-kit/releases/latest" \
  | python3 -c "
import sys, json
d = json.load(sys.stdin)
print('TAG:', d.get('tag_name',''))
print('BODY:', d.get('body','')[:800])
"
```

Show the user the changelog highlights before proceeding.

## Step 4: Fetch new templates

Fetch each template from the new release tag using raw GitHub URLs:

```bash
_TAG="{new}"  # substitute actual tag e.g. v0.3.2
_BASE="https://raw.githubusercontent.com/github/spec-kit/${_TAG}/templates"

curl -sf "$_BASE/spec-template.md"
curl -sf "$_BASE/plan-template.md"
curl -sf "$_BASE/tasks-template.md"
curl -sf "$_BASE/constitution-template.md"
curl -sf "$_BASE/checklist-template.md"
```

If any fetch fails, abort: "Failed to fetch templates for v{new}. The release may not have published template files yet. Try again later."

## Step 5: Update skill files

For each template fetched, update the `## Templates` section of the relevant skill file:

- `spec-template.md` → embedded in `~/.claude/skills/specify-spec/SKILL.md`
- `plan-template.md` → embedded in `~/.claude/skills/specify-plan/SKILL.md`
- `tasks-template.md` → embedded in `~/.claude/skills/specify-tasks/SKILL.md`
- `constitution-template.md` → embedded in `~/.claude/skills/specify-constitution/SKILL.md`
- `checklist-template.md` → embedded in `~/.claude/skills/specify-checklist/SKILL.md`

For each: find the fenced code block under `## Upstream Template` and replace its contents with the newly fetched template.

## Step 6: Update VERSION and write marker

```bash
echo "{new}" > "$HOME/.claude/skills/specify/VERSION"
echo "{old}" > "$HOME/.gstack/specify-just-upgraded-from"
```

## Step 7: Publish to the distribution repo

```bash
_DIST_REPO="$HOME/.claude/skills/specify-skills"
```

Check if the distribution repo exists:
```bash
[ -d "$_DIST_REPO/.git" ] && echo "DIST_REPO_EXISTS" || echo "DIST_REPO_MISSING"
```

If `DIST_REPO_MISSING`: tell the user "Local upgrade done. Distribution repo not found at `~/.claude/skills/specify-skills` — skipping publish. To set it up: `git clone git@github.com:salah-saleh/specify.git ~/.claude/skills/specify-skills`"

If `DIST_REPO_EXISTS`:

1. Sync the updated skill directories into the repo:
```bash
for skill_dir in "$HOME/.claude/skills/specify"*/; do
  skill_name="$(basename "$skill_dir")"
  # skip specify-skills itself to avoid recursion
  [ "$skill_name" = "specify-skills" ] && continue
  cp -r "$skill_dir" "$_DIST_REPO/"
done
# also sync root VERSION
cp "$HOME/.claude/skills/specify/VERSION" "$_DIST_REPO/VERSION"
```

2. Commit and push:
```bash
cd "$_DIST_REPO"
git add -A
git diff --cached --stat
git -c commit.gpgsign=false commit -m "Upgrade to spec-kit v{new}"
git push origin main
```

If the push succeeds: tell the user "Published to `salah-saleh/specify` — colleagues will get v{new} on their next `git pull`."
If it fails: tell the user what the git error was and suggest they run `cd ~/.claude/skills/specify-skills && git push` manually.

Tell the user: "Upgraded `/specify` skill suite to spec-kit v{new}. Templates updated. Changes take effect in the next session."

Show the changelog highlights again as a reminder of what changed.
