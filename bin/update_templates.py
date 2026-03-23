#!/usr/bin/env python3
"""Replace ## Upstream Template sections in specify-init/SKILL.md."""
import sys, re, pathlib

skill_file = pathlib.Path(sys.argv[1])
templates_dir = pathlib.Path(sys.argv[2])

template_map = {
    "spec":         "spec-template.md",
    "plan":         "plan-template.md",
    "tasks":        "tasks-template.md",
    "constitution": "constitution-template.md",
    "checklist":    "checklist-template.md",
}

content = skill_file.read_text()

for section_name, filename in template_map.items():
    new_body = (templates_dir / filename).read_text().rstrip("\n")
    pattern = (
        r'(## Upstream Template: ' + re.escape(section_name) + r'\n\n```markdown\n)'
        r'.*?'
        r'(```)'
    )
    replacement = r'\g<1>' + new_body.replace('\\', '\\\\') + r'\n\g<2>'
    new_content, count = re.subn(pattern, replacement, content, flags=re.DOTALL)
    if count == 0:
        print(f"WARNING: section '## Upstream Template: {section_name}' not found — skipped")
    else:
        print(f"  updated: {section_name}")
        content = new_content

skill_file.write_text(content)
