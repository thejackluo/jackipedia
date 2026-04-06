# Jackipedia
**Category:** Project
**Status:** Active
**Launched:** April 2026
**URL:** https://jackipedia.agentschool.io
**Last updated:** 2026-04-06

## Overview

Jackipedia is Jack's personal Wikipedia — a structured knowledge base about his own life, ideas, people, projects, and writings. It is built and maintained by Claw (his OpenClaw AI assistant) and deployed at jackipedia.agentschool.io.

The goal is to create a permanent, searchable, cross-referenced record of Jack's life that can be read like an encyclopedia. Unlike a blog or journal, it is organized by topic rather than by time, and every page links to every relevant other page.

## Technical Architecture

- **Source:** Markdown files at `/home/ubuntu/jackipedia/wiki/`
- **Build system:** Python script using pandoc for Markdown→HTML conversion
- **Template:** Wikipedia-style HTML (white background, serif fonts, blue links, left sidebar)
- **Deploy target:** `/var/www/jackipedia` → Apache virtual host
- **Domain:** jackipedia.agentschool.io (Apache reverse proxy, Let's Encrypt SSL)
- **Version control:** Git at `/home/ubuntu/jackipedia/.git/` with post-commit auto-rebuild hook
- **History:** Per-page edit history tables (git log) + global Recent Changes page

## Content Structure

```
wiki/
  people/       — Jack, collaborators, friends, advisors
  writings/     — Essays from the 360+ entry writing archive
  books/        — Reading list with notes
  projects/     — AgentDex, Mira, CES, hackathons
  fitness/      — Running logs, gym, weight tracking
  concepts/     — Reading list, writing archive index
  philosophy/   — Walk in the Park framework
  dreams/       — Dream journal
  meta/         — History, about
```

## Content Philosophy

- No emojis anywhere (Jack's rule)
- Wikipedia tone and structure — neutral third-person, cited sources
- Synthesis over summary — pages connect ideas across the archive, not just report facts
- All public-safe information — nothing private, no credentials, no personal addresses

## Build Process

1. Write or edit `.md` files
2. Commit to git (triggers post-commit hook)
3. Hook runs `build.sh` which: generates navigation, converts all markdown via pandoc, resolves `[[wiki]]` links, copies to web root
4. Site updates live within seconds

## History

| Date | Event |
|------|-------|
| Apr 2026 | Initial build: Wikipedia template, git history, main page |
| Apr 2026 | First content: meetings index, jack-luo stub, reading list, writing archive |
| Apr 5–6, 2026 | 20 writing pages ingested from Notion |
| Apr 6, 2026 | 10 people pages built from Notion CRM + meeting records |
| Apr 6, 2026 | Books, fitness, projects, dreams sections added |

## Related
- [[people/jack-luo]]
- [[projects/agentdex]]
- [[meta/about]]
