FROM rocker/r-ver:3.6.1

RUN apt-get update && apt-get install --yes \
  git
#  build-essential \
#  apt-utils \

RUN mkdir /home/analysis

RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) { install.packages('BiocManager')}"
RUN R -e "BiocManager::install(c('multtest'))"

RUN R -e "install.packages(c('shape','rjson','circlize','GetoptLong','clue','GlobalOptions'))"

RUN apt-get install --yes libpng-dev

RUN R -e "BiocManager::install(c('ComplexHeatmap'))"
RUN R -e "library(ComplexHeatmap)"

RUN R -e "BiocManager::install(c( 'ggrepel' \
           ,'grid' \
           ,'gridExtra'\
           ,'statmod'\
           ,'R.utils'\
           ,'reshape2'\
           ,'mixtools'\
           ,'scales'\
           ,'gtable'\
           ,'plyr'\
           ,'parallel'\
           ,'doParallel'\
           ,'snowfall'\
           ,'rlecuyer'\
           ,'RColorBrewer'\
           ,'metap'\
           ,'circlize'))"

RUN apt-get install --yes \
  python3 \
  python3-pip

RUN pip3 install numpy pandas

RUN git lfs clone https://github.com/matteocereda/GSECA.git

ADD https://api.github.com/repos/NCBI-Codeathons/ViraVate/git/refs/heads/master version.json
RUN git clone https://github.com/NCBI-Codeathons/ViraVate

ENV PATH "$PATH:/ViraVate/gseca"

CMD cd /GSECA \
  && ls \
  && Rscript /ViraVate/gseca/viravate.R \
  && rm Results/*analysis/*rds \
  && mv viravate.out viravate.err Results/*analysis/* /home/results

#CMD echo $GEM && echo $CCL && echo $AGS && ls -lR /home/results \
#CMD cd /GSECA \
#  && Rscript /Clinical-RNAseq/gseca/viravate.R Examples/PRAD.ptenloss.M.tsv Examples/PRAD.ptenloss.L.tsv gene_sets/cereda.158.KEGG.gmt \
#  && mv Results/*analysis/* /home/results

