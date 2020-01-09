# Clinical-RNAseq
RNAseq Reporting Designed for Clinical Deliverability
 
# Instrucitons for Use:

If not including a Results section, include this section. Examples of input and output files should be provided with some explanatory context. Any novel or complex variable parameters should be explained in sufficient detail to enable users to understand and use the tool's functionality. 

X requires two inputs from the user.  The first input is a gene expression matrix from a study containing two groups (Fig #).  The second input is a key to indicate which data belongs to a ‘control’ versus the ‘experimental’ group (Fig #).  While the author provided compilation of variants of interest, there is an optional input for the user to include additional genetic variants.

Fig. # <Image of an input gene expression matrix>
Fig. # <Image of an input group key>

The output of X will indicate significantly different viral infection derived variants between the control and experimental groups (Fig. #).


# Introduction:
 
Viral derived genome variants can provide clinicians with critical information about patient risk, which could better inform medical screenings and preventative lifestyle changes.  The prevalence of Electronic Medical Records (EMR) could be used to provide clinicians with relevant genomic variants.
 
Associating genomic variants with patients' EMR can also support to scientific inquiries.  Specifically, it is thought that viral infections may later lead to autoimmune complications such as type 1 Diabetes (Marre et al., 2018, Snyder guy), immune-mediated arthritis (Nabbe et al., 2003), or tumorigenesis (Garcia-Nieto et al., 2019).  Associating variants of EMR will facilitate scientific investigation between viral infections and autoimmune complications.
 
Including genomic variants on Electronic Medical Records (EMR) will improve patient care by informing clinicians and facilitating scientific discovery.  However, currently, it is unclear which genomic variants should be included or how this information should be reported.  This project identifies RNA sequence variants associated with chronic illness and viral infection and proposes an accessible nomenclature of these RNA sequences on Electronic Medical Records.
 
<Missing why this has to be done with RNA? Because it's viral?>
<Perhaps could further discuss the limitations in how genomic data has been previously included on EMR?>
 
# Dependencies:
 
TDB :expressionless:
 
# Methods:

### Workflow
 
![RNAseq_WorkFlow](/RNAseq_WorkFlow.png)
 
### Identification of RNAseq Variants of interest
 
To provide researchers and clinicians with relevant data, only RNA sequence variants associated with chronic illness and viral infection were considered.  These RNA sequence variants were identified with two methods.
 
First, RNA sequence variants were identified from an existing database.  Specifically, we utilized Harmonizome's "GEO Signatures of Differentially Expressed Genes for Viral Infections" (https://amp.pharm.mssm.edu/Harmonizome/dataset/GEO+Signatures+of+Differentially+Expressed+Genes+for+Viral+Infections). RNA sequences were identified using previously developed code (Lauria et al., 2019)(https://github.com/matteocereda/GSECA).
 
Second, RNA sequence variants were identified as genetic differences between controls and different types of infection states.   The infection datasets utilized were for RSV (), sepsis (), ebola (), and hepatitis ().  These datasets were identified with an NCBI SRA database search and results were limited to datasets that included raw counts to avoid differences in differential expression.  The authors acknowledge that different count methods could introduce different biases to the datasets, but this was done due to temporal limitations. For each dataset, the raw counts were used for healthy and infected transcripts. Differential expression was used to determine which variants were significantly different between controls and each infected transcripts. <I should include EdgeR here ?>  The same parameter values were used for each dataset with alpha=0.05 and a min Log2FC >1. The identified RNA sequence variants were then pooled for all datasets.
 
RNA sequence variants between both identification methods were pooled.  The authors acknowledge that this is not a comprehensive list of variants associated with viral infections and chronic illnesses but instead will use the identified variants as a proof of concept.
 
### Selected Nomenclature
 
Previous proponents of including genomic variants on EMR propose including both the variants common and technical (better word for technical?) names (Ohno-Machado et al., 2018). The common name will be easily recognized and it is the nomenclature clinicians are familiar with. The technical name will increase the computability of the information and conform to standards developed by the Human Genome Variation Society (HGVS), Human Genome Organization Gene Nomenclature Committee, and the Human Variome Project
(den Dunnen et al., 2016).  Thus using two names increases the usability of the data to both clinicians and scientists.  Therefore our selected nomenclature includes both common and technical names.
 
### Inclusion of genomic data into Electronic Medical Records
 
TBD :expressionless:
