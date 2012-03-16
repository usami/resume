PLATEX=platex
DVIPDFMX=dvipdfmx
DVIPS=dvips
BIBTEX=bibtex
TARGET=resume
DEPEND_TEX=
DEPEND_TEX_FILES=
BIB=mybib
DEPEND=$(BIB).bib
UPLOAD_URL = 
TEX_INTERMEDIATE_FILES=.log .toc

.PHONY: all
all: pdf

.PHONY: pdf
pdf: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).dvi
	$(DVIPDFMX) $<

$(TARGET).dvi: $(TARGET).tex $(DEPEND_TEX_FILES) $(DEPEND)
	$(PLATEX) -jobname=$(basename $@) $<
	$(BIBTEX) $(TARGET)
	$(PLATEX) -jobname=$(basename $@) $<
	$(BIBTEX) $(TARGET)
	$(PLATEX) -jobname=$(basename $@) $<

%.ps: %.dvi 
	$(DVIPS) $<

.PHONY: spell
spell: 
	for file in $(DEPEND_TEX_FILES); do aspell -x -t -c $$file;	done
	
.PHONY: clean
clean:
	$(RM) *.aux *.toc *.log *.dvi $(TARGET).pdf *.ps *.bbl *.blg
