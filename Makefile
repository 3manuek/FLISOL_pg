PDF=index.pdf

HTML=$(PDF:.pdf=.html)
XML=$(PDF:.pdf=.xml)
DOC=$(PDF)
SLIDY=$(HTML)

.SILENT:

#convert:
#	iconv -tUTF-8 -fISO-8859-1 --verbose oldindex > index.txt

all : doc slidy
      
help :
	@echo "targets available: all clean help doc slidy validate"

doc : $(DOC)

slidy : $(SLIDY)

clean :
	rm -f $(HTML) $(DOC) $(XML)

validate :
	for file in $(XML); do\
		[ -e $$file ] && xmllint --noout --valid $$file; \
	done

%.pdf : %.txt Makefile common/pdf_courses.xsl
	a2x --attribute encoding=UTF-8 -a lang=es --xsl-file=common/pdf_courses.xsl --fop -f pdf --xsltproc-opts="--stringparam copyrightyear $$(date +%Y) --stringparam copyrightholder '2ndQuadrant Limited' --stringparam footer.image.filename ./common/logo.png" $<
	echo "PDF file is $(PDF)"

%.html : %.txt Makefile common/slidy.css common/asciidoc.conf
	asciidoc --backend slidy --conf-file common/asciidoc.conf $<
	echo "HTML file is $(HTML)"

.PHONY: all help slidy doc clean validate
