# Doctoral Dissertation — Daria Bogatova

Boston University, Graduate School of Arts and Sciences, 2027.

LaTeX source for my doctoral dissertation. The formatting machinery
(`document/style/buthesis.sty`, the title / copyright / approval / abstract page
layouts, margins and pagination) is inherited from Dmytro Bogatov's 2022 BU
dissertation, which passed BU Mugar Library format review as-is.

## Layout

```
document/
├── main.tex              # document skeleton and preliminary-page order
├── meta.tex              # title, author, degrees, readers, major professor
├── preamble.tex          # packages, macros, bibliography and glossary setup
├── glossary.tex          # List of Abbreviations entries
├── bibfile.bib           # bibliography database
├── frontmatter/
│   ├── abstract.tex      # required
│   ├── acknowledgments.tex
│   └── dedication.tex    # optional; delete the file to drop the page
├── sections/
│   ├── introduction.tex
│   ├── methods.tex       # Materials and Methods
│   ├── study-one.tex     # results chapter
│   ├── study-two.tex     # results chapter
│   └── discussion.tex
├── endmatter/
│   ├── appendix-supplementary.tex
│   └── cv.tex            # required of all candidates; must be last
├── cv/
│   ├── cv-bu.tex         # re-typesets the resume at BU margins
│   └── build-cv.sh       # regenerates graphics/cv.pdf from the resume project
├── figures/              # one .tex wrapper per figure
├── graphics/             # figure artwork (\graphicspath points here)
└── style/buthesis.sty    # BU formatting — do not edit
```

## Curriculum Vitae

The CV is generated from the standalone resume project, which stays the single
source of truth. It is **not** edited inside this repository.

```bash
# 1. edit ~/Desktop/resume-2025/resume as usual
# 2. regenerate the CV at BU margins
bash document/cv/build-cv.sh
# 3. rebuild the dissertation
bash document/build.sh
```

`build-cv.sh` locates the resume through `TEXINPUTS` (override with
`RESUME_DIR=/path/to/resume`), re-typesets it via `document/cv/cv-bu.tex` with
top 1.5″ / left 1.5″ / right 1″ margins, and writes `document/graphics/cv.pdf`.
`endmatter/cv.tex` then includes that PDF, adding a page number to each page.

It re-typesets rather than scaling the resume's own `main_resume.pdf`, whose
0.75″ margins would have to shrink to fit — dropping the 11 pt body text to
about 9.4 pt, below the 10 pt floor in guide §1.1.2. The script warns if the CV
exceeds the three-to-four pages suggested by guide §1.9.

## How to compile

```bash
bash ./document/build.sh      # full build
bash ./document/build.sh -f   # fast: keeps aux files, much quicker rebuilds
bash ./document/build.sh -d   # draft: PDF graphics downsampled to PNG
open ./document/dist/report.pdf
```

Draft mode needs `imagemagick` (`brew install imagemagick`).

If using Overleaf, run `git config core.fileMode false`, then
`chmod +x ./document/build.sh ./test.sh`.

## BU formatting requirements

The authoritative document is the *BU Guide for Writers of Theses and
Dissertations* (Mugar Library, revised August 2026):
<https://library.bu.edu/theses>

Requirements this template already satisfies:

- Top margin 1.5″, left 1.5″, right 1″, bottom 1″; 8.5″×11″, single sided
- Title / copyright / approval pages counted as i–iii with no printed number
- Preliminary pages iv onward in lower-case Roman, bottom centre
- Main text in Arabic starting at 1, top centre, continuous through the
  appendices, bibliography and CV
- Preliminary page order per guide §1.1.6
- Lists in the required order: Tables, Figures, Abbreviations
- List of Abbreviations sorted alphabetically, not by order of appearance
- Appendices before the bibliography; CV last
- Approval page rendered **unsigned** with blank signature rules — signatures
  are collected separately through DocuSign
- All fonts embedded

Things to check before submitting:

- Delete the List of Tables / List of Figures if the final document has none;
  keep them if it has any. Both are currently enabled in `main.tex`.
- If you are registered in **Biomedical Engineering** rather than a GRS
  program, `\department` in `meta.tex` must read `College of Engineering`.
- Consider setting `colorlinks=false` in `preamble.tex` for the submitted PDF.
- Note any previously published chapters on the copyright page (guide §1.3.2).

## Submission checklist

1. Email the formatted draft PDF to `grsrec@bu.edu` **at least three weeks
   before the defense** for format review.
2. Collect reader signatures through DocuSign.
3. Submit the final PDF via ProQuest ETD (`etdadmin.com/bu`), keeping the
   approval page unsigned in the uploaded file.
4. Pay the $115 library processing fee and complete the contact form,
   BU Doctoral Exit Survey and Survey of Earned Doctorates.
