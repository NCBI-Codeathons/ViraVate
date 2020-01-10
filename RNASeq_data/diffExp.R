#!/usr/bin/env Rscript
args <- commandArgs(TRUE)
library(edgeR)
library(EnhancedVolcano)
library(ggplot2)
library(factoextra)
library(gplots)

################### Input files #####################
# 1st parameter: the counts matrix file
countMatrix <- args[1]
# 2nd parameter: the index of the 1st column containing count values
startIndex <- args[2]
# 3rd parameter: the index of the last column of count values
endIndex <- args[3]
# 4th paramter: the index of the column containing the gene ids you want to use
idIndex <- as.integer(args[4])
# 5th parameter: the group information file
groupsList <- args[5]
# 6th parameter: the contrast file
contrastGroup <- args[6]
# 7th parameter: the output file name prefix
outputFilePrefix <- args[7]

# 
# countMatrix <- "RSV/RSV_wt_control_counts.txt"
# startIndex <- 3
# endIndex <- 7
# idIndex <- 2
# groupsList <- "RSV/RSV_wt_control_groups_pooled.txt"
# contrastGroup <- "RSV/RSV_wt_control_contrast.txt"
# outputFilePrefix <- "RSV/test"

# countMatrix <- "sepsis/sepsisCD14_counts.txt"
# startIndex <- 2
# endIndex <- 53
# idIndex <- 1
# groupsList <- "sepsis/sepsisCD14_groups_pooled.txt"
# contrastGroup <- "sepsis/sepsisCD14_contrast.txt"
# outputFilePrefix <- "test"


counts <- read.table(file = countMatrix, header = TRUE)
genes <- counts[,idIndex]
counts_tb <- counts[,startIndex:endIndex]
groups <- read.delim(groupsList,header = FALSE)[,1]
samples <- colnames(counts_tb)
colnames(counts_tb) <- groups
# rownames(counts_tb) <- genes

# Generate the DGEList
dgList <- DGEList(counts = counts_tb, genes = genes,group = groups)
# dgList$samples
#head(dgList$counts)
#head(dgList$genes)

#Filtering
countsPerMillion <- cpm(dgList)
#summary(countsPerMillion)

countCheck <- countsPerMillion > 1
keep <- which(rowSums(countCheck) >= 2)
dgList <- dgList[keep,]

# Log transformation
logNormCounts <- log2(cpm(dgList) + 1)
# boxplot(logNormCounts)

# PCA plot
# plotMDS(logNormCounts)
pca <- prcomp(t(logNormCounts))
pca_data_perc=round(100*pca$sdev^2/sum(pca$sdev^2),1)
pca_data_df <- data.frame(PC1 =pca$x[,1], PC2 = pca$x[,2],sample = samples, condition = groups)

library(ggplot2)
# png("pca.png")
pca_plot <- ggplot(pca_data_df, aes(PC1,PC2, color = condition))+
  geom_point(size=8)+
  labs(x=paste0("PC1 (",pca_data_perc[1],")"), y=paste0("PC2 (",pca_data_perc[2],")"))
# print(pca_plot)
# dev.off()
pcaFilename <- paste0(outputFilePrefix,"_PCA.png")
ggsave(pcaFilename,pca_plot, width = 9, height = 7)

# Heatmap
var <- get_pca_var(pca)
firstDimOrder <- order(var$contrib[,1])
indices <- firstDimOrder <= 50
hmap_df <- logNormCounts[indices,]
row.names(hmap_df) <- dgList$genes[indices,]
hmapFilename <- paste0(outputFilePrefix,"_heatmap.pdf")

# png(hmapFilename, width = 600, height = 600)
pdf(hmapFilename)
heatmap.2(hmap_df, trace = "none", scale = "row", dendrogram = "column",  margins=c(7,15), cexRow = 0.5, keysize = 1.5, cexCol = 0.3)
dev.off()

#TMM normalization
dgList <- calcNormFactors(dgList, method="TMM")

# dgList$samples


#Set up the model

designMat <- model.matrix(~ 0 + groups)
colnames(designMat) <- levels(groups)

contrasts_group <- read.delim(contrastGroup,header = FALSE)[,1]
contrasts_group <- droplevels.factor(contrasts_group)

my_contrast <- makeContrasts(contrasts =  contrasts_group, levels=designMat)

#Estimate dispersion
dgList <- estimateGLMCommonDisp(dgList, design=designMat)
dgList <- estimateGLMTrendedDisp(dgList, design=designMat)
dgList <- estimateGLMTagwiseDisp(dgList, design=designMat)
# plotBCV(dgList)

#DIfferential expression
fit <- glmFit(dgList, designMat)
lrt <- glmLRT(fit, coef=ncol(fit$design),contrast = my_contrast)

normCountFilename <- paste0(outputFilePrefix,"_norm_counts.txt")
norm_count_mtx <- cbind(dgList$genes,lrt$fitted.values)
write.table(norm_count_mtx, normCountFilename, row.names = FALSE, quote = FALSE, sep = "\t")

edgeR_result <- topTags(lrt,n = nrow(lrt$table))

# Volcano plot
volPlotFilename <- paste0(outputFilePrefix,"_Volcano_plot.png")
png(volPlotFilename,width = 800, height = 700)
# EnhancedVolcano(edgeR_result$table, lab = NA, x = 'logFC', y = 'PValue', 
#                 pCutoff = 0.05, FCcutoff = 2)
EnhancedVolcano(edgeR_result$table, lab = NA, x = 'logFC', y = 'PValue', 
                pCutoff = 0.05, FCcutoff = 1)
dev.off()

# deGenes <- decideTestsDGE(lrt, p=0.05, lfc=2)
deGenes <- decideTestsDGE(lrt, p=0.05, lfc=1)
deGenes <- rownames(lrt)[as.logical(deGenes)]
# plotSmear(lrt, de.tags = deGenes)
# abline(h=c(-1,1), col="black")

res <- edgeR_result$table[deGenes,]


tableFilename <- paste0(outputFilePrefix,"_DE_List.txt")
write.table(res, file = tableFilename, sep = "\t", quote = FALSE, row.names = FALSE)
message <- paste("DE analysis successfully performed! Please check the output files with prefix ",outputFilePrefix)
print(message)

      