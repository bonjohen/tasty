# Tasty

A literary dark fantasy novel, written and managed with Claude Code.

48 chapters across 23 sections. ~127,000 words. First draft complete.

## Quick Start

Open Claude Code in this project directory. The CLI system activates automatically from the `.claude/` configuration.

### Resume a session

```
/resume
```

Derives project state from the filesystem — chapters written, current section, character states, what comes next. No manual context loading needed.

### Check progress

```
/chapter-status
```

Dashboard showing every section, chapter titles, word counts, and completion status.

```
/story-status
```

Development-phase dashboard — status of concept, beats, sections, characters, open questions.

---

## Writing Chapters

### Write the next section

```
/write-section
```

Auto-detects the next unwritten section. Loads context via parallel agents, drafts 2-3 chapters, updates continuity, runs quality checks, and commits.

### Write a specific section

```
/write-section 14
```

Targets section 14 specifically. Skips auto-detection.

### What happens during `/write-section`

1. Scans `chapters/` to find the next unwritten chapter
2. Looks up the section in `docs/section_map.md`
3. Spawns three agents in parallel:
   - **context-loader** — reads CLAUDE.md, story analysis, continuity; returns compressed summary
   - **outline-reader** — reads current + adjacent section outlines; returns chapter specs
   - **rhythm-reader** — reads last 1-2 chapters; returns prose rhythm analysis
4. Drafts each chapter sequentially using the agent summaries
5. After each chapter, spawns two more agents in parallel:
   - **continuity-updater** — updates `docs/continuity.md`
   - **quality-checker** — validates against a 10-point checklist
6. Reports section completion
7. Commits to git (does not push)

---

## Developing a New Story

The development system takes a story from rough premise to drafting-ready architecture.

### The pipeline

```
Discovery conversation → /generate-beats → /stabilize-beats → /expand-sections → /check-structure draft-ready → /write-section
```

### 1. Discovery and Convergence

Start a conversation. When working with structural files (`docs/story_concept.md`, `docs/15_beats.md`, `docs/characters.md`, etc.), behavioral rules load automatically from `.claude/rules/story-development.md`. Claude will ask focused questions in a structured format and produce files incrementally.

Create the initial files through conversation:
- `docs/story_concept.md` — premise, emotional core, theme
- `docs/characters.md` — characters with wound, desire, fear, contradiction, arc
- `docs/world_rules.md` — rules that affect causality
- `docs/open_questions.md` — unresolved decisions

### 2. Generate beats

```
/generate-beats
```

Creates `docs/15_beats.md` — a 12-18 beat backbone. Each beat describes what changes, why it matters emotionally, what is learned/lost/reversed, and what it sets up. Marked as Exploratory or Provisional.

### 3. Stabilize beats

```
/stabilize-beats
```

Spawns the `beat-analyzer` agent to run the Beat Expansion decision pass on every beat: should it split? Does POV alternation help? Does the internal arc change here? Returns a stability assessment with a beat-to-section coverage plan. Promotes status to Stable or Locked on your approval.

**This is the gate.** Section outlines cannot be authoritative until beats are at least Stable.

### 4. Expand sections

```
/expand-sections all
```

Generates section outline files from the stabilized beats. Each section gets: title, chapter specifications (POV, word targets, detailed beats, function paragraph), notes, and setup obligations.

```
/expand-sections 1-5
```

Generate a specific range.

