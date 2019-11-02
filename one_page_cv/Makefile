all : cv 

cv :
	@pdflatex --shell-escape cv.tex

.PHONY : clean

clean :
	@rm -rf *.aux *.bbl *.blg *.log *.soc
