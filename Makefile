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

buildBeginner:
	python3.8 extract-RussianVerbsClassification.py -l A1 A2 B1 -o abc -y Движение > cefr/beginner-ru-fr-abcOrder.csv
	xelatex -jobname=beginner-ru-fr-abcOrder "\def\csvfilename{cefr/beginner-ru-fr-abcOrder.csv} \input{tex/a4-4columns-interline.tex}"

buildIntermediate:
	python3.8 extract-RussianVerbsClassification.py -l B2 -o abc -y Движение > cefr/intermediate-ru-fr-abcOrder.csv
	xelatex -jobname=intermediate-ru-fr-abcOrder "\def\csvfilename{cefr/intermediate-ru-fr-abcOrder.csv} \input{tex/a4-4columns.tex}"

buildAdvanced:
	python3.8 extract-RussianVerbsClassification.py -l C1 C2 -o abc -y Движение > cefr/advanced-ru-fr-abcOrder.csv
	xelatex -jobname=advanced-ru-fr-abcOrder "\def\csvfilename{cefr/advanced-ru-fr-abcOrder.csv} \input{tex/a4-3columns.tex}"

buildTex:

clean:
	$(RM)  *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.tgz *.zip

veryclean: clean
	$(RM) *.pdf

distclean: veryclean

