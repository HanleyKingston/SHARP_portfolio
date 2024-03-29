# SHARP WORK PORTFOLIO
CAUTION: This is functioning as a personal work portfolio (of sharable scripts from otherwise private repos). Please contact me for the most up-to-date scripts.


# PHYLOGENETIC_ANALYSES - HIV TRANSMISSION TRENDS
  
## SEQUENCE AND METADATA QC AND FILTERING

### 1. seqs_KEY.Rmd (not included)
Connects internal study participant IDS (ptids), generated sequence IDS, and lanl sequence IDs  
**Inputs**  
participant and sample metadata (combined data frame)  
**Outputs**  
Key for sequence IDs (for internal use or by request only)  
### 2. filter_hiv_published_sequences.Rmd  
filters previously published sequences based on year and key population group  
**Inputs**  
Fasta file of all previously published sequences from Kenya  
Metadata for previously published sequences  
**Outputs**   
filtered vector of sequence names to be used in analysis  
filtered metadata file of previously published sequences  
### 3. parse_hiv_fasta_and_genotpye_file.Rmd  
recategorizes REGA and COMET sequence subtype data in 2 ways:  
* simplifies to A1, C, D, or recombinant
* simplifies to...
**Inputs**  
tsv files for REGA and COMET subtype estimates (note: should make 2 separate scripts for REGA and COMET)  
**Outputs**   
Updated REGA and COMET subtype estimate data frames   
### 4. clean_metadata.Rmd  
Combines multiple SHARP participant metadata files, sample metadata, and metadata associated with previously published sequences  
**Inputs**  
SHARP metadata: index, partners, and samples data frames  
previously published sequence metadata (note: metadata limited to subtype year, region, key population group, and sex)  
REGA and COMET subtype estimates (note: REGA subtypes were used in transmission trends analysis and COMET subtypes were used in APS analysis - see below)  
**Outputs**  
Single metadata file containing SHARP and previously published sequences, with subtype information (hereafter called "combined_metadata")    
### 5. Clean seqs and perform alignments using Geneious Prime  
workflow: "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"  
**Inputs**  
fasta files of SHARP HIV sequences for subtypes A1, C, and D  
fasta files of previously published sequences (pre-filtered) for subtypes A1, C, and D  
**Outputs**  
filtered and trimmed fasta file combining SHARP and previously published sequences for each subtype (A1, C, and D)      
record of dropped seqs and trimmed regions here: "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"  
  

## PREPPING FILES FOR BEAST AND ML ASR  
### 6. dicrete_trait_analysis_get_subsample.R  
Extracts lists of sequences for each ASR analysis based on the desired subsampling scheme:
* uniform subsampling: equal counts of seqs by region and key population group  
* Proportionate subsampling: subsample size based on estimated population size (ended up only using for region)  
Note: subsampling is done separately for A1, C, and D subtypes  
**Inputs**  
combined_metadata  
**Outputs**  
log file of trait counts in each subsampled set  
subtype-specific lists of sequences to include in each subsampled set (hereafter called "subsampled_sequence_lists")  
### 7. reformatting_and_BEAST_inputs.Rmd (steps 3.1 through 4.3)  
renames previously published sequences  
filters fasta files for each subtype  
(Note: this script actually contains steps to be run at different time-point and needs to be separated into multiple scripts)  
**Inputs**  
combined metadata    
**Outputs**  
subtype-specific fasta files  
### 8. reformatting_and_BEAST_inputs.Rmd (step 9)  
Extracts subsampled fasta files and metadata formatted for BEAST. Unlike for ML ASR, where a single tree is built and then subsampled, ASR in BEAST is conducted concurrent to tree-building. Therefore, all data must be pre-subsampled.    
(Note: this script actually contains steps to be run at different time-point and needs to be separated into multiple scripts)  
**Inputs**  
subsampled_sequence_lists  
**Outputs**  
subtype-specific subsampled fasta files (for BEAST input)  
subtype-specific subsampled metadata files with year and relevant trait info (in format expected for BEAST)    

## DEVELOP ML TREES AND CONDUCT ML ANCESTRAL STATE RECONSTRUCTION  
### 9. Make trees in IQ tree  
see "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"  
**Inputs**  
subtype-specific fasta files  
**Outputs**  
ML trees for subtype A1, C, and D  
### 10. discrete_trait_analysis3.Rmd  
**Inputs**  
combined_metadata  
subsampled_sequence_lists  
ML trees for subtype A1, C, and D  
**Outputs**  
Tables of estimates of transition counts (analogous to Markov Jumps in Bayesian analysis) between key population groups and regions for each tree  

## RECONSTRUCT AGE OF CLUSTERS AND COMMON ANCESTORS (IN BEAST)  

