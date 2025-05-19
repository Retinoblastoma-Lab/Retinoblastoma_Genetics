#!/bin/bash

# Input VCF (bgzipped and indexed)
VCF="kenya_high_confidence_variants.pass.vcf.gz"

# Output file
OUT="all_samples_variant_summary.tsv"

# Add TYPE tag if not present, then query variant info + genotypes
bcftools +fill-tags "$VCF" -Ou -- -t TYPE | \
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/TYPE[\t%GT]\n' | \
awk '
BEGIN {
  OFS="\t";
  print "CHROM", "POS", "REF", "ALT", "TYPE", "Het_Count", "HomAlt_Count", "Total_Variant_Carriers";
}
{
  het=0; hom=0;
  for (i=6; i<=NF; i++) {
    if ($i == "0/1" || $i == "1/0") het++;
    else if ($i == "1/1") hom++;
  }
  print $1, $2, $3, $4, $5, het, hom, het+hom;
}
' > "$OUT"

echo "✅ Summary written to $OUT"

