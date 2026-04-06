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
    sections = {
        "people": [], "writings": [], "philosophy": [], "projects": [],
        "books": [], "fitness": [], "dreams": [], "history": [], "concepts": [], "goals": []
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
    labels = {
        "people": "People", "writings": "Writings", "philosophy": "Philosophy",
        "projects": "Projects", "books": "Books", "fitness": "Fitness",
        "dreams": "Dreams", "history": "History", "concepts": "Concepts", "goals": "Goals"
    }
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


def build_main_page(nav, all_history, page_count=0):
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

    # Featured list — Books
    feat_list = """
<div style="border:1px solid #a2a9b1; background:#f5fffa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">Featured list</div>
  <b><a href="/wiki/concepts/reading-list.html">Jack's Reading List</a></b>
  <p style="margin:8px 0 0; font-size:13.5px;">Jack maintains a rated reading list spanning AI, business, personal development, and philosophy. Highlights include <i>The Courage to Be Disliked</i> (5 stars), <i>Essentialism</i> (4 stars, finished Feb 2026), and <i>Billion Dollar Whale</i> (4 stars, in progress). He is currently working through multiple AI/ML books simultaneously.</p>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/wiki/concepts/reading-list.html">Full reading list...</a></div>
  <div style="margin-top:4px; font-size:12px; font-family:sans-serif; color:#54595d;">Recently featured: <a href="/wiki/concepts/writing-archive.html">Writing Archive</a> &nbsp;·&nbsp; <a href="/wiki/people/meetings-index.html">Meetings</a></div>
</div>"""

    # Featured picture — Japan 2024
    feat_pic = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">Featured entry</div>
  <b>Japan Trip, December 2024</b>
  <p style="margin:8px 0; font-size:13.5px;">From December 15 to 30, 2024, Jack traveled to Japan — one of the most memorable periods of the year by his own account. The trip appears in his 2024 annual review as the defining travel experience of the year, alongside CES (Jan), TreeHacks at Stanford (Feb), and the Berkeley AI hackathon (Jun). Travel consistently absorbs the largest portion of Jack's discretionary spending.</p>
  <div style="margin-top:4px; font-size:12px; font-family:sans-serif; color:#54595d;">Source: <a href="/wiki/concepts/writing-archive.html">40 Questions Annual Review (01/06/25)</a></div>
</div>"""

    # On this day — expanded with life timeline
    otd = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px;">
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">On this day</div>
  <div style="font-size:13px; font-weight:bold; margin-bottom:8px;">April 6</div>
  <ul style="margin-left:18px; font-size:13.5px; margin-bottom:10px;">
    <li><b>2025:</b> Jack's app went to production — "seeing all the crazy stuff"</li>
    <li><b>2026:</b> Jackipedia founded. Notion MCP connected. 360+ writings ingested.</li>
  </ul>
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:4px;">Life milestones</div>
  <ul style="margin-left:18px; font-size:13px; color:#54595d;">
    <li>Jan 6–10, 2025 — CES, Las Vegas</li>
    <li>Feb 16–18, 2025 — TreeHacks, Stanford</li>
    <li>Jun 29, 2024 — Berkeley AI Hackathon</li>
    <li>Dec 15–30, 2024 — Japan</li>
    <li>2024 — Transferred to Georgia Tech</li>
  </ul>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/wiki/concepts/writing-archive.html">More from the archive...</a></div>
</div>"""

    # Community portal section
    community = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:13px; font-weight:bold; font-family:sans-serif; border-bottom:1px solid #a2a9b1; padding-bottom:4px; margin-bottom:8px;">Other areas of Jackipedia</div>
  <div style="font-size:13px; font-family:sans-serif; display:grid; grid-template-columns:1fr 1fr; gap:4px 16px;">
    <div><a href="/meta/history.html">Recent changes</a> – All edits to the wiki, most recent first.</div>
    <div><a href="/log.html">Log</a> – Chronological record of all ingests and updates.</div>
    <div><a href="/wiki/people/meetings-index.html">Meetings index</a> – All logged meetings and people.</div>
    <div><a href="/wiki/concepts/writing-archive.html">Writing archive</a> – 360+ personal entries spanning 2020–2026.</div>
    <div><a href="/wiki/concepts/reading-list.html">Reading list</a> – Rated books with notes and patterns.</div>
    <div><a href="/wiki/philosophy/walk-in-the-park-framework.html">Philosophy</a> – Core frameworks and worldview.</div>
  </div>
</div>"""

    # Sister projects (Jack's own projects)
    sister = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:13px; font-weight:bold; font-family:sans-serif; border-bottom:1px solid #a2a9b1; padding-bottom:4px; margin-bottom:8px;">Jack's projects</div>
  <p style="font-size:13px; font-family:sans-serif; margin-bottom:10px;">Jackipedia is maintained by <a href="https://openclaw.ai">Claw</a> and sourced from Jack's Notion workspace. Jack's active projects:</p>
  <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:8px; font-size:13px; font-family:sans-serif;">
    <div style="border:1px solid #a2a9b1; padding:8px; background:#fff; border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://agentdex.agentschool.io">AgentDex</a></div>
      <div style="color:#54595d; font-size:12px;">Personal CRM &amp; relationship intelligence app</div>
    </div>
    <div style="border:1px solid #a2a9b1; padding:8px; background:#fff; border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://agentschool.io">Agent School</a></div>
      <div style="color:#54595d; font-size:12px;">AI agent infrastructure and tooling</div>
    </div>
    <div style="border:1px solid #a2a9b1; padding:8px; background:#fff; border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://paperclip.agentschool.io">Paperclip</a></div>
      <div style="color:#54595d; font-size:12px;">Agent memory and context store</div>
    </div>
    <div style="border:1px solid #a2a9b1; padding:8px; background:#fff; border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://jackipedia.agentschool.io">Jackipedia</a></div>
      <div style="color:#54595d; font-size:12px;">This personal knowledge wiki</div>
    </div>
    <div style="border:1px solid #a2a9b1; padding:8px; background:#fff; border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://github.com/thejackluo">GitHub</a></div>
      <div style="color:#54595d; font-size:12px;">Open source work and repositories</div>
    </div>
    <div style="border:1px solid #a2a9b1; padding:8px; background:#fff; border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://thejackluo.notion.site">Notion</a></div>
      <div style="color:#54595d; font-size:12px;">Public writing and reflections</div>
    </div>
  </div>
</div>"""

    # Languages / dimensions of Jack
    languages = """
<div style="border:1px solid #a2a9b1; background:#f8f9fa; padding:12px 16px; margin-bottom:16px;">
  <div style="font-size:13px; font-weight:bold; font-family:sans-serif; border-bottom:1px solid #a2a9b1; padding-bottom:4px; margin-bottom:8px;">Dimensions of Jack</div>
  <p style="font-size:13px; font-family:sans-serif; margin-bottom:8px;">Jackipedia documents Jack across multiple dimensions. Articles exist or are planned for each:</p>
  <div style="font-size:13px; font-family:sans-serif; margin-bottom:6px;"><b>Documented</b></div>
  <div style="font-family:sans-serif; font-size:13px; line-height:2;">
    <a href="/wiki/people/jack-luo.html">Identity</a> &nbsp;·&nbsp;
    <a href="/wiki/philosophy/walk-in-the-park-framework.html">Philosophy</a> &nbsp;·&nbsp;
    <a href="/wiki/concepts/reading-list.html">Reading</a> &nbsp;·&nbsp;
    <a href="/wiki/concepts/writing-archive.html">Writing</a> &nbsp;·&nbsp;
    <a href="/wiki/people/meetings-index.html">Relationships</a>
  </div>
  <div style="font-size:13px; font-family:sans-serif; margin:8px 0 4px;"><b>Planned</b></div>
  <div style="font-family:sans-serif; font-size:13px; color:#54595d; line-height:2;">
    Fitness &nbsp;·&nbsp; Goals &nbsp;·&nbsp; Travel &nbsp;·&nbsp; Dream journal &nbsp;·&nbsp;
    Health &nbsp;·&nbsp; Boston &nbsp;·&nbsp; Japan &nbsp;·&nbsp; AgentDex &nbsp;·&nbsp;
    Startup history &nbsp;·&nbsp; Running log &nbsp;·&nbsp; ADHD &nbsp;·&nbsp; Anime
  </div>
</div>"""

    # Two-column layout + three-column bottom row + full bottom sections
    content = f"""
<style>
.mp-columns {{ display: flex; gap: 20px; }}
.mp-col {{ flex: 1; min-width: 0; }}
.mp-3col {{ display: flex; gap: 20px; }}
.mp-3col > div {{ flex: 1; min-width: 0; }}
@media (max-width: 700px) {{ .mp-columns, .mp-3col {{ flex-direction: column; }} }}
.mp-title {{ font-family: 'Linux Libertine', Georgia, Times, serif; font-size: 1.95em; font-weight: normal; border-bottom: 1px solid #a2a9b1; padding-bottom: 4px; margin-bottom: 16px; }}
.mp-welcome {{ background: #eaf3fb; border: 1px solid #a2a9b1; padding: 12px 16px; margin-bottom: 16px; font-size: 13.5px; }}
.mp-welcome b {{ font-size: 1.1em; }}
</style>

<div class="mp-title">Welcome to Jackipedia</div>

<div class="mp-welcome">
  <b>Jackipedia</b> is the personal knowledge wiki of <a href="/wiki/people/jack-luo.html">Jack Luo</a> — a builder, founder, and student based in Oakland, CA.
  This wiki is compiled from five years of personal writing, meeting logs, books, and reflections.
  It currently contains <b>{page_count} articles</b> drawn from <b>360+ source entries</b> spanning 2020–2026.
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
</div>

<hr style="border:none; border-top:1px solid #a2a9b1; margin:16px 0;">

<div class="mp-3col">
  <div>{feat_list}</div>
  <div>{feat_pic}</div>
  <div>
    <div style="border:1px solid #a2a9b1; background:#fff8dc; padding:12px 16px;">
      <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:6px;">Wiki stats</div>
      <table style="width:100%; border:none; font-size:13px; font-family:sans-serif;">
        <tr><td style="border:none; padding:2px 0; color:#54595d;">Articles</td><td style="border:none; padding:2px 0; font-weight:bold;">7</td></tr>
        <tr><td style="border:none; padding:2px 0; color:#54595d;">Source entries</td><td style="border:none; padding:2px 0; font-weight:bold;">360+</td></tr>
        <tr><td style="border:none; padding:2px 0; color:#54595d;">Years covered</td><td style="border:none; padding:2px 0; font-weight:bold;">2020–2026</td></tr>
        <tr><td style="border:none; padding:2px 0; color:#54595d;">Books tracked</td><td style="border:none; padding:2px 0; font-weight:bold;">20+</td></tr>
        <tr><td style="border:none; padding:2px 0; color:#54595d;">People logged</td><td style="border:none; padding:2px 0; font-weight:bold;">25+</td></tr>
        <tr><td style="border:none; padding:2px 0; color:#54595d;">Founded</td><td style="border:none; padding:2px 0; font-weight:bold;">April 6, 2026</td></tr>
      </table>
      <div style="margin-top:10px; font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:#54595d; margin-bottom:4px;">Sections</div>
      <div style="font-size:13px; font-family:sans-serif;">
        <a href="/wiki/people/jack-luo.html">People</a> &nbsp;·&nbsp;
        <a href="/wiki/philosophy/walk-in-the-park-framework.html">Philosophy</a> &nbsp;·&nbsp;
        <a href="/wiki/concepts/reading-list.html">Concepts</a>
      </div>
    </div>
  </div>
</div>

<hr style="border:none; border-top:1px solid #a2a9b1; margin:16px 0;">

{community}
{sister}
{languages}

<div style="border-top:1px solid #a2a9b1; padding-top:10px; font-size:12px; font-family:sans-serif; color:#54595d; text-align:center;">
  Content sourced from Jack Luo's personal Notion workspace &nbsp;|&nbsp;
  Maintained by <a href="https://openclaw.ai">Claw (OpenClaw)</a> &nbsp;|&nbsp;
  <a href="/meta/history.html">Recent changes</a> &nbsp;|&nbsp;
  <a href="/log.html">Log</a> &nbsp;|&nbsp;
  Powered by git + pandoc
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

# Compute page count before building main page so it can show live count
page_count = sum(
    len([f for f in os.listdir(os.path.join(WIKI_DIR, "wiki", s)) if f.endswith(".md")])
    for s in ["people","writings","philosophy","projects","books","fitness","dreams","history","concepts","goals","music"]
    if os.path.exists(os.path.join(WIKI_DIR, "wiki", s))
)

# Build main page
build_main_page(nav, all_history, page_count=page_count)

# Build history page
os.makedirs(f"{OUT_DIR}/meta", exist_ok=True)
hist_content = build_history_page(all_history)
hist_html = render_page("Recent changes", hist_content, nav)
with open(f"{OUT_DIR}/meta/history.html", "w") as f:
    f.write(hist_html)
print("  ✓ meta/history.html")

with open(f"{HISTORY_DIR}/page-history.json", "w") as f:
    json.dump(all_history, f, indent=2)

# Build random-articles.js — list of all wiki article URLs for random navigation
article_urls = []
for section in ["people", "writings", "philosophy", "projects", "books", "fitness", "dreams", "history", "concepts", "goals"]:
    section_path = f"{WIKI_DIR}/wiki/{section}"
    if os.path.exists(section_path):
        for fname in sorted(os.listdir(section_path)):
            if fname.endswith(".md"):
                url = f"/wiki/{section}/{fname.replace('.md', '.html')}"
                article_urls.append(url)

js_content = f"var JACKIPEDIA_ARTICLES = {json.dumps(article_urls)};\n"
with open(f"{OUT_DIR}/random-articles.js", "w") as f:
    f.write(js_content)
print(f"  ✓ random-articles.js ({len(article_urls)} articles)")

# Copy assets (photos, etc.) to web root
import shutil
assets_src = f"{WIKI_DIR}/assets"
assets_dst = f"{OUT_DIR}/assets"
if os.path.exists(assets_src):
    shutil.copytree(assets_src, assets_dst, dirs_exist_ok=True)
    print("  ✓ assets/")

print(f"\nDone. Deployed to {OUT_DIR}")

# Auto-commit to git with timestamp
import datetime
now = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC")
commit_msg = f"build: auto-update {now} ({page_count} pages)"
subprocess.run(["git", "add", "-A"], cwd=WIKI_DIR, capture_output=True)
result = subprocess.run(
    ["git", "commit", "-m", commit_msg],
    cwd=WIKI_DIR, capture_output=True, text=True
)
if "nothing to commit" in result.stdout or "nothing to commit" in result.stderr:
    print("  (git) nothing new to commit")
else:
    print(f"  ✓ git commit: {commit_msg}")
