---
name: chapter-status
description: "Shows a dashboard of all sections, chapters, word counts, and completion status. Use when the user asks for progress, status, word count, or a dashboard overview."
model: sonnet
allowed-tools: Read Glob Grep Bash(wc *) Bash(ls *)
user-invocable: true
---

Generate a complete project dashboard for the novel.

## Steps

1. **List all chapter files.** Use Glob to find all `book/chapters/ch*.md` files.

2. **Read the section map.** Read `book/docs/section_map.md` to get the section-to-chapter mapping.

3. **Get word counts.** Run `wc -w book/chapters/ch*.md` to get word counts for all existing chapters.

4. **Get chapter titles.** For each existing chapter file, read just the first line to extract the `# Chapter N: Title` header.

5. **Build the dashboard.** Output a table organized by section:

```
## Novel Dashboard

| Section | Title | Chapters | Status | Words | Chapter Titles |
|---------|-------|----------|--------|-------|----------------|
| 1 | Winter Hunt... | 1-3 | Complete | 8,241 | The Older Brother's Country, ... |
...
```

Status values:
- **Complete** — all chapters in the section exist
- **Partial (N/M)** — some chapters written
- **Not started** — no chapters written

6. **Summary.** After the table, output:
- Total chapters: N/48
- Total words: N
- Sections complete: N/23
- Act I (Ch 1-16): N words
- Act II (Ch 17-33): N words
- Act III (Ch 34-48): N words
