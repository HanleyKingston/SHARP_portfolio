# SHARP_portfolio
CAUTION: This is functioning as a personal work portfolio. Please contact me to access the original repos for the most up-to-date scripts.


# PHYLOGENETIC_ANALYSES - HIV TRANSMISSION TRENDS

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
Filtered fasta file of previosuly published sequences for use in analysis  
### 3. parse_hiv_fasta_and_genotpye_file.Rmd  
Converts REGA and COMET sequence genotype data to relevant categories
**Inputs**  
REGA and COMET genotype estimates (note: should make into 2 seperate scripts)  
**Outputs**  
Updated REGA and COMET genotype estimate files
### 4. clean_metadata.Rmd  
Combines multiple SHARP participant metadata, sample metadata, AND metadata associated with previously published sequences
**Inputs**  
SHARP metadata: index, partners, and samples data frames  
previously published sequence metadata (note: this is very limited)  
REGA and COMET genotype estimates (note: REGA genotypes were used in trasmission trends analysis and COMET genotypes were used in APS analysis)  
**Outputs**
Single metadata file containing SHARP and previously published seqeunces, with genotype information  
### 5. Perform alignments using in Geneious Prime  
see "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"


## PREPPING FILES FOR BEAST AND ML ASR
### 8. BEAST_prep_files.Rmd
Selects seqs by subtype
### 9. dicrete_trait_analysis_get_subsample.R
Extracts lists of sequences for each ASR analysis based on the desired subsampling scheme (in this case, equal counts of seqs by region and key population group)  
**Inputs**  
participant and sample metadata  
fasta files  
**Outputs**  
tables - logging trait counts in each subsampled set  
lists of seqeunces in each subsampled set  
subsampled fasta files  


## DEVELOP TREES AND ANCESTRAL STATE RECONSTRUCTION
### 9. Make trees in IQ tree
see "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"
drop tips that have poor temporal signal in Tempest (if desired)
### 7. visualize_metadata_on_tree.Rmd
### 10. RECONSTRUCT AGE OF COMMON ANCESTOR IN BEAST
### 11. Develop trees and perform ASR concurently in BEAST
see "onedrive/SHARP_Study/Phylogenetics/Generalized workflow/HIV_analysis_steps"
### 12. combine_spreaD3_BFs.R:
Estimates ASR support for BEAST trees based on Bayes Factor


## SUMMARY STATS AND CLUSTER ANALYSIS
### 12. discrete_trait_analysis_summaries
### 13. Analyze_clusters.Rmd



# MOLECULAR EPI INVESTIGATION OF APS

### 1. seqs_KEY.Rmd (private - not included)
### 2. parse_hiv_fasta_and_genotpye_file.Rmd (for HIV) OR parse_hcv_fasta_and_genotpye_file.Rmd (for HCV) 
### 3. combine_metadata_with_tree.Rmd (for HIV) OR combine_metadata_with_tree_HCV.Rmd (for HCV)
If doing phylogeny-based analysis. For TN93 distance-based analysis, skip this step



# INVESTIGATION OF HIV DRUG RESISTANCE
### HIV_DRM_phylogeny.Rmd
### SHARP_drug_resistance.Rmd
