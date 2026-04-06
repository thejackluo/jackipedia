# AgentDex Launch (April 2026)

**Category:** Projects / History
**Date:** April 1, 2026
**Summary:** The public launch of AgentDex — also called "Agent X" in pre-launch planning
**Last updated:** 2026-04-06

## Overview

AgentDex launched publicly on April 1, 2026. In pre-launch planning (documented in Notion meetings), the launch was codenamed "Agent X." The target was 100 emails collected before launch day, with an email blast and LinkedIn promotion planned for the launch itself.

## Pre-Launch Strategy

A March 27, 2026 Notion meeting titled "Personal Development, Crisis Management & Agent X Launch" documents the pre-launch decisions:

- **No paid ads or UGC creators** for the test launch — purely organic
- **Growth strategy**: waitlist → email blast → LinkedIn
- **100 emails** as the target before April 1
- **Waitlist website** to be set up before launch

The decisions reflect a lean, organic-first launch philosophy: build a list, launch to the list, then use the launch signal to justify the next phase of growth. No ad spend before product-market fit.

## The April 1 Date

Launching on April Fools Day is either a bold move or an accident. For a product called AgentDex (later ROLO) — a personal CRM with AI — launching on April 1 means every headline about your launch gets the "is this a joke?" question. The risk is that people don't take it seriously. The potential upside is that a product that genuinely delivers will stand out sharply against the noise of April Fools announcements.

The Notion meeting on April 1 (pitch deck feedback notes) shows Jack was already in investor conversation mode by launch day — reviewing pitch mechanics, planning the financial model, preparing for VC meetings. The launch was not the end point but the beginning of the fundraising narrative.

## Pitch Deck Context

The April 1 meeting entry ("Pitch deck feedback notes — Problem/Solution, Team, Market, Mechanics") documents Jack's distilled learnings from investor pitch review:

- **Quantify customer pain + research** before presenting solutions
- **Map solution directly to pain** — no abstract value props
- **Place team slide early** (after problem/solution, not at the end)
- **Keep market sizing logic simple** — comparable companies, unit economics
- **Avoid live demos** — pre-record instead
- **Keep slides visual** with minimal text
- **Be authentic about unknowns**

These are standard VC pitch mechanics but they suggest Jack had real VC feedback sessions by launch day — not just working from templates.

## What AgentDex Is

Full coverage at [[projects/agentdex]]. The short version: a personal CRM and relationship intelligence platform — "the Rolodex for the AI age" (hence ROLO). Core product: AI-powered contact management that tracks relationship context, surfaces relevant information at the right moment, and reduces the manual overhead of maintaining a professional network.

The technical stack: Next.js, Clerk auth, Postgres on Neon, AI routing through Bedrock → Anthropic → OpenAI, deployed via Coolify on worker-vps-1 (agentdex.agentschool.io) and Vercel for the ROLO variant (rolo.agentschool.io).

## After Launch

Post-launch state: PRs open for auth fixes (PR #172, clerk sign-in fix) and build fixes (PR #193, Coolify deployment fix). The launch was the beginning of the public phase, not the end of the build phase.

## Related

- [[projects/agentdex]]
- [[concepts/hackathon-circuit]]
- [[concepts/z-fellows]]
- [[concepts/y-combinator]]
- [[people/arman-mahjoor]]
- [[people/jack-luo]]
