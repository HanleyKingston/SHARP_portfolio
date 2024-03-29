# SHARP_portfolio
CAUTION: This is functioning as a personal work portfolio (of sharable scripts from from otherwise private repos). Please contact me for the most up-to-date scripts.


# PHYLOGENETIC_ANALYSES - HIV TRANSMISSION TRENDS
\n\n

## SEQUENCE AND METADATA QC AND FILTERING

### 1. seqs_KEY.Rmd (private - not included)
Connects internal study participant IDS (ptids), generated seqeunce IDS, and lanl sequence IDs  
**Inputs**  
participant and sample metadata (combined dataframe)  
**Outputs**  
Key for seqeunce IDs (for internal use or by request only)  
### 2. filter_hiv_published_sequences.Rmd  
**Inputs**  
Fasta file of all previously published seqeunces  
Metadata on preivously published sequences  
**Ouputs**  
Vector of seqeunce names for seqeunces to be used in analysis  
Filtered metadata file of previosuly published sequences for use in analysis  
Filtered fasta file of previosuly published sequences for use in analysis for each subtype (A1, C, and D)    
### 3. parse_hiv_fasta_and_genotpye_file.Rmd  
Converts REGA and COMET sequence subtype data to relevant categories  
**Inputs**  
REGA and COMET subtype estimates (note: should make into 2 seperate scripts)  
**Outputs**   
Updated REGA and COMET subtype estimate files  
### 4. clean_metadata.Rmd  
Combines multiple SHARP participant metadata files, sample metadata, AND metadata associated with previously published sequences  
**Inputs**  
SHARP metadata: index, partners, and samples data frames  
previously published sequence metadata (note: this is very limited)  
REGA and COMET subtype estimates (note: REGA subtypes were used in trasmission trends analysis and COMET subtypes were used in APS analysis)  
**Outputs**  
Single metadata file containing SHARP and previously published seqeunces, with subtype information (hereafter called "combined_metadata")    
### 5. Clean seqs and perform alignments using Geneious Prime  
see "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"  
**Inputs**  
fasta files of SHARP HIV sequences for each subtype (A1, C, and D)  
fasta files of previouslt published seqeunces (pre-filtered) for each subtype (A1, C, and D)  
**Outputs**  
filtered and trimmed fasta file combining SHARP and previoulsy published sequences for each subtype (A1, C, and D)      
record of dropped seqs and trimmed regions here: "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"  
\n\n

## PREPPING FILES FOR BEAST AND ML ASR
### 9. dicrete_trait_analysis_get_subsample.R
Extracts lists of sequences for each ASR analysis based on the desired subsampling scheme (in this case, equal counts of seqs by region and key population group). Subsampling is done seperately for A1, C, and D subtypes  
**Inputs**  
participant and sample metadata  
fasta files  
**Outputs**  
tables - logging trait counts in each subsampled set  
subtype-specific lists of seqeunces in each subsampled set  
### 8. BEAST_prep_files.Rmd (steps N to N)
Renames previously published seqeunces and created fasta and metadata files formatted for beast input based.  
(Note: this script actually contains steps to be run at different time-point and needt to be seperated into multiple scripts)  
**Inputs**  
lists of seqeunces in each subsampled set  
**Outputs**  
subtype-specific subsampled fasta files (for BEAST input)  
subtype-specific subsampled metadata files with year and relevant trait info (in format expected for BEAST)    


## DEVELOP TREES AND ANCESTRAL STATE RECONSTRUCTION
### 9. Make trees in IQ tree
see "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"  
drop tips that have poor temporal signal in Tempest (if desired)  
**Inputs**  
**Outputs**  
ML trees for each subtype (A1, C, and D)
**Inputs** 
combined_metadata  
ML trees  
**Oputputs**  
Phlyogeny plots  


