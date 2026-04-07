# nexter — Story Rules

**PLACEHOLDER** — This file will hold nexter's voice, character, world, and prohibition rules once the story concept stabilizes. It is intentionally empty of story content so that the shared workflow agents and skills do not pick up stale material from another book.

## How to Populate This File

When nexter's concept is defined, replace this placeholder with sections covering:

- **Project Identity** — title, genre, logline, source documents
- **Voice & Style** — POV, tense, register, rhythm, prose references
- **World Rules** — only rules that materially affect causality or voice
- **Characters** — major POVs and antagonists, with role/wound/desire/fear/arc
- **Things to Avoid** — story-specific prohibitions (clichés to reject, tonal traps, anti-patterns)

Use `books/tasty/CLAUDE.md` as a structural reference for what a fully populated story-rules file looks like — but do not copy its content. nexter is a different book.

## Development Status

- Concept: not started
- Characters: not started
- World rules: not started
- Beats: not started
- Sections: not started
- Chapters: not started

Start development with `/develop-concept nexter`. The skill walks you through a focused discovery conversation that produces `books/nexter/docs/story_concept.md` one round at a time. When the concept is at least Provisional, run `/develop-characters nexter` and `/develop-world nexter` to fill in the rest of the discovery file set. Once `story_concept.md` is at least Stable, run `/generate-beats nexter` to produce the beat backbone. Use `/story-status nexter` at any time to see the current state of the development pipeline.
