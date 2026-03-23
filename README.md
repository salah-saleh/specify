# specify

Spec-driven development skills for [Claude Code](https://claude.ai/claude-code), adapted from [github/spec-kit](https://github.com/github/spec-kit).

Write a spec → generate a plan → create tasks → implement — all without leaving your editor.

---

## Skills

| Skill | Description |
|-------|-------------|
| `/specify` | Entry point — routes to the right subskill based on what you say |
| `/specify-init` | Initialize `.specify/` scaffold in a repo (run once per project) |
| `/specify-spec` | Write or update a feature specification |
| `/specify-plan` | Write an implementation plan from the spec |
| `/specify-tasks` | Generate a phased task list from spec and plan |
| `/specify-implement` | Execute the task list phase by phase |
| `/specify-clarify` | Ask targeted questions to fill gaps in the spec |
| `/specify-analyze` | Read-only consistency check across spec, plan, and tasks |
| `/specify-checklist` | Generate a feature-specific QA/deployment/review checklist |
| `/specify-constitution` | Create or update the project's core principles |
| `/specify-taskstoissues` | Convert uncompleted tasks to GitHub issues via `gh` CLI |
| `/specify-status` | Show which artifacts exist and task completion progress |
| `/specify-upgrade` | Upgrade embedded templates to match the latest spec-kit release |

---

## Install

```bash
git clone git@github.com:salah-saleh/specify.git ~/.claude/skills/specify-skills
cd ~/.claude/skills/specify-skills && ./setup
```

Restart Claude Code, then run `/specify` in any project.

## Update

```bash
cd ~/.claude/skills/specify-skills && git pull
```

Because the install uses symlinks, a `git pull` is all you need — no re-running `setup`.

---

## Workflow

### First time in a repo

```
/specify-init          # scaffold .specify/ with constitution + templates
/specify-spec [desc]   # write the feature spec
/specify-plan          # write the implementation plan
/specify-tasks         # generate the phased task list
/specify-implement     # work through tasks one phase at a time
```

### Quick entry point

```
/specify               # describe what you want and it routes automatically
```

---

## How it works

Each skill is a Markdown file (`SKILL.md`) that Claude Code loads as a prompt. The `/specify` entry skill routes to the right subskill. The preamble script (`specify/bin/preamble.sh`) runs on every invocation to detect the current branch, locate spec artifacts, and check for upstream template updates.

Spec artifacts live in `specs/{branch}/` inside your repo:

```
specs/
└── 123-my-feature/
    ├── spec.md
    ├── plan.md
    ├── research.md
    ├── tasks.md
    └── checklist-qa.md
```

---

## Tracking upstream

This repo tracks [github/spec-kit](https://github.com/github/spec-kit) templates. The current version is in `VERSION`. Run `/specify-upgrade` inside Claude Code to pull the latest templates when a new spec-kit release is available.

---

## Credits

Templates and workflow adapted from [github/spec-kit](https://github.com/github/spec-kit).
