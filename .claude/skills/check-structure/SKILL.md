---
name: check-structure
description: "Validates consistency across all story-structural files. Checks beat coverage, section completeness, concept-beat alignment, character arcs, continuity, and status hierarchy. Use when the user asks to validate structure, check consistency, verify draft readiness, or after major structural revisions."
argument-hint: "[draft-ready]"
user-invocable: true
---

Validate the consistency of all story-structural files.

## Steps

1. **Spawn the structure-validator agent.**

   If `$ARGUMENTS` contains "draft-ready" or "readiness":
   Prompt: "Validate all story-structural files in docs/ for consistency AND assess draft readiness. Read all available files: docs/story_concept.md, docs/15_beats.md, docs/characters.md, docs/world_rules.md, docs/open_questions.md, docs/continuity.md, all docs/section_*_outline.md files, and docs/section_map.md. Run all validation checks including the draft readiness assessment."

   Otherwise:
   Prompt: "Validate all story-structural files in docs/ for consistency. Read all available files: docs/story_concept.md, docs/15_beats.md, docs/characters.md, docs/world_rules.md, docs/open_questions.md, docs/continuity.md, all docs/section_*_outline.md files, and docs/section_map.md. Run all validation checks. Do NOT run the draft readiness assessment unless specifically requested."

2. **Wait for the agent to return.**

3. **Present the report.** Show the full validation report to the user.

4. **Summarize actionable items.** After the report, list:

   **Must fix (FAIL):**
   - [issue — what to do]

   **Should review (WARN):**
   - [issue — what to do]

   **Recommended next step:**
   - If failures exist: address them, then re-run `/check-structure`
   - If only warnings: review and decide which matter
   - If clean: the structure is consistent — run `/check-structure draft-ready` if preparing to draft, or continue development

## What This Checks

1. Beat coverage — every beat has at least one section
2. Section completeness — all required fields present
3. Concept-beat alignment — beats deliver on the premise
4. Character consistency — arcs appear in the structure
5. Continuity alignment — tracker matches section expectations
6. Open question impact — blocking questions respected by status claims
7. Section handoff — setup obligations are addressed
8. Chapter numbering — sequential, no gaps
9. Status hierarchy — sections can't be authoritative if beats are provisional
10. Draft readiness (if requested) — everything needed to begin `/write-section`
