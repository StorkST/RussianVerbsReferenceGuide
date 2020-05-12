#
# makefile for adjmulticol package
#
# this file is in public domain
#
# $id$
#

version_ru_fr = v_beta
version_ru_en = v_alpha

footer_fr = ./tex/footer-fr.tex
footer_en = ./tex/footer-en.tex

beginner = A1 A2 B1
intermediate = B2
advanced = C1 C2

output_dir := build
cefr_dir := $(output_dir)/cefr

extract_csv = \
	python3.8 extract-russian_verbs_classification.py -l $(1) -o $(2) -y yellow_field > $(3)

TEX = \
	xelatex -jobname=beginner-ru-fr-abc_order \
	"\def\numcolumns{$(1)} \
	\def\widthleftcol{30} \
	\def\widthrightcol{17} \
	\def\baselinestretch{1} \
	\def\withyellow{yes} \
	\def\csvfilename{cefr/beginner-ru-fr-abc_order.csv} \
	\input{tex/a4-template.tex}"

BEGGINER_TEX := $(call TEX,4)

# wget csv. POC avec "semantic version".
# Pour chaque langue:
# 	1. generer liste avec Python
# 	2. generer pdf
# Later:
# 	changelog and release of each new PDF
getcsv:
	curl -s "https://api.github.com/repos/Stork_ST/core_russian_verbs/commits?path=russian_verbs_classification.csv" | jq -r '.[0].commit.committer.date'

CSV_TYPES = \
	freq \
	abc

build_ru_fr_beginner:
	pre := beginner-ru-fr
	job_name := $(pre)-freq_order
	csv_dst = $(cefr_dir)/$(job_name).csv
	$(call extract_csv,$(beginner),freq,$(csv_dst))
	$(call TEX,$(job_name),4,30,17,1,yes,$(csv_dst))
	$(call TEX,$(job_name),4,30,17,1,no,$(csv_dst))
	
	$(call extract_csv,$(beginner),abc,$(cefr_dir)/$(job_name).csv)
	$(call TEX,$(job_name),4,30,17,1,yes,$(csv_dst))
	$(call TEX,$(job_name),4,30,17,1,no,$(csv_dst))

build_intermediate:
	python3.8 extract-russian_verbs_classification.py -l B2 -o abc -y Движение > cefr/intermediate-ru-fr-abc_order.csv
	xelatex -jobname=intermediate-ru-fr-abc_order "\def\csvfilename{cefr/intermediate-ru-fr-abc_order.csv} \input{tex/a4-4columns.tex}"

build_advanced:
	python3.8 extract-russian_verbs_classification.py -l C1 C2 -o abc -y Движение > cefr/advanced-ru-fr-abc_order.csv
	xelatex -jobname=advanced-ru-fr-abc_order "\def\csvfilename{cefr/advanced-ru-fr-abc_order.csv} \input{tex/a4-3columns.tex}"

build_ru_fr:
	build_ru_fr_beginner
	build_ru_fr_intermediate
	build_ru_fr_advanced

build:
	build_ru_fr

clean:
	$(RM) *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.tgz *.zip

veryclean: clean
	$(RM) *.pdf
	$(RM) build/*

distclean: veryclean

