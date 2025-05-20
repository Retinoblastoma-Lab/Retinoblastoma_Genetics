# Retinoblastoma_Genetics
This repository contains Data, Code, and Results of the Kenyan RB1 variant calling analysis among 70 children with biallelic retinoblastoma.  


The README file has a detailed analysis plan, detailing each step of the analysis pipeline.    

This Repository has two parts:  
    a. Analysis Steps to identify inDELS (Insertions and Deletions), and Single Nucleotide Polymorphism.  
    b. Analysis Steps to identify Copy Number Variations (CNVs)  


### Part 1: SNPS and Indels Analysis



### Part 2: Copy Number Variation Analysis  
This a step-by-step guide for using [CNVkit](https://cnvkit.readthedocs.io/en/stable/pipeline.html) to identify copy number variations (CNVs) in the Kenyan Retinoblastoma targeted RB1 gene sequencing, including the necessary code at each step. CNVkit is optimized for targeted sequencing panels, exomes, and WGS  

#### Step 0: Setup and Installation
Create a Conda Environment specific for this analysis and install CNVkit  
**Note**: Make sure you have a working Python environment (Python ≥ 3.6). Then install CNVkit:   

```
conda create -n cnvkit-env cnvkit -c bioconda -c conda-forge
conda activate cnvkit-env
```


####  Step 1: Prepare Inputs
You'll need:

* Tumor BAM file (aligned, sorted, and indexed)
* Target BED file (from your panel, includes RB1 coordinates)
* Reference genome FASTA (same used for alignment)

#### Step 2: Create a flat reference

```
cnvkit.py reference \
    -t targets.bed \
    -f reference.fasta \
    -o flat_reference.cnn
```

#### Step 3: Run CNVkit on tumor sample

```
#!/bin/bash

# Define file paths
TARGETS="../../annotations/RB1_exons_hg38_final_27_exons.bed"
REFERENCE_FASTA="../../annotations/Homo_sapiens_assembly38.fasta"
REFERENCE_CNN="../flat_reference_files/flat_reference.cnn"
OUTPUT_DIR="cnvkit_output"
BAM_DIR="/data/bam_files"

# Make output directory
mkdir -p "$OUTPUT_DIR"

# Loop through each BAM file and process with CNVkit batch
for bam in "$BAM_DIR"/*.bam; do
    sample=$(basename "$bam" .bam)
    echo "Processing $sample"

    cnvkit.py batch "$bam" \
        -r "$REFERENCE_CNN" \
        -t "$TARGETS" \
        -f "$REFERENCE_FASTA" \
        -d "$OUTPUT_DIR/$sample"

    echo "$sample done."
done

echo "All BAM files processed successfully."
```
