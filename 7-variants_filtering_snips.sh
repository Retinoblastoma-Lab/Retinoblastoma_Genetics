#!/usr/bin/bash -l
#SBATCH -p batch                                      # Partition to submit to
#SBATCH -J variant_filtering                          # Job name
#SBATCH -n 8                                          # Number of CPU cores requested
#SBATCH -o ../error_reports/variants_filter_relaxed.out       # Standard output log
#SBATCH -e ../error_reports/variants_filter_relaxed.err       # Standard error log

# Load GATK module
module load gatk/4.4.0.0

# Define paths
INPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/applying_genotyping"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/variants_filtering"
REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run GATK VariantFiltration
#gatk VariantFiltration \
 # -R "$REFERENCE" \
 # -V "$INPUT_DIR/kenya_retino_output.vcf.gz" \
 # -O "$OUTPUT_DIR/kenya_retino_filtered_snps.vcf.gz" \
 # --filter-name "QD_lt_2" --filter-expression "QD < 2.0" \
 # --filter-name "FS_gt_60" --filter-expression "FS > 60.0" \
 # --filter-name "MQ_lt_40" --filter-expression "MQ < 40.0" \
 # --filter-name "SOR_gt_3" --filter-expression "SOR > 3.0" \
 # --filter-name "MQRankSum_lt_-12.5" --filter-expression "MQRankSum < -12.5" \
 # --filter-name "ReadPosRankSum_lt_-8.0" --filter-expression "ReadPosRankSum < -8.0"

gatk VariantFiltration \
  -R "$REFERENCE" \
  -V "$INPUT_DIR/kenya_retino_output.vcf.gz" \
  -O "$OUTPUT_DIR/kenya_retino_filtered_snps_relaxed.vcf.gz" \
  --filter-name "QD_lt_2" --filter-expression "QD < 2.0" \
  --filter-name "FS_gt_100" --filter-expression "FS > 100.0" \
  --filter-name "MQ_lt_40" --filter-expression "MQ < 40.0" \
  --filter-name "SOR_gt_4" --filter-expression "SOR > 4.0" \
  --filter-name "MQRankSum_lt_-10" --filter-expression "MQRankSum < -10.0" \
  --filter-name "ReadPosRankSum_lt_-8.0" --filter-expression "ReadPosRankSum < -8.0" \
  --genotype-filter-name "LowGQ" --genotype-filter-expression "GQ < 20" \
  --genotype-filter-name "LowDP" --genotype-filter-expression "DP < 10"

