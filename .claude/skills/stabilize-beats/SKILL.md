---
name: stabilize-beats
description: "Runs the Beat Expansion decision pass to assess whether beats are stable enough for section expansion. Analyzes each beat's structure, recommends splits or braiding, and produces the beat-to-section coverage plan. Use when the user asks to stabilize beats, check beat readiness, or prepare for section expansion."
user-invocable: true
---

Run the beat stabilization analysis. This is the gate between beat work and serious section expansion.

## Steps

1. **Check prerequisites.** Read `docs/15_beats.md`. If it doesn't exist, stop: "No beat file found. Generate beats first with `/generate-beats`."

2. **Spawn the beat-analyzer agent.** Use the Agent tool:

   Prompt: "Analyze the beat file for structural stability. Read docs/15_beats.md, docs/story_concept.md (if exists), docs/characters.md (if exists), and docs/open_questions.md (if exists). Run the full Beat Expansion decision pass on each beat and return the stability assessment with beat-to-section coverage plan."

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

5. **If user approves Stable:** Update the beat status header in `docs/15_beats.md` from its current status to **Stable**. Also update the beat-to-section mapping table if the agent produced one.

6. **If user approves Locked:** Update the beat status header to **Locked**. This means: beats will not change without explicit user instruction. Section expansion can proceed as authoritative.

## What This Does NOT Do

- Does not generate or modify beats (use `/generate-beats` for that)
- Does not generate section outlines (use `/expand-sections` for that)
- Does not resolve open questions (that's a conversation with the user)

This skill is purely analytical: it assesses the current state and recommends a status.
