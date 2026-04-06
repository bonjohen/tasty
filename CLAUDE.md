# Tasty — Project Instructions

## Project Identity

- **Title:** Tasty (working title)
- **Genre:** Literary dark fantasy
- **Logline:** A demon who consumed his dying brother to survive a winter discovers the brother's voice growing inside him — and then discovers the brother may have planned to consume him first.
- **Source documents:** `docs/01_story_beats.md` (15 beats), `docs/01_story_analysis.md` (23 sections + character/theme notes)

## Voice & Style

- Third person, past tense, shifting POV. Hurkuzak is the primary perspective. Captain Sella Vark and others get intercut chapters starting from Act I.
- Literary dark register. Precise, atmospheric, weighted sentences. Every sentence earns its place. Think McCarthy, Morrison — not genre-default fantasy prose.
- Restrained horror. The reader understands what happens without clinical detail. Psychological dread over viscera. What is understood hits harder than what is shown.
- Dark humor surfaces through Hurkuzak's internal voice: bitter, self-aware, never winking at the reader. The title line is the template — funny because it is emotionally wrong.
- "Demon meat is very tasty" appears during or after the cabin section. It must be earned by context, not dropped cold.

## Hakiia's Voice (The Bleed)

The inner voice has no formatting markers. No italics, no quotes, no indentation. It enters Hurkuzak's narration unmarked. The reader must feel the boundary dissolve.

**Progression:**
- Early (sections 1–7): sounds like survival instinct. Terse corrections, tactical observations. Could be dismissed as stress, hunger, injury.
- Middle (sections 8–14): grows specific. Uses Hakiia's idioms. Remembers things Hurkuzak shouldn't know from Hakiia's perspective. Opinions emerge.
- Late (sections 15–23): fully conversational. A second presence with memories, emotional reactions, and will. Two selves sharing one body.

The reader should feel increasing unease about which thoughts belong to whom.

## World Rules

### Setting
Pre-industrial. Wagons, sleds, bladed weapons, bows, traps. No engines, firearms, or electricity.

### Demons
"Demons" are humans warped by magical energies in a specific region. They can pass for human but show subtle differences under stress or observation — heightened healing, unusual resilience, sensory sharpness. The outside world calls them demons. They call themselves by their own names and cultures.

### The Consumption Taboo
Eating demon flesh transfers physical properties. Eating a sibling is the deepest taboo because it transfers identity fragments — instinct, memory, personality. The ancient rite was a preservation mechanism used in extremis to save lineages and knowledge across generations. It became forbidden because it was too dangerous: identity erosion, domination by the stronger personality, composite beings too layered to remain themselves.

### The Flesh Economy
Structured, multi-tiered, normalized. Hunters, butchers, merchants, physicians, chefs, and nobles all participate. Specific organs and tissues carry specific market values and effects. This is not a fringe black market — it is civilizational infrastructure with professional hierarchies and aristocratic culture built on top.

## Characters

### Hurkuzak (primary POV)
Younger brother. Gentle, conflict-avoidant. Killed Hakiia in a mercy killing, consumed him to survive, inherited his strength and voice. Arc: from denial of violence to integration of inherited power with moral choice. He does not become Hakiia reborn. He does not return to the old Hurkuzak. He becomes a third being made of both inheritance and choice.

### Hakiia (dead; present as the Bleed)
Older brother. Cruel, protective, gifted. His love was real but expressed through humiliation, pressure, and pain. He believed the world kills gentle creatures first. May have intended to kill and consume Hurkuzak on the trip. Emotionally unresolved throughout the entire book — cruel, loving, manipulative, protective, monstrous, and real. The point is that all of these are true simultaneously.

### Captain Sella Vark (secondary POV)
Human demon-hunter who has consumed her kills and gained some of their strength. Professional, observant, dangerous, disciplined. She is living proof the system works — both hunter and consumer. She represents normalized predation. Gets intercut POV chapters from early in the book.

