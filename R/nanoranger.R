# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

STARCODE='starcode'

#' extract single nucleotide variants from piled up reads
#'
#' @param BC.data.file output of call_mutations.py
#' @param ALT alternative allele (A, C, G, T)
#' @param REF reference allele (A, C, G, T)
#' @param downsample maximum number of reads to process
#' @param FILTER minimum number of reads per cell barcode
#' @returns dataframe with cell barcodes and mutation
#
extract_mutation = function(BC.data.file, ALT, REF, downsample = NA, FILTER = 4) {
  BC.data = data.table::fread(BC.data.file)

  if(!is.na(downsample)) {
    BC.data = BC.data[sample(seq(1,nrow(BC.data)), size = downsample),]
  }

  BC.list = BC.data %>% group_by(bc, umi) %>% summarize(n = n()) %>% filter (n > FILTER)

  # run starcode and identify UMI clusters
  UMIs.collapsed = data.frame()
  for (bc in unique(BC.list$bc)) {
    message(bc)
    filehandle.in = tempfile()
    filehandle.out = tempfile()
    write.table(x=BC.list[which(BC.list$bc == bc), c('umi', 'n')], file = filehandle.in, sep = '\t', row.names = F, quote = F, col.names = F)

    system(paste0(STARCODE, ' -d 3 -i ', filehandle.in, ' -o ', filehandle.out, ' --print-clusters'))
    starcode.output = as.data.frame(read.csv2(filehandle.out, sep = '\t', header = F))
    colnames(starcode.output) = c('umi', 'n', 'umi.non.collapsed')
    starcode.output$bc = bc

    UMIs.collapsed = rbind(UMIs.collapsed, starcode.output)

    unlink(filehandle.in)
    unlink(filehandle.out)
  }

  # for each UMI calculate consensus base
  UMIs.collapsed$consensus = apply(UMIs.collapsed, 1, FUN = function(x) {
    umis = unlist(strsplit(x['umi.non.collapsed'], split = ',')[[1]])
    consensus = names(sort(table(BC.data$base[which(BC.data$bc == x['bc'] & BC.data$umi %in% umis)]), decreasing = T))
    consensus[1]
  })

  # for each BC count ref and alt bases
  results = UMIs.collapsed %>% group_by(bc) %>% summarize(alt = length(which(consensus == ALT)),
                                                          ref = length(which(consensus == REF)))
  results$mutated = ifelse(results$alt / (results$alt + results$ref) > 0.2, 'mutated', 'wildtype')
  results$vaf = results$alt / (results$alt + results$ref)
  results
}


#' extract indels or insertions from
#'
#' @param BC.data.file output of call_mutations.py
#' @param REF reference allele (A, C, G, T)
#' @param downsample maximum number of reads to process
#' @param CONSENSUS number of nucleotides deleted or inserted
#' @param FILTER minimum number of reads per cell barcode
#' @returns dataframe with cell barcodes and insertion/deletion
#
extract_indel = function(BC.data.file, REF, downsample = NA, CONSENSUS = -1, FILTER = 4) {
  BC.data = data.table::fread(BC.data.file)

  if(!is.na(downsample)) {
    BC.data = BC.data[sample(seq(1,nrow(BC.data)), size = downsample),]
  }

  BC.list = BC.data %>% group_by(bc, umi) %>% summarize(n = n()) %>% filter (n > FILTER)

  # run starcode and identify UMI clusters
  UMIs.collapsed = data.frame()
  for (bc in unique(BC.list$bc)) {
    message(bc)
    filehandle.in = tempfile()
    filehandle.out = tempfile()
    write.table(x=BC.list[which(BC.list$bc == bc), c('umi', 'n')], file = filehandle.in, sep = '\t', row.names = F, quote = F, col.names = F)

    system(paste0(STARCODE, ' -d 3 -i ', filehandle.in, ' -o ', filehandle.out, ' --print-clusters'))
    starcode.output = as.data.frame(read.csv2(filehandle.out, sep = '\t', header = F))
    colnames(starcode.output) = c('umi', 'n', 'umi.non.collapsed')
    starcode.output$bc = bc

    UMIs.collapsed = rbind(UMIs.collapsed, starcode.output)

    unlink(filehandle.in)
    unlink(filehandle.out)
  }

  # for each UMI calculate consensus indel
  UMIs.collapsed$consensus = apply(UMIs.collapsed, 1, FUN = function(x) {
    umis = unlist(strsplit(x['umi.non.collapsed'], split = ',')[[1]])
    consensus = names(sort(table(BC.data$indel[which(BC.data$base == REF & BC.data$bc == x['bc'] & BC.data$umi %in% umis)]), decreasing = T))
    consensus[1]
  })

  # for each BC count ref and alt bases
  results = UMIs.collapsed %>% group_by(bc) %>% summarize(alt = length(which(consensus == CONSENSUS)),
                                                          ref = length(which(consensus == 0)))
  results$mutated = ifelse(results$alt / (results$alt + results$ref) > 0.2, 'mutated', 'wildtype')
  results$vaf = results$alt / (results$alt + results$ref)
  results
}
