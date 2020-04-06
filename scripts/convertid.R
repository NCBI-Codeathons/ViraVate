# Purpose of script is to convert IDs in Gene expression matrix (GEM) from Symbols to Ensemble gene ids (or vice versa)
# The script will put converted IDs in the 2nd column
# Run this script with: 'Rscript convertid.R GEM [symbol|gene_id]'
# first line of GEM needs to have column names that are unique
# the first column of GEM contains the IDs that you want converted
 
args <- commandArgs(trailingOnly = TRUE)
file = args[1]
idtype = args[2] # convert ID to this type: Values "symbol" or "gene_id" (Ensemble Gene ID)

library(ensembldb)
library(EnsDb.Hsapiens.v86)
egids = read.delim(file, header = T, check.names = F)
#dim(egids);head(egids);tail(egids)
ids = egids[,1]
mycolnames = colnames(egids)
#length(ids); length(unique(ids))

edb <- EnsDb.Hsapiens.v86
if (idtype == "gene_id") {
 foo = genes(edb, filter = SymbolFilter(ids))  # some IDs might not be found so nrow of Foo can be less than length of 'ids'
 mymerge = merge(egids, foo, by.x = mycolnames[1], by.y = 'symbol', all.x = T)
} else {
 foo = genes(edb, filter = GeneIdFilter(ids))  # some IDs might not be found so nrow of Foo can be less than length of 'ids'
 mymerge = merge(egids, foo, by.x = mycolnames[1], by.y = 'gene_id', all.x = T)
 #dim(mymerge)
}

selectcols = c(mycolnames[1], idtype)
if(length(mycolnames) > 1) {
  remainingcols = mycolnames[2:length(mycolnames)]
  selectcols = c(selectcols, remainingcols)
}

mymerge = mymerge[,selectcols]
#dim(mymerge)
#mymerge
write.table(mymerge, paste0(file, "_converted.tsv"), sep="\t", row.names=F, quote=F, na="")

