650-700 rows RU/FR or RU/EN:
xelatex -jobname=beginner-ru-fr-abcOrder "\def\csvfilename{cefr/beginner-ru-fr-A1A2B1-abcOrder.csv} \input{tex/a4-4columns.tex}"

max685 rows RU/FR or RU/EN, 23chars RU/17chars fr - per row:
xelatex "\def\csvfilename{} \input{a4-4columns-colored.tex}"

max420 rows RU/FR or RU/EN 25chars RU/16 chars fr - per row :
xelatex "\def\csvfilename{} \input{a4-3columns.tex}"
