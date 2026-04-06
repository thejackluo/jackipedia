# [[history/ces]] NVIDIA Keynote Analysis

**Published:** January 24, 2026 — Medium
**Type:** Technical analysis / conference notes
**Rating:** 2 Stars
**Source:** [Read on Medium](https://thejackluo8.medium.com/ces-2026-nvidia-keynote-33960ee9fbef)

## Overview

[[people/jack-luo]]'s detailed writeup of NVIDIA's CES 2026 keynote by Jensen Huang — one of his most technically dense Medium pieces, published from Las Vegas during the CES trip.

## NVIDIA's Core Argument

The keynote framed AI as the next foundational computing platform — the latest in a sequence: mainframes, PCs, Internet, cloud, mobile, now AI.

The key difference this cycle: applications are not "using" AI as a feature. They are built on top of AI models as the core runtime. This is driving a reinvention of the full five-layer computing stack:

- Software is trained rather than hand-programmed
- GPUs replace CPUs as primary compute
- Applications generate outputs (tokens, pixels, decisions) dynamically rather than executing pre-compiled logic

**Market framing:** $10 trillion of existing compute infrastructure being modernized toward AI-centric architectures. Hundreds of billions in annual venture funding. $100T global industry re-allocating R&D toward AI methods.

## AI Timeline (Huang's Version)

| Year | Milestone |
|------|-----------|
| 2015 | BERT — first language model Huang believed would be truly transformative |
| 2017 | Transformers introduced |
| 2022 | [[history/chatgpt-senior-year]] — "awakened the world" |
| 2024 | First O1-style reasoning model — "test-time scaling" (models think longer at inference) |
| 2025 | Full agentic systems: reason, call tools, plan multi-step workflows, simulate outcomes |

## Open Model Strategy

NVIDIA operates large DGX Cloud AI supercomputers for its own frontier research, not as a generic cloud provider. Key stance: releasing models and training data openly.

**Domain-specific open models shown:**
- Digital biology: protein design systems, EVO2 (multi-protein interactions)
- Physics/climate: Earth2AI, ForecastNet, CorrDiff (accelerated weather simulation)
- Language/reasoning: Nemotron 3 (hybrid Transformer/SSM, fast + strong reasoning)
- World model: Cosmos — understands how the physical world works, aligned with language
- Robotics: Groot (humanoid locomotion), AlphaMile (self-driving)

## Agentic Architecture

The standard pattern NVIDIA described for modern AI applications:

1. Smart routing layer inspects user intent
2. Routes subtasks to the most appropriate model (frontier + domain-specific)
3. Multi-model, multi-cloud, hybrid by design
4. Agent understands text, speech, images, video, 3D, PDFs, proteins
5. Agent is both interface and orchestrator

Applications announced: Palantir, ServiceNow, Snowflake, CrowdStrike, NetApp — each embedding NVIDIA agent frameworks as the new front door.

## Physical AI

Three classes of computers required:
1. Massive training systems
2. Inference computers at the edge (robots, cars, factories, hospitals)
3. Simulation computers for digital twins and evaluation

**Synthetic data breakthrough:** Cosmos and simulators generate synthetic, physically plausible video conditioned on accurate physics — turning compute into training data, covering long-tail edge cases for robotics and autonomy that real-world capture can't reach.

**EDA partnerships:** Synopsys and Cadence integrating NVIDIA AI into chip design, physical design, emulation, verification. Siemens integrating CUDA-X, physical AI, and Omniverse across the full industrial lifecycle.

## Jack's Takeaway

Jack attended this keynote in person at CES 2026. His analysis shows how seriously he tracks AI infrastructure — this is not summarizing a blog post but engaging with the architecture of what NVIDIA is building and why it matters for the agent layer he is working on at [[projects/agent-school]].

The agentic architecture Huang described — routing, multi-model, hybrid — maps directly onto the infrastructure decisions in [[projects/agentdex]] (Bedrock fallback to Anthropic fallback to OpenAI).

## Related

- [[concepts/ai-interactive-storytelling]]
- [[concepts/agent-x-launch]]
- [[projects/agentdex]]
- [[projects/ces-2025]]
- [[history/travel]]
