# Novel Project — CLI Workflow

Story-specific rules (voice, characters, world, prohibitions) live in `books/[bookname]/CLAUDE.md`. This file covers the shared workflow system.

## Project Layout

```
books/                          # All books live here
├── tasty/                      # Book 1 — literary dark fantasy (first draft complete)
│   ├── CLAUDE.md               # Story rules (voice, characters, world, prohibitions)
│   ├── chapters/               # Chapter files: ch01.md through chNN.md
│   ├── docs/                   # Outlines, continuity, analysis, beats, section map
│   └── prompts/                # Legacy manual prompts (reference only)
└── nexter/                     # Book 2 — in development
    ├── CLAUDE.md               # Story rules (placeholder)
    ├── chapters/               # Chapter files (empty)
    └── docs/                   # Outlines, beats, etc. (empty)
.claude/                        # CLI configuration (skills, agents, hooks, rules) — shared
CLAUDE.md                       # This file — workflow rules
README.md
```

## Book Selection

Every skill in this project takes an optional `[book-name]` argument that resolves to a subdirectory of `books/`. When only one book exists, skills may default to it. When multiple books exist, the caller must specify. All paths below use `books/[bookname]/` as a template — substitute the actual book folder at runtime.

## Chapter Production Workflow

The primary workflow uses the CLI orchestration system (skills + agents):

- **`/write-section [book-name] [N]`** — Main orchestrator. Loads context via parallel agents, drafts all chapters in a section, updates continuity, runs quality checks, commits.
- **`/resume [book-name]`** — Session bootstrap. Derives project state from the filesystem. Run at session start.
- **`/check-continuity [book-name] [N or range]`** — Validates chapters against `books/[bookname]/docs/continuity.md`.
- **`/chapter-status [book-name]`** — Dashboard showing all sections, chapters, word counts, completion.

The orchestrator uses five specialized agents (in `.claude/agents/`): `context-loader`, `outline-reader`, `rhythm-reader`, `quality-checker`, `continuity-updater`. These run in parallel where possible to minimize context usage and maximize throughput. Each agent accepts the book root as input (see the Input Contract section of each AGENT.md).

Section-to-chapter mapping lives at `books/[bookname]/docs/section_map.md`.

### File Conventions
1. Section outlines: `books/[bookname]/docs/section_NN_outline.md` (one per section, 2–3 chapters each)
2. Chapter files: `books/[bookname]/chapters/ch01.md`, `ch02.md`, etc. (flat, sequential across the whole book)
3. Chapter format: `# Chapter N: Title` followed by prose
4. Word targets: 2,000–3,500 words per chapter (specified per chapter in section outlines)
5. Continuity: `books/[bookname]/docs/continuity.md` updated after every chapter

### Legacy Workflow
The original manual process for tasty is preserved in `books/tasty/prompts/chapter_prompt.md`, `books/tasty/prompts/resume_session.md`, and `books/tasty/prompts/story_outline_prompt.md` for reference. These work independently of the CLI system if needed.

## Story Development Workflow

The pre-drafting development process uses a separate set of skills and agents. The pipeline runs left-to-right: discovery files → beats → sections → drafting.

**Discovery (the leftmost stage — entry point for a book with no development files yet):**

- **`/develop-concept [book-name]`** — Drives a focused discovery conversation that produces or revises `books/[bookname]/docs/story_concept.md`. One question round per invocation. Run repeatedly to converge.
- **`/develop-characters [book-name]`** — Same shape, targets `books/[bookname]/docs/characters.md`. Best run after the concept is at least Provisional.
- **`/develop-world [book-name]`** — Same shape, targets `books/[bookname]/docs/world_rules.md`. Aggressively rejects decorative worldbuilding — only rules that materially affect causality.

`open_questions.md` is maintained as a side effect by all three discovery skills — it has no dedicated entry point. Each skill writes only its target file plus open questions, and surfaces material that belongs in sibling files as recommendations rather than silent edits.

**Beat and section stages:**

- **`/generate-beats [book-name]`** — Creates or revises the beat backbone (`books/[bookname]/docs/15_beats.md`) from the discovery files. Has a soft gate that warns when `story_concept.md` is still Exploratory.
- **`/stabilize-beats [book-name]`** — Runs the Beat Expansion decision pass; assesses whether beats are ready for section expansion
- **`/expand-sections [book-name] [range]`** — Generates section outline files from stabilized beats; enforces the beat stability gate
- **`/story-status [book-name]`** — Dashboard for the development phase (concept, beats, sections, characters, open questions)
- **`/check-structure [book-name] [draft-ready]`** — Validates consistency across all structural files

Development agents (in `.claude/agents/`): `concept-interviewer`, `concept-writer`, `beat-analyzer`, `section-generator`, `structure-validator`.

Behavioral rules for story development conversations load automatically via `.claude/rules/story-development.md` when working with structural files (the rule's `paths:` use `books/*/docs/...` globs so it activates across any book).

### Development File Set (per book)
- `books/[bookname]/docs/story_concept.md` — premise, emotional core, theme, status
- `books/[bookname]/docs/15_beats.md` — 12-18 beat backbone with status header (exploratory/provisional/stable/locked)
- `books/[bookname]/docs/characters.md` — role, wound, desire, fear, contradiction, arc, secrets, relationship map
- `books/[bookname]/docs/world_rules.md` — only rules that materially affect causality
- `books/[bookname]/docs/open_questions.md` — unresolved decisions with urgency and blocking status

### Beat Stability Gate
Section outlines cannot be marked authoritative until beats are at least Stable. This is enforced by a PreToolUse hook in `.claude/settings.json` that matches any `books/*/docs/section_*_outline.md` path. Run `/stabilize-beats [book-name]` to assess and promote beat status.

## Continuity Tracking

`books/[bookname]/docs/continuity.md` is updated after every chapter. It tracks:
- Timeline (days elapsed, season, location)
- Character physical state and injuries
- What each character currently knows
- Open narrative threads
- Key objects and their status
- Any book-specific narrative-progression trackers the story uses (voice-bleed stages, corruption levels, relationship phases, etc.) — defined per book in that book's CLAUDE.md
