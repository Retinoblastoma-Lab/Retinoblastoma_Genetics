# Retinoblastoma_Genetics
This repository contains Data, Code, and Results of the Kenyan RB1 variant calling analysis among 70 children with biallelic retinoblastoma.  


The README file has a detailed analysis plan, detailing each step of the analysis pipeline.    

This Repository has two parts:  
    a. Analysis Steps to identify inDELS (Insertions and Deletions), and Single Nucleotide Polymorphism.  
    b. Analysis Steps to identify Copy Number Variations (CNVs)  


### Part 1: SNPS and Indels Analysis

// ------ Work in Progress to update the page //

### Part 2: Copy Number Variation Analysis  

For the Analysis scripts, kindly refer to the scripts directory   

This a step-by-step guide for using [CNVkit](https://cnvkit.readthedocs.io/en/stable/pipeline.html) to identify copy number variations (CNVs) in the Kenyan Retinoblastoma targeted RB1 gene sequencing, including the necessary code at each step. CNVkit is optimized for targeted sequencing panels, exomes, and WGS  

#### Step 0: Setup and Installation
Create a Conda Environment specific for this analysis and install CNVkit  
**Note**: Make sure you have a working Python environment (Python ≥ 3.6). Then install CNVkit:   

```
conda create -n cnvkit-env cnvkit -c bioconda -c conda-forge
conda activate cnvkit-env
```


####  Step 1: Prepare Inputs
What is needed:

* Tumor BAM file (aligned, sorted, and indexed)
* Target BED file (from your panel, includes RB1 coordinates)
* Reference genome FASTA (same used for alignment)

#### Step 2: Create a flat reference

Creating a flat reference provides a baseline for CNV analysis when no normal samples are available. It assumes uniform copy number across the genome, allowing CNVkit to normalize tumor coverage data despite lacking controls. This enables detection of large CNVs in tumor-only samples, though with less accuracy.

#### Step 3: Run CNVkit on tumor sample

Running CNVkit coverage and correction on tumor samples calculates read depth across targeted regions, adjusts for biases (GC content, target size), and normalizes against the reference. This step transforms raw sequencing data into corrected copy number estimates essential for identifying CNVs in the tumor genome.

#### Step 4: Visualize CNVs

Visualization helps interpret CNV data by showing copy number changes across the genome or specific regions. Plots like scatter plots or heatmaps reveal gains, losses, and patterns difficult to detect in raw data. Visualization validates findings and guides further biological or clinical analysis.

#### Step 5: Focusing on RB1 gene

Zooming in on the RB1 gene allows detailed assessment of its copy number status, critical for understanding tumor biology. Since RB1 alterations can drive cancer progression, focusing here helps detect deletions or amplifications specifically affecting this gene, informing research or therapeutic decisions.


