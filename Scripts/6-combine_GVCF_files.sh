#!/usr/bin/bash -l
#SBATCH -p batch                                     # Partition to submit to
#SBATCH -J combine_GVCF_files                        # Job name
#SBATCH -n 8                                         # Number of CPU cores requested
#SBATCH -o ../error_reports/Combine_GVCFs.out        # Standard output log
#SBATCH -e ../error_reports/Combine_GVCFs.err        # Standard error log

# Load GATK module
module load gatk/4.4.0.0

# Define paths
REFERENCE="../../RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
INPUT_DIR="../variant_calling/entire_genome/Rb1_region_only_variants"
OUTPUT_DIR="../variant_calling/entire_genome/combined_gvcfs_Rb1_only"
rb1_bed_file="../RB1_variant_calling/entire_genome/annotation/RB1_exons_filtered.bed"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Prepare the list of -V arguments
V_FILES=""
for file in "$INPUT_DIR"/*.g.vcf.gz; do
    V_FILES="$V_FILES -V $file"
done

# Run GATK CombineGVCFs
gatk CombineGVCFs \
    -R "$REFERENCE" \
    $V_FILES \
    -L  "$rb1_bed_file"\
    -O "$OUTPUT_DIR"/kenya_retinoblastoma_variants_Rb1_only.g.vcf.gz 

