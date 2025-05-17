#!/usr/bin/bash -l
#SBATCH -p batch                                   # Partition to submit to
#SBATCH -J variant_cal                             # Job name
#SBATCH -n 16                                      # Number of CPU cores requested
#SBATCH -o ../error_reports/base_cal_build_model_with_dups.out   # Standard output log
#SBATCH -e ../error_reports/base_cal_build_model_with_dups.err   # Standard error log

# Load required GATK module
module load gatk/4.4.0.0

# Define directories
INPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/alignment"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration_with_dups"
REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
KNOWN_SITES="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/Homo_sapiens_assembly38.dbsnp138.vcf"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop over all BAM files in the input directory
for BAM in "$INPUT_DIR"/*.bam; do
    BASENAME=$(basename "$BAM" .bam)
    
    gatk BaseRecalibrator \
        -I "$BAM" \
        -R "$REFERENCE" \
        --known-sites "$KNOWN_SITES" \
        -O "$OUTPUT_DIR/${BASENAME}_recal_data.table"
done





