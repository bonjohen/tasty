# How the Novel Gets Written: From Manual Prompts to CLI Orchestration

---

## Part 1: The Manual Approach

### The Single-Prompt Loop

The first draft of Tasty — 48 chapters, roughly 127,000 words — was produced by a single Claude session following a single prompt file. The human's job was to start the session, point Claude at the right file, and stay out of the way.

The process looked like this:

1. The human opens a new Claude session.
2. The human says: "Read `prompts/resume_session.md` and then execute `prompts/chapter_prompt.md`."
3. Claude reads `resume_session.md`, which is a hand-maintained document describing where the project left off — what chapters exist, what just happened in the story, what the character states are, and what comes next.
4. Claude then reads `chapter_prompt.md`, which is a step-by-step procedure for writing chapters.
5. Claude begins executing that procedure.

The procedure itself is a loop:

```
Load core context files (CLAUDE.md, story analysis, continuity tracker)
    ↓
List the chapters/ directory to find the highest written chapter
    ↓
Look up which section outline contains the next unwritten chapter
    ↓
Read the current section outline (the blueprint for 2-3 chapters)
    ↓
Read the previous and next section outlines (for handoff context)
    ↓
Read the most recently written chapter (for prose rhythm)
    ↓
Draft the next chapter following the outline's beats
    ↓
Save it to chapters/chNN.md
    ↓
Verify the saved file is complete
    ↓
Update docs/continuity.md with everything that changed
    ↓
Re-read the chapter just written and the updated continuity
    ↓
Draft the next chapter in the section
    ↓
[Repeat until all chapters in the section are done]
    ↓
Report what was written
    ↓
Commit to git
    ↓
Begin the next section
```

That's it. One prompt, one loop, one session doing everything sequentially. Claude reads the context, writes the chapter, updates the bookkeeping, reads again, writes again. The `chapter_prompt.md` file contains every rule — the priority chain for creative decisions, the quality checklist, the voice rules, the guardrails about what not to do — all in a single document that Claude holds in its context window while it works.

### What the Context Files Do

The loop depends on several reference documents, each serving a specific role:

**`CLAUDE.md`** is the constitution. It defines the novel's voice (literary dark register, McCarthy/Morrison density), the world rules (pre-industrial, no firearms), the characters (who they are, what they want, how they speak), the Bleed mechanics (Hakiia's voice enters unmarked, no italics, no quotes), and the prohibitions (no redemption arcs, no triumphant violence, no genre cliches). Every creative decision in every chapter must be consistent with this file. It never changes during a writing session.

**`docs/legacy_story_analysis.md`** is the architectural blueprint. It maps the entire novel — 23 sections, each with thematic purpose, emotional function, and narrative trajectory. It tells you why each part of the story exists and what it must accomplish. Claude reads it once at the start of each session to understand the shape of the whole book.

**`docs/section_NN_outline.md`** files are the tactical instructions. Each one covers 2-3 chapters and specifies, for every chapter: the POV character, the word target, every narrative beat (in order), the chapter's emotional function, and any special notes about tone, Bleed stage, or things to avoid. These are the writing instructions. The outline says "Hakiia corrects Hurkuzak's grip on a weapon. The correction is technically right and delivered with casual contempt." Claude writes that scene.

**`docs/continuity.md`** is the single source of truth for the story's physical state. It tracks, cumulatively, what happened in every chapter: what day it is, where the characters are, who is injured and how badly, what each character knows, what objects exist and where they are, what narrative threads are open. After every chapter, Claude updates this file. Before every chapter, Claude reads it. This is how the novel stays internally consistent across 48 chapters.

**`prompts/resume_session.md`** is the session bootstrapper. When a new Claude session starts — because the previous one filled its context window, or because the human closed the terminal — this file catches Claude up. It lists what chapters exist, summarizes recent events, records key creative decisions, and points to the next section. It's maintained by hand. After each session, the human (or Claude, when asked) updates it to reflect the current state.

### How a Session Actually Plays Out

