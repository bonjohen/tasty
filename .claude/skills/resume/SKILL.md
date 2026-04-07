---
name: resume
description: "Bootstraps project context by deriving state from the filesystem. Use when starting a new session, resuming work, or when the user asks 'where are we', 'resume', 'load context', or 'what is the project state'."
argument-hint: "[book-name]"
allowed-tools: Read Glob Grep Bash(wc *) Bash(ls *)
user-invocable: true
---

Derive the current project state from the filesystem and report it.

## Step 0: Determine Target Book

Resolve which book to report on; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, list subdirectories of `books/`.
   - If only one book exists, use it.
   - If multiple books exist, report state for ALL of them (briefly for each), then recommend the user specify one with `/resume <book>` for detailed output.
3. If the chosen book has no `chapters/` directory or `docs/section_map.md`, report the book as "uninitialized — development phase" and run `/story-status` instead.

## Steps

1. **Scan chapter files.** List all `{book}/chapters/ch*.md` files. Identify the highest chapter number. Count total chapters.

2. **Read section map.** Read `{book}/docs/section_map.md` to determine:
   - Which sections are complete (all chapters in range exist)
   - Which section is current/next (first section with missing chapters)
   - Current act, if the section map declares act boundaries

3. **Read continuity state.** Read `{book}/docs/continuity.md`. Extract:
   - The last 3 timeline table entries (most recent chapters)
   - Current state for each major character listed in the book's continuity tracker (physical, location, knowledge, emotional)
   - Any book-specific stage trackers maintained in continuity (e.g., voice-bleed stage, if the book uses one)
   - Count of open narrative threads

4. **Read last chapter.** Read the most recently written chapter (`{book}/chapters/chNN.md` where NN is the highest number). Extract:
   - Where the narrative left off (location, scene state)
   - Emotional register at the end
   - POV character

5. **Word count.** Run `wc -w {book}/chapters/ch*.md` for total word count.

6. **Identify next work.** If chapters remain unwritten:
   - Identify the next chapter number and its section
   - Read the first few lines of that section's outline to get the section title and goal

7. **Report.** Output the following structure, using the book's actual title (from `{book}/CLAUDE.md`) and the total chapter count from `{book}/docs/section_map.md`:

```
## Project State: [Book Title]

**Chapters written:** N/[total from section map]
**Sections complete:** N/[total sections]
**Current act:** [I/II/III, if applicable]
**Total words:** ~N

### What Just Happened
[Summary of last 2-3 chapters from continuity timeline — what events occurred, where characters are]

### Character States
[For each major character tracked in continuity.md, one line: physical, location, emotional state]

### What Comes Next
[Next unwritten section: number, title, goal from outline header]
[Or: "First draft complete. All chapters written."]

### Open Threads
[Count and top 5 most significant unresolved threads]
```

8. **Ready prompt.** End with:
   > Ready to continue. Use `/write-section` to draft the next section, `/check-continuity` to validate recent chapters, or `/chapter-status` for a full dashboard.

## If All Chapters Exist

If every chapter specified in the section map is written, report the project as first-draft-complete and suggest:
- `/check-continuity` to validate specific chapter ranges
- `/chapter-status` for the full dashboard
- Revision work (manual — no `/revise` skill yet)
