# Hongyin (Subconscious)
**Type:** Person
**Relationship to Jack:** Technical collaborator
**Last updated:** 2026-04-06

## Overview

Hongyin works at or with a project called Subconscious. Jack met with them on January 28, 2026, during the same week as the customer discovery sprint. The focus was workflow caching - a specific technical area at the intersection of AI agent systems and performance optimization.

## The Meeting (January 28, 2026)

From Notion:
> "Collab in person on workflow caching next week."

The meeting was a planning session for a hands-on technical collaboration the following week. The topic - workflow caching - is a specific problem in AI agent systems: how to avoid re-executing expensive operations (LLM calls, tool uses) by caching intermediate states and resuming from checkpoints.

## Subconscious

Subconscious is likely a reference to a project in the second-brain / knowledge graph space. The name matches the aesthetic of personal knowledge management tools (roam-like, networked notes, externalized cognition). This would make the workflow caching collaboration thematically coherent: Jack is building agentic systems that need memory and context persistence; Subconscious is building infrastructure for external memory. The intersection is real.

## Technical Relevance

Workflow caching in agent systems is non-trivial. Key problems:
- Deterministic replay: can you re-run a partially completed agent from a checkpoint?
- Context invalidation: when does a cached intermediate state become stale?
- Tool-call deduplication: how do you avoid re-executing side-effectful operations on resume?

Jack's Medium post on "Hierarchical Memory and Adaptive State Management for an AI Agent" (referenced on his website) suggests he was already thinking deeply about these problems. Hongyin is a collaborator who appears to be working on adjacent infrastructure.

## Related
- [[people/jack-luo]]
- [[people/meetings-index]]
- [[writings/browser-agents-drl]]
