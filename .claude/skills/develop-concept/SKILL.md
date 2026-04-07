---
name: develop-concept
description: "Drives a focused discovery conversation that produces or revises books/{name}/docs/story_concept.md. The entry point for a book that has no story concept yet, and the way to push an existing concept toward Provisional or Stable. Use when the user wants to develop the story concept, work out the premise, the protagonist, the inciting disruption, the ending direction, or wants to start a new book from scratch."
argument-hint: "[book-name]"
user-invocable: true
---

Drive one discovery round on a book's `story_concept.md`. Each invocation runs one question-and-write cycle. Run repeatedly to converge on a stable concept.

## Step 0: Determine Target Book

Resolve which book to work on; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, if only one book exists under `books/`, use it. If multiple, ask the user which.
3. Verify `{book}/docs/` exists. If not, create it.

## Step 1: Read Current State

Read whichever of these exist (use Glob to check first, then Read):

- `{book}/CLAUDE.md` — story rules, voice, prohibitions
- `{book}/docs/story_concept.md` — the target file
- `{book}/docs/characters.md` — sibling file (for context only — never written by this skill)
- `{book}/docs/world_rules.md` — sibling file (for context only)
- `{book}/docs/open_questions.md` — accumulated unresolved decisions

Note the **Status** of `story_concept.md` if it exists. If the file does not exist, this is a cold start.

## Step 2: Spawn the concept-interviewer agent

Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt.

Prompt: "Produce the next focused question round for the discovery conversation on `story_concept.md`. Book root: {book}. Target file: story_concept.md. Read {book}/CLAUDE.md (if exists), {book}/docs/story_concept.md (if exists), {book}/docs/characters.md (if exists), {book}/docs/world_rules.md (if exists), and {book}/docs/open_questions.md (if exists). Identify the highest-priority unresolved questions for the concept file specifically — premise, protagonist wound/desire/contradiction, central engine, inciting disruption, antagonistic force, ending direction. Return the question round in the prescribed format (Current story shape / Most important unresolved questions / Questions for this round, 3-7 questions)."

Wait for the agent to return.

## Step 3: Present the round to the user

Print the agent's output verbatim. Add nothing before or after it except a single line at the end:

> When you have answered, I will use your answers to update `story_concept.md` (and `open_questions.md` for anything we cannot decide this round).

Then stop and wait for the user's answer.

## Step 4: Synthesize the user's commitments

When the user replies, do not immediately invoke the writer. First, internally answer these questions:

1. **Are the answers substantial enough to warrant a write?** A one-line non-answer ("not sure yet") is not enough. A real commitment to even one of premise / protagonist wound / inciting / ending IS enough.
2. **Which sections of `story_concept.md` does this answer touch?** Be specific. List them.
3. **What is unresolved or deferred?** These become open questions, not concept content.
4. **Does anything belong in a sibling file?** A character-level detail belongs in `characters.md`, a causal rule belongs in `world_rules.md`. Note these but do NOT write them — the writer agent will report them and the user can run the sibling skill.

If the answers are too thin to write, do not invoke the writer. Instead, briefly tell the user what is still unclear and offer to run another round (return to Step 2 with the user's permission). Do not try to write a placeholder file.

If the answers are substantial enough, proceed to Step 5.

## Step 5: Spawn the concept-writer agent

Construct a structured commitments payload from the user's answers. The payload should be your synthesis (in plain prose, organized by `story_concept.md` section), not raw user dialogue.

Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt.

Prompt: "Write or revise story_concept.md for the book at book root {book}. Target file: story_concept.md. Read {book}/CLAUDE.md (if exists) and all four discovery files for context. Apply the following commitments to the target file. If the file does not exist, create it from your canonical template. If it exists, apply surgical Edits — cumulative, not destructive. Promote status from Exploratory to Provisional only if these commitments substantially populate the required sections. Do not promote past Provisional. Update the Last revised date to today and update the Architecture Status block. Also append the listed open questions to {book}/docs/open_questions.md (creating it from template if absent). Report what changed in the structured format.

COMMITMENTS:
[Your synthesis here, organized by section: Premise / Emotional Core / Theme / Protagonist Shape / Central Relationship or Engine / Antagonistic Force / Inciting Disruption / Ending Direction / Tonal & Aesthetic Constraints. Only include sections the user has actually committed to. Mark each as 'new content' or 'revision of existing'.]

OPEN QUESTIONS TO APPEND:
[List of questions surfaced this round that the user could not or did not resolve. For each: question text, urgency (High/Medium/Low), blocks (beats / sections / drafting / nothing), context, provisional answer if any.]"

Wait for the agent to return.

## Step 6: Report to the user

Present the agent's report (target file, action, status before/after, sections changed, open questions added) and then add a **Recommended Next Step** section with one of:

- **Run another round of `/develop-concept`** — if the file is still Exploratory and major sections are placeholder. State which sections are still empty.
- **Run `/develop-characters`** — if the concept now names characters whose wounds/desires need to be developed before beats can be generated. State which characters.
- **Run `/develop-world`** — if the concept names world rules (magic, technology, social structure) that need to be made causal before beats. State which rules.
- **Mark `story_concept.md` as Stable and run `/generate-beats`** — if the file is now Provisional with all required sections populated and the user is satisfied. Promotion to Stable is the user's call; tell them how to do it (manually edit the Status header, or you can offer to do it for them after explicit confirmation).

Also surface anything the writer agent flagged as **Material for sibling files**. Tell the user which sibling skill to run for each item. Do not write those siblings yourself.

## Discipline (this skill specifically)

- **One round per invocation.** Do not loop. The user re-invokes the skill to run another round.
- **Only writes `story_concept.md` and `open_questions.md`.** Never edits sibling files. Surfaces cross-file material as recommendations.
- **Respects the existing status.** If the file is at Stable or Locked, do not silently demote it. Ask the user before writing if the new commitments would force a demotion.
- **Does not invent.** If the user has not committed to something, leave the placeholder.
- **The emotional engine is primary.** When deciding what to write or what to ask next round, prioritize protagonist wound, central relationship, and ending shape over decorative worldbuilding.
