# Agents in the Long Game of AI

**Category:** Books
**Authors:** Marjorie McShane, Sergei Nirenburg, Jesse English
**Rating:** 5/5
**Status:** Completed
**Category:** AI
**Last updated:** 2026-04-06

## Overview

"Agents in the Long Game of AI" is a book by Marjorie McShane, Sergei Nirenburg, and Jesse English. Jack rated it 5 stars - one of his highest-rated books and the only 5-star AI book in the Notion media database. For someone building AI agents at [[projects/agentdex]] and contributing to the MIT SIPB Arc Project (agentic architecture), this is not a casual read.

## What the Book Argues

McShane and Nirenburg are cognitive scientists and computational linguists who have been working on AI since before the deep learning era. Their central argument: the field of AI has been seduced by pattern matching (deep learning, large language models) at the expense of genuine reasoning, knowledge representation, and cognitive modeling.

The "long game" of the title refers to the long-term goal of building machines that actually understand - not machines that are very good at predicting the next token in a sequence. Their position: current AI systems are impressive but brittle, and the path to genuine intelligence runs through knowledge-grounded reasoning, not bigger models on more data.

This is a minority view in mainstream AI. It is also a serious one: McShane and Nirenburg have decades of work on knowledge representation and natural language understanding. Their critique of LLM-based approaches is technically grounded, not just philosophical.

## Why Jack Rated It 5 Stars

Five stars in Jack's Michelin-influenced system means: exceptional, worth a special journey. For an AI book in 2025–2026, when LLMs dominate everything, rating a book that argues LLMs are not the long-game solution at 5 stars is itself a statement.

Jack is building AI agents - [[projects/agentdex]] uses AI routing (Bedrock → Anthropic → OpenAI), the MIT SIPB Arc Project is working on agentic architecture. He has opinions about what agents actually need to do well. A book that argues for deeper cognitive grounding vs. pure pattern matching would resonate with someone building systems that need to actually understand relationship context, not just predict likely responses.

## The Agent Architecture Problem

The book's core challenge for practitioners: how do you build an agent that doesn't just do things but understands what it's doing and why?

Current LLM-based agents are powerful but have specific failure modes:
- **Hallucination**: generating plausible-sounding but incorrect information
- **Context fragility**: losing track of long-term context and goals
- **No genuine memory**: each conversation starts fresh without persistent state
- **No causal reasoning**: can describe correlations, struggle with causation

McShane and Nirenburg's framework - grounded in cognitive science and knowledge representation - addresses these failure modes directly. Whether their approach scales is a separate question. The diagnosis is correct.

## Connection to AgentDex

[[projects/agentdex]] is fundamentally an agent system: an AI that understands your relationships, tracks context over time, and surfaces relevant information at the right moment. This is exactly the use case where McShane and Nirenburg's concerns are most relevant. A personal relationship agent that hallucinates or loses long-term context is not just useless - it's actively harmful.

Jack's Medium writing on "hierarchical memory and adaptive state management for an AI agent" (published on Medium @thejackluo8) addresses the same problem from the practitioner side.

## Related

- [[projects/agentdex]]
- [[concepts/jotion]]
- [[books/goodreads]]
- [[people/jack-luo]]
