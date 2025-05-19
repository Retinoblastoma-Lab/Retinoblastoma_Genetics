#!/bin/bash

# Input VCF
VCF="kenya_high_confidence_variants.pass.vcf.gz"

# Output file
OUT="variant_summary_with_samples.tsv"

# Get list of sample names
samples=($(bcftools query -l "$VCF"))

# Add TYPE tag and extract genotypes
bcftools +fill-tags "$VCF" -Ou -- -t TYPE | \
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/TYPE[\t%GT]\n' | \
awk -v OFS="\t" -v sample_list="${samples[*]}" '
BEGIN {
  split(sample_list, sample_arr, " ");
  print "CHROM", "POS", "REF", "ALT", "TYPE", "Het_Count", "HomAlt_Count", "Total_Carriers", "Carrier_Samples";
}
{
  het=0; hom=0; carriers="";
  for (i=6; i<=NF; i++) {
    sample_name = sample_arr[i-5];
    gt = $i;
    if (gt == "0/1" || gt == "1/0") {
      het++;
      carriers = carriers sample_name ","
    } else if (gt == "1/1") {
      hom++;
      carriers = carriers sample_name ","
    }
  }
  # remove trailing comma
  if (carriers != "") sub(/,$/, "", carriers);
  print $1, $2, $3, $4, $5, het, hom, het+hom, carriers;
}
' > "$OUT"

echo "✅ Written to $OUT"