### 11. Use BEAST to get estimated age-of-origin for each branch and for the total tree
Using all sequences (note: for ASR, we used pre-sub setted fasta files), generate a phylogeny for each subtype to estimate year of origin. Then, use TreeAnnotator to generate a maximum clade credibility tree from 1000 last trees.  
Note: ASR analyses use a strict clock to improve computational speed, but here I use a relaxed clock.   
**Inputs**  
fasta files for each subtype  
Input parameters are here: [add after cleaning]  
**Outputs**  
phylogeny with year-of-origin estimates for each branch (hereafter called MRCA_tree)  
estimated year of most recent common ancestor for the whole tree  
### 12. Identify clusters on MRCA tree
Use ClusterPicker to identify clusters on the MRCA tree using maximum distance threshold of 0.045  
**Inputs**  
MRCA_tree 
**Outputs**  
Data frames of cluster assignments:  
* by-sequence: 1 sequence per row  
* by-cluster: 1 cluster per row  
### 13. reformatting_and_BEAST_inputs.Rmd (step 8)  
Develop metadata file for FigTree visualization  
(Note: this needs to be made into a separate script)  
**Inputs**  
combined_metadata  
per-sequence cluster assignments data frame  
**Outputs**  
metadata formatted for figtree with sequence cluster assignment and sequence source (SHARP study vs previously published) (hereafter called FigTree_metadata)  
### 14. View year of origin estimates AND estimate avg. year of origin for clusters containing PWID sequences and PWID-exclusive clusters
Use FigTree V1.1.4 to visualize metadata on tree and find the estimated year of origin.  
Color clusters by estimated year of origin (be sure to use random colors and not a gradient for easy differentiation) and use shape to indicate PWID seqs.  
For each cluster, note the year of origin and document in an excel sheet. From this, mean dates and confidences can be calculated.  
**Inputs**  
MRCA_tree  
FigTree_matadata  
**Outputs**  
excel file (generated manually) of each date for:
* clusters containing a PWID seq  
* clusters exclusive to PWID   

### 15. Develop BEAST input files using beauti v1.10.4  
Develop Bayesian trees while concurrently estimating ancestor states for the traits of interest (region and key population group).  
**Inputs**  
subtype-specific subsampled fasta files (for BEAST input)  
subtype-specific subsampled metadata (for BEAST input)  
Input parameters are here: [will add after edits]  
**Outputs**  
XML file to read into BEAST  
### 16. Develop trees and perform ASR concurrently in BEAST  
**Inputs**  
XML file generated in beauti  
**Outputs**  
log file  
tree file  
summary file  
### 17. Summarize Markov jumps from BEAST outputs  
Steps are here: [will add after edits]. In short:  
* check for convergence in Tracer  
* extract the 1000 last trees  
* Edit the XML file to count Markov jumps in each direction for each of these trees for the traits of interest (region and/or key population group)  
* Run BEAST with edited XML file  
* Use log file output to summarize Markov jumps between traits of interest across the 1000 trees  
**Inputs**  
XML file generated in beauti  
tree output file from BEAST  
**Outputs**  
Excel file of Markov jump counts  
### 18. Estimate Bayes Factor for Markov jump counts for each BEAST tree  
Use spreaD3_v0.9.6. to estimate Baye's factor for each transition rate (between traits of interest).  
Note: must have checked "infer social network with BSSVS" in BEAST input files for this to work  
**Inputs**  
log files from Beast runs  
**Outputs**  
Text files of BF estimates for each pair of traits & for each subsampled tree (X3 subtypes)    
### 19. combine_spreaD3_BFs.R:  
Calculates the median BF estimate for each pair of traits across the subsampled trees. Run via command line. Only argument is input path where separate BF file estimates are stored.    
**Inputs**  
Text files of BF estimates  
**Outputs**  
Text files of BF estimates combining each subsampled tree   


## CLUSTER ANALYSIS  
Evaluate clustering trends for HIV sequences from PWID. Unlike with the MRCA_tree cluster analysis (focused on estimating time of origin for clusters), we will define clusters using a ML tree.    
### 20. Identify clusters
Use ClusterPicker to identify clusters on the subtype-specific ML trees using maximum distance thresholds of 0.015 and 0.045. Do not use a confidence threshold.  
**Inputs**  
ML trees for each subtype  
**Outputs**  
data frames of cluster assignments (one data frame is 1 sequence per row and 1 data frame is 1 cluster per row) X2 (for each distance)  
### 21. Analyze_clusters.Rmd  
**Inputs** 
combined_metadata  
data frames of cluster assignments:  
* by-sequence  
* by-cluster
**Outputs**  
Summary statistics for cluster makeup by key population groups and regions   
Figures:   
* histogram of cluster size distribution for each key population group   
* mixture plots showing percent makeup of clusters by region (all and limited to SHARP study sequences) and key population group  


## SUMMARY STATS  
### 22. visualize_metadata_on_tree.Rmd  
Plots phylogenies with visualization of sequence or individual-level metadata  
**Inputs**   
combined_metadata  
ML phylogenies (for each subtype)  
**Outputs**  
phylogeny plots by (for SHARP seqs only and all seqs) and for each subtype (A1, C, and D):  
* batch (SHARP seqs only)  
* subtype  
* region  
* year  
* source (SHARP vs previously published)  
* key population group  
* risk factors (SHARP only)  
### 23. discrete_trait_analysis_summaries   
Generate summary statistics from metadata.  
**Inputs**  
combined_metadata  
**Outputs**  
counts for flow diagrams of data availability   
Table 1 stratified by:  
* sequence source (SHARP or previously published)  
* region  
* key population group   


# MOLECULAR EPI INVESTIGATION OF APS
### Use output fasta and metadata files from SEQUENCE AND METADATA QC AND FILTERING (see above)  
### For analogous HCV seq data cleaning steps, see: parse_hcv_fasta_and_genotpye_file.Rmd and combine_metadata_with_tree_HCV.Rmd 
### Main analysis: APS_V2.Rmd


# INVESTIGATION OF HIV DRUG RESISTANCE
### HIV_DRM_phylogeny.Rmd
### SHARP_drug_resistance.Rmd
