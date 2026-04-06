---
name: expand-sections
description: "Generates section outline files from the stabilized beat backbone. Can generate all sections or a specific range. Enforces the beat stability gate — refuses to generate authoritative sections if beats are not at least Stable. Use when the user asks to expand sections, generate outlines, or build the section architecture."
argument-hint: "[section range, e.g. 1-5 or 'all']"
user-invocable: true
---

Generate section outline files from the beat backbone.

## Step 1: Gate Check

Read `book/docs/15_beats.md` and check the beat status header.

- If **Locked** or **Stable**: proceed. Sections will be marked **authoritative**.
- If **Provisional**: warn the user. "Beats are Provisional. Section outlines generated now will be marked provisional and may need significant revision. Recommend running `/stabilize-beats` first. Continue anyway?" If proceeding, mark all generated sections as **provisional**.
- If **Exploratory**: refuse. "Beats are Exploratory — major turns are still unclear. Section expansion requires at least Provisional beats. Run `/stabilize-beats` or continue discovery work first."
- If the file doesn't exist: refuse. "No beat file found. Generate beats first with `/generate-beats`."

## Step 2: Determine Scope

If `$ARGUMENTS` specifies a range (e.g., "1-5", "12-15", "all"):
- Generate those sections.
- Read the beat-to-section mapping from `book/docs/15_beats.md` to determine which beats each section covers.

If no argument:
- Check which section outlines already exist (Glob for `book/docs/section_*_outline.md`).
- Generate the next missing batch (up to 5 sections per invocation to avoid context exhaustion).

## Step 3: Read Context

Read these files once (they're shared across all sections):
- `book/docs/15_beats.md` — the backbone
- `book/docs/story_concept.md` — premise and theme (if exists)
- `book/docs/characters.md` — character reference (if exists)
- `book/docs/world_rules.md` — causality rules (if exists)
- `book/docs/continuity.md` — state tracker (if exists)

## Step 4: Generate Sections

For sections that don't depend on each other's handoff (non-adjacent sections), spawn **section-generator agents in parallel**.

For sections that ARE adjacent and need handoff context, generate them **sequentially** — each one needs the previous section's output to know what state it's inheriting.

For each section, spawn the section-generator agent:

Prompt: "Generate section [N] covering beats [X-Y]. Read book/docs/15_beats.md, book/docs/story_concept.md, book/docs/characters.md, book/docs/world_rules.md, book/docs/continuity.md, and adjacent section outlines book/docs/section_[NN-1]_outline.md and book/docs/section_[NN+1]_outline.md (if they exist). Beat status is [status]. Write the section outline to book/docs/section_[NN]_outline.md."

## Step 5: Update Section Map

After all sections are generated, update or create `book/docs/section_map.md` with the current section-to-chapter mapping:

```markdown
# Section Map

| Section | Chapters | Range | Title |
|---------|----------|-------|-------|
| 1 | [count] | [start]-[end] | [title] |
...
```

Include act boundaries if the story has a clear act structure.

## Step 6: Report

```
## Section Expansion Report

### Sections Generated
| Section | Title | Chapters | Type | Status | Beats Covered |
|---------|-------|----------|------|--------|---------------|
| 1 | ... | 2 | anchor | authoritative | 1 |
...

### Total: [N] sections, [M] chapters

### Coverage Check
- Beats covered: [list]
- Beats NOT covered: [list, or "all covered"]

### Next Steps
[Recommendations: generate remaining sections, run /check-structure, begin drafting with /write-section]
```

## Design Principles

- A section exists because the reader needs a distinct experience there, not because the beat list has another line item.
- 18-26 sections is typical. 2-3 chapters per section is typical.
- Split beats when emotional timing requires it. Separate event from interpretation when that increases force. Give aftermath space when the story needs quiet.
- Do not pad. Every section must justify its existence through emotional function.
