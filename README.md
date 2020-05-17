650-700 rows RU/FR or RU/EN:
xelatex -jobname=beginner-ru-fr-abcOrder "\def\csvfilename{cefr/beginner-ru-fr-A1A2B1-abcOrder.csv} \input{tex/a4-4columns.tex}"
xelatex -jobname=intermediate-ru-fr-abcOrder "\def\csvfilename{cefr/intermediate-ru-fr-B2-abcOrder.csv} \input{tex/a4-4columns.tex}"

max685 rows RU/FR or RU/EN, 23chars RU/17-18chars fr - ~95 per row:
xelatex "\def\csvfilename{} \input{a4-4columns-colored.tex}"

max420 rows RU/FR or RU/EN 25chars RU/16 chars fr - ~70 per row :
xelatex "\def\csvfilename{build/cefr/advanced-abc_order.csv} \input{a4-3columns.tex}"

TODO:
  * remove space after comma if enough to keep it on one line (<16 or 17 chars)
