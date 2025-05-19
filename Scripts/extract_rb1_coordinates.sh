#!/usr/bin/bash -l
#SBATCH -p batch                                      # Partition to submit to
#SBATCH -J genotype_GVCFs                             # Job name
#SBATCH -n 8                                          # Number of CPU cores requested
#SBATCH -o clean_bam.out                              # Standard output log
#SBATCH -e clean_bam.err                              # Standard error log

# === Define input/output ===
GTF="Homo_sapiens.GRCh38.113.chr.gtf"
OUTPUT_BED="RB1_exons.bed"

# === Extract RB1 exons and write to BED ===
grep -w 'exon' $GTF | grep 'gene_name "RB1"' | \
awk 'BEGIN{OFS="\t"} {
    match($9, /exon_number "([0-9]+)"/, exon);
    match($9, /transcript_id "([^"]+)"/, transcript);
    print "chr"$1, $4-1, $5, "exon"exon[1], 0, $7
}' | sort -k1,1 -k2,2n > "$OUTPUT_BED"

# Filter the exons that are found within the rb1 gene region
wk '$1 == "chr13" && $2 >= 48303750 && $3 <= 48481890' RB1_exons.bed > RB1_exons_filtered.bed