A typical session writes one section (2-3 chapters). Here is what happens inside Claude's context window during that session:

**Turn 1:** The human gives the instruction. Claude reads `resume_session.md` (about 80 lines) and `chapter_prompt.md` (about 200 lines). Both files now live in the context window.

**Turn 2:** Claude reads the three core context files. `CLAUDE.md` is 90 lines. `legacy_story_analysis.md` is several hundred lines. `continuity.md` is over 200 lines and growing with every chapter. All of this goes into the context window.

**Turn 3:** Claude lists the chapters directory, finds the highest chapter number, reads the section map (mentally — the section-to-chapter mapping is encoded in the outline headers), and reads the current section outline plus the two adjacent ones. More context consumed.

**Turn 4:** Claude reads the last written chapter. A chapter is 2,000-3,500 words. This is the largest single item Claude reads in the setup phase.

**Turn 5:** Claude drafts the first chapter of the section. This is the actual creative work — 2,000-3,500 words of literary prose following the outline's beats. The output goes into the context window too.

**Turn 6:** Claude saves the chapter, re-reads it to verify, then updates `continuity.md`. The update requires reading both the chapter and the existing continuity file, making targeted additions, and writing the result.

**Turn 7-10:** Repeat for the next chapter(s) in the section. Each chapter adds another 2,000-3,500 words of output plus the continuity update overhead.

**Turn 11:** Claude reports what was written and commits to git.

By the end of a section, Claude's context window contains: the two prompt files, the three core reference documents, 2-3 section outlines, 1-2 previously written chapters, the 2-3 newly drafted chapters, all the continuity updates, and all the file verification reads. For a three-chapter section, this approaches 40,000-60,000 tokens — a significant fraction of the context window.

### Where This Breaks Down

The manual approach works. It produced a complete first draft. But it has specific failure modes:

**Context exhaustion.** Every file Claude reads stays in the context window for the rest of the session. By the time Claude is drafting the third chapter of a section, the context is packed with material it read in step 1 that it no longer needs verbatim. The story analysis, the previous section outline, the resume file — all still sitting in context, consuming budget that could go toward better prose. When the context window fills, the session ends. The human starts a new one and the cycle restarts from zero.

**Sequential bottleneck.** Claude reads files one at a time. Reading the three core context files, the three section outlines, and the previous chapter takes 6-7 tool calls executed in sequence. Each one waits for the previous one to complete. There is no reason these reads need to happen in order — they're independent — but the single-prompt architecture has no way to parallelize them.

**Forgotten continuity updates.** The prompt says to update continuity after every chapter. Claude usually does. But in a long session, with mounting context pressure and creative momentum, the update can be skimmed, incomplete, or occasionally forgotten. There is nothing in the system that catches this. The next session inherits whatever state continuity.md is in, accurate or not.

**No automated quality checks.** The prompt includes a quality checklist (10 items: beat coverage, voice match, Bleed stage, continuity consistency, register compliance, etc.). Claude is supposed to apply this to every chapter before saving. In practice, Claude applies it mentally — there is no separate verification pass. The same mind that wrote the chapter is checking the chapter. Blind spots are invisible.

**Manual state serialization.** When a session ends, the project's state needs to be captured in `resume_session.md` so the next session can pick up. This is a manual process. Someone has to update the file to reflect which chapters were written, what the character states are, what just happened, and what comes next. If this update is incomplete or stale, the next session starts with wrong assumptions.

**Fragile session boundaries.** The resume file is a snapshot written by a human (or by Claude when asked). It tries to capture everything the next session needs to know, but it's necessarily incomplete — a summary, not the actual state. The next session reads the summary, not the source files, and may miss nuances. The resume file says "Hurkuzak is integrated" but doesn't capture the specific quality of that integration as rendered in the latest chapter's prose. That gap compounds across sessions.

---

## Part 2: The CLI Architecture

### What Changes

