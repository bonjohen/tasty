---
paths:
  - "books/*/docs/story_concept.md"
  - "books/*/docs/15_beats.md"
  - "books/*/docs/characters.md"
  - "books/*/docs/world_rules.md"
  - "books/*/docs/open_questions.md"
  - "books/*/docs/section_*_outline.md"
  - "books/*/docs/continuity.md"
---

# Story Development Rules

These rules activate when working with story-structural files. They govern how you behave during the pre-drafting development process — discovery, convergence, beat generation, section expansion.

## Modes and Dependency Chain

You operate in overlapping modes, but respect the dependency chain:

1. **Discovery** — understand premise, protagonist, core relationship, antagonistic shape, ending direction
2. **Convergence** — reduce ambiguity, decide what the story is actually about
3. **Beat Generation** — create the 12-18 beat backbone
4. **Beat Stabilization** — make beats robust enough to support section expansion
5. **Section Expansion** — expand beats into drafting-ready section architecture
6. **Continuity Maintenance** — track state across all structural changes
7. **Draft Readiness** — validate the architecture is complete enough for chapter drafting

Discovery feeds Convergence. Convergence feeds Beat Generation. Beat Generation feeds Beat Stabilization. Only after Beat Stabilization may Section Expansion become heavy and authoritative.

## Beat Status States

Track these in the `{book}/docs/15_beats.md` file header:

- **Exploratory** — major turns still unclear
- **Provisional** — enough to sketch, not enough to build deeply
- **Stable** — major turns, order, and ending shape unlikely to change without a real story reason
- **Locked** — user has approved the beat layer for drafting expansion

**Gate rule:** Heavy section work may begin only when beats are at least Stable. Until then, section work must be marked provisional.

## Conversational Discipline

- Ask focused questions that improve the story. Do not ask everything at once.
- Do not ask broad questions when narrower ones produce better structure.
- Do not wait for perfect certainty before producing useful outputs.
- Do not finalize structure too early.
- Do not flatten contradictions that are emotionally important.
- Favor emotional causality, narrative pressure, and meaningful reversals over lore accumulation.
- If the user has already implied or decided something strongly, treat it as decided.
- If momentum matters and several interpretations are viable, choose one, state the assumption, continue.

### Question Priority (descending)

1. Protagonist wound, desire, contradiction
2. Central relationship or emotional engine
3. Inciting disruption
4. Major antagonistic force
5. World rules that affect plot
6. Thematic spine
7. Ending shape
8. Sequel implications
9. Tonal and aesthetic constraints

Low-priority questions wait unless they materially affect structure.

### Question Round Format

**Current story shape:** Short paragraph.

**Most important unresolved questions:** Short prioritized list.

**Questions for this round:** Numbered list, 3-7 focused questions.

### After User Answers

**What changed:** Short list of decisions or clarified assumptions.

**Updated story shape:** Short paragraph.

**Current architecture status:**
- Concept: exploratory/provisional/stable/locked
- Beats: exploratory/provisional/stable/locked
- Sections: exploratory/provisional/stable/locked

**Next step:** One of: ask next refinement round, create/revise concept, create/revise beats, run beat expansion pass, create/revise sections, update continuity/support files.

## File Hierarchy

These files solve different problems. Keep them distinct:

- `story_concept.md` — the one-page truth (premise, emotional core, theme, status)
- `15_beats.md` — the backbone (what the book must do)
- `section_NN_outline.md` — decompressed structure (how long each movement needs, what each drafting unit must accomplish)
- `continuity.md` — state memory (who knows what, injuries, objects, threads)
- `characters.md` — emotional and structural identity memory
- `world_rules.md` — causality memory (only rules that affect plot)
- `open_questions.md` — unresolved structural pressure

Do not let the beat file drift into section work. Do not let section files drift into chapter prose.

## Incremental Output Rules

- Produce useful outputs early, even if incomplete
- Mark partial outputs with their status (exploratory, provisional, stable)
- Revise existing files rather than creating conflicting duplicates
- When generating a file, write it in direct file-ready form — do not narrate the process
- If a user answer changes prior assumptions: revise concept, beats, affected sections, continuity, and support files as needed — do not leave old contradictions sitting in parallel

## The Emotional Engine Is Primary

The story's emotional engine is always more important than decorative worldbuilding. Structure exists to serve emotional causality. A beat matters because it changes something the reader feels, not because it fills a structural slot.
