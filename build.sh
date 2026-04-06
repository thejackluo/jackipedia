#!/usr/bin/env python3
"""
Jackipedia build script — full Wikipedia-style site with custom homepage
"""

import os
import subprocess
import re
import json

WIKI_DIR = "/home/ubuntu/jackipedia"
OUT_DIR = "/var/www/jackipedia"
HISTORY_DIR = f"{WIKI_DIR}/meta/history"

os.makedirs(HISTORY_DIR, exist_ok=True)
os.makedirs(OUT_DIR, exist_ok=True)

BASE_TEMPLATE = open(f"{WIKI_DIR}/template.html").read()


def get_git_log(md_file):
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
    sections = {"people": [], "philosophy": [], "goals": [], "concepts": []}
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
    for key, label in labels.items():
        if sections[key]:
            nav += f'<div class="nav-heading">{label}</div>'
            for name, href in sections[key]:
                nav += f'<a href="{href}">{name}</a>'
    return nav


def build_history_page(all_history):
    all_edits = []
    for page, edits in all_history.items():
        for e in edits:
            all_edits.append({**e, "page": page})
    all_edits.sort(key=lambda x: x["date"], reverse=True)
    rows = ""
    for e in all_edits[:200]:
        page_name = e["page"].replace("/", " / ").replace("-", " ").title()
        page_href = f"/{e['page']}.html"
        rows += f"<tr><td>{e['date']}</td><td><a href='{page_href}'>{page_name}</a></td><td><code>{e['commit']}</code></td><td>{e['summary']}</td></tr>"
    return f"<h1>Recent changes</h1><p class='page-meta'>All edits to Jackipedia, most recent first.</p><table><tr><th>Date</th><th>Page</th><th>Commit</th><th>Summary</th></tr>{rows}</table>"


def build_page_history_html(history):
    if not history:
        return ""
    rows = "".join(f"<tr><td>{e['date']}</td><td><code>{e['commit']}</code></td><td>{e['summary']}</td></tr>" for e in history)
    return f"<div style='margin-top:32px;border-top:1px solid #a2a9b1;padding-top:12px;'><h2>Page history</h2><table><tr><th>Date</th><th>Commit</th><th>Edit summary</th></tr>{rows}</table></div>"


def render_page(title, content, nav, extra_css="", is_main=False):
    tabs = ""
    if not is_main:
        tabs = '<a class="tab active" href="#">Article</a><a class="tab" href="/meta/history.html">History</a>'
    else:
        tabs = '<a class="tab active" href="/index.html">Main page</a><a class="tab" href="/meta/history.html">Recent changes</a>'

    html = BASE_TEMPLATE
    html = html.replace("NAV_PLACEHOLDER", nav)
    html = html.replace("CONTENT_PLACEHOLDER", content)
    html = html.replace("TABS_PLACEHOLDER", tabs)
    html = html.replace("EXTRA_CSS_PLACEHOLDER", extra_css)
    html = html.replace("<title>Jackipedia</title>", f"<title>{title} — Jackipedia</title>")
    return html


def build_page(md_file, nav, all_history):
    rel_path = os.path.relpath(md_file, WIKI_DIR)
    out_file = os.path.join(OUT_DIR, rel_path.replace(".md", ".html"))
    os.makedirs(os.path.dirname(out_file), exist_ok=True)

    result = subprocess.run(
        ["pandoc", "--from", "markdown", "--to", "html", "--no-highlight", md_file],
        capture_output=True, text=True
    )
    content = result.stdout
    content = re.sub(
        r'\[\[([^\]]+)\]\]',
        lambda m: f'<a href="/{m.group(1)}.html">{m.group(1).split("/")[-1].replace("-", " ").title()}</a>',
        content
    )

    with open(md_file) as f:
        first_line = f.readline().strip()
    title = first_line.lstrip("# ") if first_line.startswith("#") else os.path.basename(md_file).replace(".md", "")

    history = get_git_log(md_file)
    page_key = rel_path.replace(".md", "")
    all_history[page_key] = history

    last_edit = history[0]["date"] if history else "unknown"
    meta = f'<div class="page-meta">Last edited: {last_edit} &nbsp;|&nbsp; <a href="/meta/history.html">View all changes</a></div>'
    history_html = build_page_history_html(history)
    full_content = meta + content + history_html

    is_main = (rel_path == "index.md")
    html = render_page(title, full_content, nav, is_main=is_main)
    with open(out_file, "w") as f:
        f.write(html)

    print(f"  ✓ {rel_path}")
    return page_key, history


