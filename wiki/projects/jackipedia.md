# Jackipedia

<table class="infobox">
<caption>Jackipedia</caption>
<tr><th class="infobox-image" colspan="2">
<img src="/assets/photos/jack-main.jpg" alt="Jack Luo">
<span class="infobox-caption">Jack Luo, subject and author of Jackipedia</span>
</th></tr>
<tr><th class="infobox-section" colspan="2">Project overview</th></tr>
<tr><th class="infobox-label">Type</th><td class="infobox-data">Personal knowledge wiki</td></tr>
<tr><th class="infobox-label">Status</th><td class="infobox-data">🟢 Active</td></tr>
<tr><th class="infobox-label">Launched</th><td class="infobox-data">April 6, 2026</td></tr>
<tr><th class="infobox-label">URL</th><td class="infobox-data"><a href="https://jackipedia.agentschool.io">jackipedia.agentschool.io</a></td></tr>
<tr><th class="infobox-section" colspan="2">Content</th></tr>
<tr><th class="infobox-label">Articles</th><td class="infobox-data">127+</td></tr>
<tr><th class="infobox-label">Source entries</th><td class="infobox-data">360+ (2020–2026)</td></tr>
<tr><th class="infobox-label">Categories</th><td class="infobox-data">People, Books, History, Philosophy, Projects, Concepts, Dreams, Fitness</td></tr>
<tr><th class="infobox-section" colspan="2">Technical</th></tr>
<tr><th class="infobox-label">Build</th><td class="infobox-data">Python + pandoc</td></tr>
<tr><th class="infobox-label">Hosting</th><td class="infobox-data">AWS EC2 + Apache</td></tr>
<tr><th class="infobox-label">Maintained by</th><td class="infobox-data"><a href="https://openclaw.ai">Claw (OpenClaw)</a></td></tr>
<tr><th class="infobox-label">Source</th><td class="infobox-data">Notion MCP + Git</td></tr>
</table>

**Jackipedia** is the personal knowledge wiki of [[people/jack-luo]] — a builder, founder, and student based in Cupertino, CA. It is structured like Wikipedia but documents a single person's life: ideas, people, projects, writing, books, travel, and philosophy. It is built and maintained by Claw (Jack's [[concepts/notion]]-connected AI assistant) and deployed at [jackipedia.agentschool.io](https://jackipedia.agentschool.io).

The goal is a permanent, searchable, cross-referenced record — organized by topic rather than by time, where every page links to every relevant other page.

## Overview

Jackipedia was founded on April 6, 2026. It ingests content from Jack's five-year [[concepts/writing-archive]] (360+ entries), meeting logs, [[concepts/reading-list]], project notes, and personal reflections. Content is written in Wikipedia-style neutral third-person, synthesized rather than summarized, with cross-links connecting ideas across domains.

The wiki is organized into eight major sections: People, Books, History, [[philosophy/walk-in-the-park-framework]], Projects, Concepts, Dreams, and Fitness. Articles range from short stubs to multi-thousand-word deep dives.

## Technical Architecture

- **Source:** Markdown files at `/home/ubuntu/jackipedia/wiki/`
- **Build system:** Python + pandoc for Markdown→HTML conversion
- **Template:** Wikipedia-style HTML with dark mode, serif fonts, blue links, left sidebar
- **Deploy target:** `/var/www/jackipedia` → Apache virtual host
- **Domain:** jackipedia.agentschool.io (Apache, Let's Encrypt SSL)
- **Version control:** Git with post-commit auto-rebuild hook
- **History:** Per-page edit history (git log) + global Recent Changes page
- **Search:** Client-side JSON index with live filtering

## Content Philosophy

- Wikipedia tone — neutral third-person, factual, cited where possible
- Synthesis over summary — pages connect ideas across the archive
- No emojis in article body
- All public-safe — nothing private, no credentials, no personal addresses
- Cross-linked — every article points to related articles, minimum 5 backlinks

## Build Process

1. Write or edit `.md` files in `wiki/`
2. Commit to git (triggers post-commit hook)
3. Hook runs `build.sh` which converts all Markdown via pandoc, resolves `[[wiki]]` links, and copies to web root
4. Site updates live within seconds of commit

## History

| Date | Event |
|------|-------|
| Apr 6, 2026 | Founded — Wikipedia template, git history, main page |
| Apr 6, 2026 | First 20 writing pages ingested from Notion |
| Apr 6, 2026 | People, books, projects, dreams sections added |
| Apr 6, 2026 | Search, dark mode, rotating featured article added |
| Apr 7, 2026 | Infobox system added; 127+ articles |

## Related

- [[people/jack-luo]]
- [[projects/agentdex]]
- [[concepts/notion]]
- [[concepts/writing-archive]]
- [[concepts/reading-list]]
- [[philosophy/walk-in-the-park-framework]]
- [[projects/agent-school]]

## Screenshots

![Jackipedia on mobile — the wiki as seen on an iPhone](/assets/photos/jackipedia-mobile-screenshot.jpg)

![SSH connection attempt — server administration work](/assets/photos/ssh-connection-attempt.jpg)

![Jackipedia on iPhone — dark mode, main page](/assets/photos/jackipedia-mobile-dark.jpg)
