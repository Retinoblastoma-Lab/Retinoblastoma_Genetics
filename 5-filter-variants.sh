#!/usr/bin/bash -l
#SBATCH -p batch                                  # Partition to submit to
#SBATCH -J variant_cal                            # Job name
#SBATCH -n 12                                     # Number of CPU cores requested
#SBATCH -o ../error_reports/var_filtering.out       # Standard output log
#SBATCH -e ../error_reports/var_filtering.err       # Standard error log1


#Step 1 - VariantRecalibrator
gatk VariantRecalibrator \
    -V ../output/variant_calling/genotyping/C075_S70_L001.vcf.gz \
    --trust-all-polymorphic \
    -mode SNP \
    --max-gaussians 6 \
    --resource:hapmap,known=false,training=true,truth=true,prior=15 ../reference/hg38_v0_hapmap_3.3.hg38.vcf \
    --resource:omni,known=false,training=true,truth=true,prior=12 ../reference/hg38_v0_1000G_omni2.5.hg38.vcf \
    --resource:1000G,known=false,training=true,truth=false,prior=10 ../reference/hg38/hg38_v0_1000G_phase1.snps.high_confidence.hg38.vcf \
    --resource:dbsnp,known=true,training=false,truth=false,prior=7 ../reference/Homo_sapiens_assembly38.dbsnp138.vcf \
    -an QD -an MQRankSum -an ReadPosRankSum -an FS -an MQ -an SOR -an DP \
    -O ../output/variant_calling/filtered/C075_S70_L001_snps.recal \
    --tranches-file ..output/variant_calling/filtered/C075_S70_L001_snps.tranches

#Step 2 - ApplyVQSR
#gatk ApplyVQSR \
 #   -R ../reference/hg38/Homo_sapiens_assembly38.fasta \
 #   -V ../output/variant_calling/genotyping/C075_S70_L001.vcf.gz \
 #   -O ../output/variant_calling/filtered/C075_S70_L001.vqsr.vcf \
 #   --truth-sensitivity-filter-level 99.0 \
 #   --tranches-file ..output/variant_calling/filtered/C075_S70_L001_snps.tranches \
 #   --recal-file ..output/variant_calling/filtered/C075_S70_L001_snps.recal \
 #   -mode SNP

