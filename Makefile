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
	xelatex -output-directory $(output_dir) -jobname=$(1) \
	"\def\numcolumns{$(2)} \
	\def\widthleftcol{$(3)} \
	\def\widthrightcol{$(4)} \
	\def\baselinevar{$(5)} \
	\def\transfield{$(6)} \
	\def\withyellow{$(7)} \
	\def\csvfilename{$(8)} \
	\def\footerfile{$(9)} \
	\input{tex/a4-template.tex}"

# wget csv. POC avec "semantic version".
# Pour chaque langue:
# 	1. generer liste avec Python
# 	2. generer pdf
# Later:
# 	changelog and release of each new PDF
#getcsv:
#	curl -s "https://api.github.com/repos/Stork_ST/core_russian_verbs/commits?path=russian_verbs_classification.csv" | jq -r '.[0].commit.committer.date'


# Name files to produce
# Generate list such as: RU-FR-beginner-abc_order.pdfR U-FR-beginner-abc_order_colored.pdf... RU-FR-advanced-freq_order_colored.pdf

suffix_files = abc_order.pdf abc_order-colored.pdf freq_order.pdf freq_order-colored.pdf
files_level = $(addprefix $(1), $(suffix_files))
files_lang = $(call files_level,$(1)-beginner-,$(files_level)) $(call files_level,$(1)-intermediate-,$(files_level)) $(call files_level,$(1)-advanced-,$(files_level))


# Specific variables

RU-FR-%: transfield = transFr
RU-EN-%: transfield = transEn
color = no
%colored.pdf: color = yes

beginnersPDF = RU-FR-beginner-% RU-EN-beginner-%
intermediatesPDF = RU-FR-intermediate-% RU-EN-intermediate-%

$(beginnersPDF) $(intermediatesPDF): numcolumns = 4 widthleftcol = 30 widthrightcol = 17 baselinevar = 1
$(beginnersPDF): baselinevar = 1.1


# Rules to produce files

all: directories RU-FR

RU-FR: $(call files_lang,RU-FR)

RU-FR-beginner-freq_order%: $(addprefix $(cefr_dir)/,beginner-freq_order.csv)
	$(call TEX,$(basename $@),$(numcolumns),$(widthleftcol),$(widthrightcol),$(baselinevar),$(transfield),$(color),$<,$(footer_fr))

RU-FR-beginner-abc_order%: $(addprefix $(cefr_dir)/,beginner-abc_order.csv)
	$(call TEX,$(basename $@),$(numcolumns),$(widthleftcol),$(widthrightcol),$(baselinevar),$(transfield),$(color),$<,$(footer_fr))

## Create specific CSV file for each level (one file contains translation for every language)
## $(*F) sets the CEFR levels by calling the right var containing them
$(addprefix $(cefr_dir)/,%-abc_order.csv): $(russian_verbs_c)
	$(call extract_csv,$($(*F)),abc,$@)

$(addprefix $(cefr_dir)/,%-freq_order.csv): $(russian_verbs_c)
	$(call extract_csv,$($(*F)),freq,$@)


# Other rules

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

directories: $(OUT_DIR)

clean:
	$(RM) *.log *.aux

veryclean: clean
	#$(RM) *.pdf
	$(RM) -rf $(output_dir)

