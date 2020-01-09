# Purpose of script is to convert Ensembl gene ids in Gene expression matrix (GEM) to Gene Symbols
# The script will put Gene symbols in the 2nd column
# Run this script with: 'Rscript convertid.R GEM'
# first line of GEM needs to have column names that are unique
# the first column of GEM contains the Ensembl gene ids
 
args <- commandArgs(trailingOnly = TRUE)
file = args[1]
idtype = "symbol"   # convert ensembl gene id to this type: Values "symbol", "entrezid"

library(ensembldb)
library(EnsDb.Hsapiens.v86)
egids = read.delim(file, header = T, check.names = F)
#dim(egids);head(egids);tail(egids)
ids = egids[,1]
mycolnames = colnames(egids)
#length(ids); length(unique(ids))

edb <- EnsDb.Hsapiens.v86
foo = genes(edb, filter = GeneIdFilter(ids))  # some IDs might not be found so nrow of Foo can be less than length of 'ids'

mymerge = merge(egids, foo, by.x = mycolnames[1], by.y = 'gene_id', all.x = T)
#dim(mymerge)

selectcols = c(mycolnames[1], idtype)
if(length(mycolnames) > 1) {
  remainingcols = mycolnames[2:length(mycolnames)]
  selectcols = c(selectcols, remainingcols)
}

mymerge = mymerge[,selectcols]
#dim(mymerge)
#mymerge
write.table(mymerge, paste0(file, "_converted.tsv"), sep="\t", row.names=F, quote=F, na="")

