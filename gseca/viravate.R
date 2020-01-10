#!/usr/bin/env Rscript


###################################### DEFINE FUNCTIONS ############################################


# define GSECA function
applyGSECA <- function(gene_expression_matrix,
                       case_ctrl_list,
                       gene_sets){
  
  # Run GSECA
  res = GSECA_executor(    gene_expression_matrix # Gene Expression matrix
                         , case_ctrl_list # Sample label list
                         , gene_sets # gene set list
                         , outdir = "Results" #outdir folder
                         , analysis = "my_analysis" # analysis name
                         , N.CORES = 2 # number of cores
                         , EMPIRICAL = T # true if empirical p-value is requested
                         , BOOTSTRP = T
                         , nsim = 2 # number of bootstrapping
                         , AS = 0.25 # AS threshold
                         , PEMP = 1 # p.emp threshold
                         , SR   = 0.7 # success rate threshold
                         , toprank = 10 # success rate threshold
                         , iphen = c("CASE", "CNTR") #  phenotype lables
  )
  
  return(res)
  
}


###################################### PROCESS ARGUMENTS ############################################

'ViraVate

Usage:
  viravate.R <gene_expression_matrix> <case_ctrl_list> <gene_sets> [-ags=<additional_gene_set>]

Options:
  -h --help                       Show this screen
  -ags=<additional_gene_set>     Additional Gene Set

' -> doc


#library(docopt)

#arguments <- docopt(doc)


gem=Sys.getenv("GEM")
ccl=Sys.getenv("CCL")
gsl="/ViruVate/gseca/combined.gmt"
ags=Sys.getenv("AGS")

cat('gene_expression_matrix:',gem,'\n')
cat('case_ctrl_list:',ccl,'\n')
cat('gene_sets:',gsl,'\n')
cat('additional_gene_set:',ags,'\n')
cat('--ags does not exists:',is.null(ags),'\n')




###################################### MAIN BODY ############################################


setwd('/GSECA/')

source("Scripts/config.R")

# Gene set list
gene_sets = read.gmt.file(gsl)

if (!is.null(ags)) {
  # additional user-defined gene sets
  
  # code to combine user-provided <ags> .gmt file with <gene_expression_matrix>
  ags = read.gmt.file(arguments$ags)
  gene_sets = c(gene_sets,ags)
  
}

# Gene expression matrix
gene_expression_matrix = read.delim(gem)

# Sample label list
case_ctrl_list = read.delim(ccl)[,1]

# Get significant gene set lists
res = applyGSECA(gene_expression_matrix,
                 case_ctrl_list,
                 gene_sets)

# Modify outputs
result_dir = res$analysis
input_file = paste(result_dir, '/gseca.csv', sep = '')
output_file = paste(result_dir, '/viravate_output.csv', sep = '')
call_dataclean = paste('interpret.py', input_file, output_file)
system(call_dataclean)

