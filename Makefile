#
# makefile for adjmulticol package
#
# this file is in public domain
#
# $id$
#

langs := RU-FR RU-EN
russian_verbs_c := RussianVerbsClassification.csv
yellow_field := Действительный
yellow_when := действит.
beginner := A1 A2 B1
intermediate := B2
advanced := C1 C2

today := $(shell date +%Y/%m/%d)
version_ru_fr := $(today) - vBeta
footer_fr := ./tex/footer-fr.tex
version_ru_en := $(today) - vAlpha
footer_en := ./tex/footer-en.tex

output_dir := build
cefr_dir := $(output_dir)/cefr
OUT_DIR := $(output_dir) $(cefr_dir)

extract_csv = \
	python3.8 extract-RussianVerbsClassification.py --cefr-levels $(1) --order $(2) --yellow $(yellow_field) $(yellow_when) > $(3)

TEX = \
	xelatex -output-directory $(output_dir) -jobname=$(1) \
	"\def\fontsizevar{$(2)} \
	\def\numcolumns{$(3)} \
	\def\widthleftcol{$(4)} \
	\def\widthrightcol{$(5)} \
	\def\baselinevar{$(6)} \
	\def\transfield{$(7)} \
	\def\withyellow{$(8)} \
	\def\csvfilename{$(9)} \
	\def\footerfile{$(10)} \
	\def\level{$(11)} \
	\def\refvar{$(subst _,\_,$(1))} \
	\def\version{$(12)} \
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

suffix_files_abc := abc_order.pdf abc_order-colored.pdf
suffix_files_freq := freq_order.pdf freq_order-colored.pdf
suffix_files_freq_n_proximity := freq_n_proximity_order.pdf freq_n_proximity_order-colored.pdf
suffix_files := $(suffix_files_abc) $(suffix_files_freq) $(suffix_files_freq_n_proximity)

files_level_abc = $(addprefix $(1),$(suffix_files_abc))
files_level_freq = $(addprefix $(1),$(suffix_files_freq))
files_level_freq_n_proximity = $(addprefix $(1),$(suffix_files_freq_n_proximity))
files_level = $(files_level_abc) $(files_level_freq) $(files_level_freq_n_proximity)
files_lang = $(call files_level,$(1)-beginner-) $(call files_level,$(1)-intermediate-) $(call files_level,$(1)-advanced-)
files_langs = $(foreach lang,$(1),$(call files_lang,$(lang)))

# Functions to build every abc/freq field for each language and levels
files_level_lang_abc = $(foreach lang,$(1),$(call files_level_abc,$(lang)$(2)))
files_level_lang_freq = $(foreach lang,$(1),$(call files_level_freq,$(lang)$(2)))
files_level_lang_freq_n_proximity = $(foreach lang,$(1),$(call files_level_freq_n_proximity,$(lang)$(2)))

files_beginners_abc = $(call files_level_lang_abc,$(1),-beginner-)
files_beginners_freq = $(call files_level_lang_freq,$(1),-beginner-)
files_beginners_freq_n_proximity = $(call files_level_lang_freq_n_proximity,$(1),-beginner-)
files_intermediates_abc = $(call files_level_lang_abc,$(1),-intermediate-)
files_intermediates_freq = $(call files_level_lang_freq,$(1),-intermediate-)
files_intermediates_freq_n_proximity = $(call files_level_lang_freq_n_proximity,$(1),-intermediate-)
files_advanceds_abc = $(call files_level_lang_abc,$(1),-advanced-)
files_advanceds_freq = $(call files_level_lang_freq,$(1),-advanced-)
files_advanceds_freq_n_proximity = $(call files_level_lang_freq_n_proximity,$(1),-advanced-)

lang_level := $(foreach lang,$(langs),$(lang)-beginner $(lang)-intermediate $(lang)-advanced)

# Specific variables. Configuration of Latex template.

beginnersPDF_abc := $(call files_beginners_abc,$(langs))
beginnersPDF_freq := $(call files_beginners_freq,$(langs))
beginnersPDF_freq_n_proximity := $(call files_beginners_freq_n_proximity,$(langs))
beginnersPDF := $(beginnersPDF_abc) $(beginnersPDF_freq) $(beginnersPDF_freq_n_proximity)

intermediatesPDF_abc := $(call files_intermediates_abc,$(langs))
intermediatesPDF_freq := $(call files_intermediates_freq,$(langs))
intermediatesPDF_freq_n_proximity := $(call files_intermediates_freq_n_proximity,$(langs))
intermediatesPDF := $(intermediatesPDF_abc) $(intermediatesPDF_freq) $(intermediatesPDF_freq_n_proximity)

