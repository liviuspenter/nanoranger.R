# example to read out somatic mutations

library(ggplot2)

knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_TP53_1.csv.gz'), cutoff = 100)
ggsave('./vignettes/1002_TP53_kneeplot.png', width = 2.5, height = 2)
knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_U2AF1.csv.gz'), cutoff = 50)
ggsave('./vignettes/1002_U2AF1_kneeplot.png', width = 2.5, height = 2)

