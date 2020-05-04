#
# Makefile for adjmulticol package
#
# This file is in public domain
#
# $Id$
#

SAMPLES = sample.tex

all:  $(PACKAGE).pdf ${SAMPLES:%.tex=%.pdf} 

build:
	xelatex intermediate-B2-longtable.tex

clean:
	$(RM)  *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.tgz *.zip

veryclean: clean
	$(RM) *.pdf

distclean: veryclean

