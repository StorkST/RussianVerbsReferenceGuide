## WIP - Most Common Russian Verbs Reference Guide

Targeted output (more examples in the build/ folder):

![screenshot of example PDF file](https://github.com/StorkST/RussianVerbsSheets/raw/master/example-sheet.png "RU/EN intermediate")

Presentation of the project here: https://storkst.github.io/Russian-Learning-Tools/posts/core-verbs-of-the-russian-language/#what-is-next-need-help

Based on work from https://github.com/StorkST/CoreRussianVerbs


**Help for translation RU->EN and RU->FR is welcome. If you want to contribute please let me know by email: vchd+ttl@pm.me**


### Commands for Xelatex
650-700 rows RU/FR or RU/EN:
xelatex -jobname=beginner-ru-fr-abcOrder "\def\csvfilename{cefr/beginner-ru-fr-A1A2B1-abcOrder.csv} \input{tex/a4-4columns.tex}"
xelatex -jobname=intermediate-ru-fr-abcOrder "\def\csvfilename{cefr/intermediate-ru-fr-B2-abcOrder.csv} \input{tex/a4-4columns.tex}"

max685 rows RU/FR or RU/EN, 23chars RU/17-18chars fr - ~95 per row:
xelatex "\def\csvfilename{} \input{a4-4columns-colored.tex}"

max420 rows RU/FR or RU/EN 25chars RU/16 chars fr - ~70 per row :
xelatex "\def\csvfilename{build/cefr/advanced-abc_order.csv} \input{a4-3columns.tex}"

### Update release on Github with custom labels
hub release edit vBeta-1.0 -m "Référentiel des verbes russes de niveau intermédiaire en deux versions: classé par ordre alphabétique, classé par fréquence dans la langue" -a "build/RU-FR-intermediate-abc_order.pdf#RU-FR intermédiaire - abc" -a "build/RU-FR-intermediate-freq_n_proximity_order.pdf#RU-FR intermédiaire - fréquence"

TODO:
  * remove space after comma if enough to keep it on one line (<16 or 17 chars)?