Non-adjacent sections are generated in parallel via `section-generator` agents. Adjacent sections are generated sequentially (each needs the previous section's handoff context).

### 5. Validate

```
/check-structure
```

Cross-references all structural files for consistency — beat coverage, section completeness, character arcs, continuity, status hierarchy. Reports FAIL/WARN issues.

```
/check-structure draft-ready
```

Same checks plus a full draft-readiness assessment. When this passes, the architecture is ready for `/write-section`.

---

## Validation Commands

### Check continuity

```
/check-continuity 40-43
```

Validates specific chapters against `docs/continuity.md`. Cross-references timeline, character state, injuries, knowledge, Bleed stage, objects, and narrative threads. Reports errors, warnings, and info-level issues.

```
/check-continuity
```

Without arguments, checks the last 3 written chapters.

### Check structure

```
/check-structure
```

Validates consistency across all story-structural files. 10-point check: beat coverage, section completeness, concept-beat alignment, character consistency, continuity alignment, open question impact, section handoff, chapter numbering, status hierarchy.

---

## Project Structure

```
.
├── CLAUDE.md                           # Voice, style, world rules, characters, workflow
├── chapters/
│   ├── ch01.md                         # Chapter 1: The Older Brother's Country
│   ├── ch02.md                         # ...
│   └── ch48.md                         # Chapter 48 (final)
├── docs/
│   ├── 01_story_analysis.md            # 23-section narrative architecture
│   ├── 01_story_beats.md               # 15-beat high-level outline
│   ├── continuity.md                   # Cumulative state tracker
│   ├── section_01_outline.md           # Section outline (chapters 1-3)
│   ├── ...
│   ├── section_23_outline.md           # Section outline (chapter 48)
│   ├── section_map.md                  # Section-to-chapter lookup table
│   └── orchestration_guide.md          # How the system works (detailed)
├── prompts/
│   ├── chapter_prompt.md               # Legacy manual writing process
│   ├── resume_session.md               # Legacy session bootstrapper
│   └── story_outline_prompt.md         # Legacy story development prompt
└── .claude/
    ├── settings.json                   # Permissions, hooks
    ├── rules/
    │   └── story-development.md        # Auto-loads when editing structural files
    ├── skills/
    │   ├── write-section/SKILL.md      # /write-section — chapter orchestrator
    │   ├── resume/SKILL.md             # /resume — session bootstrap
    │   ├── check-continuity/SKILL.md   # /check-continuity — chapter validation
    │   ├── chapter-status/SKILL.md     # /chapter-status — progress dashboard
    │   ├── generate-beats/SKILL.md     # /generate-beats — beat backbone
    │   ├── stabilize-beats/SKILL.md    # /stabilize-beats — beat stability gate
    │   ├── expand-sections/SKILL.md    # /expand-sections — section generation
    │   ├── story-status/SKILL.md       # /story-status — development dashboard
    │   └── check-structure/SKILL.md    # /check-structure — structural validation
    └── agents/
        ├── context-loader/AGENT.md     # Reads core docs, returns summary
        ├── outline-reader/AGENT.md     # Reads section outlines
        ├── rhythm-reader/AGENT.md      # Analyzes prose rhythm
        ├── quality-checker/AGENT.md    # 10-point chapter validation
        ├── continuity-updater/AGENT.md # Updates continuity.md
        ├── beat-analyzer/AGENT.md      # Beat expansion decision pass
        ├── section-generator/AGENT.md  # Generates section outlines
        └── structure-validator/AGENT.md# Cross-file consistency check
```

## Hooks (Automated Enforcement)

Three hooks in `.claude/settings.json` enforce workflow discipline:

| Hook | Trigger | What it does |
|------|---------|-------------|
| Continuity reminder | After writing a chapter file | Injects a reminder to update `docs/continuity.md` |
| Beat stability gate | Before writing a section outline | Blocks authoritative sections if beats aren't Stable |
| Stop verification | Before session ends | Checks continuity was updated, sections are complete, commits were made |

## Key Concepts

**Beat status states:** Exploratory → Provisional → Stable → Locked. Section outlines cannot be authoritative until beats are at least Stable. This gate is enforced by a hook.

**Agents as context compressors:** The writing agents read large reference documents and return compressed summaries. The main session gets summaries (~1,000 words) instead of raw files (~5,000+ words). Context budget goes to creative work.

**Parallel execution:** Context loading spawns 3 agents simultaneously. Post-chapter processing spawns 2 agents simultaneously. Non-adjacent section generation runs in parallel.

**Continuity as single source of truth:** `docs/continuity.md` tracks everything — timeline, character states, injuries, knowledge, objects, threads. Updated after every chapter by the `continuity-updater` agent.

**Section map:** `docs/section_map.md` is a static lookup table mapping sections to chapter ranges. Eliminates runtime parsing of outline headers.

## For a New Novel

The system is generic. To start a new novel with the same workflow:

1. Create the project directory with the same structure
2. Copy the `.claude/` directory (skills, agents, rules, settings)
3. Write `CLAUDE.md` with voice rules, world rules, characters, prohibitions
4. Start a discovery conversation — the rules file activates automatically
5. Follow the pipeline: `/generate-beats` → `/stabilize-beats` → `/expand-sections` → `/write-section`
