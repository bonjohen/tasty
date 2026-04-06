# Novel Project — CLI Workflow

Story-specific rules (voice, characters, world, prohibitions) live in `book/CLAUDE.md`. This file covers the shared workflow system.

## Project Layout

```
book/                           # All book content lives here
├── CLAUDE.md                   # Story rules (voice, characters, world, prohibitions)
├── chapters/                   # Chapter files: ch01.md through chNN.md
├── docs/                       # Outlines, continuity, analysis, beats, section map
└── prompts/                    # Legacy manual prompts (reference only)
.claude/                        # CLI configuration (skills, agents, hooks, rules)
CLAUDE.md                       # This file — workflow rules
README.md
```

## Chapter Production Workflow

The primary workflow uses the CLI orchestration system (skills + agents):

- **`/write-section [N]`** — Main orchestrator. Loads context via parallel agents, drafts all chapters in a section, updates continuity, runs quality checks, commits.
- **`/resume`** — Session bootstrap. Derives project state from the filesystem. Run at session start.
- **`/check-continuity [N or range]`** — Validates chapters against `book/docs/continuity.md`.
- **`/chapter-status`** — Dashboard showing all sections, chapters, word counts, completion.

The orchestrator uses five specialized agents (in `.claude/agents/`): `context-loader`, `outline-reader`, `rhythm-reader`, `quality-checker`, `continuity-updater`. These run in parallel where possible to minimize context usage and maximize throughput.

Section-to-chapter mapping is in `book/docs/section_map.md`.

### File Conventions
1. Section outlines: `book/docs/section_NN_outline.md` (one per section, 2–3 chapters each)
2. Chapter files: `book/chapters/ch01.md`, `ch02.md`, etc. (flat, sequential across the whole book)
3. Chapter format: `# Chapter N: Title` followed by prose
4. Word targets: 2,000–3,500 words per chapter (specified per chapter in section outlines)
5. Continuity: `book/docs/continuity.md` updated after every chapter

### Legacy Workflow
The original manual process is preserved in `book/prompts/chapter_prompt.md`, `book/prompts/resume_session.md`, and `book/prompts/story_outline_prompt.md` for reference. These work independently of the CLI system if needed.

## Story Development Workflow

The pre-drafting development process uses a separate set of skills and agents:

- **`/generate-beats`** — Creates or revises the beat backbone (`book/docs/15_beats.md`) from the story concept
- **`/stabilize-beats`** — Runs the Beat Expansion decision pass; assesses whether beats are ready for section expansion
- **`/expand-sections [range]`** — Generates section outline files from stabilized beats; enforces the beat stability gate
- **`/story-status`** — Dashboard for the development phase (concept, beats, sections, characters, open questions)
- **`/check-structure [draft-ready]`** — Validates consistency across all structural files

Development agents (in `.claude/agents/`): `beat-analyzer`, `section-generator`, `structure-validator`.

Behavioral rules for story development conversations load automatically via `.claude/rules/story-development.md` when working with structural files.

### Development File Set
- `book/docs/story_concept.md` — premise, emotional core, theme, status
- `book/docs/15_beats.md` — 12-18 beat backbone with status header (exploratory/provisional/stable/locked)
- `book/docs/characters.md` — role, wound, desire, fear, contradiction, arc, secrets, relationship map
- `book/docs/world_rules.md` — only rules that materially affect causality
- `book/docs/open_questions.md` — unresolved decisions with urgency and blocking status

### Beat Stability Gate
Section outlines cannot be marked authoritative until beats are at least Stable. This is enforced by a PreToolUse hook in `.claude/settings.json`. Run `/stabilize-beats` to assess and promote beat status.

## Continuity Tracking

`book/docs/continuity.md` is updated after every chapter. It tracks:
- Timeline (days elapsed, season, location)
- Character physical state and injuries
- What each character currently knows
- Open narrative threads
- Key objects and their status
- The Bleed's current stage of development
