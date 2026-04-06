# Improving Browser Autonomous Agents with Deep Reinforcement Learning and Memory (11/05/25)
**Rating:** 3 Stars
**Date:** November 5–6, 2025
**Notebook:** Academic/Essay
**Tags:** Academic, Essay
**Last updated:** 2026-04-06

## Overview

A technical essay written in November 2025 proposing four concrete improvements to browser-based AI agents (web automation tools like Comet, Composite, Fellou). This is Jack's most technically rigorous piece of writing in the archive — rated 3 Stars. It reads as a genuine product and research proposal, not just speculation.

## Context

> "As we enter the age of web agents, we are bombarded with new software releases every few days like Comet, Composite, Fellou. All of these software promises to automate our everyday tasks (with way too many of them using travel planning as an example). However, current approaches to automating user tasks are very slow: Large Language Models would often take 5 or more seconds to take a single action such as a button press or scroll."

Jack focuses his analysis on **Composite** as the leading browser automation platform of the time.

## How Current Web Agents Work

> "Essentially, these agents take your prompt, create a plan, take a screenshot, analyze elements, and then decide the next step based on the picture. I also believe there's a combination of taking a picture and analyzing the div elements as well."

## Four Proposed Improvements

### 1. Deep Reinforcement Learning for Low-Level Actions

Use DRL to train fast, narrow models for specific sub-actions (scrolling, button finding) rather than using large LLMs for everything:

> "I would propose deep reinforcement learning for specific actions, like scrolling, finding buttons. Instead of training the AI to do arbitrary tasks, it would train to do tasks like finding buttons or sorting them down (basic actions that should be fast). That way, when the AI makes large plans, it will make it much easier as well."

Rationale: LLMs are good general models but overkill for deterministic micro-actions. A narrow RL model trained on these basic interactions would be much faster.

### 2. Mixing Deterministic and Probabilistic Search

Not all web navigation requires AI. Many tasks (finding a specific button, locating financial data) can be handled by classical deterministic search, reserving AI for genuinely ambiguous states:

> "A lot of search in websites could be done with 'Find every place' right? This is true in financial modeling and finding data. This is also true in finding the book button, etc. And I think in these moments, it's crucial to actually not use AI as much unless an office has a chance that you know you need to use AI."

Benefits: reduces compute intensity, makes the agent's job easier, faster execution.

> "Right now, large language models are being used for everything because it's a good general thing, but I think there is definitely optimization that could be done."

### 3. Soft Learning Through Asking Questions

Users repeat similar tasks with similar preferences. Agents should learn these over time by occasionally asking:

> "Perhaps an AI can ask a user whether it thinks that this is going to be something they will need help with in the future or this is one-off."

> "These small questions could help tailor the AI to have better preferences over time. Recently, I've seen Wispr Flow implement this."

### 4. Dynamic Workflow Templates

For power users, agents should support abstract workflow templates — reusable policies for common task types:

> "If people or users want to be power users in the future, I think there should be the ability to create power workflows for the different types of tasks, like travel planning or writing an essay, etc. This is similar to having an abstract class in computer science, except in this case you're creating workflows instead. It's like creating a policy for these AI agents."

## Significance

This essay demonstrates Jack's ability to think at multiple levels of abstraction simultaneously — from RL theory to UX design to product strategy — and synthesize them into concrete proposals. It predates many features that were later built into web agent products (workflow templates, preference learning).

## Related
- [[concepts/writing-archive]]
- [[goals/agentdex]]
- [[people/jack-luo]]
