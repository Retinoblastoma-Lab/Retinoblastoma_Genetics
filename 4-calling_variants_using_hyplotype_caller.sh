#!/usr/bin/bash -l
#SBATCH -p batch      			          # Partition to submit to
#SBATCH -J variant_cal          		  # Job name
#SBATCH -n 12                			  # Number of CPU cores requested
#SBATCH -o ../error_reports/call_var.out       # Standard output log
#SBATCH -e ../error_reports/call_var.err       # Standard error log1



gatk HaplotypeCaller \
    -I ../output/C075_S70_L001.sort.dup.bqsr.bam \
    -R ../reference/hg38/Homo_sapiens_assembly38.fasta \
    -ERC GVCF \
    -L chr13 \
    -O ../output/variant_calling/C075_S70_L001.g.vcf.gz