advancedsPDF_abc := $(call files_advanceds_abc,$(langs))
advancedsPDF_freq := $(call files_advanceds_freq,$(langs))
advancedsPDF_freq_n_proximity := $(call files_advanceds_freq_n_proximity,$(langs))
advancedsPDF := $(advancedsPDF_abc) $(advancedsPDF_freq) $(advancedsPDF_freq_n_proximity)

RU-FR-%: transfield := transFr
RU-EN-%: transfield := transEn
RU-FR-%: version := $(version_ru_fr)
RU-EN-%: version := $(version_ru_en)
color := no
%colored.pdf: color := yes
$(beginnersPDF): level := A1 A2 B1
$(intermediatesPDF): level := B2
$(advancedsPDF): level := C1 C2
$(beginnersPDF) $(intermediatesPDF): fontsizevar := 7pt
$(beginnersPDF) $(intermediatesPDF): numcolumns := 4
$(beginnersPDF) $(intermediatesPDF): widthleftcol := 30mm
$(beginnersPDF) $(intermediatesPDF): widthrightcol := 18mm
$(intermediatesPDF) $(advancedsPDF): baselinevar := 1
$(beginnersPDF): baselinevar := 1.1
$(advancedsPDF): fontsizevar := 9pt
$(advancedsPDF): numcolumns := 3
$(advancedsPDF): widthleftcol := 44mm
$(advancedsPDF): widthrightcol := 21mm


# MAIN: Rules to produce files
.PHONY: all dir $(langs) $(lang_level) beginner intermediate advanced

all: dir $(call files_langs,$(langs))

# ex RU-FR RU-EN
$(langs): dir
	$(MAKE) $(call files_langs,$@)

# ex RU-FR-beginner RU-FR-intermediate
$(lang_level): dir
	$(if $(findstring beginner,$@),$(MAKE) $(call files_level,$@-))
	$(if $(findstring intermediate,$@),$(MAKE) $(call files_level,$@-))
	$(if $(findstring advanced,$@),$(MAKE) $(call files_level,$@-))

beginner: dir $(beginnersPDF)
intermediate: dir $(intermediatesPDF)
advanced: dir $(advancedsPDF)

$(beginnersPDF_abc):: $(addprefix $(cefr_dir)/,beginner-abc_order.csv)
$(beginnersPDF_freq):: $(addprefix $(cefr_dir)/,beginner-freq_order.csv)
$(beginnersPDF_freq_n_proximity):: $(addprefix $(cefr_dir)/,beginner-freq_n_proximity_order.csv)

$(intermediatesPDF_abc):: $(addprefix $(cefr_dir)/,intermediate-abc_order.csv)
$(intermediatesPDF_freq):: $(addprefix $(cefr_dir)/,intermediate-freq_order.csv)
$(intermediatesPDF_freq_n_proximity):: $(addprefix $(cefr_dir)/,intermediate-freq_n_proximity_order.csv)

$(advancedsPDF_abc):: $(addprefix $(cefr_dir)/,advanced-abc_order.csv)
$(advancedsPDF_freq):: $(addprefix $(cefr_dir)/,advanced-freq_order.csv)
$(advancedsPDF_freq_n_proximity):: $(addprefix $(cefr_dir)/,advanced-freq_n_proximity_order.csv)

%.pdf:
	$(call TEX,$(basename $@),$(fontsizevar),$(numcolumns),$(widthleftcol),$(widthrightcol),$(baselinevar),$(transfield),$(color),$<,$(footer_fr),$(level),$(version))


## Create specific CSV file for each level (one file contains translation for every language)
## $(*F) sets the CEFR levels by calling the right var containing them
$(addprefix $(cefr_dir)/,%-abc_order.csv): $(russian_verbs_c)
	$(call extract_csv,$($(*F)),abc,$@)

$(addprefix $(cefr_dir)/,%-freq_order.csv): $(russian_verbs_c)
	$(call extract_csv,$($(*F)),freq,$@)

$(addprefix $(cefr_dir)/,%-freq_n_proximity_order.csv): $(russian_verbs_c)
	$(call extract_csv,$($(*F)),freq_n_proximity,$@)

# Other rules

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

dir: $(OUT_DIR) # Create output directories

clean:
	$(RM) -r $(output_dir)/*.aux
	$(RM) -r $(output_dir)/*.log

veryclean:
	$(RM) -r $(output_dir)/*
	$(RM) -r $(cefr_dir)/*

