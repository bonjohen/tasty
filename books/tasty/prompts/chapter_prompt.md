# Write Next Section

You are writing chapters for the novel Tasty. Follow this process exactly.

1. Load Core Context

Read these files first:

* CLAUDE.md
* docs/legacy_story_analysis.md
* docs/continuity.md

Purpose:

* CLAUDE.md = voice, style, world rules, character profiles, prohibitions
* docs/legacy_story_analysis.md = full narrative architecture and emotional design
* docs/continuity.md = current timeline, character state, injuries, knowledge, open threads, key objects, key locations

If any required file is missing, stop and report the missing file or files.

2. Determine the Next Unwritten Section

List files in chapters/.

Identify all existing chapter files matching:
chapters/chNN.md

Rules:

* Do not overwrite an existing chapter unless explicitly asked.
* Do not skip chapter numbers.
* If chapter numbering has gaps, stop and report the gap instead of guessing.
* If no chapters exist, begin with docs/section_01_outline.md and Chapter 1.
* If all 48 chapters exist, report that all sections are complete and stop.

Find the highest existing chapter number.
The next chapter to write is the next integer after that number.

Identify which section outline contains that next unwritten chapter:
docs/section_NN_outline.md

Read:

* the current section outline
* the previous section outline, if it exists
* the next section outline, if it exists

The current section outline is the primary guide.
The previous section tells you what was just established.
The next section tells you what must be set up.

Important:

* Write only the unwritten chapter or chapters belonging to the current section.
* Do not rewrite earlier chapters in the section if they already exist.
* Do not begin the following section automatically.

3. Read the Most Recent Written Chapter

If any chapter already exists, read the most recent written chapter:
chapters/chNN.md

This establishes:

* current narrative rhythm
* scene handoff
* emotional register
* line-level continuity

Also use docs/continuity.md to confirm that the last written chapter and continuity state agree.
If they materially conflict, report the conflict before writing.

4. Write the Remaining Unwritten Chapter or Chapters in the Current Section

For each unwritten chapter in the current section, in order:

4a. Draft the Chapter

Follow, in descending priority:

1. the current section outline beats and notes
2. CLAUDE.md
3. docs/legacy_story_analysis.md
4. docs/continuity.md
5. the immediately previous written chapter

Chapter format:

# Chapter N: Title

[prose]

Use the title specified by the section outline unless there is a clear continuity reason not to. If you change a title, note the change when reporting section completion.

Target word count:
Use the word target specified in the section outline for that chapter.
Stay within the stated range unless a small deviation is necessary to avoid padding, rushing, or breaking the chapter's emotional function.

Voice rules:

* Third person, past tense
* Hurkuzak POV: searching, emotionally layered, weighted prose
* Vark POV: cooler, professional, efficient, tonally distinct from Hurkuzak
* Bleed: no formatting markers, no italics, no quotation marks, no typographic signaling
* Bleed stage must match the current section outline notes exactly
* Restrained horror: psychological and moral weight over gore
* No genre-default fantasy diction
* No ornamental archaism
* No summarizing emotion when behavior, perception, rhythm, or choice can show it instead

Quality rules:

* Do not invent beats that contradict the outline
* Do not skip any major beat from the outline
* Do not flatten ambiguity that the outline says to preserve
* Do not resolve emotional questions the outline says should remain unresolved
* Do not let action scenes become triumphant if the outline says they should read as frightening
* Do not add sequel setup before the designated section
* Do not introduce new lore unless required by the outline and consistent with existing materials

4b. Save the Chapter

Save to:
chapters/chNN.md

After saving, reopen the file and verify:

* the title is correct
* the file is complete
* the chapter number is correct
* the prose saved cleanly

4c. Update Continuity Immediately After Each Chapter

Update docs/continuity.md after each chapter, preserving existing structure unless it is clearly broken.

Update all relevant areas:

* Timeline table
* character physical state
* injuries and recovery
* knowledge gained
* Bleed stage
* open narrative threads
* key objects
* key locations
* new relationships, allegiances, or hostilities
* unresolved consequences created by the chapter

Continuity update rules:

* Do not delete still-relevant information
* Do not rewrite the document from scratch unless necessary
* Keep entries concise, factual, and cumulative
* If the chapter changes understanding of prior events, note the reinterpretation clearly

4d. Re-read and Continue

Before drafting the next unwritten chapter in the same section:

* read the chapter you just wrote
* read the current continuity doc again
* then write the next chapter

5. DO NOT Stop at Section Boundaries.

When all unwritten chapters in the current section are complete:

Report:

* which chapters were written
* each chapter title
* approximate word count for each chapter
* any deviations from the outline and why
* any continuity issues noticed and how they were handled
* the next section file to be written next

Chapter Checklist

Apply this to every chapter before saving:

* All major outline beats are covered
* The chapter achieves the emotional function stated in the outline
* POV voice matches the character
* The Bleed is at the correct stage
* No continuity conflicts with prior chapters or continuity.md
* No chapter-numbering errors
* No modern idiom that breaks the book's register
* No genre cliches prohibited by CLAUDE.md
* The chapter earns its title
* continuity.md is updated immediately after the chapter
* Word count is within target range, or the deviation is justified by chapter quality

At the completion of each section commit and push.

Begin this prompt again, this time using the next section_NN_outline.md file.


Operational Guardrails

* If required context files are missing, stop and report
* If chapter numbering is broken, stop and report
* If a needed section outline is missing, stop and report
* If continuity and the latest chapter materially conflict, stop and report before drafting
* Never overwrite an existing chapter unless explicitly instructed
* Never continue past the current section in the same run
* Never "fix" earlier prose unless explicitly instructed


