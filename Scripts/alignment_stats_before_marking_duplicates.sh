#!/usr/bin/bash -l
#SBATCH -p batch
#SBATCH -J align_stats
#SBATCH -n 4
#SBATCH -o ../error_reports/align_stats_output.log
#SBATCH -e ../error_reports/align_stats_error.log

# Load samtools if not already loaded
module load samtools/1.9 

# Define directories
INPUT_DIR="../../variant_calling/entire_genome/alignment"
OUTPUT_DIR="../../variant_calling/entire_genome/alignment_stats"
MERGED_REPORT="${OUTPUT_DIR}/alignment_statistics.txt"

# Create output directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Clear the merged report file if it exists
> "$MERGED_REPORT"

# Loop through all sorted BAM files
for bam_file in "$INPUT_DIR"/*.bam; do
    base_name=$(basename "$bam_file" .bam)
    out_file="${OUTPUT_DIR}/${base_name}_flagstat.txt"

    # Generate alignment stats
    samtools flagstat "$bam_file" > "$out_file"

    # Append to merged report with header
    echo "===== $base_name =====" >> "$MERGED_REPORT"
    cat "$out_file" >> "$MERGED_REPORT"
    echo -e "\n" >> "$MERGED_REPORT"
done
