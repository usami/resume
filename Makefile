PLATEX=platex
DVIPDFMX=dvipdfmx
DVIPS=dvips
BIBTEX=jbibtex
TARGET=resume
DEPEND_TEX=
DEPEND=pmref
BIB=mybib
UPLOAD_URL =
DEPEND_TEX_JIS=$(addsuffix .jis.tex, $(DEPEND_TEX))
TEX_INTERMEDIATE_FILES=.log .toc

.PHONY: all
all: pdf

.PHONY: pdf
pdf: $(TARGET).pdf

.PHONY: dvi
dvi: $(TARGET).dvi

.PHONY: ps
ps: $(TARGET).ps

.PHONY: bbl
bbl: $(TARGET).bbl

.PHONY: bb
bb: $(DEPEND).bb

.INTERMEDIATE: $(DEPEND_TEX_JIS)
$(TARGET).dvi: $(DEPEND_TEX_JIS) 

%.dvi: %.tex

%.bb: $(DEPEND).pdf
	ebb $<

%.dvi: %.tex 
	$(PLATEX) -jobname=$(basename $@) $<

%.ps: %.dvi 
	$(DVIPS) $<

%.pdf: %.dvi
	$(DVIPDFMX) $<

.PHONY: wc
wc: 
	perl -ne 's/\\[^}]*[}\]]//g; s/.*\\\\//g; s/\\hline//g; print' $(addsuffix .tex, $(DEPEND_TEX)) | wc -w
	
.PHONY: clean
clean:
	$(RM) *.aux *.toc *.log *.dvi $(TARGET).pdf *.ps *.bbl *.blg

.PHONY: upload
upload: $(TARGET).pdf cookie.txt
	curl -k -b cookie.txt\
		-F "file=@$(TARGET).pdf;type=application/pdf" \
		-F "etitle=`grep '\\\etitle' $(TARGET).tex | sed -e 's/\\\etitle{\([^}]*\)}/\1/g'`" \
		-F "jtitle=`grep '\\\jtitle' $(TARGET).tex | sed -e 's/\\\jtitle{\([^}]*\)}/\1/g'`" \
		-F "remark=" \
		-F "submit=Upload" \
		--progress-bar \
		$(UPLOAD_URL) > /dev/null

.INTERMEDIATE: cookie.txt
cookie.txt:
	curl -k -d @passwd -c cookie.txt -s $(UPLOAD_URL) > /dev/null
