all:
	./plot_lang_stats.gnu
	rm -rf masonlarobina.cv.pdf
	pdflatex -halt-on-error -interaction=errorstopmode masonlarobina.cv.tex

plots:
	rm *.dat
	./plot_lang_stats.sh

.PHONY: plots