def build_main_page(nav, all_history):
    """Build the Wikipedia-style two-column main page."""

    # Featured article — Walk in the Park Framework
    featured = """
<div style="border:1px solid #a2a9b1; background:#eaf3fb; padding:12px 16px; margin-bottom:4px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">Featured article</div>
  <b><a href="/wiki/philosophy/walk-in-the-park-framework.html">The Walk in the Park Framework</a></b>
  <p style="margin:8px 0 0;">On February 9, 2025, Jack articulated a four-part personal philosophy during a walk — one of the highest-rated pieces in his five-year writing archive. The framework covers relationships (grow, don't chase), success (vision over money), work (game-like engagement), and wisdom (acceptance, not control). It draws on themes from <a href="/wiki/concepts/reading-list.html">The Courage to Be Disliked</a> and represents the clearest single synthesis of Jack's values.</p>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/wiki/philosophy/walk-in-the-park-framework.html">Read full article...</a></div>
</div>
<div style="font-size:12px; font-family:sans-serif; color:#54595d; margin-bottom:16px;">
  Recently added: <a href="/wiki/concepts/writing-archive.html">Writing Archive</a> &nbsp;·&nbsp; <a href="/wiki/people/meetings-index.html">Meetings Index</a> &nbsp;·&nbsp; <a href="/wiki/concepts/reading-list.html">Reading List</a>
</div>"""

    # Did you know
    dyk = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">Did you know</div>
  <ul style="margin-left:18px; font-size:13.5px;">
    <li>... that Jack has maintained a personal writing practice since 2020, accumulating over <b>360 entries</b> spanning reflections, essays, and startup notes?</li>
    <li>... that Jack's song of the year for 2024 was <i>Steins;Gate</i>'s "Hacking to the Gate"?</li>
    <li>... that Jack conducted over <b>20 customer discovery interviews</b> in a single month in early 2026?</li>
    <li>... that Jack traveled to <b>Japan</b> for two weeks in December 2024, one of his most memorable periods of the year?</li>
    <li>... that Jack rated <i>The Courage to Be Disliked</i> <b>5 stars</b> — his highest rating — alongside a book on AI agents?</li>
    <li>... that Jack's "Walk in the Park" philosophy was synthesized entirely during a single walk in February 2025?</li>
    <li>... that Jack identified his biggest failure of 2024 as "not pursuing side projects hard enough"?</li>
  </ul>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/wiki/concepts/writing-archive.html">Browse writing archive...</a></div>
</div>"""

    # In the news / recent activity
    news = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">Recent activity</div>
  <ul style="margin-left:18px; font-size:13.5px;">
    <li>AgentDex auth migration to Clerk (Story 4.7) merged — <a href="/wiki/goals/agentdex.html">AgentDex</a></li>
    <li>Jackipedia launched at <a href="https://jackipedia.agentschool.io">jackipedia.agentschool.io</a></li>
    <li>Notion MCP connected — 360+ writings now accessible</li>
    <li>Worker VPS SSH restored after firewall IP change</li>
    <li>20-day customer discovery sprint completed (Jan–Feb 2026)</li>
  </ul>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/meta/history.html">View all recent changes...</a></div>
</div>"""

    # On this day
    otd = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">On this day</div>
  <div style="font-size:13px; font-weight:bold; margin-bottom:6px;">April 6</div>
  <ul style="margin-left:18px; font-size:13.5px;">
    <li><b>2025:</b> Jack's app went to production for the first time — "seeing all the crazy stuff" (from 2024 annual review)</li>
    <li><b>2026:</b> Jackipedia founded</li>
  </ul>
</div>"""

    # Two-column layout
    content = f"""
<style>
.mp-columns {{ display: flex; gap: 20px; }}
.mp-col {{ flex: 1; min-width: 0; }}
@media (max-width: 700px) {{ .mp-columns {{ flex-direction: column; }} }}
.mp-title {{ font-family: 'Linux Libertine', Georgia, Times, serif; font-size: 1.95em; font-weight: normal; border-bottom: 1px solid #a2a9b1; padding-bottom: 4px; margin-bottom: 16px; }}
.mp-welcome {{ background: #eaf3fb; border: 1px solid #a2a9b1; padding: 12px 16px; margin-bottom: 16px; font-size: 13.5px; }}
.mp-welcome b {{ font-size: 1.1em; }}
</style>

<div class="mp-title">Welcome to Jackipedia</div>

<div class="mp-welcome">
  <b>Jackipedia</b> is the personal knowledge wiki of <a href="/wiki/people/jack-luo.html">Jack Luo</a> — a builder, founder, and student based in Oakland, CA.
  This wiki is compiled from five years of personal writing, meeting logs, books, and reflections.
  It currently contains <b>7 articles</b> drawn from <b>360+ source entries</b> spanning 2020–2026.
  Maintained by <a href="https://openclaw.ai">Claw</a> via Notion MCP.
</div>

<div class="mp-columns">
  <div class="mp-col">
    {featured}
    {dyk}
  </div>
  <div class="mp-col">
    {news}
    {otd}
  </div>
</div>"""

    out_file = f"{OUT_DIR}/index.html"
    html = render_page("Jackipedia", content, nav, is_main=True)
    with open(out_file, "w") as f:
        f.write(html)
    print("  ✓ index.html (main page)")


# ── Build ──────────────────────────────────────────────────────────────

nav = get_sidebar_nav()
all_history = {}
skip = {"AGENTS.md", "build.sh", "index.md"}  # index handled separately

for root, dirs, files in os.walk(WIKI_DIR):
    dirs[:] = [d for d in dirs if d not in {".git", "meta"}]
    for fname in files:
        if fname.endswith(".md") and fname not in skip:
            build_page(os.path.join(root, fname), nav, all_history)

# Build log page
build_page(f"{WIKI_DIR}/log.md", nav, all_history)

# Build main page
build_main_page(nav, all_history)

# Build history page
os.makedirs(f"{OUT_DIR}/meta", exist_ok=True)
hist_content = build_history_page(all_history)
hist_html = render_page("Recent changes", hist_content, nav)
with open(f"{OUT_DIR}/meta/history.html", "w") as f:
    f.write(hist_html)
print("  ✓ meta/history.html")

with open(f"{HISTORY_DIR}/page-history.json", "w") as f:
    json.dump(all_history, f, indent=2)

print(f"\nDone. Deployed to {OUT_DIR}")
