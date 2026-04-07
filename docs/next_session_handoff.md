# Next Session Handoff

**Date prepared:** 2026-04-07
**Reason:** Restructure phase complete. Next project is the story-component production workflow.

---

## 1. Resume Prompt (paste this into the new session)

> Read `docs/next_session_handoff.md`, then `docs/restructure_plan.md` for context. We just finished restructuring the project and are now starting the next project: a workflow that helps me produce the information needed to generate story components (story_concept.md, characters.md, world_rules.md, open_questions.md). Begin by entering Plan Mode and exploring how this workflow should be designed before writing any code or files. I want to review the design before any implementation.

---

## 2. What Was Just Completed

The project structure was reorganized over 5 commits on `main` (local only, **not pushed**):

| Commit | Phase | Description |
|---|---|---|
| `a041b6e` | 1 | Rename tasty legacy docs: `01_story_beats.md` → `15_beats.md`, `01_story_analysis.md` → `legacy_story_analysis.md`. Updated 4 live references in tasty CLAUDE.md, orchestration_guide.md, write-section SKILL.md, context-loader AGENT.md. |
| `169a9b4` | 2 | Moved 96 review files: `books/tasty/chapters/weak-review/` → `books/tasty/reviews/weak-writing/`, `books/tasty/chapters/consistency-review/` → `books/tasty/reviews/consistency/`. `chapters/` now contains only `chXX.md` files. |
| `2375a29` | 3 | Moved tasty-specific legacy prompts: `.claude/prompts/*` → `books/tasty/prompts/*`. Updated internal path refs. Removed empty `.claude/prompts/` folder. |
| `b243add` | 4 | Created empty scaffold: `books/nexter/docs/.gitkeep` and `books/nexter/chapters/.gitkeep`. |
| `34f599c` | 5 | Refreshed README.md to use `books/[name]/` template throughout. Decoupled `.claude/settings.json` hooks: PostToolUse continuity reminder and PreToolUse beat-stability gate now match `books/<bookname>/...` patterns and extract the book name from the file path at runtime — no longer hardcoded to `tasty` or enumerated as `tasty|nexter`. |

Full plan with rationale and per-file detail: `docs/restructure_plan.md`.

### Verification (Phase 6) — all clean
- No live references to `01_story_beats` / `01_story_analysis` (the only hits are in the plan doc itself and 6 historical review files under `books/tasty/reviews/consistency/`, which are intentionally frozen audit records).
- No references to `chapters/weak-review` or `chapters/consistency-review` outside the plan doc.
- No references to `.claude/prompts/`. Folder is gone.
- `books/tasty/chapters/` contains exactly 48 `chXX.md` files, no subfolders.
- `.claude/settings.json` validates as JSON.

---

## 3. Current Repository Layout

```
tasty/                                     ← repo root (defer renaming until later)
├── CLAUDE.md                              ← workflow rules (book-agnostic)
├── README.md                              ← updated, uses books/[name]/ template
├── docs/                                  ← project-level plans/designs
│   ├── restructure_plan.md
│   └── next_session_handoff.md            ← this file
├── books/
│   ├── tasty/                             ← Book 1, first draft complete
│   │   ├── CLAUDE.md                      ← story rules (voice, characters, world)
│   │   ├── chapters/                      ← ch01.md … ch48.md (clean, prose only)
│   │   ├── docs/
│   │   │   ├── 15_beats.md                ← was 01_story_beats.md
│   │   │   ├── legacy_story_analysis.md   ← was 01_story_analysis.md
│   │   │   ├── continuity.md
│   │   │   ├── section_NN_outline.md      ← ×23
│   │   │   ├── section_map.md
│   │   │   ├── orchestration_guide.md
│   │   │   └── reader.html
│   │   ├── reviews/
│   │   │   ├── consistency/               ← 48 historical review files
│   │   │   └── weak-writing/              ← 48 historical review files
│   │   └── prompts/                       ← legacy manual prompts (reference only)
│   │       ├── chapter_prompt.md
│   │       ├── resume_session.md
│   │       └── story_outline_prompt.md
│   └── nexter/                            ← Book 2, in development (empty)
│       ├── CLAUDE.md                      ← placeholder
│       ├── chapters/.gitkeep
│       └── docs/.gitkeep
└── .claude/
    ├── settings.json                      ← hooks now book-agnostic via wildcards
    ├── settings.local.json
    ├── rules/                             ← story-development.md, weak-writing.md, poor-consistency.md, writing-blunders.md
    ├── skills/                            ← 9 SKILL.md files
    └── agents/                            ← 8 AGENT.md files
```

---

## 4. The Next Project: Story-Component Production Workflow

### What the user asked for
> "Our next project is to produce a workflow that helps the user to produce information needed to produce the story components."

### What this means concretely

The **Development File Set** (per `CLAUDE.md` lines 64-69) is the canonical input for the existing `/generate-beats` skill. Each book is supposed to have:

- `books/[name]/docs/story_concept.md` — premise, emotional core, theme, status
- `books/[name]/docs/characters.md` — role, wound, desire, fear, contradiction, arc, secrets, relationship map
- `books/[name]/docs/world_rules.md` — only rules that materially affect causality
- `books/[name]/docs/open_questions.md` — unresolved decisions with urgency and blocking status

`books/nexter/` currently has none of these. `books/tasty/` doesn't have them either — the closest equivalent is the legacy `legacy_story_analysis.md`, which is a single monolithic file that predates this convention.

### What needs to be designed

A workflow (likely a new skill, possibly with one or more new agents) that:

