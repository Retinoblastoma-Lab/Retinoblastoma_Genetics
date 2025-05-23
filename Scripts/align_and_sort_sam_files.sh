#!/usr/bin/bash -l
#SBATCH -p batch                                  # Partition to submit to
#SBATCH -J align_and_sort                         # Job name
#SBATCH -n 12                                      # Number of CPU cores requested
#SBATCH -o ../error_reports/align_and_sort_sam.out    # Standard output log
#SBATCH -e ../error_reports/align_and_sort_sam.err    # Standard error log

# Load modules
module load bwa/0.7.18
module load samtools/1.17

# Define paths
REF="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
OUTPUT_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/aligned_sam"
INPUT_DIR="/home/emurungi/gitau/Doctorat/RB1_variant_calling/RB_data/trimmed_fastq_data"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop over all R1 FASTQ files
for R1 in "$INPUT_DIR"/*_trimmed_R1.fastq.gz; do
    # Get base sample name (e.g., C001_S1)
    SAMPLE=$(basename "$R1" _L001_trimmed_R1.fastq.gz)

    # Construct R2 file path
    R2="$INPUT_DIR/${SAMPLE}_L001_trimmed_R2.fastq.gz"

    # Check if R2 file exists
    if [[ ! -f "$R2" ]]; then
        echo "Missing R2 for $SAMPLE, skipping..."
        continue
    fi

    # Output SAM file
    OUT_SAM="$OUTPUT_DIR/${SAMPLE}.sam"
    OUT_SORTED_SAM="$OUTPUT_DIR/${SAMPLE}.sorted.sam"

    # Define read group
    RG="@RG\tID:${SAMPLE}\tLB:${SAMPLE}\tPL:ILLUMINA\tPM:HISEQ\tSM:${SAMPLE}"

    echo "Aligning and creating SAM file for $SAMPLE..."

    # Align and output SAM file
    bwa mem -t 12 -M -R "$RG" "$REF" "$R1" "$R2" > "$OUT_SAM"

    # Sort the SAM file and output the sorted version
    samtools sort -o "$OUT_SORTED_SAM" "$OUT_SAM"

    # Optionally, remove the unsorted SAM file
    rm "$OUT_SAM"

    echo "Finished processing $SAMPLE."
done 

