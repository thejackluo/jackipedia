# Granola

**Category:** Concepts / Tools
**Website:** granola.ai
**Summary:** AI meeting notes tool Jack uses for all meeting transcription and summaries
**Last updated:** 2026-04-06

## Overview

Granola is an AI-powered meeting notes tool that runs on macOS, listens to meetings (via system audio capture), and produces structured AI summaries automatically. Jack uses it as his primary meeting documentation system — the Notion meetings database is full of entries tagged "Source: Granola."

## How It Works

Granola runs in the background during a call. You don't need to share a bot link or invite anyone — it captures the audio directly from your Mac's system output. After the meeting, it produces a transcript and structured summary with:

- Summary of what was discussed
- Decisions made
- Action items
- Key quotes

Jack's Notion meetings database shows the Granola fingerprint clearly: entries have "Confidence: AI Summarized" and a link back to `notes.granola.ai/t/[meeting-id]`. The summaries are then manually reviewed and tagged ("Source: Granola" → cleaned → "Status: Cleaned").

## Why It Matters to Jack's System

Jack runs a dense meeting schedule and documents everything. Before tools like Granola, meeting notes were either manual (slow, incomplete) or neglected (never written). Granola makes high-quality documentation nearly automatic.

The result is the meetings database in [[concepts/jotion]]: dozens of structured entries with action items, decisions, and summaries that can be queried, searched, and cross-referenced. This is the raw material for Jackipedia's history and people sections.

The March 28 meeting entry ("Codebase architecture + onboarding story") and the March 27 entry ("Personal Development, Crisis Management & Agent X Launch") are both Granola-sourced. They contain verbatim action items and decisions that read like they were structured by the AI and then cleaned by Jack.

## The Broader Tools Philosophy

Granola is one node in a stack of tools Jack uses to reduce friction between experience and documentation:

- **Granola** → meeting notes
- **Notion** → personal OS (Jotion V4.5)
- **Jackipedia** → public-facing knowledge base built from the Notion data
- **Strava** → run logging (used during the 2021 running project)
- **Flighty** → flight tracking (76 flights documented)

The pattern: every significant experience gets captured in a structured system. The structured systems talk to each other. Jackipedia is the rendered output.

## Product Notes

Granola launched in 2023 and has grown quickly in the founder/knowledge worker segment. It competes with tools like Otter.ai, Fireflies, and tl;dv. Its differentiation: no bot join required, cleaner UI, better AI summaries, and deeper integration with macOS.

It is venture-backed and actively developing. The core insight — meeting notes should be automatically generated and structured, not manually taken — is correct and will persist regardless of which tool wins.

## Related

- [[concepts/jotion]]
- [[people/jack-luo]]
- [[projects/agentdex]]
- [[people/arman-mahjoor]]
