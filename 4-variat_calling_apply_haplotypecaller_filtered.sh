#!/usr/bin/bash -l
#SBATCH -p batch                                     # Partition to submit to
#SBATCH -J run_haplotypecaller                       # Job name
#SBATCH -n 8                                         # Number of CPU cores requested
#SBATCH -o ../error_reports/apply_haplotypecaller.out  # Standard output log
#SBATCH -e ../error_reports/apply_haplotypecaller.err  # Standard error log

# Load required GATK module
module load gatk/4.4.0.0

# Define directories
INPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration_step_2"
REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/Rb1_region_only_variants"
rb1_bed_file="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/annotation/RB1_exons_filtered.bed"
# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# ---------------------
# Loop through BAM files and run HaplotypeCaller
# ---------------------
echo "Starting HaplotypeCaller for all samples..."

for bam_file in "$INPUT_DIR"/*.bqsr.bam; do
    bam_base=$(basename "$bam_file" .bqsr.bam)  # Get sample name (e.g., C001_S1.sorted_dedup)

    echo "Processing sample: $bam_base"

    gatk HaplotypeCaller \
        -I "$bam_file" \
        -R "$REFERENCE" \
        -ERC GVCF \
        -L  "$rb1_bed_file"\
        -O "$OUTPUT_DIR/${bam_base}.g.vcf.gz"
done

echo "All samples processed with HaplotypeCaller!"
