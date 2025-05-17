#!/usr/bin/bash -l
#SBATCH -p batch                              # Partition to submit to
#SBATCH -J variant_calling                    # Job name
#SBATCH -n 12                                 # Number of CPU cores requested
#SBATCH -o ../error_reports/Apply_bqsr.out        # Standard output log
#SBATCH -e ../error_reports/Apply_bqsr.err        # Standard error log


# step 2: Apply the model to adjust the base quality scores
gatk ApplyBQSR \
    -I ../output/C075_S70_L001.sort.dup.bam \
    -R ../reference/hg38/Homo_sapiens_assembly38.fasta \
    --bqsr-recal-file ../output/recal_data.table \
    -O ../output/C075_S70_L001.sort.dup.bqsr.bam



