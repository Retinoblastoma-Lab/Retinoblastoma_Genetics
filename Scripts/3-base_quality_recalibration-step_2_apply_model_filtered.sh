#!/usr/bin/bash -l
#SBATCH -p batch                                   # Partition to submit to
#SBATCH -J variant_cal                             # Job name
#SBATCH -n 16                                      # Number of CPU cores requested
#SBATCH -o ../error_reports/Apply_bqsr.out         # Standard output log
#SBATCH -e ../error_reports/Apply_bqsr.err         # Standard error log


# Load required GATK module
module load gatk/4.4.0.0

# Define directories
#INPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/marked_duplicates"
#OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration_step_2"
#REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
#KNOWN_SITES="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/Homo_sapiens_assembly38.dbsnp138.vcf"
#bqsr-recal-file="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration"


# Create output directory if it doesn't exist
#mkdir -p "$OUTPUT_DIR"

# step 2: Apply the model to adjust the base quality scores
#gatk ApplyBQSR \
#    -I ../output/C075_S70_L001.sort.dup.bam \
#    -R ../reference/hg38/Homo_sapiens_assembly38.fasta \
##    --bqsr-recal-file ../output/recal_data.table \
#    -O ../output/C075_S70_L001.sort.dup.bqsr.bam



# Define directories
INPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/marked_duplicates"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration_step_2"
REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
BQSR_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all BAM files
for bam_file in "$INPUT_DIR"/*.sorted_dedup.bam; do
    # Extract the base filename (without path)
    bam_filename=$(basename "$bam_file")
    # Remove the .bam extension to get sample base
    sample_base="${bam_filename%.bam}"   # Example: C001_S1.sorted_dedup

    echo "Processing sample: $sample_base"

    gatk ApplyBQSR \
        -I "$bam_file" \
        -R "$REFERENCE" \
        --bqsr-recal-file "$BQSR_DIR/${sample_base}_recal_data.table" \
        -O "$OUTPUT_DIR/${sample_base}.bqsr.bam"
done

echo "All samples processed!"


