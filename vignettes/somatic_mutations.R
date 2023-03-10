# examples to read out somatic mutations including insertions/deletions

library(ggplot2)

knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_TP53_1.csv.gz'), cutoff = 20)
ggsave('./vignettes/1002_TP53_kneeplot.png', width = 2.5, height = 2)
knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_U2AF1.csv.gz'), cutoff = 20)
ggsave('./vignettes/1002_U2AF1_kneeplot.png', width = 2.5, height = 2)

TP53 = extract_mutation(BC.data.file = './vignettes/data/1002_pileup_TP53_1.csv.gz', REF = 'G', ALT = 'T', FILTER = 100, downsample = 100000)
U2AF1 = extract_mutation(BC.data.file = './vignettes/data/1002_pileup_U2AF1.csv.gz', REF = 'G', ALT = 'T', FILTER = 50, downsample = 100000)

knee_plot(x = data.table::fread('./vignettes/data/1007_pileup_STAG2.csv.gz'), cutoff = 20)
ggsave('./vignettes/1007_STAG2_kneeplot.png', width = 2.5, height = 2)
extract_indel(BC.data.file = './vignettes/data/1007_pileup_STAG2.csv.gz', REF = 'C', CONSENSUS = -2, FILTER = 20)
