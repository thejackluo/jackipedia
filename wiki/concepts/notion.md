# Notion

**Category:** Concepts / Tools
**Summary:** The all-in-one workspace that became the default operating system for a generation of knowledge workers and startups
**Last updated:** 2026-04-06

## Overview

Notion is a note-taking, knowledge management, and project management tool founded in 2013 by Ivan Zhao and Simon Last. It launched publicly in 2016 and became one of the fastest-growing productivity tools in history, reaching a $10 billion valuation in 2021.

Notion's core insight: the rigid distinction between documents, spreadsheets, databases, and kanban boards is artificial. Everything is a block. Blocks can be combined into any structure you want. A page can contain a database. A database row can open into a full document. A database can be viewed as a table, a board, a gallery, a list, or a calendar.

For a certain generation of builders and knowledge workers, Notion became the place where everything lived.

## The Block Model

Notion's data model is unusually flexible. The base unit is a block:
- A paragraph is a block
- A heading is a block
- An image is a block
- A code snippet is a block
- A table row is a block
- A toggle is a block that contains more blocks

This composability means you can build almost any structure. The flip side is that an empty Notion page is intimidating — you have to decide what kind of structure you want before you can use it, which creates a design and organizational overhead that not every user wants.

## Databases

Notion databases are what separate it from simpler note-taking tools. A database in Notion is a collection of pages (rows) with shared properties. Properties can be text, numbers, dates, checkboxes, select/multi-select, relations to other databases, and formulas.

This makes it possible to build:
- CRM systems (contacts database linked to interactions database linked to companies)
- Project management (tasks database with status, assignee, deadline, priority)
- Content pipelines (articles database with stage, publish date, author, word count)
- Personal knowledge bases (notes linked to people, projects, and concepts)

The relational linking between databases — a task linked to a person linked to a project — is what makes Notion powerful for operational work.

## Why People Use It

**Startups:** Notion became the default for early-stage startups because it's cheap, flexible, and fast to set up. You can build a basic CRM, a project tracker, and a knowledge base in a few hours without any configuration. The product evolved from note-taking to full team operating system.

**Knowledge workers:** For people who do a lot of writing, research, and synthesis, Notion works well because the document and database models are unified. You can write a document that also queries a database. You can maintain a reading list that links to notes that link to people you discussed the book with.

**Personal operating systems:** "Second brain" culture — influenced by Tiago Forte's *Building a Second Brain* and the PARA method (Projects, Areas, Resources, Archive) — found Notion to be a natural home. The flexibility supports almost any personal knowledge management approach.

## Jotion: Jack's Notion System

Jack built Jotion — his personal OS running on top of Notion — extensively during 2024. Jotion V4.5 was a full personal operating system: tasks, goals, writing, reading, meetings, contacts, all connected in a single Notion workspace.

The appeal: Notion's database relational model is genuinely powerful for connecting context across domains. A meeting with a person links to everything known about that person, which links to projects you're working on together, which links to follow-ups from that meeting.

The limitation: Notion is slow at scale, its mobile experience has always been behind the desktop, and maintaining a complex system requires ongoing organizational work that competes with doing the actual work.

See [[concepts/jotion]] for the full documentation of Jack's Notion system.

## Notion AI

Notion added AI features in 2023 — writing assistance, summarization, Q&A over your workspace content, autofill for database properties. The Q&A feature (asking questions and getting answers drawn from your existing notes) is the most genuinely useful: it turns your knowledge base into a retrievable memory rather than a searchable archive.

The limitation is that Notion AI currently lacks deep reasoning and long-context understanding. It's useful for retrieval and summarization but not for complex inference across large knowledge bases.

## The Competition

Notion faces serious competition:
- **Obsidian** — Local markdown files, plugin ecosystem, graph view. Popular with users who want data portability and don't trust cloud-only storage.
- **Linear** — Replaced Notion for project management at many teams. Faster, more opinionated, better keyboard shortcuts.
- **Coda** — Similar block model, stronger formulas and automation.
- **Confluence** — Atlassian's documentation tool, still dominant in large enterprises despite being worse than Notion by most measures.
- **Roam Research** — Bidirectional linking, outliner model, popular with researchers and "networked thought" practitioners.

## Related

- [[concepts/jotion]]
- [[concepts/granola]]
- [[projects/jackipedia]]
- [[people/jack-luo]]
