# examples to read out fusions and isoforms

library(dplyr)
library(ggplot2)

CAR.ONT = extract_fusion_gene('./vignettes/data/97_6_CART_CD28.csv.gz', WILDTYPE = 'CD28', FUSION = 'CARTmod')

knee_plot(data.table::fread('./vignettes/data/1007_1_exons.csv.gz') %>% filter(gene == 'PTPRC' & exon == 'exon4'), cutoff = 10)
ggsave('./vignettes/1007_PTPRC_exon4_kneeplot.png', width = 2.5, height = 2)
PTPRC.1 = extract_isoforms('./vignettes/data/1007_1_exons.csv.gz', GENE = 'PTPRC', EXON = 'exon4', filter = 10)
