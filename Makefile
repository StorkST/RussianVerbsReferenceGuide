#
# makefile for adjmulticol package
#
# this file is in public domain
#
# $id$
#

russian_verbs_c = RussianVerbsClassification.csv

yellow_field = Движение

version_ru_fr = v_beta
version_ru_en = v_alpha

footer_fr = ./tex/footer-fr.tex
footer_en = ./tex/footer-en.tex

beginner = A1 A2 B1
intermediate = B2
advanced = C1 C2

output_dir := build
cefr_dir := $(output_dir)/cefr
OUT_DIR = $(output_dir) $(cefr_dir)

extract_csv = \
	python3.8 extract-RussianVerbsClassification.py --cefr-levels $(1) --order $(2) --yellow $(yellow_field) > $(3)

TEX = \
	xelatex -jobname=$(1) \
	"\def\numcolumns{$(2)} \
	\def\widthleftcol{$(3)} \
	\def\widthrightcol{$(4)} \
	\def\baselinevar{$(5)} \
	\def\withyellow{$(6)} \
	\def\csvfilename{$(7)} \
	\def\footerfile{$(8)} \
	\input{tex/a4-template.tex}"

BEGGINER_TEX := $(call TEX,4)

# wget csv. POC avec "semantic version".
# Pour chaque langue:
# 	1. generer liste avec Python
# 	2. generer pdf
# Later:
# 	changelog and release of each new PDF
#getcsv:
#	curl -s "https://api.github.com/repos/Stork_ST/core_russian_verbs/commits?path=russian_verbs_classification.csv" | jq -r '.[0].commit.committer.date'

#RU-FR-beginner-abc_order.csv
#RU-FR-beginner-abc_order-colored.csv
#RU-FR-beginner-freq_order.csv
#RU-FR-beginner-freq_order-colored.csv

#RU-FR-beginner-freq_order.csv: $(russian_verbs_c)
#	$(call extract_csv,$(beginner),freq,$@)
	
$(cefr_dir)/RU-FR-beginner-abc_order.csv: $(russian_verbs_c)
	$(call extract_csv,$(beginner),abc,$@)

RU-FR-beginner-abc_order.pdf: $(cefr_dir)/RU-FR-beginner-abc_order.csv
	$(call TEX,$(basename $@),4,30,17,1.1,no,$<,$(footer_fr))

#RU-FR-beginner-abc_order.pdf RU-FR-beginner-abc_order-colored.pdf RU-FR-beginner-freq_order.pdf RU-FR-beginner-freq_order-colored.pdf: RU-FR-beginner-freq_order.csv RU-FR-beginner-abc_order.csv
#	$(call TEX,$(job_name),4,30,17,1,yes,$(csv_dst))

#RU-FR%:

#RU-FR-%.pdf:
#Beginner: $(beginners)

#Intermediate: $(intermediate)

#Advanced: $(advanced)

#build_ru_fr_beginner:
#	class := Débutant
#	pre := beginner-ru-fr
#	job_name := $(pre)-freq_order
#	csv_dst = $(cefr_dir)/$(job_name).csv
#	$(call extract_csv,$(beginner),freq,$(csv_dst))
#	$(call TEX,$(job_name),4,30,17,1,yes,$(csv_dst))
#	$(call TEX,$(job_name),4,30,17,1,no,$(csv_dst))
#	
#	$(call extract_csv,$(beginner),abc,$(cefr_dir)/$(job_name).csv)
#	$(call TEX,$(job_name),4,30,17,1,yes,$(csv_dst))
#	$(call TEX,$(job_name),4,30,17,1,no,$(csv_dst))
#
#build_intermediate:
#	python3.8 extract-russian_verbs_classification.py -l B2 -o abc -y Движение > cefr/intermediate-ru-fr-abc_order.csv
#	xelatex -jobname=intermediate-ru-fr-abc_order "\def\csvfilename{cefr/intermediate-ru-fr-abc_order.csv} \input{tex/a4-4columns.tex}"
#
#build_advanced:
#	python3.8 extract-russian_verbs_classification.py -l C1 C2 -o abc -y Движение > cefr/advanced-ru-fr-abc_order.csv
#	xelatex -jobname=advanced-ru-fr-abc_order "\def\csvfilename{cefr/advanced-ru-fr-abc_order.csv} \input{tex/a4-3columns.tex}"
#
#build_ru_fr:
#	build_ru_fr_beginner
#	build_ru_fr_intermediate
#	build_ru_fr_advanced

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

directories: $(OUT_DIR)

all: directories RU-FR-beginner-abc_order.pdf

clean:
	$(RM) *.log *.aux

veryclean: clean
	#$(RM) *.pdf
	$(RM) -rf $(output_dir)

distclean: veryclean

