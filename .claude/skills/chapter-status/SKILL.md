---
name: chapter-status
description: "Shows a dashboard of all sections, chapters, word counts, and completion status. Use when the user asks for progress, status, word count, or a dashboard overview."
argument-hint: "[book-name]"
model: sonnet
allowed-tools: Read Glob Grep Bash(wc *) Bash(ls *)
user-invocable: true
---

Generate a complete project dashboard for the novel.

## Step 0: Determine Target Book

Resolve which book to report on; the resolved path replaces `{book}` for the rest of this skill.

1. If `$ARGUMENTS` provides a book name matching a subdirectory of `books/`, use `books/[name]` as the book root.
2. Otherwise, list subdirectories of `books/`.
   - If only one book has chapters, use it.
   - If multiple books have chapters, show a brief dashboard for each (title, chapter count, total words) and recommend the user specify one for detail.
3. If the book has no `chapters/` directory, report "uninitialized" and stop.

## Steps

1. **List all chapter files.** Use Glob to find all `{book}/chapters/ch*.md` files.

2. **Read the section map.** Read `{book}/docs/section_map.md` to get the section-to-chapter mapping.

3. **Get word counts.** Run `wc -w {book}/chapters/ch*.md` to get word counts for all existing chapters.

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
- Total chapters: N / [total from section map]
- Total words: N
- Sections complete: N / [total sections]
- Per-act word counts if the section map declares act boundaries (otherwise omit)
