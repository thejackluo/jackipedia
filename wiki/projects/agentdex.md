# AgentDex (ROLO / Agent Text)
**Category:** Project
**Status:** Active (launched April 1, 2026)
**Last updated:** 2026-04-06

## Overview

AgentDex is Jack's primary startup — a relationship intelligence platform positioned as "the Rolodex for the AI age." Also known as ROLO and "Agent Text." The core product: a personal CRM that uses AI to help users manage their relationships, contacts, and communication patterns with minimal manual overhead.

Jack has been building this since at least mid-2024. It went to production April 6, 2024 (first version), and publicly launched April 1, 2026.

## Product

**The problem:** People have hundreds of contacts, meetings, and ongoing relationships but no reliable system for tracking them. Existing CRMs are built for sales teams, not individuals. Important relationships decay because there's no system to maintain them.

**The solution:** An AI-powered personal CRM that:
- Imports contacts and calendar from Google (single OAuth connection)
- Surfaces relationship health and follow-up reminders
- Tracks meeting history and key facts about contacts
- Routes AI requests across Bedrock, Anthropic, and OpenAI

**Tech stack:**
- Frontend: Next.js (app router)
- Backend: Next.js API server
- Database: Postgres on Neon
- Auth: Clerk
- AI routing: Bedrock → Anthropic → OpenAI
- Deployment: Coolify on worker-vps-1 (agentdex.agentschool.io) and Vercel (rolo.agentschool.io)

## The Night Shift

![Agentdex commit analysis — Jack at 1am still building](/assets/photos/agentdex-commit-analysis.jpg)

A late-night AI analysis of the agentdex-v1 commit log, March 2026. The "Jessica Incident" refers to a persona Jack added to the codebase at 10pm, deleted at 1:35am after an existential crisis, then restored 21 minutes later. She's still in the repo today.

![OpenCode session tracking March dev log](/assets/photos/opencode-dev-log.jpg)

Jack's OpenCode session log for March 2026 — days like March 26 logged 76 turns in a single session. March 27: 299 turns. The kind of data that only accumulates when you don't stop.

## Project History

| Date | Event |
|------|-------|
| Jun–Sep 2024 | Mira project (predecessor/parallel work) |
| Sep 2024 | MAGK customer discovery begins |
| Oct–Nov 2024 | Technical architecture decisions |
| Dec 2024 | Product ideas and MVP planning meetings |
| Jan 2026 | Customer discovery sprint (25+ interviews, CD series) |
| Feb 2026 | Team formed: Arman Mahjoor, Karthik Jandhyala onboarded |
| Mar 28, 2026 | Codebase architecture review (Granola meeting) |
| Mar 31, 2026 | Targeted launch date (Agent Text public launch) |
| Apr 1, 2026 | Official launch |

## Customer Discovery Sprint (Jan–Feb 2026)

Jack ran a structured 26-interview customer discovery sprint in January-February 2026. Key findings:

- **Champion:** Nimesh (hotel operator, 3 owned + 20+ managed, Best Western network)
- **Non-ICP contacts** who made intros: Manas Nair (sales co-founder intro)
- **Team recruit:** Arman Mahjoor (CD 8, became collaborator)
- **Insight:** Pain points vary sharply by user type (investors, hotel operators, founders, sales professionals)

## Architecture (March 2026)

From the March 28 team sync (Granola):
- Next.js app router + API server
- Postgres on Neon (serverless)
- AI routing: starts with Bedrock, falls back to Anthropic, then OpenAI
- Story 4.6 proposed: single Google connection to import both Calendar and Contacts at onboarding

## Decisions Made

From March 28 meeting:
> "Prioritize larger features vs small fixes; delegate small fixes to AI agents; proceed with Story 4.6 onboarding enhancement."

This is the "overnight agent harness" architecture — AI agents handle small bugs automatically, humans handle architecture decisions.

## Name History

- **MAGK** — early codename during customer discovery
- **AgentDex** — the technical project name (GitHub, Coolify, domain)
- **ROLO** — product name for the Vercel/consumer version (rolo.agentschool.io)
- **Agent Text** — the public-facing launch name

## Related
- [[people/arman-mahjoor]]
- [[people/kevin-zhang]]
- [[people/karthik-jandhyala]]
- [[people/nimesh]]
- [[people/jack-luo]]
- [[projects/mira]]