## RECONSTRUCT AGE OF CLUSTERS AND COMMON ANCESTORS
### 10. Use BEAST to get estimated age-or-origin for each branch and for the total tree
Using all sequences (note: for ASR, we used pre-subsetting fasta files), generate a phylogeny for each subtype while estimating year of origin    
Note: ASR analyses use a strict clock to improve computational speed, but here I use a relaxed clock.   
**Inputs**  
fasta files for each subtype  
Input parameters are here: [add after cleaning]  
**Outputs**  
phylogeny with year-of-origin estimates for each branch (MRCA tree)  
estimated year of most recent common ancestor for the whole tree  
## 12. Identify clusters
Use ClusterPicker to identify clusters on the MRCA tree using maximum distance threshold of 0.045  
**Inputs**  
MRCA tree 
**Outputs**  
dataframes of cluster assignments (one dataframe is 1 seqeunce per row and 1 dataframe is 1 cluster per row)  
## 12. BEAST_prep_files.Rmd (steps N to N)
Develop metadata file for FigTree visualization
(Note: this needs to be made into a seperate script)  
**Input**  
combined_metadata  
cluster assignments dataframe (per seqeunce)  
**Outputs**  
metadata formatted for figtree with sequence cluster assignment and whether seqeunce is from SHARP study (FigTree metadata)  
## 13. View year of origin estimates AND estimate avg. year of origin for clusters containing PWID seqeunces and PWID-exclusive clusters
use FigTree V1.1.4 to visualize metadata on tree and find the estimated year of origin for:  
Color clusters by estiamted year of origin (be sure to use random colors and not a gradient for easy differentiation) and use shape to indicate PWID seqs).
For each cluster, note the year of origin and document in an excel sheet. From this, mean dates and confidences can be calculated  
**Inputs**  
MRCA tree  
FigTree matadata  
**Outputs**  
excel file (generated manually) of each date for:
* clusters containing a PWID seq  
* clusters exclusive to PWID   

### 11. Develop BEAST input files using beauti v1.10.4  
**Inputs**  
fasta files (already subsetted with sequence names matching metadata)  
metadata (already subsetted and formatted for BEAST, with relevant trait information)  
Input parameters are here: [add after cleaning]  
**Outputs**  
xml file to read into BEAST  
### 11. Develop trees and perform ASR concurently in BEAST  
**Inputs**  
XML file generated in beauti  
**Outputs**  
log file  
tree file  
summary file  
### 12. Summarize Markov jumps from BEAST outputs  
Steps are here: [add after cleaning]. In short:  
* check for convergence
* extract the 1000 last trees
* Edit the XML file to count Markov jumps in each direction for each of these trees for the traits of interest (region and/or key population group)
* Run BEAST with edited XML file  
* Use log file output to summarize Markov jumps between traits of interest accross the 1000 trees  
**Inputs**
XML file generated in beauti
tree output file from BEAST
**Outputs**  
Excel file of Markov jump counts  
### 12. Estimate Bayes Factor for Markov jump counts for each BEAST tree  
**Inputs**  
log files from Beast runs into spreaD3_v0.9.6. Note: must have checked "infer scoail netowrk with BSSVS" in BEAST input files for this to work  
### 12. combine_spreaD3_BFs.R:  
Estimates ASR support for BEAST trees based on Bayes Factor. Run via command line. Only argument is input path where seperate BF file estimates are stored.    


## CLUSTER ANALYSIS  
Evaluate clustering trends for HIV seqeunces from PWID
## 12. Identify clusters
Use ClusterPicker to identify clusters on the ML trees (for each subtype) using maximum distance thresholds of 0.015 and 0.045. Do not use a confidence threshold.  
**Inputs**  
ML trees for each subtype  
**Outputs**  
dataframes of cluster assignments (one dataframe is 1 seqeunce per row and 1 dataframe is 1 cluster per row) X2 (for each distance)  
### 13. Analyze_clusters.Rmd  
**Inputs** 
dataframes of cluster assignments (by sequence and by cluster)  
Summary statistics for cluster makeup by key population groups and regions  
Figures :
* histogram of cluster size distribution for each key population group  
* mixture plots showing percent makeup of clusters by region (all and limited to SHARP study seqeunces) and key population group


## SUMMARY STATS  
### 7. visualize_metadata_on_tree.Rmd  
Plots phylogenies with visualization of sequence or individual-level metadata
**Inputs**  
combined_metadata  
ML phylogenies (for each subtype)  
**Outputs**  
phylogenies by (for SHARP seqs only and all seqs) and for each subtype (A1, C, and D):
* batch (SHARP seqs only)
* subtype
* region
* year
* source (SHARP vs previously published)
* key population group
* risk factors (SHARP only)
### 12. discrete_trait_analysis_summaries  
**Inputs**  
combined_metadata  
**Outputs**  
counts for flow diagrams of data availability
Table 1 stratified by:
* sequence source (SHARP or previosuly published)
* region
* key population group  


# MOLECULAR EPI INVESTIGATION OF APS

### 1. seqs_KEY.Rmd (private - not included)
### 2. parse_hiv_fasta_and_genotpye_file.Rmd (for HIV) OR parse_hcv_fasta_and_genotpye_file.Rmd (for HCV) 
### 3. combine_metadata_with_tree.Rmd (for HIV) OR combine_metadata_with_tree_HCV.Rmd (for HCV)
If doing phylogeny-based analysis. For TN93 distance-based analysis, skip this step



# INVESTIGATION OF HIV DRUG RESISTANCE
### HIV_DRM_phylogeny.Rmd
### SHARP_drug_resistance.Rmd
