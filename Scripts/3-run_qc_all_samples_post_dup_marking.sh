#!/usr/bin/bash -l
#SBATCH -p batch                                    # Partition to submit to
#SBATCH -J run_qc                                   # Job name
#SBATCH -n 8                                        # Number of CPU cores requested
#SBATCH -o ../error_reports/qc_metric_all.out       # Standard output log
#SBATCH -e ../error_reports/qc_metric_all.err       # Standard error log

# Define Picard JAR path
PICARD_JAR="/export/apps/picard/2.8.2/picard.jar"

# Load necessary modules if needed (uncomment if on your cluster)
module load fastqc/0.11.9
module load R/4.3

# Define paths
FASTQ_DIR="/home/emurungi/gitau/Doctorat/RB1_variant_calling/RB_data/trimmed_fastq_data"
BAM_DIR="/var/scratch/global/emurungi/variant_calling/entire_genome/base_quality_recalibration_step_2"
REFERENCE="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/reference/hg38/Homo_sapiens_assembly38.fasta"
OUTPUT_DIR="/home/emurungi/gitau/Doctorat/RB1_variant_calling/entire_genome/output/qc_metrics_all_filtered_samples"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# -------------------
# Step 1: Run FastQC on all fastq.gz files
# -------------------
echo "Running FastQC on all FASTQ files..."

fastqc "$FASTQ_DIR"/*.fastq.gz -o "$OUTPUT_DIR"

echo "FastQC done!"

# -------------------
# Step 2: Run Picard CollectMultipleMetrics on each BAM
# -------------------
echo "Running Picard CollectMultipleMetrics on all BAM files..."

for bam_file in "$BAM_DIR"/*.bqsr.bam; do
    bam_base=$(basename "$bam_file" .bqsr.bam)  # Remove ".bqsr.bam" to get sample name

    echo "Processing BAM: $bam_base"

    java -jar "$PICARD_JAR" CollectMultipleMetrics \
        R="$REFERENCE" \
        I="$bam_file" \
        O="$OUTPUT_DIR/${bam_base}.CollectMultipleMetrics"
done

echo "Picard CollectMultipleMetrics done!"


echo "QC metrics for all samples collected." 

