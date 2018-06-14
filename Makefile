all: slides_final.pdf

background.png: makebackground.jl
	julia $<

.PHONY: all clean

slides.md: slides.Rmd
	Rscript -e "library(knitr); knit(input='$<')"

slides.tex: slides.md
	pandoc $< -t beamer --slide-level 2 -fmarkdown-implicit_figures -o $@ --template ./template/pl.tex

slides.pdf: slides.tex
	latexmk

slides_final.pdf: slides.pdf
	cp $< $@

clean:
	latexmk	-c
	-rm *.{vrb,nav,snm}

figures/incrementalcumulative.png: figures/incrementalcumulative.tex
	pdflatex $<
	mv incrementalcumulative.pdf figures/incrementalcumulative.pdf
	pdfcrop figures/incrementalcumulative.pdf figures/incrementalcumulative.pdf
	convert -density 300 figures/incrementalcumulative.pdf figures/incrementalcumulative.png
