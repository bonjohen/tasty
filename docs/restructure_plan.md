# Project Restructure Plan

**Purpose:** Rename and relocate files/folders so the project structure matches its own documentation, aligns tasty's legacy layout with the new per-book convention, and is ready for an upcoming "story-component production" workflow.

**Status:** DRAFT — awaiting user approval before execution.
**Date:** 2026-04-07

---

## 1. Findings (What Is Currently Inconsistent)

### 1.1 Legacy `01_` prefix in tasty docs does not match the new convention

Tasty uses `docs/01_story_beats.md` and `docs/01_story_analysis.md`. The new per-book workflow (documented in root `CLAUDE.md`, referenced throughout `.claude/skills/` and `.claude/agents/`) expects `docs/15_beats.md` and a separate set of `story_concept.md` / `characters.md` / `world_rules.md` / `open_questions.md`. The `01_` prefix is a holdover from the original manual workflow.

### 1.2 Documentation-vs-reality mismatch for legacy prompts

Root `CLAUDE.md:48` states:

> The original manual process for tasty is preserved in `books/tasty/prompts/chapter_prompt.md`, `books/tasty/prompts/resume_session.md`, and `books/tasty/prompts/story_outline_prompt.md`...

But those files actually live at `.claude/prompts/`. They reference tasty-specific files (`01_story_analysis.md`, etc.), so they are tasty-specific legacy artifacts, not generic `.claude/` tooling.

### 1.3 Review output lives inside `chapters/`

`books/tasty/chapters/weak-review/` and `books/tasty/chapters/consistency-review/` hold editor-pass output (one review file per chapter). These are tool output, not chapter content, and do not belong in `chapters/`. Future writing-blunders runs will need a home too.

### 1.4 Nexter has no scaffolding

`books/nexter/` contains only `CLAUDE.md`. There is no `docs/` or `chapters/` folder. The upcoming story-component workflow will want to write into `books/nexter/docs/`, so the folder should exist.

### 1.5 README.md references the old singular `book/` layout

README.md section "Project Structure" (lines ~168-214) describes a `book/` folder (singular). The real layout is `books/tasty/`. This is stale documentation, not a rename, but should be fixed in the same pass.

### 1.6 No top-level `docs/` folder for project-level planning artifacts

Per your global `CLAUDE.md`, design and plan artifacts belong in `docs/`. This plan creates that folder for the first time (it did not exist before this file was written).

---

## 2. Target Structure

```
tasty/                               # Git repo root (optionally rename — see §6)
├── CLAUDE.md                        # Workflow rules (unchanged)
├── README.md                        # Updated to reflect books/[name]/ layout
├── docs/                            # NEW — project-level plans/designs
│   └── restructure_plan.md          # This file
├── books/
│   ├── tasty/
│   │   ├── CLAUDE.md                # Story rules (source-doc references updated)
│   │   ├── chapters/                # ONLY chXX.md files
│   │   │   ├── ch01.md
│   │   │   └── ...
│   │   │   └── ch48.md
│   │   ├── docs/
│   │   │   ├── 15_beats.md                      # was 01_story_beats.md
│   │   │   ├── legacy_story_analysis.md         # was 01_story_analysis.md
│   │   │   ├── continuity.md
│   │   │   ├── section_map.md
│   │   │   ├── section_NN_outline.md (×23)
│   │   │   ├── orchestration_guide.md
│   │   │   └── reader.html
│   │   ├── reviews/                 # NEW — editor-pass output
│   │   │   ├── weak-writing/        # was chapters/weak-review/
│   │   │   │   └── review_chNN.md
│   │   │   └── consistency/         # was chapters/consistency-review/
│   │   │       └── review_chNN.md
│   │   └── prompts/                 # NEW — moved from .claude/prompts/
│   │       ├── chapter_prompt.md
│   │       ├── resume_session.md
│   │       └── story_outline_prompt.md
│   └── nexter/
│       ├── CLAUDE.md
│       ├── chapters/                # NEW — empty, tracked via .gitkeep
│       └── docs/                    # NEW — empty, tracked via .gitkeep
└── .claude/
    ├── settings.json
    ├── settings.local.json
    ├── rules/                       # unchanged
    ├── skills/                      # SKILL.md files updated to new path names
    └── agents/                      # AGENT.md files updated to new path names
    # .claude/prompts/ is removed (was tasty-specific, now lives in books/tasty/prompts/)
```

---

## 3. Phased Execution Plan

Each phase is independently committable. All file moves use `git mv` to preserve history. Reference updates happen inside the phase that owns the renamed file.

