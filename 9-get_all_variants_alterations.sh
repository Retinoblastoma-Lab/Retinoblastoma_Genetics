#!/usr/bin/bash -l
#SBATCH -p batch                                      # Partition to submit to
#SBATCH -J model_build                                # Job name
#SBATCH -n 8                                           # Number of CPU cores requested
#SBATCH -o ../error_reports/all_variations.out           # Standard output log
#SBATCH -e ../error_reports/all_variations.err           # Standard error log

# Load GATK module
module load gatk/4.4.0.0

# Define paths
INPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/applying_genotyping"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/model_building"
REFERENCE_DIR="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"


#gatk VariantRecalibrator \
 # -V "${INPUT_DIR}/kenya_retino_output.vcf.gz" \
 # --trust-all-polymorphic \
 # -mode INDEL \
 # --max-gaussians 4 \
 # --resource:mills,known=false,training=true,truth=true,prior=12 ${REFERENCE_DIR}/annotation/Homo_sapiens_assembly38.known_indels.vcf.gz \
 # --resource:dbsnp,known=true,training=false,truth=false,prior=2 ${REFERENCE_DIR}/annotation/Homo_sapiens_assembly38.dbsnp138.vcf.gz \
 # -an QD -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP \
 # -O "${OUTPUT_DIR}/kenyan_retino_indels.recal" \
 # --tranches-file "${OUTPUT_DIR}/kenyan_retino_indels.tranches"

gatk VariantRecalibrator \
  -V "${INPUT_DIR}/kenya_retino_output.vcf.gz" \
  --trust-all-polymorphic \
  -mode INDEL \
  --max-gaussians 4 \
  --resource:mills,known=false,training=true,truth=true,prior=12 ${REFERENCE_DIR}/annotation/Homo_sapiens_assembly38.known_indels.vcf.gz \
  --resource:dbsnp,known=true,training=false,truth=false,prior=2 ${REFERENCE_DIR}/annotation/Homo_sapiens_assembly38.dbsnp138.vcf.gz \
  -an QD -an FS -an SOR -an DP \
  -O "${OUTPUT_DIR}/kenyan_retino_indels.recal" \
  --tranches-file "${OUTPUT_DIR}/kenyan_retino_indels.tranches"