#!/usr/bin/bash -l
#SBATCH -p batch                                      # Partition to submit to
#SBATCH -J genotype_GVCFs                             # Job name
#SBATCH -n 8                                          # Number of CPU cores requested
#SBATCH -o ../error_reports/apply_genotyping.out      # Standard output log
#SBATCH -e ../error_reports/apply_genotyping.err      # Standard error log

# Load GATK module
module load gatk/4.4.0.0

# Define paths
REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
INPUT_GVCF="/var/scratch/global/emurungi/variant_calling/entire_genome/combined_gvcfs_Rb1_only/kenya_retinoblastoma_variants_Rb1_only.g.vcf.gz"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/applying_genotyping_rb1_gene"
rb1_bed_file="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/annotation/RB1_exons_filtered.bed"
OUTPUT_VCF="${OUTPUT_DIR}/kenya_retino_rb1_output.vcf.gz"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run GATK GenotypeGVCFs
gatk GenotypeGVCFs \
    -R "$REFERENCE" \
    -V "$INPUT_GVCF" \
    -L "$rb1_bed_file" \
    -O "$OUTPUT_VCF"