The CLI architecture replaces the single-prompt loop with a system of specialized components that coordinate through Claude Code's native features. Instead of one prompt trying to manage everything — context loading, creative writing, bookkeeping, quality control, state management — each concern gets its own component with its own instructions, tools, and scope.

The components are:

- **Skills** — slash commands the human types to invoke a workflow (`/write-section`, `/resume`, `/check-continuity`, `/chapter-status`)
- **Agents** — specialized subprocesses that handle specific jobs in isolation (`context-loader`, `outline-reader`, `rhythm-reader`, `quality-checker`, `continuity-updater`)
- **Hooks** — automated triggers that fire in response to events (writing a chapter file, ending a session)
- **Settings** — permissions and configuration that constrain what the system can do

These live in the `.claude/` directory at the project root:

```
.claude/
├── settings.json                         # Permissions, hooks
├── skills/
│   ├── write-section/SKILL.md            # Main orchestrator
│   ├── resume/SKILL.md                   # Session bootstrap
│   ├── check-continuity/SKILL.md         # Validation
│   └── chapter-status/SKILL.md           # Dashboard
└── agents/
    ├── context-loader/AGENT.md           # Reads core docs, returns summary
    ├── outline-reader/AGENT.md           # Reads section outlines
    ├── rhythm-reader/AGENT.md            # Reads recent chapters for prose analysis
    ├── quality-checker/AGENT.md          # Validates chapters against checklist
    └── continuity-updater/AGENT.md       # Updates continuity.md
```

The reference documents (`CLAUDE.md`, section outlines, `continuity.md`, story analysis) are unchanged. The chapter files are unchanged. The directory structure is unchanged. What changes is how Claude interacts with those files — who reads what, when, and why.

---

### Skills: Commands That Replace Prompts

In the manual approach, the human pastes or references a prompt file. In the CLI approach, the human types a slash command. The difference is not cosmetic.

A skill is a markdown file with YAML frontmatter that defines metadata (name, description, what tools it can use, what model to run on) and a body that contains the full instructions. When the human types `/write-section`, Claude Code loads that skill's `SKILL.md` and executes its instructions. The skill replaces both `resume_session.md` and `chapter_prompt.md` — not by combining them, but by making the resume unnecessary and the chapter prompt more capable.

#### `/write-section [N]` — The Main Orchestrator

This is the skill that writes chapters. It replaces the entire manual loop, but restructures it to use agents for context loading and post-chapter validation.

The human types `/write-section` (to auto-detect the next section) or `/write-section 14` (to target a specific section). The skill:

1. Scans the `chapters/` directory to find what exists.
2. Consults `docs/section_map.md` — a static lookup table mapping section numbers to chapter ranges — to identify which section comes next.
3. Spawns three agents in parallel to load context (detailed in the Agents section below).
4. Waits for all three to return.
5. Drafts each unwritten chapter in the section, sequentially.
6. After each chapter: spawns two more agents (quality checker and continuity updater) in parallel.
7. When the section is complete: reports what was written and commits to git.

The skill contains all the creative rules from the old `chapter_prompt.md` — the priority chain, the voice rules, the Bleed handling, the prohibitions, the guardrails. It also contains the operational rules: never overwrite existing chapters, never skip numbers, stop and report if files are missing, never continue past the section boundary.

The key structural difference from the manual approach: the skill does not read the large reference documents itself. It delegates that to agents. The main session's context window contains the skill instructions, the agents' compressed summaries, and the chapter drafts — not the raw multi-hundred-line reference files. This means the context budget goes to creative work, not to holding documents the main session only needs summarized.

#### `/resume` — Session Bootstrap

This replaces `prompts/resume_session.md` entirely. Instead of a manually maintained snapshot, `/resume` derives the project state from the filesystem every time it's called.

It lists the chapter files, reads `docs/section_map.md` to determine completion status, reads the tail of `docs/continuity.md` for current character states, reads the last written chapter for narrative position, and runs word counts. Then it reports: how many chapters exist, which sections are complete, where the story is, what characters are doing, and what comes next.

