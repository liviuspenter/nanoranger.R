# example to read out somatic mutations

library(ggplot2)

knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_TP53_1.csv.gz'), cutoff = 100, downsample = 10000)
ggsave('./vignettes/1002_TP53_kneeplot.png', width = 2.5, height = 2)
knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_U2AF1.csv.gz'), cutoff = 50)
ggsave('./vignettes/1002_U2AF1_kneeplot.png', width = 2.5, height = 2)

TP53 = extract_mutation(BC.data.file = './vignettes/data/1002_pileup_TP53_1.csv.gz', REF = 'G', ALT = 'T', FILTER = 100, downsample = 100000)
U2AF1 = extract_mutation(BC.data.file = './vignettes/data/1002_pileup_U2AF1.csv.gz', REF = 'G', ALT = 'T', FILTER = 50, downsample = 100000)
