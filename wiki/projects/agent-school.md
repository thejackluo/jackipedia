# Agent School


<table class="infobox">
<caption>Agent School</caption>
<tr><th class="infobox-section" colspan="2">Project</th></tr>
<tr><th class="infobox-label">Type</th><td class="infobox-data">Infrastructure / Organization</td></tr>
<tr><th class="infobox-label">URL</th><td class="infobox-data"><a href="https://agentschool.io">agentschool.io</a></td></tr>
<tr><th class="infobox-label">Status</th><td class="infobox-data">Active</td></tr>
<tr><th class="infobox-section" colspan="2">Details</th></tr>
<tr><th class="infobox-label">Operator</th><td class="infobox-data"><a href="/wiki/people/jack-luo.html">Jack Luo</a></td></tr>
<tr><th class="infobox-label">Location</th><td class="infobox-data">MIT E38-379, Cambridge MA</td></tr>
<tr><th class="infobox-label">Services</th><td class="infobox-data">Paperclip, Jackipedia, AgentDex</td></tr>
</table>


**Category:** Projects / Infrastructure
**URL:** agentschool.io
**Summary:** The infrastructure umbrella for Jack's AI agent ecosystem - Paperclip, Jackipedia, and more
**Last updated:** 2026-04-06

## Overview

Agent School is the organizational umbrella and domain (agentschool.io) under which Jack runs his AI agent infrastructure. It is not a single product but a collection of tools, services, and experiments related to AI agents and intelligent automation.

## What Agent School Is

The agentschool.io domain hosts several active properties:

| Subdomain | Product | Description |
|-----------|---------|-------------|
| agentdex.agentschool.io | AgentDex | The main CRM product, deployed via Coolify on worker-vps-1 |
| rolo.agentschool.io | ROLO | Vercel-deployed variant with Clerk auth |
| paperclip.agentschool.io | Paperclip | Internal AI/agent management tool |
| jackipedia.agentschool.io | Jackipedia | This wiki |

## Paperclip

Paperclip is an AI agent management platform running at paperclip.agentschool.io (also accessible at the server's internal port 3100). It runs via Docker Compose on the main OpenClaw server at 52.12.222.191.

Paperclip's exact functionality is internal-facing - it's a tooling and management layer for running AI agents, not a consumer product.

## The Infrastructure Stack

The Agent School infrastructure includes:
- **OpenClaw server**: AWS Lightsail, 52.12.222.191, 2 vCPU, 3.7GB RAM, 4GB swap
- **Worker VPS**: 54.205.100.7 (worker-vps-1), 61GB RAM - main dev/coding machine
- **Coolify**: deployment platform running on worker-vps-1, manages AgentDex containers
- **Neon**: Postgres database provider (used by AgentDex API server)
- **Clerk**: authentication provider (used by ROLO variant)
- **Bedrock → Anthropic → OpenAI**: the AI routing chain in AgentDex

## The Name

"Agent School" suggests an environment where agents learn, develop, and operate. It positions the umbrella as educational and developmental - not just a collection of tools but a system for building and running AI that gets smarter over time.

The name is also a branding surface: agentschool.io is memorable and relevant in the current AI agent moment. As AI agents become a mainstream category (2024–2026), having "agent" in the domain is a positioning asset.

## Connection to AgentDex

[[projects/agentdex]] is the main product; Agent School is the platform it runs on. The distinction matters: AgentDex is the thing users interact with; Agent School is the infrastructure layer that makes it possible to run, iterate, and deploy multiple experiments simultaneously.

The relationship between Agent School and AgentDex is similar to the relationship between AWS and a specific application: one provides the substrate, the other provides the value.

## Related

- [[projects/agentdex]]
- [[projects/jackipedia]]
- [[people/jack-luo]]
- [[concepts/granola]]
- [[concepts/jotion]]

## Photos

![Agent School door at night — the workspace where it all happens](/assets/photos/agent-school-door-night.jpg)

![Agent School room — interior setup](/assets/photos/agent-school-room.jpg)

![Agent School door — hand-lettered sign reads "AGENT SCHOOL"](/assets/photos/agent-school-e38-379-door.jpg)

![Agent School room E38-379 — Jack building at desk, MIT campus](/assets/photos/agent-school-e38-379-room.jpg)

![Instagram story: "If you are in agent school get grinding :)"](/assets/photos/agent-school-startup-resumed-story.jpg)
