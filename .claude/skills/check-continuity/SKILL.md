---
name: check-continuity
description: "Validates that chapters and the book's continuity tracker are consistent. Cross-references timeline, character state, any book-specific narrative stages, objects, and threads. Use when the user asks to check, verify, or validate continuity."
argument-hint: "[book-name] [chapter-number or range, e.g. 40-43]"
allowed-tools: Read Glob Grep
user-invocable: true
---

Validate continuity between chapter files and the book's `continuity.md`.

## Step 0: Determine Target Book

Resolve which book to operate on; the resolved path replaces `{book}` for the rest of this skill.

1. Parse `$ARGUMENTS`. If the first token matches a subdirectory of `books/`, that is the book. Strip it; the remainder is the chapter scope.
2. Otherwise, if only one book has chapters, use it. If multiple, ask the user which.
3. Verify `{book}/chapters/`, `{book}/docs/continuity.md`, and `{book}/docs/section_map.md` exist. If any is missing, stop and report.

## Steps

1. **Determine scope.**
   - If the remaining `$ARGUMENTS` (after book extraction) specifies chapter numbers (e.g., "42" or "40-43"), check those chapters.
   - If no argument, check the last 3 written chapters (by highest chapter number).

2. **Read the target chapters.** Read each chapter file in the scope from `{book}/chapters/chNN.md`.

3. **Read continuity.md.** Read `{book}/docs/continuity.md` in full.

4. **Read section outlines.** For each chapter in scope, determine its section from `{book}/docs/section_map.md` and read the corresponding section outline for any expected narrative-stage markers (e.g., voice-bleed stage if the book uses one) and other requirements.

5. **Cross-reference each chapter.** For every chapter in scope, check:

### Timeline
- Does a timeline entry exist in continuity.md for this chapter?
- Does the day/period match what the chapter narrates?
- Does the season match?
- Does the location match where the chapter actually takes place?
- Are the key events accurate and complete?

### Character Physical State
- Do injuries mentioned in the chapter match what continuity.md records?
- Are new injuries from this chapter recorded in continuity.md?
- Is healing progress consistent (no miraculously healed injuries, no forgotten wounds)?
- Are character locations consistent?

### Character Knowledge
- If a character learns something new in this chapter, is it recorded?
- Does the character reference knowledge they shouldn't have yet (based on continuity.md's tracking of when knowledge was gained)?

### Book-Specific Narrative Stage (if applicable)
- If the book's continuity tracker maintains a named narrative stage (e.g., voice-bleed stage, power level, corruption progression), does the chapter's handling of it match what the section outline specifies?
- Does it match what continuity.md records as the current stage?
- Is there an unrecorded progression?

### Objects and Locations
- Are new objects introduced in the chapter tracked in continuity.md?
- Are objects used in the chapter actually available (not lost or destroyed earlier)?
- Are new locations described consistently with any prior descriptions?

### Narrative Threads
- Are new threads opened in this chapter tracked?
- Are resolved threads marked?

6. **Report.** Output:

```
## Continuity Check: Chapters [range]

### Results
| Chapter | Issues Found | Severity |
|---------|-------------|----------|
| Ch N | [count] | [highest severity] |

### Issues
[For each issue:]
**Ch N — [Category] — [Severity: ERROR/WARNING/INFO]**
- **Chapter says:** [quote or description]
- **Continuity says:** [quote or description]
- **Resolution:** [What needs to change — in the chapter, in continuity.md, or investigation needed]

### Clean
[List any chapters with zero issues]
```

Severity levels:
- **ERROR:** Direct contradiction (wrong location, impossible knowledge, missing injuries)
- **WARNING:** Missing or incomplete entry (timeline row exists but key events incomplete, narrative-stage markers not updated)
- **INFO:** Minor inconsistency or style issue (location name varies slightly, timeline day is ambiguous)
