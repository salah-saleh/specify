---
name: specify-clarify
version: 1.0.0
description: |
  Ask targeted questions to fill gaps in the current spec, then encode answers
  directly into spec.md. Up to 5 questions, one at a time. Never adds a Q&A section —
  integrates answers into existing prose. Use when asked to "clarify the spec",
  "ask questions about the spec", or "improve the spec".
allowed-tools:
  - Bash
  - Read
  - Edit
  - AskUserQuestion
---

# /specify-clarify

Identify and fill gaps in the current feature spec.

## Preamble

```bash
source "$HOME/.claude/skills/specify/bin/preamble.sh"
```

If `SPEC_EXISTS` is `no`: "No spec found for branch `$_BRANCH`. Run `/specify-spec [description]` first." Stop.

---

## Step 1: Read and analyze the spec

Read `$_SPEC_DIR/spec.md` deeply. Find:
- Ambiguous requirements (could mean more than one thing)
- Missing acceptance criteria (user story has no Given/When/Then)
- Unclear edge cases
- Undefined entities or behaviors
- Inconsistent or missing success criteria
- Anything that would force an implementation assumption

## Step 2: Ask targeted questions

Formulate up to 5 questions. Each must:
- Point to a specific part of the spec ("In User Story 2, when a user cancels...")
- Have a clear answer that directly improves the spec
- Not be answerable by reading the existing spec
- Not be a yes/no unless the answer changes behavior meaningfully

Ask **one at a time** via AskUserQuestion. After each answer, update the spec before asking the next.

## Step 3: Update spec in place

For each answer, edit the relevant section of `$_SPEC_DIR/spec.md` to encode it naturally:
- Add/update acceptance scenarios
- Fill in missing edge cases
- Clarify requirement wording
- Never add a "Clarifications" or "Q&A" section — weave answers into the existing structure

## Step 4: Done

After all questions: "Spec updated with your clarifications. Run `/specify-plan` when ready."
