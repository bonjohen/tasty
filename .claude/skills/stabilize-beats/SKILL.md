---
name: stabilize-beats
description: "Runs the Beat Expansion decision pass to assess whether a book's beats are stable enough for section expansion. Analyzes each beat's structure, recommends splits or braiding, and produces the beat-to-section coverage plan. Use when the user asks to stabilize beats, check beat readiness, or prepare for section expansion."
argument-hint: "[book-name]"
user-invocable: true
---

Run the beat stabilization analysis. This is the gate between beat work and serious section expansion.

## Step 0: Determine Target Book

Resolve which book to analyze; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, if only one book exists under `books/`, use it. If multiple, ask the user which.

## Steps

1. **Check prerequisites.** Read `{book}/docs/15_beats.md`. If it doesn't exist, stop: "No beat file found for this book. Generate beats first with `/generate-beats {book-name}`."

2. **Spawn the beat-analyzer agent.** Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt:

   Prompt: "Analyze the beat file for structural stability. Book root: {book}. Read {book}/docs/15_beats.md, {book}/docs/story_concept.md (if exists), {book}/docs/characters.md (if exists), and {book}/docs/open_questions.md (if exists). Run the full Beat Expansion decision pass on each beat and return the stability assessment with beat-to-section coverage plan."

   Wait for the agent to return.

3. **Review the analysis.** Present the agent's report to the user:
   - The per-beat expansion recommendations
   - The beat-to-section coverage plan
   - The stability verdict and any blockers
   - The recommended section count

4. **Ask for user decision.** Based on the analysis:

   If the agent recommends **Stable**: "The beat structure appears stable. Would you like to mark it as Stable and begin section expansion? Or review specific beats first?"

   If the agent recommends **Provisional** (with blockers): "These issues need resolution before beats can be stabilized: [list blockers]. Would you like to address them now?"

   If the agent recommends **Exploratory**: "The beat structure has significant unresolved elements. Recommend continuing discovery/convergence work before attempting stabilization."

5. **If user approves Stable:** Update the beat status header in `{book}/docs/15_beats.md` from its current status to **Stable**. Also update the beat-to-section mapping table if the agent produced one.

6. **If user approves Locked:** Update the beat status header to **Locked**. This means: beats will not change without explicit user instruction. Section expansion can proceed as authoritative.

## What This Does NOT Do

- Does not generate or modify beats (use `/generate-beats` for that)
- Does not generate section outlines (use `/expand-sections` for that)
- Does not resolve open questions (that's a conversation with the user)

This skill is purely analytical: it assesses the current state and recommends a status.