### Orath Tessivane (the merchant prince)
The system-builder behind the flesh trade. Exploitation refined into theory and culture. He does not merely consume power — he organizes its production, distribution, ritual use, and elite meaning. Named when the narrative reveals him, not before.

## Chapter Production Workflow

The primary workflow uses the CLI orchestration system (skills + agents):

- **`/write-section [N]`** — Main orchestrator. Loads context via parallel agents, drafts all chapters in a section, updates continuity, runs quality checks, commits.
- **`/resume`** — Session bootstrap. Derives project state from the filesystem. Run at session start.
- **`/check-continuity [N or range]`** — Validates chapters against `docs/continuity.md`.
- **`/chapter-status`** — Dashboard showing all sections, chapters, word counts, completion.

The orchestrator uses five specialized agents (in `.claude/agents/`): `context-loader`, `outline-reader`, `rhythm-reader`, `quality-checker`, `continuity-updater`. These run in parallel where possible to minimize context usage and maximize throughput.

Section-to-chapter mapping is in `docs/section_map.md`.

### File Conventions
1. Section outlines: `docs/section_NN_outline.md` (one per section, 2–3 chapters each)
2. Chapter files: `chapters/ch01.md`, `ch02.md`, etc. (flat, sequential across the whole book)
3. Chapter format: `# Chapter N: Title` followed by prose
4. Word targets: 2,000–3,500 words per chapter (specified per chapter in section outlines)
5. Continuity: `docs/continuity.md` updated after every chapter

### Legacy Workflow
The original manual process is preserved in `prompts/chapter_prompt.md`, `prompts/resume_session.md`, and `prompts/story_outline_prompt.md` for reference. These work independently of the CLI system if needed.

## Story Development Workflow

The pre-drafting development process uses a separate set of skills and agents:

- **`/generate-beats`** — Creates or revises the beat backbone (`docs/15_beats.md`) from the story concept
- **`/stabilize-beats`** — Runs the Beat Expansion decision pass; assesses whether beats are ready for section expansion
- **`/expand-sections [range]`** — Generates section outline files from stabilized beats; enforces the beat stability gate
- **`/story-status`** — Dashboard for the development phase (concept, beats, sections, characters, open questions)
- **`/check-structure [draft-ready]`** — Validates consistency across all structural files

Development agents (in `.claude/agents/`): `beat-analyzer`, `section-generator`, `structure-validator`.

Behavioral rules for story development conversations load automatically via `.claude/rules/story-development.md` when working with structural files.

### Development File Set
- `docs/story_concept.md` — premise, emotional core, theme, status
- `docs/15_beats.md` — 12-18 beat backbone with status header (exploratory/provisional/stable/locked)
- `docs/characters.md` — role, wound, desire, fear, contradiction, arc, secrets, relationship map
- `docs/world_rules.md` — only rules that materially affect causality
- `docs/open_questions.md` — unresolved decisions with urgency and blocking status

### Beat Stability Gate
Section outlines cannot be marked authoritative until beats are at least Stable. This is enforced by a PreToolUse hook in `.claude/settings.json`. Run `/stabilize-beats` to assess and promote beat status.

## Continuity Tracking

`docs/continuity.md` is updated after every chapter. It tracks:
- Timeline (days elapsed, season, location)
- Character physical state and injuries
- What each character currently knows
- Open narrative threads
- Key objects and their status
- The Bleed's current stage of development

## Things to Avoid

- Redemption arcs that excuse Hakiia's cruelty — the point is that love and cruelty coexist without resolution
- Action scenes that feel triumphant — violence should feel frightening, even when Hurkuzak wins
- Over-explaining the magic system — keep it felt, not catalogued
- Breaking the Bleed by making Hakiia's presence too obvious too early
- Modern idiom or phrasing that breaks the pre-industrial register
- Treating the flesh economy as simple villainy — it is normalized, systemic, civilizational
- Genre-default fantasy prose: no "he let out a breath he didn't know he was holding," no "darkness claimed him," no ornamental archaisms
- Summarizing emotion instead of rendering it — show the behavioral evidence, trust the reader
