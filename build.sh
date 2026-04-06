#!/usr/bin/env python3
"""
Jackipedia build script — converts markdown to HTML with Wikipedia-style history
"""

import os
import subprocess
import re
import json
from datetime import datetime, timezone

WIKI_DIR = "/home/ubuntu/jackipedia"
OUT_DIR = "/var/www/jackipedia"
HISTORY_DIR = f"{WIKI_DIR}/meta/history"

os.makedirs(HISTORY_DIR, exist_ok=True)
os.makedirs(OUT_DIR, exist_ok=True)

TEMPLATE = open(f"{WIKI_DIR}/template.html").read()


def get_git_log(md_file):
    """Get full git history for a file."""
    rel = os.path.relpath(md_file, WIKI_DIR)
    result = subprocess.run(
        ["git", "log", "--follow", "--format=%H|%ai|%s", "--", rel],
        capture_output=True, text=True, cwd=WIKI_DIR
    )
    entries = []
    for line in result.stdout.strip().splitlines():
        if not line.strip():
            continue
        parts = line.split("|", 2)
        if len(parts) == 3:
            commit, date, msg = parts
            entries.append({"commit": commit[:8], "date": date[:19].replace("T", " "), "summary": msg})
    return entries


def get_sidebar_nav():
    """Build dynamic sidebar nav from existing wiki files."""
    sections = {
        "people": [],
        "philosophy": [],
        "goals": [],
        "concepts": [],
    }
    for section in sections:
        path = f"{WIKI_DIR}/wiki/{section}"
        if os.path.exists(path):
            for f in sorted(os.listdir(path)):
                if f.endswith(".md"):
                    name = f.replace(".md", "").replace("-", " ").title()
                    href = f"/wiki/{section}/{f.replace('.md', '.html')}"
                    sections[section].append((name, href))

    nav = ""
    labels = {"people": "People", "philosophy": "Philosophy", "goals": "Goals", "concepts": "Concepts"}
    special = [("Main page", "/index.html"), ("Recent changes", "/log.html"), ("History", "/meta/history.html")]
    nav += "<h3>Navigation</h3>"
    for label, href in special:
        nav += f'<a href="{href}">{label}</a>'

    for key, label in labels.items():
        if sections[key]:
            nav += f"<h3>{label}</h3>"
            for name, href in sections[key]:
                nav += f'<a href="{href}">{name}</a>'
    return nav


def build_history_page(all_history):
    """Build a global history/recent changes page."""
    # Flatten and sort all edits
    all_edits = []
    for page, edits in all_history.items():
        for e in edits:
            all_edits.append({**e, "page": page})
    all_edits.sort(key=lambda x: x["date"], reverse=True)

    rows = ""
    for e in all_edits[:200]:
        page_name = e["page"].replace("/", " / ").replace("-", " ").title()
        page_href = f"/{e['page']}.html"
        rows += f"""
        <tr>
          <td>{e['date']}</td>
          <td><a href="{page_href}">{page_name}</a></td>
          <td><code>{e['commit']}</code></td>
          <td>{e['summary']}</td>
        </tr>"""

    content = f"""
<h1>Recent changes</h1>
<p class="page-meta">All edits to Jackipedia, most recent first. Powered by git history.</p>
<table>
  <tr><th>Date</th><th>Page</th><th>Commit</th><th>Summary</th></tr>
  {rows}
</table>"""
    return content


def build_page_history(page_rel, history):
    """Build per-page history sidebar content."""
    if not history:
        return ""
    rows = ""
    for e in history:
        rows += f"<tr><td>{e['date']}</td><td><code>{e['commit']}</code></td><td>{e['summary']}</td></tr>"
    return f"""
<div style="margin-top:32px; border-top:1px solid #a2a9b1; padding-top:12px;">
  <h2>Page history</h2>
  <table><tr><th>Date</th><th>Commit</th><th>Edit summary</th></tr>{rows}</table>
</div>"""


def build_page(md_file, nav, all_history):
    rel_path = os.path.relpath(md_file, WIKI_DIR)
    out_file = os.path.join(OUT_DIR, rel_path.replace(".md", ".html"))
    os.makedirs(os.path.dirname(out_file), exist_ok=True)

    # Convert markdown to HTML
    result = subprocess.run(
        ["pandoc", "--from", "markdown", "--to", "html", "--no-highlight", md_file],
        capture_output=True, text=True
    )
    content = result.stdout

    # Fix wiki-style links [[page]] → <a href>
    content = re.sub(
        r'\[\[([^\]]+)\]\]',
        lambda m: f'<a href="/{m.group(1)}.html">{m.group(1).split("/")[-1].replace("-", " ").title()}</a>',
        content
    )

    # Get title
    with open(md_file) as f:
        first_line = f.readline().strip()
    title = first_line.lstrip("# ") if first_line.startswith("#") else os.path.basename(md_file).replace(".md", "")

    # Get git history for this file
    history = get_git_log(md_file)
    page_key = rel_path.replace(".md", "")
    all_history[page_key] = history

    # Add page history section
    history_html = build_page_history(rel_path, history)
    last_edit = history[0]["date"] if history else "unknown"

    # Build meta line
    meta = f'<div class="page-meta">Last edited: {last_edit} &nbsp;|&nbsp; <a href="/meta/history.html">View all changes</a></div>'

    full_content = meta + content + history_html

    html = TEMPLATE.replace("CONTENT_PLACEHOLDER", full_content)
    html = html.replace('<a href="/index.html">Article</a>', f'<a href="/{rel_path.replace(".md", ".html")}">Article</a>')
    html = html.replace("NAV_PLACEHOLDER", nav)
    html = html.replace("<title>Jackipedia</title>", f"<title>{title} — Jackipedia</title>")

    with open(out_file, "w") as f:
        f.write(html)

    print(f"  ✓ {rel_path}")
    return page_key, history


skip = {"AGENTS.md", "build.sh"}
all_history = {}
nav = get_sidebar_nav()

# Update template to use NAV_PLACEHOLDER
template_content = open(f"{WIKI_DIR}/template.html").read()

for root, dirs, files in os.walk(WIKI_DIR):
    dirs[:] = [d for d in dirs if d not in {".git", "meta"}]
    for fname in files:
        if fname.endswith(".md") and fname not in skip:
            build_page(os.path.join(root, fname), nav, all_history)

# Build global history page
os.makedirs(f"{OUT_DIR}/meta", exist_ok=True)
hist_content = build_history_page(all_history)
hist_html = TEMPLATE.replace("CONTENT_PLACEHOLDER", hist_content)
hist_html = hist_html.replace("NAV_PLACEHOLDER", nav)
hist_html = hist_html.replace("<title>Jackipedia</title>", "<title>Recent changes — Jackipedia</title>")
with open(f"{OUT_DIR}/meta/history.html", "w") as f:
    f.write(hist_html)
print("  ✓ meta/history.html")

# Save history JSON for future use
with open(f"{HISTORY_DIR}/page-history.json", "w") as f:
    json.dump(all_history, f, indent=2)

print(f"\nDone. Deployed to {OUT_DIR}")
