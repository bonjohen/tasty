---
name: resume
description: "Bootstraps project context by deriving state from the filesystem. Use when starting a new session, resuming work, or when the user asks 'where are we', 'resume', 'load context', or 'what is the project state'."
allowed-tools: Read Glob Grep Bash(wc *) Bash(ls *)
user-invocable: true
---

Derive the current project state from the filesystem and report it. This replaces the manual `prompts/resume_session.md` loading process.

## Steps

1. **Scan chapter files.** List all `chapters/ch*.md` files. Identify the highest chapter number. Count total chapters.

2. **Read section map.** Read `docs/section_map.md` to determine:
   - Which sections are complete (all chapters in range exist)
   - Which section is current/next (first section with missing chapters)
   - Current act (I: Ch 1-16, II: Ch 17-33, III: Ch 34-48)

3. **Read continuity state.** Read `docs/continuity.md`. Extract:
   - The last 3 timeline table entries (most recent chapters)
   - Current character states (Hurkuzak, Hakiia/Bleed, Vark, Tessivane — physical, location, knowledge, emotional)
   - Current Bleed stage
   - Count of open narrative threads

4. **Read last chapter.** Read the most recently written chapter (`chapters/chNN.md` where NN is the highest number). Extract:
   - Where the narrative left off (location, scene state)
   - Emotional register at the end
   - POV character

5. **Word count.** Run `wc -w chapters/ch*.md` for total word count.

6. **Identify next work.** If chapters remain unwritten:
   - Identify the next chapter number and its section
   - Read the first few lines of that section's outline to get the section title and goal

7. **Report.** Output the following structure:

```
## Project State: Tasty

**Chapters written:** N/48
**Sections complete:** N/23
**Current act:** [I/II/III]
**Total words:** ~N

### What Just Happened
[Summary of last 2-3 chapters from continuity timeline — what events occurred, where characters are]

### Character States
- **Hurkuzak:** [physical, location, emotional, Bleed stage]
- **Hakiia/Bleed:** [status]
- **Vark:** [physical, location, status]
- **Tessivane:** [status]

### What Comes Next
[Next unwritten section: number, title, goal from outline header]
[Or: "First draft complete. All 48 chapters written."]

### Open Threads
[Count and top 5 most significant unresolved threads]
```

8. **Ready prompt.** End with:
   > Ready to continue. Use `/write-section` to draft the next section, `/check-continuity` to validate recent chapters, or `/chapter-status` for a full dashboard.

## If All Chapters Exist

If all 48 chapters are written, report the project as first-draft-complete and suggest:
- `/check-continuity` to validate specific chapter ranges
- `/chapter-status` for the full dashboard
- Revision work (manual — no `/revise` skill yet)