1. **Walks the user through producing the development file set** for a book that has none.
2. Produces files that are immediately consumable by the existing `/generate-beats` → `/stabilize-beats` → `/expand-sections` → `/write-section` pipeline.
3. Should work for both the **greenfield case** (nexter — start from rough premise) and possibly a **backfill case** (tasty — derive the four files from the existing `legacy_story_analysis.md` and chapters). The user has not yet decided whether backfill is in scope.

### Open design questions to discuss before building
- **Conversation-driven vs. interview-driven vs. template-driven?** The existing `.claude/rules/story-development.md` already contains behavioral rules for "story development conversations" — does the new workflow extend that, or replace it, or sit alongside it?
- **One skill that produces all four files, or separate skills per file?** A single `/develop-concept` is one option; `/produce-concept`, `/produce-characters`, etc. is another.
- **Order of production** — `story_concept.md` first (premise/theme), then `characters.md`, then `world_rules.md`, with `open_questions.md` accumulating throughout? Or some other order?
- **What does "ready" look like for each file?** Each needs an exit criterion before the user can move to the next stage. The existing beat status states (Exploratory → Provisional → Stable → Locked) are a model.
- **Does it use any agents?** A `concept-interviewer` agent? A `consistency-checker` for cross-file alignment? Or is this a single-skill conversation?
- **Backfill for tasty** — in scope, deferred, or no?

These are not rhetorical — they should be explicitly answered before any code/files are written.

---

## 5. Approved Decisions Carried Forward

These were approved during the restructure and remain in force unless changed:

| # | Decision | Status |
|---|---|---|
| 1 | `01_story_analysis.md` renamed to `legacy_story_analysis.md`, kept as legacy reference, not split. | Done |
| 2 | Review folders use `weak-writing` / `consistency` to match `.claude/rules/` filenames. | Done |
| 3 | Nexter scaffolding is empty `.gitkeep` only — the upcoming workflow defines the file structure, not pre-existing templates. | Done |
| 4 | `.claude/prompts/` folder deleted after move. | Done |
| 5 | Repo root rename (`tasty` → something generic) deferred. **Decouple any path that mentions `tasty` with variables** so future rename has minimal blast radius. | In effect for new work |

**Rule for new work:** never hardcode `tasty` or `nexter` in `.claude/` files, hooks, skills, or agents. Use `{book}`, `[name]`, or `<bookname>` placeholders and resolve at runtime.

---

## 6. User Preferences & Guardrails

Sourced from global `CLAUDE.md` and prior session feedback. These override default behavior:

- **Never `git push`** unless explicitly requested in the current message. Authorization does not carry across messages or sessions.
- **Never use `ANTHROPIC_API_KEY`.** A preflight hook blocks Bash if it is set. If blocked, stop and ask the user to unset it and restart. (This blocked the start of the previous session — confirm it is unset before relying on Bash.)
- **Never trigger credit-consuming runs** without explicit current-message permission.
- **Plan-before-execute on non-trivial work.** Use Plan Mode to design, get approval, then execute. Once approved, run end-to-end without pausing between phases for further approval.
- **Questions are read-only.** Don't edit files when the user is asking "why" or "what".
- **Don't ask confirmation questions.** Make a reasonable assumption and execute. The user will correct.
- **Scope discipline.** Don't expand beyond the literal verb in the request.

---

## 7. Working Tree State at Handoff

After session-end housekeeping commits, the working tree is clean. `books/tasty/docs/note_01.md` was intentionally removed by the user and that deletion was committed. `docs/restructure_plan.md` and `docs/next_session_handoff.md` are both tracked.

**Verify at session start:**
```bash
git status --short
git log --oneline -7   # should show e9a8d11 + 34f599c + the four prior phase commits + b58e786
```

Expected log top:
```
e9a8d11 Add project restructure plan and create initial docs/ and chapters/ folders
34f599c Refresh README.md layout and decouple settings.json hooks from book names
b243add Scaffold nexter docs/ and chapters/ folders
2375a29 Move tasty legacy prompts to books/tasty/prompts/ to match CLAUDE.md
169a9b4 Move review output out of chapters/ into reviews/
a041b6e Rename tasty legacy docs to match new convention
b58e786 Refactor skills to support book-specific paths and improve argument handling
```

**None of these commits have been pushed.**

---

## 8. Suggested First Actions for the Next Session

1. Read this file (`docs/next_session_handoff.md`).
2. Read `docs/restructure_plan.md` for the full restructure context.
3. Run `git status --short` and `git log --oneline -6` to confirm the repo state matches §7.
4. Confirm `ANTHROPIC_API_KEY` is unset (if blocked at session start, stop and tell the user).
5. Ask the user about the unrelated `note_01.md` deletion — commit it, restore it, or leave it.
6. **Enter Plan Mode** and start designing the story-component production workflow. Discuss the open questions in §4 with the user before producing any files. Do not write code or new skill files until the user approves a design.

---

## 9. Reference Pointers

| What | Where |
|---|---|
| Workflow rules (project-wide) | `CLAUDE.md` |
| Tasty story rules (voice, characters, world) | `books/tasty/CLAUDE.md` |
| Existing development file set spec | `CLAUDE.md` lines 64-69 |
| Existing skills (story development) | `.claude/skills/{generate-beats,stabilize-beats,expand-sections,story-status,check-structure}/SKILL.md` |
| Existing agents (development) | `.claude/agents/{beat-analyzer,section-generator,structure-validator}/AGENT.md` |
| Behavioral rules for development conversations | `.claude/rules/story-development.md` |
| Prior restructure plan and rationale | `docs/restructure_plan.md` |
| Tasty's closest equivalent to the new file set | `books/tasty/docs/legacy_story_analysis.md` |
