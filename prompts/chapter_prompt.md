# Write Next Section

You are writing chapters for the novel "Tasty." Follow this process exactly.

## Step 1: Load Context

Read these files in parallel:
- `CLAUDE.md` (voice, style, world rules, character profiles, things to avoid)
- `docs/01_story_analysis.md` (full story architecture — use to keep the narrative on track)
- `docs/continuity.md` (current character state, timeline, open threads)

## Step 2: Determine Next Section

List existing chapter files in `chapters/`. Find the highest chapter number written. Identify which section outline contains the next unwritten chapter.

- If no chapters exist, start with `docs/section_01_outline.md`.
- If all 48 chapters exist, report that all sections are complete and stop.

Read that section's outline file (`docs/section_NN_outline.md`). This is your **primary guide** for this session.

Also read the **previous section's outline** (if one exists) to understand what was just established, and the **next section's outline** (if one exists) to know what you need to set up.

## Step 3: Read the Last Written Chapter

If any chapters already exist, read the most recent one (`chapters/chNN.md`). This establishes:
- Current narrative voice and rhythm
- Where the scene left off
- Emotional register to continue from

## Step 4: Write Each Chapter in the Section

For each chapter listed in the section outline, sequentially:

### 4a. Draft the Chapter

Write the chapter following:
- The **section outline beats** as your primary structure (follow them closely — they were reviewed and approved)
- The **analysis doc** for broader narrative context and emotional architecture
- The **CLAUDE.md** for voice, style, and rules (literary dark register, restrained horror, no genre cliches)
- The **continuity doc** for character state consistency

Chapter format:
```
# Chapter N: Title

[prose]
```

Target word count: 2,000-3,500 words (as specified in the outline's word target for that chapter).

**Voice rules:**
- Third person, past tense
- If POV is Hurkuzak: searching, emotionally layered, weighted prose
- If POV is Vark: cooler, professional, efficient — tonally distinct from Hurkuzak
- The Bleed (Hakiia's inner voice): NO formatting markers. No italics. It enters the narration unmarked. Check the outline's notes for the Bleed's current stage.
- Restrained horror: psychological weight, not viscera. What is understood hits harder than what is shown.
- No genre-default fantasy prose. No ornamental archaisms. No summarizing emotion — show the behavioral evidence.

### 4b. Save the Chapter

Save to `chapters/chNN.md` (flat numbered, sequential).

### 4c. Update Continuity

After each chapter, update `docs/continuity.md`:
- Add the chapter to the Timeline table
- Update character physical state, injuries, knowledge
- Update the Bleed stage if it has progressed
- Add any new open narrative threads
- Update key objects and locations
- Note any new information characters have learned

### 4d. Proceed to Next Chapter

If the section has more chapters, read the chapter you just wrote (for continuity), then write the next one. Repeat 4a-4c.

## Step 5: Section Complete

When all chapters in the section are written:
1. Report which chapters were written, with their titles and word counts
2. Note any deviations from the outline and why
3. Identify the next section to be written

Do NOT proceed to the next section automatically. Stop and let the user review.

## Quality Checklist (apply to every chapter)

- [ ] Beats from the section outline are covered (no skipped beats)
- [ ] Emotional function stated in the outline is achieved
- [ ] Voice matches POV character (Hurkuzak vs. Vark vs. other)
- [ ] The Bleed is at the correct stage (check outline notes)
- [ ] No modern idiom or phrasing breaking the pre-industrial register
- [ ] No genre cliches (check CLAUDE.md "Things to Avoid")
- [ ] Chapter earns its title
- [ ] Continuity doc is updated
- [ ] Word count is within the outline's target range
