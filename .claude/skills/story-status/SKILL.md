---
name: story-status
description: "Dashboard for the story development phase. Shows the status of all structural files — concept, beats, sections, characters, continuity, open questions — and reports development readiness. Use when the user asks for story status, development progress, architecture status, or where things stand."
model: sonnet
allowed-tools: Read Glob Grep Bash(wc *)
user-invocable: true
---

Generate a development status dashboard for the story project.

## Steps

1. **Check which files exist.** Use Glob to find:
   - `docs/story_concept.md`
   - `docs/15_beats.md`
   - `docs/characters.md`
   - `docs/world_rules.md`
   - `docs/open_questions.md`
   - `docs/continuity.md`
   - `docs/section_*_outline.md` (all section outlines)
   - `docs/section_map.md`
   - `chapters/ch*.md` (any drafted chapters)

2. **Read status headers.** For files that exist:
   - `docs/story_concept.md` — look for architecture status block (concept/beats/sections status)
   - `docs/15_beats.md` — look for beat status header (exploratory/provisional/stable/locked) and beat count
   - Each `docs/section_*_outline.md` — look for section status (provisional/authoritative)

3. **Count open questions.** If `docs/open_questions.md` exists, count total questions and count how many are marked as blocking beat stabilization or section authority.

4. **Count characters.** If `docs/characters.md` exists, count major characters with defined arcs.

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
- Continue discovery conversation
- Run `/generate-beats`
- Run `/stabilize-beats`
- Run `/expand-sections`
- Run `/check-structure` for validation
- Run `/write-section` to begin drafting
```
