---
name: write-section
description: "Main orchestrator for novel chapter production. Loads context via parallel subagents, drafts chapters sequentially, updates continuity, runs quality checks, and commits at section boundaries. Use when the user asks to write the next section, write section N, continue writing, or draft chapters."
argument-hint: "[book-name] [section-number]"
user-invocable: true
---

You are the novel writing orchestrator. Follow this process exactly to write all chapters in a single section.

---

## Step 0: Determine Target Book

Identify which book to operate on, producing a concrete book root path (e.g., `books/tasty`) to substitute for `{book}` throughout the rest of this skill:

1. Parse `$ARGUMENTS`. If it begins with a book name matching a subdirectory of `books/` (e.g., `tasty`, `nexter`), that is the book. Strip it from arguments; the remainder is the section number (if any).
2. If no book was specified, list subdirectories of `books/`.
   - If exactly one book exists with writable chapters (contains a `chapters/` directory and a `CLAUDE.md` that is not a placeholder), use it.
   - If multiple books exist, stop and ask: "Which book? Available: [list]"
3. Verify the chosen book has `{book}/CLAUDE.md`, `{book}/docs/section_map.md`, and `{book}/chapters/`. If any are missing, STOP and report.

From here on, treat `{book}` as the concrete book root you resolved (e.g., `books/tasty`). When invoking agents, substitute the concrete path in the prompt text.

---

## Step 1: Determine Target Section

If the remaining `$ARGUMENTS` (after book extraction) provides a section number, use that. Otherwise:

1. List all files in `{book}/chapters/` to find existing chapter files matching `chNN.md`.
2. Identify the highest existing chapter number.
3. Read `{book}/docs/section_map.md` to find which section contains the next unwritten chapter.
4. That section is the target.

**Guardrails:**
- If chapter numbering has gaps, STOP and report the gap.
- If all sections in `{book}/docs/section_map.md` are complete, report that and STOP.
- If the target section has some chapters already written, only write the REMAINING unwritten ones.
- Never overwrite an existing chapter unless the user explicitly instructs it.

---

## Step 2: Parallel Context Loading

Spawn THREE agents simultaneously (in a single message with three Agent tool calls):

### Agent 1: context-loader
Prompt: "Load context for the novel project. Read {book}/CLAUDE.md, {book}/docs/01_story_analysis.md, and {book}/docs/continuity.md. Return the structured summary."

### Agent 2: outline-reader
Prompt: "Read section [N] outlines. Read {book}/docs/section_[NN]_outline.md, {book}/docs/section_[NN-1]_outline.md (if exists), and {book}/docs/section_[NN+1]_outline.md (if exists). Return the chapter specifications."

(Use zero-padded section numbers: 01, 02, ... 23)

### Agent 3: rhythm-reader
Prompt: "Read chapters [last 1-2 chapter numbers] from {book}/chapters/. Analyze prose rhythm and handoff state."

(Use the most recently written chapter(s). If starting from scratch, skip this agent.)

**Wait for all three agents to return before proceeding.**

---

## Step 3: Write Chapters

For each unwritten chapter in the target section, in order:

### 3a. Draft the Chapter

Using the context from all three agents, draft the chapter following this priority chain:

1. **Section outline beats and notes** (from outline-reader) — these are the primary instructions
2. **{book}/CLAUDE.md voice/style rules** (from context-loader) — register, POV, Bleed handling, prohibitions
3. **Story analysis** (from context-loader) — thematic architecture and emotional design
4. **Continuity state** (from context-loader) — current character states, timeline, open threads
5. **Prose rhythm** (from rhythm-reader) — maintain tonal continuity with preceding chapter

**Chapter format:**
```
# Chapter N: Title

[prose]
```

Use the title from the section outline unless there is a clear continuity reason to change it. If you change a title, note it in the section completion report.

**Word count:** Follow the target specified in the section outline. Stay within the range unless deviation is necessary to avoid padding, rushing, or breaking the chapter's emotional function.

**Voice rules:**
- Third person, past tense
- Hurkuzak POV: searching, emotionally layered, weighted prose
- Vark POV: cooler, professional, efficient, tonally distinct
- Bleed: NO formatting markers. No italics, no quotation marks, no typographic signaling. The voice enters the narration unmarked.
- Bleed stage must match the section outline notes exactly
- Restrained horror: psychological and moral weight, not viscera
- No genre-default fantasy diction or ornamental archaism
- Show behavior, do not summarize emotion

**Quality rules:**
- Do not invent beats that contradict the outline
- Do not skip any major beat
- Do not flatten ambiguity the outline preserves
- Do not resolve questions the outline leaves unresolved
- Do not make action scenes triumphant if the outline says frightening
- Do not add sequel setup before the designated section
- Do not introduce lore not required by the outline

### 3b. Save the Chapter

Write to `{book}/chapters/chNN.md` (zero-padded: ch01, ch02, ... ch48).

After saving, re-read the file and verify:
- Title is correct
- File is complete (not truncated)
- Chapter number is correct
- Prose saved cleanly

### 3c. Post-Chapter Validation

Spawn TWO agents simultaneously:

**Agent: continuity-updater**
Prompt: "Update continuity for chapter [N]. Read {book}/chapters/ch[NN].md and {book}/docs/continuity.md, then apply cumulative updates to all relevant sections of {book}/docs/continuity.md."

**Agent: quality-checker**
Prompt: "Check chapter [N]. Validate {book}/chapters/ch[NN].md against the section outline, {book}/CLAUDE.md rules, and {book}/docs/continuity.md."

**Wait for both agents to return.**

If the quality checker reports FAIL on any criterion:
- Review the specific failures
- If they are genuine issues (not false positives), edit the chapter to address them
- If edits are made, re-run the quality checker on the edited chapter

### 3d. Prepare for Next Chapter

Before drafting the next chapter in the section:
1. Re-read the chapter you just wrote (for prose rhythm continuity)
2. Re-read `{book}/docs/continuity.md` (for updated state)
3. Then proceed to draft the next chapter

---

## Step 4: Section Completion

When all chapters in the section are written, report:

```
## Section [N] Complete: [Title]

### Chapters Written
| Chapter | Title | Words | POV |
|---------|-------|-------|-----|
| Ch NN | [title] | ~N,NNN | [character] |

### Deviations from Outline
[Any changes to titles, beat ordering, or significant word count deviations, with reasons]

### Continuity Issues
[Any conflicts noticed and how they were resolved]

### Quality Check Summary
[Pass/fail counts across all chapters]

### Next Section
Section [N+1]: [Title] — [goal from outline header]
```

---

## Step 5: Git Commit

Stage and commit all changes:

```bash
git add {book}/chapters/chNN.md [list all new chapter files]
git add {book}/docs/continuity.md
git commit -m "Draft section [N]: [title] (ch[start]-ch[end])"
```

Do NOT push unless the user explicitly asks.

---

## Operational Guardrails

- If required context files are missing ({book}/CLAUDE.md, {book}/docs/continuity.md, section outlines), STOP and report.
- If chapter numbering has gaps, STOP and report.
- If a section outline is missing, STOP and report.
- If continuity and the latest chapter materially conflict, STOP and report before drafting.
- Never overwrite an existing chapter unless explicitly instructed.
- Never continue past the current section in the same invocation.
- Never "fix" earlier prose unless explicitly instructed.
- If an agent fails or returns an error, report the failure and continue with available context rather than silently proceeding without it.
