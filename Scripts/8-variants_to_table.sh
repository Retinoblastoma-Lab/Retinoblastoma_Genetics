#!/usr/bin/bash -l
#SBATCH -p batch                                       # Partition to submit to
#SBATCH -J variant                            # Job name
#SBATCH -n 8                                           # Number of CPU cores requested
#SBATCH -o ../error_reports/variants_to_table.out      # Standard output log
#SBATCH -e ../error_reports/variants_to_table.err      # Standard error log

# Load GATK module
module load gatk/4.4.0.0

# Define paths
INPUT_DIR="../../variant_calling/entire_genome/variants_filtering"
OUTPUT_DIR="../../variant_calling/entire_genome/variants_to_table"
REFERENCE="../RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
INPUT_VCF="${INPUT_DIR}/kenya_retino_filtered_passed_snps.vcf"
OUTPUT_TSV="${OUTPUT_DIR}/kenya_retino_filtered_passed_snps.tsv"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run GATK VariantsToTable
gatk VariantsToTable \
    -R "$REFERENCE" \
    -V "$INPUT_VCF" \
    -F CHROM -F POS -F FILTER -F TYPE -GF AD -GF DP \
    --show-filtered \
    -O "$OUTPUT_TSV"
