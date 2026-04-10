# AgentDex

<table class="infobox">
<caption>AgentDex</caption>
<tr><th class="infobox-image" colspan="2">
<img src="/assets/photos/startup-is-resumed.jpg" alt="AgentDex development">
<span class="infobox-caption">AgentDex in development, early 2026</span>
</th></tr>
<tr><th class="infobox-section" colspan="2">Project overview</th></tr>
<tr><th class="infobox-label">Also known as</th><td class="infobox-data">ROLO</td></tr>
<tr><th class="infobox-label">Type</th><td class="infobox-data">Personal CRM / Relationship intelligence</td></tr>
<tr><th class="infobox-label">Status</th><td class="infobox-data">🟢 Active</td></tr>
<tr><th class="infobox-label">Launched</th><td class="infobox-data">April 1, 2026</td></tr>
<tr><th class="infobox-label">Founded</th><td class="infobox-data">Mid-2024</td></tr>
<tr><th class="infobox-section" colspan="2">Technical</th></tr>
<tr><th class="infobox-label">Stack</th><td class="infobox-data">Next.js, PostgreSQL, Drizzle ORM</td></tr>
<tr><th class="infobox-label">Auth</th><td class="infobox-data">Clerk</td></tr>
<tr><th class="infobox-label">Hosting</th><td class="infobox-data">AWS / Nixpacks</td></tr>
<tr><th class="infobox-label">Repo</th><td class="infobox-data"><a href="https://github.com/agent-school/agentdex">agent-school/agentdex</a></td></tr>
<tr><th class="infobox-section" colspan="2">People</th></tr>
<tr><th class="infobox-label">Founder</th><td class="infobox-data"><a href="/wiki/people/jack-luo.html">Jack Luo</a></td></tr>
<tr><th class="infobox-label">Collaborator</th><td class="infobox-data"><a href="/wiki/people/arman-mahjoor.html">Arman Mahjoor</a></td></tr>
<tr><th class="infobox-label">Advisor</th><td class="infobox-data"><a href="/wiki/people/kunal-gupta.html">Kunal Gupta</a></td></tr>
</table>

**AgentDex** (also known as ROLO) is [[people/jack-luo]]'s primary startup — a relationship intelligence platform and personal CRM positioned as "the Rolodex for the AI age." The core product helps users manage contacts, meetings, and relationships using AI extraction, calendar integration, and a typed relationship graph — with minimal manual overhead.

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

![Agentdex commit analysis - Jack at 1am still building](/assets/photos/agentdex-commit-analysis.jpg)


![OpenCode session tracking March dev log](/assets/photos/opencode-dev-log.jpg)

Jack's OpenCode session log for March 2026 - days like March 26 logged 76 turns in a single session. March 27: 299 turns. The kind of data that only accumulates when you don't stop.

## Project History

| Date | Event |
|------|-------|
| Jun–Sep 2024 | Mira project (predecessor/parallel work) |
| Sep 2024 | MAGK customer discovery begins |
| Oct–Nov 2024 | Technical architecture decisions |
| Dec 2024 | Product ideas and MVP planning meetings |
| Jan 2026 | Customer discovery sprint (25+ interviews, CD series) |
| Feb 2026 | Team formed: [[people/arman-mahjoor]], Karthik Jandhyala onboarded |
| Mar 28, 2026 | Codebase architecture review (Granola meeting) |
| Mar 31, 2026 | Targeted launch date (AgentDex public launch) |
| Apr 1, 2026 | Official launch |

## Customer Discovery Sprint (Jan–Feb 2026)

Jack ran a structured 26-interview customer discovery sprint in January-February 2026. Key findings:

- **Champion:** Nimesh (hotel operator, 3 owned + 20+ managed, Best Western network)
- **Non-ICP contacts** who made intros: [[people/manas-nair]] (sales co-founder intro)
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

This is the "overnight agent harness" architecture - AI agents handle small bugs automatically, humans handle architecture decisions.

## Name History

- **MAGK** - early codename during customer discovery
- **AgentDex** - the technical project name (GitHub, Coolify, domain)
- **ROLO** - product name for the Vercel/consumer version (rolo.agentschool.io)

## Related
- [[people/arman-mahjoor]]
- [[people/kevin-zhang]]
- [[people/karthik-jandhyala]]
- [[people/jack-luo]]
- [[projects/mira]]
- [[projects/agent-school]]
- [[history/georgia-tech-era]]
- [[concepts/notion]]
- [[concepts/linear]]

## Development Photos

![Gather Town, January 2026 — virtual team space during AgentDex development](/assets/photos/gather-town-jan2026.jpg)

![OpenCode dev log March 2026 — AI-assisted sessions, 299 messages on Mar 27](/assets/photos/agentdex-opencode-log-march.jpg)

![AgentDex dev session — deep work](/assets/photos/agentdex-dev-session.jpg)

![Startup financials class — studying financial modeling](/assets/photos/startup-financials-class.jpg)

![Startup class notes — financial modeling coursework](/assets/photos/startup-class-notes.jpg)
