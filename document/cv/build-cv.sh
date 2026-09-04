#!/usr/bin/env bash
#
# Build the dissertation's Curriculum Vitae from the standalone resume project.
#
# Reads   : $RESUME_DIR (resume.cls + sections/*.tex)
# Writes  : document/graphics/cv.pdf
#
# The resume sources are NOT copied into this repository. They are located via
# TEXINPUTS, so the resume project stays the single source of truth: edit it,
# re-run this script, then rebuild the dissertation.
#
# Usage:
#   bash document/cv/build-cv.sh
#   RESUME_DIR=/path/to/other/resume bash document/cv/build-cv.sh

set -euo pipefail

cd "${0%/*}"
HERE="$(pwd)"

RESUME_DIR="${RESUME_DIR:-$HOME/Desktop/resume-2025/resume}"

if [ ! -f "$RESUME_DIR/resume.cls" ]; then
	echo "error: no resume.cls in '$RESUME_DIR'" >&2
	echo "       set RESUME_DIR to the folder holding resume.cls and sections/" >&2
	exit 1
fi

echo "Resume source : $RESUME_DIR"
echo "Last modified : $(find "$RESUME_DIR" -name '*.tex' -o -name '*.cls' \
	| xargs stat -f '%Sm %N' -t '%Y-%m-%d %H:%M' | sort -r | head -1)"

BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

# TEXINPUTS lets \documentclass{resume} and \input{sections/...} resolve
# against the resume project. The trailing colon keeps the default search path.
export TEXINPUTS="$RESUME_DIR:$HERE:"

echo "Compiling ..."
for pass in 1 2; do
	pdflatex \
		-interaction=nonstopmode \
		-halt-on-error \
		-output-directory "$BUILD" \
		"$HERE/cv-bu.tex" > "$BUILD/pass$pass.log" 2>&1 || {
			echo "error: pdflatex failed. Log follows:" >&2
			grep -aE '^!' -A5 "$BUILD/pass$pass.log" | head -40 >&2
			exit 1
		}
done

# TeX wraps log lines at ~79 characters, so "Output written on ... (N pages"
# can be split mid-string. Strip newlines before matching.
PAGES="$(tr -d '\n' < "$BUILD/pass2.log" \
	| grep -oE 'Output written on [^(]*\(([0-9]+) pages' \
	| grep -oE '([0-9]+) pages' | grep -oE '[0-9]+' || echo 0)"

mkdir -p "$HERE/../graphics"
cp "$BUILD/cv-bu.pdf" "$HERE/../graphics/cv.pdf"

echo "Wrote document/graphics/cv.pdf (${PAGES} pages)"

# BU guide 1.9 asks candidates to keep the vita to three or four pages.
if [ "${PAGES:-0}" -gt 4 ]; then
	echo
	echo "WARNING: the CV is ${PAGES} pages. BU guide 1.9 says to try to limit"
	echo "         the vita to three or four pages. Consider trimming it."
fi