### Phase 1 — Rename legacy tasty docs

| # | Status | Action |
|---|---|---|
| 1.1 | Open | `git mv books/tasty/docs/01_story_beats.md books/tasty/docs/15_beats.md` |
| 1.2 | Open | `git mv books/tasty/docs/01_story_analysis.md books/tasty/docs/legacy_story_analysis.md` |
| 1.3 | Open | Update `books/tasty/CLAUDE.md:8` — source-doc reference |
| 1.4 | Open | Update `books/tasty/docs/orchestration_guide.md` lines 63, 77, 204 |
| 1.5 | Open | Update `.claude/skills/write-section/SKILL.md:48` |
| 1.6 | Open | Update `.claude/agents/context-loader/AGENT.md:20` |
| 1.7 | Open | Commit: `Rename tasty legacy docs to match new convention` |

**NOT updated** in this phase: historical review files under `books/tasty/chapters/consistency-review/review_ch*.md` that mention `01_story_beats.md` / `01_story_analysis.md`. Those are frozen snapshots of past editor passes — they are historical records, not live references.

### Phase 2 — Relocate review output out of chapters/

| # | Status | Action |
|---|---|---|
| 2.1 | Open | `git mv books/tasty/chapters/weak-review books/tasty/reviews/weak-writing` |
| 2.2 | Open | `git mv books/tasty/chapters/consistency-review books/tasty/reviews/consistency` |
| 2.3 | Open | Grep for `chapters/weak-review` and `chapters/consistency-review` — update any references (expected: zero hits in live files, possibly hits inside moved review files themselves) |
| 2.4 | Open | Commit: `Move review output out of chapters/ into reviews/` |

Rationale for the `weak-writing` / `consistency` folder names: they match the `.claude/rules/` filenames (`weak-writing.md`, `poor-consistency.md`) that drive those passes. Future `writing-blunders.md` runs get a sibling folder `books/tasty/reviews/blunders/` created on demand — not created empty by this plan.

### Phase 3 — Move tasty-specific legacy prompts

| # | Status | Action |
|---|---|---|
| 3.1 | Open | `git mv .claude/prompts/chapter_prompt.md books/tasty/prompts/chapter_prompt.md` |
| 3.2 | Open | `git mv .claude/prompts/resume_session.md books/tasty/prompts/resume_session.md` |
| 3.3 | Open | `git mv .claude/prompts/story_outline_prompt.md books/tasty/prompts/story_outline_prompt.md` |
| 3.4 | Open | Update path references inside the three moved prompt files: `01_story_analysis.md` → `legacy_story_analysis.md`, `01_story_beats.md` → `15_beats.md` |
| 3.5 | Open | Remove the empty `.claude/prompts/` folder |
| 3.6 | Open | Commit: `Move tasty legacy prompts to books/tasty/prompts/ to match CLAUDE.md` |

Note: root `CLAUDE.md:48` already says these files live at `books/tasty/prompts/`. This phase makes reality match the documentation — no CLAUDE.md edit needed.

### Phase 4 — Scaffold nexter

| # | Status | Action |
|---|---|---|
| 4.1 | Open | Create `books/nexter/docs/.gitkeep` |
| 4.2 | Open | Create `books/nexter/chapters/.gitkeep` |
| 4.3 | Open | Commit: `Scaffold nexter docs/ and chapters/ folders` |

No story files are pre-created. The upcoming story-component workflow is responsible for producing `story_concept.md`, `characters.md`, `world_rules.md`, `open_questions.md`, `15_beats.md`.

### Phase 5 — Refresh README.md layout section

| # | Status | Action |
|---|---|---|
| 5.1 | Open | Replace README.md "Project Structure" block (lines ~168-214) with the new `books/[name]/` layout |
| 5.2 | Open | Update README.md lines 179-180 (`01_story_analysis.md` / `01_story_beats.md` references) |
| 5.3 | Open | Spot-check the rest of README.md for any lingering `book/` (singular) references |
| 5.4 | Open | Commit: `Update README.md to reflect books/[name]/ layout` |

### Phase 6 — Verification pass

| # | Status | Action |
|---|---|---|
| 6.1 | Open | Grep the entire repo (excluding `.git/` and `books/tasty/reviews/**` historical files) for: `01_story_beats`, `01_story_analysis`, `chapters/weak-review`, `chapters/consistency-review`, `.claude/prompts/`. Expected: zero hits. |
| 6.2 | Open | Run `/resume tasty` and confirm the bootstrap still succeeds |
| 6.3 | Open | Run `/chapter-status tasty` and confirm chapter discovery still works |
| 6.4 | Open | Run `/story-status tasty` — expect it to now look for `15_beats.md` and find it |
| 6.5 | Open | No commit — this phase produces a verification report only |

