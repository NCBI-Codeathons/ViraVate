#see http://stackoverflow.com/questions/2151212/how-can-i-read-command-line-parameters-from-an-r-script
args <- commandArgs(trailingOnly = TRUE)
#args=c("ids.three.tsv","T","entrezgene")
#args=c("ids.three.nohead.tsv","F","entrezgene_id")
file = args[1]
header = as.logical(args[2])
filters = args[3]         # the type of input IDs: i.e. "entrezgene_id", "hgnc_symbol", or "mgi_symbol"
dataset = args[4]         # if leave blank, will default to 'hsapiens_gene_ensembl'; or use 'mmusculus_gene_ensembl' for mouse

if (is.na(dataset) ) {
	dataset = "hsapiens_gene_ensembl"
}

# column 1 is the unique identifier that needs to be annotated
data = read.delim(file, header=header)   # read.delim header=T is default

#source("http://bioconductor.org/biocLite.R")
#biocLite("biomaRt")
library(biomaRt)
emart <- useMart("ensembl", dataset = dataset)

symbol = 'hgnc_symbol'
if (grepl("^mmusculus", dataset)) {
    symbol = 'mgi_symbol'
}

map <- getBM(mart = emart, attributes = c("description",symbol,"entrezgene_id","gene_biotype"),
             filters = filters, values=data[,1])
map[,1] = sub(" \\[Source.*\\]","",as.character(map[,1]))

ids = as.data.frame(data[,1])   # get the unique identifier column as a data frame
idname = colnames(data)[1]
colnames(ids) = idname

# after merge, will contain duplicate UniqueID values
ids.annot = merge(ids,map,by.x=idname,by.y=filters,all.x=TRUE)
# get indexes of first occurrence of UniqueID
idx = match(ids[,1],ids.annot[,1])
ids.annot = ids.annot[idx,]

outfile=paste(file,".annotated.tsv", sep="")
toWrite = cbind(data, ids.annot[,2:length(colnames(ids.annot))])
write.table(toWrite,outfile,sep="\t",row.names=F,quote=F,na="",col.names=header)
