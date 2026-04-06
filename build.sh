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
        return '<div id="page-history" style="margin-top:32px;border-top:1px solid var(--border);padding-top:12px;"><p style="font-family:sans-serif;font-size:13px;color:var(--text-muted);">No revision history available.</p></div>'
    rows = "".join(
        f"<tr><td>{e['date']}</td>"
        f"<td><a href='https://github.com/thejackluo/jackipedia/commit/{e['commit']}' target='_blank'><code>{e['commit'][:8]}</code></a></td>"
        f"<td>{e['summary']}</td></tr>"
        for e in history
    )
    return f"<div id='page-history' style='margin-top:32px;border-top:1px solid var(--border);padding-top:12px;'><h2>Revision history</h2><table><tr><th>Date</th><th>Commit</th><th>Edit summary</th></tr>{rows}</table></div>"


def render_page(title, content, nav, extra_css="", is_main=False, translation_html="", lang_label=""):
    tabs = ""
    if not is_main:
        lang_btn = f'<button class="lang-toggle-btn" onclick="toggleLang(this, \'{lang_label}\')">{lang_label}</button>' if translation_html else ""
        tabs = f'<a class="tab active" href="#">Article</a><a class="tab" href="#page-history" onclick="event.preventDefault();var el=document.getElementById(\'page-history\');if(el){{el.scrollIntoView({{behavior:\'smooth\',block:\'start\'}})}}">History</a><a class="tab" href="/meta/history.html">All changes</a>{lang_btn}'
    else:
        tabs = '<a class="tab active" href="/index.html">Main page</a><a class="tab" href="/meta/history.html">Recent changes</a>'

    translation_block = f'<div id="content-translation">{translation_html}</div>' if translation_html else ""

    html = BASE_TEMPLATE
    html = html.replace("NAV_PLACEHOLDER", nav)
    html = html.replace("CONTENT_PLACEHOLDER", content)
    html = html.replace("TRANSLATION_PLACEHOLDER", translation_block)
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
        lambda m: f'<a href="/wiki/{m.group(1)}.html">{m.group(1).split("/")[-1].replace("-", " ").title()}</a>',
        content
    )

    with open(md_file) as f:
        first_line = f.readline().strip()
    title = first_line.lstrip("# ") if first_line.startswith("#") else os.path.basename(md_file).replace(".md", "")

    history = get_git_log(md_file)
    page_key = rel_path.replace(".md", "")
    all_history[page_key] = history

    last_edit = history[0]["date"] if history else "unknown"
    rev_count = len(history)
    meta = f'<div class="page-meta">Last edited: {last_edit} &nbsp;|&nbsp; <a href="#page-history">{rev_count} revision{"s" if rev_count != 1 else ""}</a> &nbsp;|&nbsp; <a href="/meta/history.html">All changes</a></div>'
    history_html = build_page_history_html(history)
    full_content = meta + content + history_html

    is_main = (rel_path == "index.md")

    # Check for translation file (.zh.md or .ja.md)
    translation_html = ""
    lang_label = ""
    for lang_ext, lang_lbl in [(".zh.md", "中文"), (".ja.md", "日本語")]:
        trans_file = md_file.replace(".md", lang_ext)
        if os.path.exists(trans_file):
            tr = subprocess.run(
                ["pandoc", "--from", "markdown", "--to", "html", "--no-highlight", trans_file],
                capture_output=True, text=True
            )
            translation_html = tr.stdout
            lang_label = lang_lbl
            break

    html = render_page(title, full_content, nav, is_main=is_main, translation_html=translation_html, lang_label=lang_label)
    with open(out_file, "w") as f:
        f.write(html)

    print(f"  ✓ {rel_path}")
    return page_key, history


