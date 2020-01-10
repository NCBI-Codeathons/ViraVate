# Clinical-RNAseq
RNAseq Reporting Designed for Clinical Deliverability
 
# Why use ViraVate?

ViraVate ("vee-rah-vah-tey") is a command-line tool to identify whether differences between a user-provided gene expression matrix of any case vs. control (e.g. diabetics vs. non-diabetics) are associated with differentially expressed genes in infected vs. uninfected groups across a database of human-viral infections.

With ViraVate, you have a simple and fast solution to identify viral infection derived variants in data you already have. 

# How to ger ViraVate (i.e., installation instructions):

### Docker?

### Installing ViraVate from Github

1.
<pre><code>git clone https://github.com/NCBI-Codeathons/Clinical-RNAseq.git
</code></pre>
2.
[]Anything else?

### Configuration

# How to use ViraVate:

ViraVate takes inputs of (1) a gene expression matrix from a study containing two groups and (2) a key to indicate which data belongs to a ‘control’ versus the ‘experimental’ group.  The output of ViraVate is a list of the viral infection derived variants between the control and experimental groups.  

![UserInterfaceFlowChart](Figures/UserInterfaceFlowChart.png)

ViraVate requires two inputs from the user.  The first input is a gene expression matrix from a study containing two groups (Fig #).  The second input is a key to indicate which data belongs to a ‘control’ versus the ‘experimental’ group (Fig #).  While the author provided compilation of variants of interest, there is an optional input for the user to include additional genetic variants.

[] Fig. # <Image of an input gene expression matrix>
[] Fig. # <Image of an input group key>
 
 Running ViraVate is easily run with the following line(s) of code in <R?>:
 
<pre><code>This is a code block.
</code></pre>

The output of X will indicate significantly different viral infection derived variants between the control and experimental groups (Fig. #).

[] Fig. # <Image of output of ViraVate>

# Additional Functionality? 

