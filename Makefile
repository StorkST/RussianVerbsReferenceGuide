#
# Makefile for adjmulticol package
#
# This file is in public domain
#
# $Id$
#

SAMPLES = sample.tex

all:  $(PACKAGE).pdf ${SAMPLES:%.tex=%.pdf} 

# wget csv. POC avec "semantic version".
# Pour chaque langue:
# 	1. generer liste avec Python
# 	2. generer pdf
# Later:
# 	Changelog and release of each new PDF
getcsv:
	curl -s "https://api.github.com/repos/StorkST/CoreRussianVerbs/commits?path=RussianVerbsClassification.csv" | jq -r '.[0].commit.committer.date'

build:

	xelatex -jobname=beginner-ru-fr-abcOrder "\def\csvfilename{cefr/beginner-ru-fr-A1A2B1-abcOrder.csv} \input{tex/a4-4columns.tex}"
	xelatex -jobname=intermediate-ru-fr-abcOrder "\def\csvfilename{cefr/intermediate-ru-fr-B2-abcOrder.csv} \input{tex/a4-4columns.tex}"
	xelatex -jobname=advanced-ru-fr-abcOrder "\def\csvfilename{cefr/advanced-ru-fr-C1C2-abcOrder.csv} \input{tex/a4-3columns.tex}"

clean:
	$(RM)  *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.tgz *.zip

veryclean: clean
	$(RM) *.pdf

distclean: veryclean