def build_main_page(nav, all_history, page_count=0):
    """Build the Wikipedia-style two-column main page."""
    import datetime
    day_of_year = datetime.datetime.utcnow().timetuple().tm_yday

    # Pool of featured articles — rotates by day of year
    featured_pool = [
        {
            "title": "The Walk in the Park Framework",
            "url": "/wiki/philosophy/walk-in-the-park-framework.html",
            "color": "wiki-box-blue",
            "body": 'On February 9, 2025, Jack articulated a four-part personal philosophy during a walk — one of the highest-rated pieces in his five-year writing archive. The framework covers relationships (grow, don\'t chase), success (vision over money), work (game-like engagement), and wisdom (acceptance, not control). It draws on themes from <a href="/wiki/concepts/reading-list.html">The Courage to Be Disliked</a> and <a href="/wiki/books/essentialism.html">Essentialism</a> and represents the clearest single synthesis of Jack\'s values.',
        },
        {
            "title": "Japan Trip 2024",
            "url": "/wiki/history/japan-trip-2024.html",
            "color": "wiki-box-blue",
            "body": 'From December 15–30, 2024, Jack traveled to <a href="/wiki/history/japan-trip-2024.html">Japan</a> — one of the most memorable periods of the year. The trip surfaced in his <a href="/wiki/concepts/writing-archive.html">2024 annual review</a> as the defining travel experience of the year. Jack visited Tokyo, Kyoto, and Osaka, and the trip deepened his interest in <a href="/wiki/interests/anime.html">anime</a>, Japanese design, and the country\'s relationship with technology and tradition.',
        },
        {
            "title": "AgentDex",
            "url": "/wiki/projects/agentdex.html",
            "color": "wiki-box-green",
            "body": '<a href="/wiki/projects/agentdex.html">AgentDex</a> is Jack\'s main project: an AI-native personal CRM and relationship intelligence app. It ingests contacts from <a href="/wiki/history/georgia-tech-era.html">calendar</a>, email, and conversations, structures them into a typed graph, and surfaces context at the moment you need it. The product is built with Next.js, PostgreSQL, and Drizzle ORM. As of April 2026, the MVP backbone and most intelligence surfaces are implemented.',
        },
        {
            "title": "Essentialism",
            "url": "/wiki/books/essentialism.html",
            "color": "wiki-box-blue",
            "body": 'Jack finished <a href="/wiki/books/essentialism.html">Essentialism</a> by Greg McKeown on February 14, 2026 — rated 4 stars. The book\'s core thesis: "Far too many people are focused on additive activities." The disciplined pursuit of less resonated with Jack\'s tendency toward too many simultaneous projects. Key lessons: protect your time like an asset, learn to say no, and recognize that the most important choices compound. See also: <a href="/wiki/philosophy/walk-in-the-park-framework.html">Walk in the Park Framework</a>.',
        },
        {
            "title": "Cupertino High School Era",
            "url": "/wiki/history/cupertino-high-school.html",
            "color": "wiki-box-blue",
            "body": 'Jack attended <a href="/wiki/history/cupertino-high-school.html">Cupertino High School</a> — in the heart of Silicon Valley, surrounded by Apple, Google, and Intel campuses. The environment shaped his early exposure to technology and ambition. Growing up in Cupertino means growing up adjacent to the mythology of how the modern tech industry was built. It\'s one of the few places on earth where founding a company in high school is not unusual.',
        },
        {
            "title": "Vienna, Austria",
            "url": "/wiki/history/vienna-austria.html",
            "color": "wiki-box-blue",
            "body": 'Jack visited <a href="/wiki/history/vienna-austria.html">Vienna</a> as part of a choir trip — one of the densest architectural and intellectual cities in the world. Vienna was the center of the <a href="/wiki/concepts/mit-media-lab.html">Habsburg Empire</a> for centuries and in the early 20th century hosted Freud, Wittgenstein, Klimt, and Mahler simultaneously. Jack traveled via Lufthansa, and the food — Wiener Schnitzel, Sachertorte, Viennese Kaffeehaus breakfast — is its own category.',
        },
        {
            "title": "The Billion Dollar Whale",
            "url": "/wiki/books/billion-dollar-whale.html",
            "color": "wiki-box-green",
            "body": '"Jho Low is probably one of the most interesting guys I have had the honor to read." Jack is currently reading <a href="/wiki/books/billion-dollar-whale.html">Billion Dollar Whale</a> (4 stars) — the story of how Jho Low stole $4.5 billion from Malaysia\'s 1MDB sovereign wealth fund using Goldman Sachs, Hollywood, and the global financial system. It\'s a masterclass in how money, relationships, and audacity combine. See also: <a href="/wiki/concepts/effective-altruism.html">Effective Altruism</a> and the FTX parallel.',
        },
    ]

    fa = featured_pool[day_of_year % len(featured_pool)]
    recently_added_articles = [
        ("/wiki/concepts/reading-list.html", "Reading List"),
        ("/wiki/history/vienna-austria.html", "Vienna"),
        ("/wiki/concepts/mit-media-lab.html", "MIT Media Lab"),
        ("/wiki/philosophy/effective-altruism.html", "Effective Altruism"),
        ("/wiki/concepts/linear.html", "Linear"),
        ("/wiki/interests/anime.html", "Anime"),
    ]
    recently_added_html = " &nbsp;·&nbsp; ".join(f'<a href="{u}">{n}</a>' for u, n in recently_added_articles)

    featured = f"""
<div class="wiki-box {fa['color']}">
  <div class="wiki-box-heading">Featured article</div>
  <b><a href="{fa['url']}">{fa['title']}</a></b>
  <p style="margin:8px 0 0;">{fa['body']}</p>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="{fa['url']}">Read full article...</a></div>
</div>
<div style="font-size:12px; font-family:sans-serif; color:var(--text-muted); margin-bottom:16px;">
  Recently added: {recently_added_html}
</div>"""

    # Did you know — rotates a subset by day
    all_dyk = [
        '... that Jack has maintained a personal writing practice since 2020, accumulating over <b>360 entries</b> in his <a href="/wiki/concepts/writing-archive.html">writing archive</a>?',
        '... that Jack\'s song of the year for 2024 was <i>Steins;Gate</i>\'s "Hacking to the Gate" — connecting his love of <a href="/wiki/interests/anime.html">anime</a> and music?',
        '... that Jack traveled to <a href="/wiki/history/japan-trip-2024.html">Japan</a> for two weeks in December 2024, rating it as one of the most memorable periods of the year?',
        '... that Jack rated <a href="/wiki/books/the-courage-to-be-disliked.html"><i>The Courage to Be Disliked</i></a> <b>5 stars</b> — his highest rating — alongside a book on AI agents?',
        '... that Jack\'s <a href="/wiki/philosophy/walk-in-the-park-framework.html">Walk in the Park philosophy</a> was synthesized entirely during a single walk in February 2025?',
        '... that Jack identified his biggest failure of 2024 as "not pursuing side projects hard enough" in his <a href="/wiki/concepts/writing-archive.html">annual review</a>?',
        '... that <a href="/wiki/projects/agentdex.html">AgentDex</a> was built with a BMAD story workflow and has over 6 epics of structured product work?',
        '... that Jack attended <a href="/wiki/history/cupertino-high-school.html">Cupertino High School</a> — steps from Apple HQ — before studying at <a href="/wiki/history/ucsc-era.html">UCSC</a> and <a href="/wiki/history/georgia-tech-era.html">Georgia Tech</a>?',
        '... that Jack performed in a choir on a trip to <a href="/wiki/history/vienna-austria.html">Vienna</a> — the city where Mozart, Beethoven, and Brahms all spent their careers?',
        '... that Jack is reading <a href="/wiki/books/billion-dollar-whale.html">Billion Dollar Whale</a> — calling Jho Low "one of the most interesting guys I have had the honor to read"?',
        '... that <a href="/wiki/history/qhouse-2023.html">Q House</a> was a hacker house Jack co-organized in San Francisco in 2023, where his working relationship with <a href="/wiki/people/kevin-zhang.html">Kevin Zhang</a> solidified?',
        '... that Jack\'s <a href="/wiki/concepts/reading-list.html">reading list</a> includes both Nick Bostrom\'s <i>Superintelligence</i> and <i>Deep Utopia</i> — signaling serious engagement with AI risk?',
        '... that Jack completed <a href="/wiki/books/essentialism.html">Essentialism</a> on February 14, 2026, rating it 4 stars and noting "far too many people are focused on additive activities"?',
        '... that Jack attended the <a href="/wiki/projects/ces-2025.html">CES 2025</a> trade show in Las Vegas in January 2025 as one of his first major industry events?',
    ]
    # Pick 6 DYK items rotating by day
    start = day_of_year % len(all_dyk)
    selected_dyk = [all_dyk[(start + i) % len(all_dyk)] for i in range(6)]
    dyk_items = "".join(f"<li>{item}</li>" for item in selected_dyk)
    dyk = f"""
<div class="wiki-box">
  <div class="wiki-box-heading">Did you know</div>
  <ul style="margin-left:18px; font-size:13.5px;">
    {dyk_items}
  </ul>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/wiki/concepts/writing-archive.html">Browse writing archive...</a></div>
</div>"""

    # In the news / recent activity
    news = """
<div class="wiki-box">
  <div class="wiki-box-heading">Recent activity</div>
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
<div class="wiki-box">
  <div class="wiki-box-heading">On this day</div>
  <div style="font-size:13px; font-weight:bold; margin-bottom:6px;">April 6</div>
  <ul style="margin-left:18px; font-size:13.5px;">
    <li><b>2025:</b> Jack's app went to production for the first time — "seeing all the crazy stuff" (from 2024 annual review)</li>
    <li><b>2026:</b> Jackipedia founded</li>
  </ul>
</div>"""

    # Featured list — Books
    feat_list = """
<div class="wiki-box wiki-box-green">
  <div class="wiki-box-heading">Featured list</div>
  <b><a href="/wiki/concepts/reading-list.html">Jack's Reading List</a></b>
  <p style="margin:8px 0 0; font-size:13.5px;">Jack maintains a rated reading list spanning AI, business, personal development, and philosophy. Highlights include <i>The Courage to Be Disliked</i> (5 stars), <i>Essentialism</i> (4 stars, finished Feb 2026), and <i>Billion Dollar Whale</i> (4 stars, in progress). He is currently working through multiple AI/ML books simultaneously.</p>
  <div style="margin-top:8px; font-size:12px; font-family:sans-serif;"><a href="/wiki/concepts/reading-list.html">Full reading list...</a></div>
  <div style="margin-top:4px; font-size:12px; font-family:sans-serif; color:var(--text-muted);">Recently featured: <a href="/wiki/concepts/writing-archive.html">Writing Archive</a> &nbsp;·&nbsp; <a href="/wiki/people/meetings-index.html">Meetings</a></div>
</div>"""

    # Featured picture — Japan 2024
    feat_pic = """
<div class="wiki-box">
  <div class="wiki-box-heading">Featured entry</div>
  <b>Japan Trip, December 2024</b>
  <p style="margin:8px 0; font-size:13.5px;">From December 15 to 30, 2024, Jack traveled to Japan — one of the most memorable periods of the year by his own account. The trip appears in his 2024 annual review as the defining travel experience of the year, alongside CES (Jan), TreeHacks at Stanford (Feb), and the Berkeley AI hackathon (Jun). Travel consistently absorbs the largest portion of Jack's discretionary spending.</p>
  <div style="margin-top:4px; font-size:12px; font-family:sans-serif; color:var(--text-muted);">Source: <a href="/wiki/concepts/writing-archive.html">40 Questions Annual Review (01/06/25)</a></div>
</div>"""

    # On this day — expanded with life timeline
    otd = """
<div class="wiki-box">
  <div class="wiki-box-heading">On this day</div>
  <div style="font-size:13px; font-weight:bold; margin-bottom:8px;">April 6</div>
  <ul style="margin-left:18px; font-size:13.5px; margin-bottom:10px;">
    <li><b>2025:</b> Jack's app went to production — "seeing all the crazy stuff"</li>
    <li><b>2026:</b> Jackipedia founded. Notion MCP connected. 360+ writings ingested.</li>
  </ul>
  <div style="font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:var(--text-muted); margin-bottom:4px;">Life milestones</div>
  <ul style="margin-left:18px; font-size:13px; color:var(--text-muted);">
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
<div class="wiki-box">
  <div style="font-size:13px; font-weight:bold; font-family:sans-serif; border-bottom:1px solid var(--border); padding-bottom:4px; margin-bottom:8px;">Other areas of Jackipedia</div>
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
<div class="wiki-box">
  <div style="font-size:13px; font-weight:bold; font-family:sans-serif; border-bottom:1px solid var(--border); padding-bottom:4px; margin-bottom:8px;">Jack's projects</div>
  <p style="font-size:13px; font-family:sans-serif; margin-bottom:10px;">Jackipedia is maintained by <a href="https://openclaw.ai">Claw</a> and sourced from Jack's Notion workspace. Jack's active projects:</p>
  <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:8px; font-size:13px; font-family:sans-serif;">
    <div style="border:1px solid var(--border); padding:8px; background:var(--bg-secondary); border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://agentdex.agentschool.io">AgentDex</a></div>
      <div style="color:var(--text-muted); font-size:12px;">Personal CRM &amp; relationship intelligence app</div>
    </div>
    <div style="border:1px solid var(--border); padding:8px; background:var(--bg-secondary); border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://agentschool.io">Agent School</a></div>
      <div style="color:var(--text-muted); font-size:12px;">AI agent infrastructure and tooling</div>
    </div>
    <div style="border:1px solid var(--border); padding:8px; background:var(--bg-secondary); border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://paperclip.agentschool.io">Paperclip</a></div>
      <div style="color:var(--text-muted); font-size:12px;">Agent memory and context store</div>
    </div>
    <div style="border:1px solid var(--border); padding:8px; background:var(--bg-secondary); border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://jackipedia.agentschool.io">Jackipedia</a></div>
      <div style="color:var(--text-muted); font-size:12px;">This personal knowledge wiki</div>
    </div>
    <div style="border:1px solid var(--border); padding:8px; background:var(--bg-secondary); border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://github.com/thejackluo">GitHub</a></div>
      <div style="color:var(--text-muted); font-size:12px;">Open source work and repositories</div>
    </div>
    <div style="border:1px solid var(--border); padding:8px; background:var(--bg-secondary); border-radius:2px;">
      <div style="font-weight:bold; margin-bottom:2px;"><a href="https://thejackluo.notion.site">Notion</a></div>
      <div style="color:var(--text-muted); font-size:12px;">Public writing and reflections</div>
    </div>
  </div>
</div>"""

    # Languages / dimensions of Jack
    languages = """
<div class="wiki-box">
  <div style="font-size:13px; font-weight:bold; font-family:sans-serif; border-bottom:1px solid var(--border); padding-bottom:4px; margin-bottom:8px;">Dimensions of Jack</div>
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
  <div style="font-family:sans-serif; font-size:13px; color:var(--text-muted); line-height:2;">
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
.mp-title {{ font-family: 'Linux Libertine', Georgia, Times, serif; font-size: 1.95em; font-weight: normal; border-bottom: 1px solid var(--border); padding-bottom: 4px; margin-bottom: 16px; }}
.mp-welcome {{ background: var(--bg-secondary); border: 1px solid var(--border); padding: 12px 16px; margin-bottom: 16px; font-size: 13.5px; }}
.mp-welcome b {{ font-size: 1.1em; }}
[data-theme="dark"] .mp-welcome {{ background: #1f1f20 !important; color: #d7dadc; }}
[data-theme="dark"] .mp-title {{ border-bottom-color: #3c3c3d; }}
[data-theme="dark"] .mp-welcome a {{ color: #4e9af1; }}
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

<hr style="border:none; border-top:1px solid var(--border); margin:16px 0;">

<div class="mp-3col">
  <div>{feat_list}</div>
  <div>{feat_pic}</div>
  <div>
    <div class="wiki-box wiki-box-yellow">
      <div class="wiki-box-heading">Wiki stats</div>
      <table style="width:100%; border:none; font-size:13px; font-family:sans-serif;">
        <tr><td style="border:none; padding:2px 0; color:var(--text-muted);">Articles</td><td style="border:none; padding:2px 0; font-weight:bold;">{page_count}</td></tr>
        <tr><td style="border:none; padding:2px 0; color:var(--text-muted);">Source entries</td><td style="border:none; padding:2px 0; font-weight:bold;">360+</td></tr>
        <tr><td style="border:none; padding:2px 0; color:var(--text-muted);">Years covered</td><td style="border:none; padding:2px 0; font-weight:bold;">2020–2026</td></tr>
        <tr><td style="border:none; padding:2px 0; color:var(--text-muted);">Books tracked</td><td style="border:none; padding:2px 0; font-weight:bold;">20+</td></tr>
        <tr><td style="border:none; padding:2px 0; color:var(--text-muted);">People logged</td><td style="border:none; padding:2px 0; font-weight:bold;">25+</td></tr>
        <tr><td style="border:none; padding:2px 0; color:var(--text-muted);">Founded</td><td style="border:none; padding:2px 0; font-weight:bold;">April 6, 2026</td></tr>
      </table>
      <div style="margin-top:10px; font-size:11px; font-family:sans-serif; text-transform:uppercase; letter-spacing:.05em; color:var(--text-muted); margin-bottom:4px;">Sections</div>
      <div style="font-size:13px; font-family:sans-serif;">
        <a href="/wiki/people/jack-luo.html">People</a> &nbsp;·&nbsp;
        <a href="/wiki/philosophy/walk-in-the-park-framework.html">Philosophy</a> &nbsp;·&nbsp;
        <a href="/wiki/concepts/reading-list.html">Concepts</a>
      </div>
    </div>
  </div>
</div>

<hr style="border:none; border-top:1px solid var(--border); margin:16px 0;">

{community}
{sister}
{languages}

<div style="border-top:1px solid var(--border); padding-top:10px; font-size:12px; font-family:sans-serif; color:var(--text-muted); text-align:center;">
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
skip_files = {"AGENTS.md", "build.sh"}  # root index.md handled separately
root_skip = {"index.md"}  # only skip index.md at the top level

for root, dirs, files in os.walk(WIKI_DIR):
    dirs[:] = [d for d in dirs if d not in {".git", "meta"}]
    is_root = (root == WIKI_DIR)
    for fname in files:
        if fname.endswith(".md") and fname not in skip_files:
            if is_root and fname in root_skip:
                continue
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

# ── Search index + search page ────────────────────────────────────────────────
import json as _json

_index = []
for _root, _dirs, _files in os.walk(WIKI_DIR):
    for _f in sorted(_files):
        if not _f.endswith(".md") or ".zh." in _f or ".ja." in _f:
            continue
        _path = os.path.join(_root, _f)
        _rel  = os.path.relpath(_path, WIKI_DIR).replace(".md", "")
        _url  = f"/wiki/{_rel}.html"
        with open(_path) as _fh:
            _raw = _fh.read()
        _title_m = re.search(r'^#\s+(.+)', _raw, re.MULTILINE)
        _title = _title_m.group(1).strip() if _title_m else _rel.split("/")[-1].replace("-"," ").title()
        _summ_m = re.search(r'\*\*Summary:\*\*\s*(.+)', _raw)
        if _summ_m:
            _summary = _summ_m.group(1).strip()
        else:
            _lines = [l.strip() for l in _raw.split("\n") if l.strip() and not l.startswith("#") and not l.startswith("**") and not l.startswith("|") and not l.startswith("-")]
            _summary = _lines[0][:160] if _lines else ""
        _body = re.sub(r'\[\[([^\]|]+)(?:\|[^\]]+)?\]\]', r'\1', _raw)
        _body = re.sub(r'\*+|#+|`+|\|', ' ', _body)
        _body = re.sub(r'\s+', ' ', _body).strip()[:2000]
        _cat = _rel.split("/")[0]
        _index.append({"title": _title, "url": _url, "summary": _summary, "body": _body, "cat": _cat})

with open(f"{OUT_DIR}/search-index.json", "w") as _fh:
    _json.dump(_index, _fh)
print(f"  ✓ search-index.json ({len(_index)} articles)")

# Copy search.html to web root
import shutil as _shutil
_shutil.copy("/home/ubuntu/jackipedia/search.html", f"{OUT_DIR}/search.html")
print("  ✓ search.html")
