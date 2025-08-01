# Retinoblastoma_Genetics
This repository contains Data, Code, and Results of the Kenyan RB1 variant calling analysis among 70 children with biallelic retinoblastoma.  


The README file has a detailed analysis plan, detailing each step of the analysis pipeline.    

This Repository has two parts:  
    a. Analysis Steps to identify inDELS (Insertions and Deletions), and Single Nucleotide Polymorphism.  
    b. Analysis Steps to identify Copy Number Variations (CNVs)  


### Part 1: SNPS and Indels Analysis

#### **Refer to the 'Scripts' directory above for the code corresponding to each step. Script names match the step names for easier navigation. These scripts were written following the GAT best practises and the analysis tutorial detailed [Here](https://www.melbournebioinformatics.org.au/tutorials/tutorials/variant_calling_gatk1/variant_calling_gatk1/)**

. Step 1 - Quality assessment of Fastq files using FastQC and MultiQC tools

. Step 2 - 

. Step 3 - 

. Step 4 - 

. Step 5 - 

. Step 6 - 

. Step 7 - 

. Step 8 - 

. Step 9 - 

. Step 10 - 



### Part 2 a: Copy Number Variation Analysis  

#### The first step is to calculate Read Coverage and save it to a file for subsequent use

For the Analysis scripts, kindly refer to the scripts directory   

#### Load Required Library, and specify the genome to use

```

library(BSgenome.Hsapiens.UCSC.hg38)
genome <- BSgenome.Hsapiens.UCSC.hg38

```


#### Define Paths - Adjust the file paths accordingly

```

bedFile <- "../../Retinoblastoma_final_analyses/copy_number_variation/bed_file/RB1_exons_hg38_final_27_exons.bed"
bamdir <- "../../Retinoblastoma_final_analyses/copy_number_variation/bam_files"

```

#### List BAM Files and Sample Names

```

bamFile <- list.files(bamdir, pattern = '\\.bam$', full.names = FALSE)
bamPaths <- file.path(bamdir, bamFile)
sampname <- tools::file_path_sans_ext(bamFile)

```

#### Create BAM+BED Object

```

bambedObj <- getbambed(
  bamdir = bamPaths,
  bedFile = bedFile,
  sampname = sampname,
  projectname = "RB1_CNV"
)

bamdir <- bambedObj$bamdir
sampname <- bambedObj$sampname
ref <- bambedObj$ref
projectname <- bambedObj$projectnam

```

#### Get Raw Read Depth


```

coverageObj <- getcoverage(bambedObj, mapqthres = 20)
Y <- coverageObj$Y
write.csv(Y, file = paste0(projectname, "Retinoblastoma_Read_coverage.csv"), quote = FALSE)

```

### Part 2 b: Identify CNV from the Retinoblastoma_Read_coverage file from step 2a above

#### Load the required R packages

```

library(tidyverse)
library(reshape2)
library(pheatmap)
library(ggplot2)

```

#### Load your data

```

df <- read.csv("Retinoblastoma_Read_coverage.csv", row.names = 1)

```

#### Normalize each sample (CPM normalization)


```

df_cpm <- sweep(df, 2, colSums(df), FUN = "/") * 1e6

```

#### Z-score normalization (by row)


```

z_df <- t(apply(df_cpm, 1, scale))
colnames(z_df) <- colnames(df_cpm)
rownames(z_df) <- rownames(df_cpm)

```

#### Convert the normalization output to a data frame

```

z_df <- as.data.frame(z_df)

```

#### Create a Function to call Copy Number Variantss using the Criteria: DEL = z < -2, DUP = z > 2, else NOR

```

call_cnv <- function(z) {
  ifelse(z < -2, "DEL", ifelse(z > 2, "DUP", "NOR"))
}

cnv_calls <- as.data.frame(apply(z_df, c(1, 2), call_cnv))

```

#### Count deletions and duplications per region

```

cnv_summary <- cnv_calls %>%
  mutate(Region = rownames(.)) %>%
  pivot_longer(-Region, names_to = "Sample", values_to = "CNV") %>%
  group_by(Region, CNV) %>%
  summarise(Count = n(), .groups = "drop") %>%
  pivot_wider(names_from = CNV, values_from = Count, values_fill = 0)

```

#### Export CNV calls to a matrix and get a summary


```

write.csv(cnv_calls, "RB1_CNV_calls_full_matrix.csv")
write.csv(cnv_summary, "RB1_CNV_summary_per_region.csv")

```

#### Get the CNV summary per sample

```

cnv_summary_sample <- cnv_calls %>%
  rownames_to_column("Region") %>%
  pivot_longer(-Region, names_to = "Sample", values_to = "CNV") %>%
  group_by(Sample, CNV) %>%
  summarise(Count = n(), .groups = "drop") %>%
  pivot_wider(names_from = CNV, values_from = Count, values_fill = 0)
write.csv(cnv_summary_sample, "RB1_CNV_summary_per_sample.csv")

```

 - -  - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 ### Plotting figures (Results) - Twick the parameters as appropriate to get a better outlook

 #### Plot 1: Heatmap of Z-scores

 ```

pheatmap(z_df,
         cluster_rows = FALSE,
         cluster_cols = TRUE,
         color = colorRampPalette(c("blue", "white", "red"))(100),
         main = "Z-score Heatmap: CNV Detection in RB1",
         filename = "RB1_CNV_Zscore_Heatmap.pdf", # Save as PDF
         width = 10,
         height = 6)

```

#### Plot 2: A plot to Visualize deletions

 ```

plot <- cnv_summary %>%
  mutate(Region = fct_reorder(Region, DEL)) %>%
  ggplot(aes(x = DEL, y = Region)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Deletions per RB1 Region",
       x = "Number of Deletions",
       y = "Genomic Region (Exon)") +
  theme_minimal()

ggsave("RB1_CNV_Deletions_Barplot.pdf", plot = plot, width = 8, height = 6)

```

#### Plot 3: A plot to Visualize Duplications

```

plot_dup <- cnv_summary %>%
  mutate(Region = fct_reorder(Region, DUP)) %>%
  ggplot(aes(x = DUP, y = Region)) +
  geom_bar(stat = "identity", fill = "darkorange") +
  labs(title = "Duplications per RB1 Region",
       x = "Number of Duplications",
       y = "Genomic Region (Exon)") +
  theme_minimal()

ggsave("RB1_CNV_Duplications_Barplot.pdf", plot = plot_dup, width = 8, height = 6)

```