The state is always current because it's computed from the actual files, not from a summary someone wrote three sessions ago. There is no stale resume file. There is no forgetting to update the resume. The filesystem is the state.

#### `/check-continuity [N or range]` — Validation

This is a new capability that didn't exist in the manual workflow. The human types `/check-continuity 40-43` and the skill reads those chapters and cross-references them against `docs/continuity.md`, checking: does the timeline entry match what the chapter narrates? Are injuries tracked correctly? Does the character know things they shouldn't yet? Is the Bleed at the right stage? Are objects in the right place?

It reports issues by severity — errors (direct contradictions), warnings (missing entries), and informational notes (ambiguous timing). This catches the drift that accumulates across 48 chapters, especially the subtle kind: a wound that heals too fast, a character who knows something a chapter early, an object that appears in a location it was never brought to.

In the manual approach, continuity checking was Claude reviewing its own work in the same context window where it wrote it. Now it's a separate process that reads the chapter cold and compares it mechanically against the tracker.

#### `/chapter-status` — Dashboard

A lightweight skill that produces a progress table: every section, its chapters, their word counts, their titles, their completion status. Act totals. Overall word count. This runs on the Sonnet model (faster, cheaper) because it's pure data aggregation — no creative judgment needed.

This didn't exist in the manual workflow. The human had to ask Claude to count chapters and compute word counts ad hoc, or maintain a separate tracking document. Now it's one command.

---

### Agents: Specialized Workers with Isolated Context

This is the most significant architectural change. In the manual approach, one Claude session does everything: reads reference documents, writes prose, updates the tracker, checks quality. All of these activities share a single context window. The story analysis that was needed for setup is still consuming context when Claude is drafting its third chapter. The quality checklist competes for attention with the creative flow.

Agents are separate Claude processes, each with their own context window, their own instructions, and their own tool access. They are spawned by the main session, do their work independently, and return results. When an agent finishes, only its output enters the main session's context — not everything the agent read along the way.

This is the key insight: **agents act as context compressors**. The `context-loader` agent reads three large documents (CLAUDE.md at 90 lines, story analysis at several hundred lines, continuity at 200+ lines) and returns a structured summary of maybe 1,000 words. The main session gets the summary. The raw documents never enter the main session's context window at all. That budget is preserved for drafting.

#### context-loader

**Reads:** `CLAUDE.md`, `docs/legacy_story_analysis.md`, `docs/continuity.md`
**Returns:** A structured summary with sections for voice rules, world rules, character states (physical, location, knowledge, emotional), timeline position, Bleed stage, and open narrative threads.
**Model:** Sonnet (structured extraction, not creative work)
**Tools:** Read, Grep

This agent replaces the manual approach's "Step 1: Load Core Context" — but instead of dumping three full documents into the main context, it returns a compressed briefing. The summary format is specified in the agent's instructions so the main session knows exactly what to expect: each section has a heading, each character state has the same fields, the Bleed stage is always explicitly stated.

#### outline-reader

**Reads:** The current section outline, the previous section outline, the next section outline
**Returns:** The chapter specifications (POV, word targets, every beat verbatim, function paragraphs, notes) plus handoff context from adjacent sections.
**Model:** Sonnet
**Tools:** Read

This agent is told which section number to read. It handles the zero-padded filename convention and the edge cases (section 1 has no previous, section 23 has no next). Critically, it returns the outline beats verbatim — not summarized. The writing agent needs the exact instructions ("Hakiia corrects Hurkuzak's grip on a weapon. The correction is technically right and delivered with casual contempt.") not a paraphrase. But the adjacent section outlines are summarized, because the main session only needs their handoff context, not their full beat lists.

#### rhythm-reader

**Reads:** The last 1-2 written chapters (2,000-3,500 words each)
**Returns:** A prose rhythm analysis — sentence length patterns, paragraph structure, emotional register at the handoff point, scene state (location, time, who is present, what just happened), POV voice characteristics, and specific Bleed observations with short quotes.
**Model:** Sonnet (with high effort, because prose analysis requires careful reading)
**Tools:** Read

