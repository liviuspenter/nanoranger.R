# Using nanoranger.R

## Single nucleotide variants

After processing the long-read data with nanoranger and performing the pileup of reads (perform_pileup.py) 
aligning with the locus of interest, the R package will be used for the actual variant calling. To do see we need to identify
a cut-off that will be used to identify cell barcodes that likely represent high-quality events in the
targeted sequencing library. 

In general, the higher the cut-off, the more stringent low-quality cells represented by chimeric reads will be excluded.  

`knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_TP53_1.csv.gz'), cutoff = 100)`<br>
`knee_plot(x = data.table::fread('./vignettes/data/1002_pileup_U2AF1.csv.gz'), cutoff = 50)`

<img src="1002_TP53_kneeplot.png"  width="250" height="200"> <img src="1002_U2AF1_kneeplot.png"  width="250" height="200">

After having identified a cut-off, the actual variant calling can be performed. By using the `downsample = ...` parameter,
we can speed things up for illustration purposes (in that case, the cut-off should also be changed). 

`TP53 = extract_mutation(BC.data.file = './vignettes/data/1002_pileup_TP53_1.csv.gz', REF = 'G', ALT = 'T', FILTER = 100, downsample = 100000)`

`U2AF1 = extract_mutation(BC.data.file = './vignettes/data/1002_pileup_U2AF1.csv.gz', REF = 'G', ALT = 'T', FILTER = 50, downsample = 100000)`
