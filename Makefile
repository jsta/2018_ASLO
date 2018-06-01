TEXMFHOME = $(shell kpsewhich -var-value=TEXMFHOME)
INSTALL_DIR = $(TEXMFHOME)/tex/latex/pltheme
FILE=slides
OUTPUT=$(FILE)_final.pdf

all: $(OUTPUT)

background.png: makebackground.jl
	julia $<

.PHONY: clean

$(FILE).md: $(FILE).Rmd
	Rscript -e "library(knitr); knit(input='$<')"

$(FILE).tex: $(FILE).md
	pandoc $< -t beamer --slide-level 2 -fmarkdown-implicit_figures -o $@ --template ./template/pl.tex

$(FILE).pdf: $(FILE).tex
	latexmk

$(OUTPUT): $(FILE).pdf
	cp $< $@

clean:
	latexmk	-c
	-rm *.{vrb,nav,snm}
