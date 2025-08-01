# Retinoblastoma_Genetics
This repository contains Data, Code, and Results of the Kenyan RB1 variant calling analysis among 70 children with biallelic retinoblastoma.  


The README file has a detailed analysis plan, detailing each step of the analysis pipeline.    

This Repository has two parts:  
    a. Analysis Steps to identify inDELS (Insertions and Deletions), and Single Nucleotide Polymorphism.  
    b. Analysis Steps to identify Copy Number Variations (CNVs)  


### Part 1: SNPS and Indels Analysis

// ------ Work in Progress to update the page //



### Part 2: Copy Number Variation Analysis  

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
