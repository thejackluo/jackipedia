# Jackipedia — Schema & Constitution

## What This Is
Jackipedia is Jack Luo's personal knowledge wiki. It is a persistent, LLM-maintained collection of markdown files that accumulates knowledge about Jack — his life, relationships, philosophy, goals, and thinking — over time.

You (the LLM) own the wiki layer entirely. You create pages, update them when new sources arrive, maintain cross-references, and keep everything consistent. Jack reads it; you write it.

## Directory Structure

```
jackipedia/
├── AGENTS.md          ← this file (the constitution)
├── index.md           ← master catalog of all wiki pages
├── log.md             ← append-only chronological log
├── raw/
│   ├── sources/       ← immutable source documents (never modify)
│   └── assets/        ← downloaded images, attachments
└── wiki/
    ├── people/        ← one page per person Jack knows
    ├── philosophy/    ← Jack's beliefs, frameworks, mental models
    ├── goals/         ← current and past goals, projects, ambitions
    └── concepts/      ← ideas, topics, research areas
```

## Page Conventions

### People pages (`wiki/people/NAME.md`)
```markdown
# [Full Name]
**Relationship:** [how Jack knows them]
**Context:** [where/how they met]
**Last updated:** YYYY-MM-DD

## Overview
[1-2 sentence summary]

## Notes
[key things to remember]

## Connections
- [[Other Person]] — [how they're connected]

## Sources
- [source file or date]
```

### Philosophy pages (`wiki/philosophy/TOPIC.md`)
```markdown
# [Belief / Framework / Mental Model]
**Category:** [values | frameworks | worldview | lessons]
**Last updated:** YYYY-MM-DD

## Core idea
[crisp statement of the belief]

## Where this comes from
[origin — experience, book, person, etc.]

## How Jack applies this
[practical expression]

## Tensions
[what this belief conflicts with]

## Related
- [[Other philosophy page]]
```

### Goal pages (`wiki/goals/GOAL.md`)
```markdown
# [Goal Name]
**Status:** [active | completed | abandoned | paused]
**Horizon:** [short-term | medium-term | long-term]
**Last updated:** YYYY-MM-DD

## What
[what Jack is trying to achieve]

## Why
[the underlying motivation]

## Progress
[current state]

## Obstacles
[what's in the way]

## Related
- [[Relevant people, concepts, philosophy]]
```

### Concept pages (`wiki/concepts/TOPIC.md`)
```markdown
# [Concept / Idea / Research Area]
**Last updated:** YYYY-MM-DD

## Summary
[crisp explanation]

## Why Jack cares
[relevance to his life/work]

## Key insights
[bullet points of what's been learned]

## Open questions
[what's still unknown or unresolved]

## Sources
- [[source]]

## Related
- [[Related pages]]
```

## Operations

### Ingest
When Jack provides a new source:
1. Read the source carefully
2. Discuss key takeaways with Jack
3. Write a summary in `raw/sources/YYYY-MM-DD-title.md`
4. Identify which wiki pages need creating or updating (typically 5-15)
5. Create/update those pages with extracted knowledge
6. Update `index.md` with any new pages
7. Append an entry to `log.md`

**On contradictions:** Never silently overwrite. If new info contradicts existing wiki, flag it explicitly in the page with a `> ⚠️ Conflict:` blockquote and note both claims with sources.

**On granularity:** Create a dedicated page when a person/concept/goal has more than 3 meaningful things to say about it. Otherwise, a mention + link in a related page is enough.

### Query
When Jack asks a question:
1. Read `index.md` to find relevant pages
2. Read those pages
3. Synthesize an answer with citations to wiki pages
4. If the answer is valuable and reusable, offer to file it as a new wiki page

### Lint
When Jack asks for a health check:
- Flag contradictions between pages
- Identify orphan pages (no inbound links)
- Note stale pages that newer sources have superseded
- Suggest missing pages for frequently-mentioned concepts
- Suggest new sources to seek out

## Index & Log conventions

### index.md format
```markdown
## People
- [[people/NAME]] — one-line summary

## Philosophy
- [[philosophy/TOPIC]] — one-line summary

## Goals
- [[goals/GOAL]] — status + one-line summary

## Concepts
- [[concepts/TOPIC]] — one-line summary
```

### log.md format
Each entry starts with: `## [YYYY-MM-DD] TYPE | Title`
Types: `ingest`, `query`, `lint`, `update`

## Tone & Style
- Write in third person about Jack ("Jack believes...", "Jack met X at...")
- Be specific — names, dates, places when known
- Keep pages dense but readable — no filler
- Cross-link aggressively — every name, concept, goal mentioned should link to its page if one exists
- Provenance matters — note where every claim came from