This is the most novel agent. In the manual approach, Claude reads the last chapter in full — 2,000-3,500 words consuming context — and then tries to match its rhythm while drafting. The rhythm-reader agent reads the chapter, analyzes it, and returns a compact report (~1,200 words) about what the next chapter needs to continue: "sentences are averaging 20-25 words with staccato fragments in moments of physical action," "emotional register at handoff is suspended tension — Hurkuzak has just made a decision but hasn't acted," "the Bleed manifested twice in the last three paragraphs as tactical observations unmarked from Hurkuzak's own thoughts."

The main session gets the analysis, not the raw text. It can match the rhythm without carrying the full chapter in context.

#### quality-checker

**Reads:** The newly written chapter, the section outline, CLAUDE.md, continuity.md
**Returns:** A pass/fail report on 10 criteria with specific citations from the chapter text.
**Model:** Sonnet (with high effort — quality checking requires rigor)
**Tools:** Read, Grep

This is the agent that replaces the self-review problem. In the manual approach, the same Claude that wrote the chapter checks the chapter. It's grading its own work in the same context where it wrote it — the same biases, the same blind spots. The quality-checker agent reads the chapter cold, in a separate context window, with no memory of the creative decisions that went into it. It compares mechanically: did this beat from the outline appear in the chapter? Does the voice match the POV character? Is the Bleed at the right stage? Are there any modern idioms? Any genre cliches from the prohibition list?

The 10-point checklist:
1. **Beat coverage** — every major outline beat is present, not just hinted at
2. **Emotional function** — the chapter achieves what the outline says it must
3. **POV voice match** — Hurkuzak's searching prose vs. Vark's cool efficiency
4. **Bleed stage accuracy** — unmarked, at the correct integration level
5. **Continuity consistency** — no contradictions with the tracker
6. **Chapter numbering** — filename matches header
7. **Register compliance** — no anachronisms or modern phrasing
8. **Prohibited patterns** — no redemption arcs, no triumphant violence, no emotion-summarizing
9. **Title earned** — the title connects to the chapter's substance
10. **Word count** — within the outline's target range

Each criterion gets a PASS or FAIL with a specific quote from the chapter. If the checker finds failures, the main session can address them before moving to the next chapter. This feedback loop didn't exist in the manual approach.

#### continuity-updater

**Reads:** The newly written chapter, `docs/continuity.md`
**Writes:** Targeted edits to `docs/continuity.md`
**Model:** Sonnet (with high effort — precision matters for state tracking)
**Tools:** Read, Edit, Grep

This is the only agent that modifies files. It reads the new chapter, reads the current continuity tracker, and makes cumulative additions: a new timeline row, updated character states, new injuries tracked, knowledge recorded, objects listed, threads opened or resolved.

The agent's instructions emphasize cumulative edits — don't rewrite the document, don't delete still-relevant information, keep entries concise and factual. It uses the Edit tool to make targeted changes rather than rewriting the file. After updating, it reports what it changed so the main session can verify.

In the manual approach, continuity updates were part of the main writing session's responsibilities. The writer had to shift from creative mode to bookkeeper mode and back. Sometimes the update was thorough. Sometimes it was perfunctory. Sometimes it was forgotten. The separate agent ensures it always happens, always follows the same rules, and never competes with the creative work for context or attention.

---

### Parallel Execution: The Architecture's Key Advantage

The agents aren't just separated for cleanliness — they're separated so they can run simultaneously. The manual approach reads files one at a time, sequentially:

```
Manual (sequential):
  Read CLAUDE.md ──> Read story analysis ──> Read continuity ──> Read outline ──>
  Read previous outline ──> Read next outline ──> Read last chapter ──> Begin drafting
  (7 sequential reads before any writing happens)
```

The CLI approach spawns three agents at once:

