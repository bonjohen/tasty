---
name: develop-characters
description: "Drives a focused discovery conversation that produces or revises books/{name}/docs/characters.md. The entry point for developing a book's characters once a story concept exists, and the way to deepen wound/desire/fear/contradiction/voice for individual characters. Use when the user wants to develop characters, work out a protagonist's wound or arc, define the antagonist, or build out the relationship map."
argument-hint: "[book-name]"
user-invocable: true
---

Drive one discovery round on a book's `characters.md`. Each invocation runs one question-and-write cycle. Run repeatedly to deepen the cast.

## Step 0: Determine Target Book

Resolve which book to work on; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, if only one book exists under `books/`, use it. If multiple, ask the user which.
3. Verify `{book}/docs/` exists. If not, create it.

## Step 1: Read Current State

Read whichever of these exist:

- `{book}/CLAUDE.md` — story rules, voice, prohibitions
- `{book}/docs/story_concept.md` — concept file (sibling — for context only, never written here)
- `{book}/docs/characters.md` — the target file
- `{book}/docs/world_rules.md` — sibling file (for context only)
- `{book}/docs/open_questions.md` — accumulated unresolved decisions

If `story_concept.md` does not exist, this skill can still run, but tell the user in Step 6 that running `/develop-concept` first usually produces stronger character work — characters need a story to live inside.

Note the **Status** of `characters.md` if it exists. If the file does not exist, this is a cold start.

## Step 2: Spawn the concept-interviewer agent

Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt.

Prompt: "Produce the next focused question round for the discovery conversation on `characters.md`. Book root: {book}. Target file: characters.md. Read {book}/CLAUDE.md (if exists), {book}/docs/story_concept.md (if exists), {book}/docs/characters.md (if exists), {book}/docs/world_rules.md (if exists), and {book}/docs/open_questions.md (if exists). Identify the highest-priority unresolved questions for the characters file specifically — protagonist wound/desire/fear/contradiction, central relationship dynamics, antagonist's motivation and contradiction, voice/register per character, the relationship map. Bias toward emotional load-bearing questions, not biographical detail. Return the question round in the prescribed format (Current story shape / Most important unresolved questions / Questions for this round, 3-7 questions)."

Wait for the agent to return.

## Step 3: Present the round to the user

Print the agent's output verbatim. Add nothing before or after it except a single line at the end:

> When you have answered, I will use your answers to update `characters.md` (and `open_questions.md` for anything we cannot decide this round).

Then stop and wait for the user's answer.

## Step 4: Synthesize the user's commitments

When the user replies, internally answer:

1. **Are the answers substantial enough to warrant a write?** A real commitment to even one character's wound/desire/contradiction or to the central relationship IS enough.
2. **Which characters and which fields does this answer touch?** Be specific. Name them.
3. **What is unresolved or deferred?** These become open questions.
4. **Does anything belong in a sibling file?** A premise-level decision belongs in `story_concept.md`. A causal world rule belongs in `world_rules.md`. Note these but do NOT write them.

If the answers are too thin, do not invoke the writer. Tell the user what is still unclear and offer to run another round.

If substantial enough, proceed to Step 5.

## Step 5: Spawn the concept-writer agent

Construct a structured commitments payload from the user's answers. Organize the payload by character (one block per character) and within each character by field (Role / Wound / Desire / Fear / Contradiction / Arc / Secrets / Voice). Include the Relationship Map as a separate section if the user has touched on relationships.

Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt.

Prompt: "Write or revise characters.md for the book at book root {book}. Target file: characters.md. Read {book}/CLAUDE.md (if exists) and all four discovery files for context. Apply the following commitments to the target file. If the file does not exist, create it from your canonical template. If it exists, apply surgical Edits — cumulative, not destructive. Add new characters as new sections; deepen existing characters by editing their fields. Promote status from Exploratory to Provisional only if the major characters now have wound, desire, contradiction, and arc populated. Do not promote past Provisional. Update the Last revised date to today. Also append the listed open questions to {book}/docs/open_questions.md (creating it from template if absent). Report what changed.

COMMITMENTS:
[Your synthesis here, organized by character. For each character: name, then any fields the user has committed to (Role / Wound / Desire / Fear / Contradiction / Arc / Secrets / Voice). Mark each as 'new character' or 'revision of existing'. If the user has touched on relationships, include a Relationship Map section.]

OPEN QUESTIONS TO APPEND:
[List of questions surfaced this round. For each: question text, urgency (High/Medium/Low), blocks (beats / sections / drafting / nothing), context, provisional answer if any.]"

Wait for the agent to return.

## Step 6: Report to the user

Present the agent's report and add a **Recommended Next Step** section with one of:

- **Run another round of `/develop-characters`** — if major characters still have placeholder fields. State which.
- **Run `/develop-concept`** — if this round surfaced premise-level decisions that need to land in the concept file first.
- **Run `/develop-world`** — if this round surfaced causal rules that affect what characters can do.
- **Mark `characters.md` as Stable and run `/generate-beats`** — if the file is now Provisional and the user is satisfied.

Surface anything the writer agent flagged as **Material for sibling files**.

If `story_concept.md` does not exist, tell the user explicitly: "characters.md was created without a concept file. Beat generation will warn you about this. Consider running `/develop-concept` before going further."

## Discipline (this skill specifically)

- **One round per invocation.** Do not loop.
- **Only writes `characters.md` and `open_questions.md`.** Never edits sibling files.
- **Emotional fields take priority over biographical fields.** Wound, desire, fear, contradiction, and voice matter more for beat generation than backstory or appearance. If the user wants to talk about backstory, redirect to wound/desire.
- **Voice notes should be concrete.** "Speaks formally" is too vague. "Speaks in conditionals — never direct claims, always 'one might suppose'" is useful.
- **The relationship map is about emotional load-bearing connections.** Not all relationships. Just the ones the story turns on.
