---
name: story-status
description: "Dashboard for the story development phase. Shows the status of all structural files — concept, beats, sections, characters, continuity, open questions — and reports development readiness. Use when the user asks for story status, development progress, architecture status, or where things stand."
argument-hint: "[book-name]"
model: sonnet
allowed-tools: Read Glob Grep Bash(wc *)
user-invocable: true
---

Generate a development status dashboard for a story project.

## Step 0: Determine Target Book

Resolve which book to report on; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, list subdirectories of `books/`. If only one book exists, use it. If multiple, show a brief status for each (one line per book) and recommend the user specify one for detail.

## Steps

1. **Check which files exist.** Use Glob to find:
   - `{book}/docs/story_concept.md`
   - `{book}/docs/15_beats.md`
   - `{book}/docs/characters.md`
   - `{book}/docs/world_rules.md`
   - `{book}/docs/open_questions.md`
   - `{book}/docs/continuity.md`
   - `{book}/docs/section_*_outline.md` (all section outlines)
   - `{book}/docs/section_map.md`
   - `{book}/chapters/ch*.md` (any drafted chapters)

2. **Read status headers.** For files that exist:
   - `{book}/docs/story_concept.md` — look for architecture status block (concept/beats/sections status)
   - `{book}/docs/15_beats.md` — look for beat status header (exploratory/provisional/stable/locked) and beat count
   - Each `{book}/docs/section_*_outline.md` — look for section status (provisional/authoritative)

3. **Count open questions.** If `{book}/docs/open_questions.md` exists, count total questions and count how many are marked as blocking beat stabilization or section authority.

4. **Count characters.** If `{book}/docs/characters.md` exists, count major characters with defined arcs.

5. **Count sections and chapters.** How many section outlines exist? How many are provisional vs. authoritative? How many total chapters are specified? How many chapters are drafted?

6. **Word counts.** If any chapter files exist, run `wc -w` on them.

## Output

```
## Story Development Dashboard

### File Status
| File | Exists | Status | Notes |
|------|--------|--------|-------|
| story_concept.md | Yes/No | [status] | [one-line note] |
| 15_beats.md | Yes/No | [status] | [N beats] |
| characters.md | Yes/No | — | [N characters] |
| world_rules.md | Yes/No | — | |
| open_questions.md | Yes/No | — | [N questions, M blocking] |
| continuity.md | Yes/No | — | [N entries] |
| section_map.md | Yes/No | — | |

### Section Architecture
- Sections defined: [N]
- Provisional: [N]
- Authoritative: [N]
- Total chapters specified: [N]
- Chapters drafted: [N]

### Development Phase
[Based on what exists and its status, identify the current phase:]
- **Discovery** — no concept file or concept is exploratory
- **Convergence** — concept exists but beats don't
- **Beat Generation** — beats exist but are exploratory
- **Beat Stabilization** — beats are provisional, need stabilization pass
- **Section Expansion** — beats are stable/locked, sections being generated
- **Continuity Maintenance** — sections exist, filling in support files
- **Draft Readiness** — all sections authoritative, ready for chapter drafting
- **Drafting** — chapters exist

### Open Blockers
[List any open questions that block beat stabilization or section authority]

### Recommended Next Action
[One of:]
- Run `/develop-concept [book]` — if no `story_concept.md` exists, or if it is still Exploratory
- Run `/develop-characters [book]` — if `story_concept.md` is at least Provisional but `characters.md` is missing or thin
- Run `/develop-world [book]` — if the story relies on world rules that have not yet been captured
- Run `/generate-beats [book]` — if the discovery files are at least Provisional and no beats exist yet
- Run `/stabilize-beats [book]` — if beats exist but are still Provisional
- Run `/expand-sections [book]` — if beats are Stable or Locked and sections are missing
- Run `/check-structure [book]` — for cross-file validation
- Run `/write-section [book]` — to begin or continue drafting
```

When choosing the recommendation, walk the pipeline left-to-right and pick the first stage that is incomplete. The `/develop-*` skills are the leftmost stage — recommend them whenever the four discovery files are missing or still Exploratory.