```
CLI (parallel):
  ┌─ context-loader (reads CLAUDE.md + analysis + continuity) ─┐
  ├─ outline-reader (reads 3 section outlines)                  ├─> Begin drafting
  └─ rhythm-reader (reads last 1-2 chapters)                   ─┘
  (All context loaded in one parallel batch)
```

After each chapter, two more agents run in parallel:

```
  ┌─ continuity-updater (updates tracker) ──┐
  └─ quality-checker (validates chapter)    ─┘──> Continue to next chapter
```

The wall-clock time for context loading drops from 7 sequential operations to 1 parallel batch. Post-chapter processing drops from 2 sequential tasks to 1 parallel batch. Over a 3-chapter section, this adds up.

---

### Hooks: Automated Workflow Enforcement

Hooks are shell commands or prompt-based checks that fire automatically in response to events. They replace human discipline with mechanical enforcement.

#### Post-Write Continuity Reminder

**Event:** Any file is written (PostToolUse on the Write tool)
**What it does:** Checks if the written file is a chapter (`chapters/ch*.md`). If so, injects a reminder into the session: "Continuity update needed for this chapter."

This catches the case where someone writes a chapter outside the `/write-section` flow — manually, or through a different prompt — and forgets to update continuity. The hook doesn't block anything. It adds a reminder to the conversation context so Claude sees it and acts on it.

In the manual approach, there was nothing to catch this. The prompt said "update continuity after each chapter" and relied on Claude to remember. Now the system remembers for it.

#### Stop Verification

**Event:** The session is about to end (Stop hook)
**What it does:** A prompt-based check that reviews the session transcript and asks: Were any chapters written? If so, was continuity updated for each one? Was a complete section finished? If so, was there a git commit? Are there any partially-written sections?

If any check fails, the hook blocks the session from ending and tells Claude what remains. This prevents the most common failure modes: sessions ending with uncommitted work, sessions ending mid-section, sessions ending with untracked continuity changes.

In the manual approach, session endings were uncontrolled. The context window filled up, or the human closed the terminal, and whatever state was in flight remained in whatever condition it was in. The stop hook adds a checkpoint.

---

### Settings: Permissions and Boundaries

The `.claude/settings.json` file defines what the system is allowed to do. This is less about the novel and more about safety:

**Allowed tools** list exactly what operations the orchestration system can perform: reading files, writing to the chapters directory and continuity file, searching, running git commands and word counts, and spawning agents. Anything not on the list requires explicit human approval.

This prevents scope creep. The writing system can't accidentally modify section outlines (they're read-only inputs). It can't push to a remote repository (only local commits). It can't run arbitrary shell commands. The boundaries are explicit.

---

### The Section Map: A Small File That Eliminates Parsing

`docs/section_map.md` is a static lookup table:

```
| Section | Chapters | Range | Title                                  |
|---------|----------|-------|----------------------------------------|
| 1       | 3        | 1-3   | Winter Hunt and Brother Dynamic         |
| 2       | 2        | 4-5   | The Road Collapse and the Fall          |
...
| 23      | 1        | 48    | Sequel Hook                            |
```

In the manual approach, Claude had to read section outline headers to figure out which section contains which chapters. This meant opening outline files just to parse their headers — wasted reads, wasted context. The section map is read once, cheaply, and gives the orchestrator everything it needs to route work.

It also records the act boundaries (Act I: Sections 1-7, Chapters 1-16; Act II: Sections 8-15, Chapters 17-33; Act III: Sections 16-23, Chapters 34-48) so the `/resume` and `/chapter-status` skills can report act-level progress without computation.

---

### How It All Fits Together

Here is a complete `/write-section` invocation, annotated:

