---
name: generate-beats
description: "Generates or revises the beat backbone (docs/15_beats.md) from the current story concept, characters, and conversation context. Use when the user asks to create beats, generate the backbone, outline the story structure, or when enough discovery/convergence has happened to produce a first beat draft."
user-invocable: true
---

Generate or revise the beat backbone for the novel.

## Prerequisites

Check that these files exist:
- `docs/story_concept.md` — REQUIRED. If missing, tell the user: "No story concept file found. The beat backbone needs at least a premise, emotional core, and ending direction. Either create `docs/story_concept.md` or discuss the story concept first."
- `docs/characters.md` — recommended but not required
- `docs/world_rules.md` — recommended but not required
- `docs/open_questions.md` — read if exists, to understand unresolved decisions

If `docs/15_beats.md` already exists, read it. This is a revision, not a fresh generation. Preserve what's working and revise what needs to change.

## Beat Generation Rules

Generate 12 to 18 major beats. Each beat must:
- **Change** the story — something is different after this beat
- **Matter emotionally** — the reader cares about what changed
- **Deepen, reverse, expose, or escalate** — no beats that merely advance plot without emotional consequence

Do NOT write scenes. Do NOT expand into chapter logic. Beats describe what the story must do, not how individual chapters will do it.

## Required Structural Beats

The beat architecture must clearly include:

1. Setup — the world and relationships before disruption
2. Inciting disruption — the event that makes the old status quo impossible
3. First irreversible commitment — the protagonist crosses a line they cannot uncross
4. Escalating complications — pressure builds, options narrow
5. Midpoint change in understanding — what the protagonist (or reader) believed is reframed
6. False reconciliation or emotional opening (if applicable) — a moment of hope or connection that is not yet earned
7. Devastating revelation — the truth that reinterprets everything prior
8. Confrontation with final antagonist or system — the climactic external conflict
9. Internal climax — the protagonist's deepest self-reckoning (may precede or follow external climax)
10. External climax — the decisive action
11. Aftermath — what survival or resolution costs
12. Emotional ending — where the protagonist lands, what the reader carries
13. Sequel hook (if applicable) — the thread that extends beyond the book

Not all of these require separate beats. Some may combine. Some stories need additional beats between these markers. Use judgment.

## Beat Format

Write `docs/15_beats.md` with this structure:

```markdown
# [Story Title] — Beat Architecture

**Beat status:** [Exploratory / Provisional / Stable / Locked]
**Beat count:** [N]
**Last revised:** [date]

---

## Beat 1: [Title]

**What changes:** [One sentence — the irreversible shift]
**Why it matters emotionally:** [One sentence — what the reader feels]
**What is learned, lost, or reversed:** [One sentence]
**What it sets up:** [One sentence — what later beats depend on this]

---

## Beat 2: [Title]
...

---

## Beat-to-Section Mapping (provisional)

| Beat | Recommended Sections | Notes |
|------|---------------------|-------|
| 1 | 1 | [expansion notes] |
| 2-3 | 2-3 | [may split or braid] |
...
```

## Status Rules

- If this is the first generation and the concept is still rough, mark beats as **Exploratory**.
- If the concept is solid and major turns are clear but details are flexible, mark as **Provisional**.
- Never mark as Stable or Locked during generation — that requires the stabilization pass (`/stabilize-beats`).

## After Generation

Report:
- Beat count
- Beat status
- Key structural landmarks (where the inciting event falls, where the midpoint is, where the climax is)
- Any open questions that affect the beat structure
- Recommended next step (usually: review with user, then `/stabilize-beats` when ready)