---

## 4. Files Being Touched (Consolidated)

### Renamed / moved

| Old path | New path |
|---|---|
| `books/tasty/docs/01_story_beats.md` | `books/tasty/docs/15_beats.md` |
| `books/tasty/docs/01_story_analysis.md` | `books/tasty/docs/legacy_story_analysis.md` |
| `books/tasty/chapters/weak-review/` | `books/tasty/reviews/weak-writing/` |
| `books/tasty/chapters/consistency-review/` | `books/tasty/reviews/consistency/` |
| `.claude/prompts/chapter_prompt.md` | `books/tasty/prompts/chapter_prompt.md` |
| `.claude/prompts/resume_session.md` | `books/tasty/prompts/resume_session.md` |
| `.claude/prompts/story_outline_prompt.md` | `books/tasty/prompts/story_outline_prompt.md` |

### Edited in place (reference updates)

| File | Reason |
|---|---|
| `books/tasty/CLAUDE.md` | Source-doc reference at line 8 |
| `books/tasty/docs/orchestration_guide.md` | References at lines 63, 77, 204 |
| `.claude/skills/write-section/SKILL.md` | Reference at line 48 |
| `.claude/agents/context-loader/AGENT.md` | Reference at line 20 |
| `books/tasty/prompts/chapter_prompt.md` (after move) | Lines 10, 16, 83 |
| `books/tasty/prompts/resume_session.md` (after move) | Line 22 |
| `README.md` | Lines 179, 180 plus the Project Structure diagram |

### Created

| Path | Purpose |
|---|---|
| `docs/restructure_plan.md` | This file (already created) |
| `books/nexter/docs/.gitkeep` | Scaffold folder |
| `books/nexter/chapters/.gitkeep` | Scaffold folder |

### Removed

| Path | Reason |
|---|---|
| `.claude/prompts/` (empty folder) | All contents moved to `books/tasty/prompts/` |

---

## 5. Explicitly Out of Scope

- **Creating the new development file set for tasty** (`story_concept.md`, `characters.md`, `world_rules.md`, `open_questions.md`). Tasty's first draft is complete; back-filling these is a separate decision. If wanted, the upcoming story-component workflow can retrofit them.
- **Editing historical review files** under `books/tasty/reviews/consistency/review_ch*.md` that mention `01_story_beats.md` / `01_story_analysis.md`. These are frozen audit records.
- **Splitting `legacy_story_analysis.md` into separate concept/characters/world_rules files.** Deferred — may happen naturally if the upcoming workflow is used to re-derive tasty's story-component files.
- **Renaming the git repo root** from `tasty` to something generic (see §6).

---

## 6. Optional Consideration: Repo Root Rename

The git repo is named `tasty` but contains multiple books. Renaming the repo root to `novels`, `writing`, or similar would reduce confusion with `books/tasty/`. This is a GitHub/remote operation (not a local move) and is NOT included in any phase above. Flag for decision only.

---

## 7. Decisions Needed Before Execution

1. **Rename strategy for `01_story_analysis.md`** — proposed: `legacy_story_analysis.md`. Alternatives: keep the name, or split into concept/characters/world_rules files. **Recommendation:** `legacy_story_analysis.md`, defer the split.
2. **Review folder layout** — proposed: `reviews/weak-writing/` and `reviews/consistency/`. Alternative: flatter (`reviews/weak/`, `reviews/consistency/`). **Recommendation:** match the `.claude/rules/` filenames — `weak-writing` and `consistency`.
3. **Nexter scaffolding depth** — proposed: empty folders with `.gitkeep`. Alternative: pre-create empty template files (`story_concept.md`, etc.). **Recommendation:** empty — let the upcoming workflow produce them, so their structure is defined by the workflow, not by pre-existing templates.
4. **Delete `.claude/prompts/` entirely after the move** — proposed: yes, the folder is tasty-specific and becomes empty. **Recommendation:** delete.
5. **Repo root rename** — proposed: out of scope for now. **Recommendation:** defer until after the restructure lands.

---

## 8. Execution Protocol

- All file moves use `git mv` (preserves history, Windows-safe).
- Each phase ends with its own commit. Do NOT push.
- Run verification (Phase 6) only after Phases 1-5 have all landed.
- If any reference update is missed, Phase 6's grep will catch it — fix and amend the owning phase (or add a cleanup commit).
- Do not proceed until the user approves this plan.
