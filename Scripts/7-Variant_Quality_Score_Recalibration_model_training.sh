#!/usr/bin/bash -l
#SBATCH -p batch                                      # Partition to submit to
#SBATCH -J model_build                                # Job name
#SBATCH -n 8                                           # Number of CPU cores requested
#SBATCH -o ../error_reports/model_train.out           # Standard output log
#SBATCH -e ../error_reports/model_train.err           # Standard error log

# Load GATK module
module load gatk/4.4.0.0

# Define paths
INPUT_DIR="../../../variant_calling/entire_genome/applying_genotyping"
OUTPUT_DIR="../variant_calling/entire_genome/model_building"
REFERENCE_DIR="../../RB1_variant_calling/entire_genome/reference"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run VariantRecalibrator
gatk VariantRecalibrator \
    -V "${INPUT_DIR}/kenya_retino_output.vcf.gz" \
    --trust-all-polymorphic \
    -mode SNP \
    --max-gaussians 6 \
    --resource:hapmap,known=false,training=true,truth=true,prior=15 ${REFERENCE_DIR}/hg38_v0_hapmap_3.3.hg38.vcf.gz \
    --resource:omni,known=false,training=true,truth=true,prior=12 ${REFERENCE_DIR}/hg38_v0_1000G_omni2.5.hg38.vcf \
    --resource:1000G,known=false,training=true,truth=false,prior=10 ${REFERENCE_DIR}/hg38_v0_1000G_phase1.snps.high_confidence.hg38.vcf \
    --resource:dbsnp,known=true,training=false,truth=false,prior=7 ${REFERENCE_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf \
    -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ -an SOR -an DP \
    -O "${OUTPUT_DIR}/kenyan_retino_snps.recal" \
    --tranches-file "${OUTPUT_DIR}/kenyan_retino_snps.tranches"  
