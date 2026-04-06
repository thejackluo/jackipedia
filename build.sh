#!/usr/bin/env python3
"""Jackipedia build script — converts markdown to HTML"""

import os
import subprocess
import re

WIKI_DIR = "/home/ubuntu/jackipedia"
OUT_DIR = "/var/www/jackipedia"

TEMPLATE = open(f"{WIKI_DIR}/template.html").read()

def build_page(md_file):
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
    content = re.sub(r'\[\[([^\]]+)\]\]', lambda m: f'<a href="/{m.group(1)}.html">{m.group(1).split("/")[-1]}</a>', content)

    # Get title
    with open(md_file) as f:
        first_line = f.readline().strip()
    title = first_line.lstrip("# ") if first_line.startswith("#") else os.path.basename(md_file).replace(".md", "")

    html = TEMPLATE.replace("CONTENT_PLACEHOLDER", content)
    html = html.replace("<title>Jackipedia</title>", f"<title>{title} — Jackipedia</title>")

    with open(out_file, "w") as f:
        f.write(html)

    print(f"  ✓ {rel_path}")

# Build all markdown files
skip = {"AGENTS.md", "template.html"}
for root, dirs, files in os.walk(WIKI_DIR):
    dirs[:] = [d for d in dirs if d not in {".git"}]
    for fname in files:
        if fname.endswith(".md") and fname not in skip:
            build_page(os.path.join(root, fname))

print(f"\nDone. Deployed to {OUT_DIR}")
