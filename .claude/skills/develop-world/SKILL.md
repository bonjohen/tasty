---
name: develop-world
description: "Drives a focused discovery conversation that produces or revises books/{name}/docs/world_rules.md. The entry point for capturing only the world rules that materially affect causality — what characters can do, decide, or fear. Aggressively rejects decorative worldbuilding. Use when the user wants to define a magic system constraint, a social rule, a technology limit, or any rule the plot turns on."
argument-hint: "[book-name]"
user-invocable: true
---

Drive one discovery round on a book's `world_rules.md`. Each invocation runs one question-and-write cycle. Run repeatedly to capture every rule that the plot turns on — and only those.

## Step 0: Determine Target Book

Resolve which book to work on; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, if only one book exists under `books/`, use it. If multiple, ask the user which.
3. Verify `{book}/docs/` exists. If not, create it.

## Step 1: Read Current State

Read whichever of these exist:

- `{book}/CLAUDE.md` — story rules, voice, prohibitions
- `{book}/docs/story_concept.md` — concept file (sibling — for context only)
- `{book}/docs/characters.md` — sibling file (for context only)
- `{book}/docs/world_rules.md` — the target file
- `{book}/docs/open_questions.md` — accumulated unresolved decisions

If neither `story_concept.md` nor `characters.md` exists, this skill can still run, but warn in Step 6: world rules without a story or characters tend to drift into decorative worldbuilding. The causality test cannot be applied if there is no plot to test against.

Note the **Status** of `world_rules.md` if it exists.

## Step 2: Spawn the concept-interviewer agent

Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt.

Prompt: "Produce the next focused question round for the discovery conversation on `world_rules.md`. Book root: {book}. Target file: world_rules.md. Read {book}/CLAUDE.md (if exists), {book}/docs/story_concept.md (if exists), {book}/docs/characters.md (if exists), {book}/docs/world_rules.md (if exists), and {book}/docs/open_questions.md (if exists). Identify the highest-priority unresolved questions for the world rules file specifically — but ONLY rules that materially affect causality. For each candidate rule, the test is: does this change what characters can do, decide, or fear? If not, do not ask about it. Reject decorative worldbuilding (architecture, fashion, food, taxonomy) unless it directly bears on the plot. Return the question round in the prescribed format (Current story shape / Most important unresolved questions / Questions for this round, 3-7 questions)."

Wait for the agent to return.

## Step 3: Present the round to the user

Print the agent's output verbatim. Add nothing before or after it except a single line at the end:

> When you have answered, I will use your answers to update `world_rules.md` (and `open_questions.md` for anything we cannot decide this round). If anything you answer is decorative rather than causal, I will surface it but I will not write it to the file.

Then stop and wait for the user's answer.

## Step 4: Synthesize the user's commitments

When the user replies, internally answer:

1. **Apply the causality test to every claim.** For each thing the user said, ask: does this change what a character can do, decide, or fear? If yes, it goes in the commitments payload. If no, it does not — but mention it in Step 6 as "decorative material — kept aside, not written to world_rules.md".
2. **Are there enough causal commitments to warrant a write?** Even one new causal rule with concrete enables/forbids/why-it-matters is enough.
3. **What is unresolved or deferred?** These become open questions.
4. **Does anything belong in a sibling file?** A character power belongs in `characters.md`. A premise-shifting decision belongs in `story_concept.md`. Note these but do NOT write them.

If no causal commitments emerged, do not invoke the writer. Tell the user which of their answers were decorative (if any) and what causal questions remain. Offer to run another round.

If causal commitments are present, proceed to Step 5.

## Step 5: Spawn the concept-writer agent

Construct a structured commitments payload from the user's causal answers. Organize by rule. For each rule, supply: brief statement, what it enables, what it forbids, why it matters to the plot.

Use the Agent tool. Substitute the concrete book root for `{book}` in the prompt.

Prompt: "Write or revise world_rules.md for the book at book root {book}. Target file: world_rules.md. Read {book}/CLAUDE.md (if exists) and all four discovery files for context. Apply the following commitments to the target file. If the file does not exist, create it from your canonical template (which begins with the causality discipline blockquote). If it exists, apply surgical Edits — cumulative, not destructive. Add new rules as new sections; revise existing rules by editing their fields. Promote status from Exploratory to Provisional only if the rules now substantially cover the world's plot-bearing constraints. Do not promote past Provisional. Update the Last revised date to today. Also append the listed open questions to {book}/docs/open_questions.md (creating it from template if absent). Report what changed.

COMMITMENTS:
[Your synthesis here, organized by rule. For each rule: brief statement, what it enables, what it forbids, why it matters to the plot. Mark each as 'new rule' or 'revision of existing'. Group related rules under category headings if there are several.]

OPEN QUESTIONS TO APPEND:
[List of questions surfaced this round. For each: question text, urgency (High/Medium/Low), blocks (beats / sections / drafting / nothing), context, provisional answer if any.]"

Wait for the agent to return.

## Step 6: Report to the user

Present the agent's report and add a **Recommended Next Step** section with one of:

- **Run another round of `/develop-world`** — if there are still major plot-bearing rules undefined. Name them.
- **Run `/develop-concept`** — if this round surfaced premise-level decisions that need to land in the concept file first.
- **Run `/develop-characters`** — if this round surfaced character abilities or limitations that belong in characters.md.
- **`world_rules.md` is sufficient — move to `/generate-beats`** — if the rules now cover everything the plot relies on. World rules can stay Provisional; beats do not require Stable world rules. The user can iterate later.

If the user surfaced decorative material (architecture, fashion, food, taxonomy not connected to plot), report it explicitly:

> Decorative material kept aside (not written to world_rules.md): [list]. If any of this needs to live somewhere, it belongs in `{book}/CLAUDE.md` as story-flavor notes, not in the discovery files.

Surface anything the writer agent flagged as **Material for sibling files**.

## Discipline (this skill specifically)

- **Apply the causality test ruthlessly.** "Iron is rare" is decorative unless the plot turns on iron's rarity. "Iron forged in moonlight binds the soul of the smith and cannot be wielded by anyone else" is causal — it changes who can use what weapon.
- **Each rule's three fields must be concrete.** What it enables: a verb the character can now do. What it forbids: a verb they cannot. Why it matters to the plot: a specific scene or beat that depends on this rule.
- **Reject taxonomies.** Lists of species, factions, or magic schools are not rules unless each entry has plot consequences.
- **Reject power scaling.** "Mages get stronger as they age" is not a rule unless the story turns on a specific aging threshold.
- **Reject "and the world is..." backstory.** History only enters the file when a current character's decisions depend on it.
- **One round per invocation.** Do not loop.
- **Only writes `world_rules.md` and `open_questions.md`.** Never edits sibling files.