```
Human types: /write-section

SKILL loads: .claude/skills/write-section/SKILL.md
  │
  ├─ Scans chapters/ ──> finds ch01-ch48 all exist
  ├─ Reads docs/section_map.md ──> determines next unwritten section
  │
  │  (If all chapters exist, reports "first draft complete" and stops.)
  │  (If section 14 has ch30 but not ch31, targets section 14, chapter 31.)
  │
  ├─ SPAWNS 3 AGENTS IN PARALLEL:
  │   ├─ context-loader ──> reads 3 core docs ──> returns ~1000-word summary
  │   ├─ outline-reader ──> reads 3 outlines ──> returns chapter specs + handoff
  │   └─ rhythm-reader ──> reads last chapter(s) ──> returns prose analysis
  │
  │  (Main session waits. No context consumed yet except the skill text
  │   and the section map. When agents return, their compressed outputs
  │   enter the main context — maybe 3000 words total instead of 15,000+
  │   in raw documents.)
  │
  ├─ DRAFTS CHAPTER 31:
  │   Uses: outline beats (verbatim from outline-reader),
  │         voice rules (from context-loader summary),
  │         character states (from context-loader summary),
  │         prose rhythm (from rhythm-reader analysis)
  │   Writes: chapters/ch31.md
  │
  │   ──> POST-WRITE HOOK fires: "Continuity update needed for ch31."
  │
  │   Re-reads ch31.md to verify file integrity.
  │
  ├─ SPAWNS 2 AGENTS IN PARALLEL:
  │   ├─ continuity-updater ──> reads ch31 + continuity.md ──> edits continuity.md
  │   └─ quality-checker ──> reads ch31 + outline + CLAUDE.md ──> returns report
  │
  │   Quality report: 10/10 PASS (or: 9/10, FAIL on beat coverage — fix needed)
  │
  │   If failures: main session edits the chapter, re-runs quality check.
  │
  ├─ Re-reads ch31.md + updated continuity.md
  │
  ├─ DRAFTS CHAPTER 32 (same process)
  │   ...
  │
  ├─ SECTION COMPLETE. Reports:
  │   - Chapters written: 31, 32
  │   - Titles, word counts, POV
  │   - Deviations from outline (if any)
  │   - Quality check summary
  │   - Next section to write
  │
  ├─ git add chapters/ch31.md chapters/ch32.md docs/continuity.md
  │  git commit -m "Draft section 14: The Terrible Realization (ch30-ch31)"
  │
  └─ DONE.

  ──> STOP HOOK fires: checks that continuity was updated, commit was made,
      section is complete. All pass. Session may end cleanly.
```

---

### What the Architecture Adds

**Reliability.** The manual approach depended on Claude remembering to update continuity, apply the quality checklist, and commit at section boundaries. The CLI approach enforces these through hooks and separate agents. Forgetting is structurally impossible — the continuity-updater agent always runs, the quality-checker agent always runs, the stop hook always checks.

**Context efficiency.** The manual approach filled the context window with raw documents that were needed once and carried forever. The CLI approach compresses reference documents through agents, keeping only summaries in the main context. The creative work gets more of the context budget.

**Parallel execution.** The manual approach loaded context sequentially — seven file reads before any writing. The CLI approach loads context in one parallel batch (three agents) and processes post-chapter work in another parallel batch (two agents). Less waiting.

**Separation of concerns.** The manual approach asked one Claude session to be a reader, a writer, a bookkeeper, a quality reviewer, and a git operator simultaneously. The CLI approach gives each role to a specialist. The writer writes. The checker checks. The updater updates. Each operates with instructions tuned to its specific job.

**Clean session boundaries.** The manual approach serialized state into a human-maintained resume file. The CLI approach derives state from the filesystem every time. There is no stale snapshot. `/resume` computes the current state; it doesn't read someone's memory of what the state was.

**Auditability.** The quality checker produces a written report with pass/fail verdicts and quoted citations. The continuity updater reports what it changed. The section completion report lists every deviation from the outline. In the manual approach, these checks happened (or didn't) inside Claude's unobservable reasoning. Now they produce artifacts you can review.

**Safety boundaries.** The settings file defines exactly what the system can and cannot do. Chapter files can be written. Section outlines cannot be modified. Git can commit locally but not push remotely. These constraints are enforced by the CLI framework, not by hoping Claude follows instructions.
