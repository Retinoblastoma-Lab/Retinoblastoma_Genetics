#!/bin/bash

# Step 1: Download latest GENCODE GTF
wget -O gencode.v44.annotation.gtf.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.annotation.gtf.gz

# Step 2: Unzip
gunzip -f gencode.v44.annotation.gtf.gz

# Step 3: Extract only RB1 canonical transcript exons and convert to BED
awk 'BEGIN{OFS="\t"}
    $3 == "exon" && $0 ~ /gene_name "RB1"/ && $0 ~ /appris_principal_1/ {
        chrom = $1;
        start = $4 - 1;  # BED is 0-based
        end = $5;
        print chrom, start, end
}' gencode.v44.annotation.gtf | sort -u > RB1_exons_hg38.bed

