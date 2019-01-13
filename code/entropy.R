# include
tryCatch({
  library('argparse')
}, error = function(e) {
  cat('You need to install "argparse" package before running this code.')
  quit()
})

tryCatch({
  library('DescTools')
}, error = function(e) {
  cat('You need to install "DescTools" package before running this code.')
  quit()
})

# functions
init_parser <- function()
{
  parser <- ArgumentParser(description='Entropy')
  parser$add_argument('--train', type="character", required=TRUE,
                      help='your train Rdata file')
  parser$add_argument('--entropy', type='double', required=TRUE, choices=c('3.5', '3.8', '4.0', '4.2'),
                      help='entropy threshold')
  parser$add_argument('--output', type="character", required=TRUE,
                      help='your entropy output file')
  parser
}

parse_args <- function(parser, args)
{
  tryCatch({
    args <- parser$parse_args(args)
  }, error = function(e) {
    parser$print_help()
    quit()
  })
}


# main
parser <- init_parser()
args <- commandArgs(trailingOnly=TRUE)
args <- parse_args(parser, args)

train_data_file <- gsub('\\\\', '/', args$train)
output_file <- gsub('\\\\', '/', args$output)

# calculate entropy
load(train_data_file)
all_ingredients <- colnames(train_df[-c(1,2,3)])
all_cuisines <- train_df$cuisine
drop_ingredients <- c()
for(i in all_ingredients) {
  all_use_rate <- c()
  for(j in unique(all_cuisines)) {
    total <- length(train_df[train_df$cuisine == j,]$cuisine)
    use_rate <- sum(train_df[train_df$cuisine == j,][[i]])/total
    all_use_rate <- c(all_use_rate, use_rate)
  }
  entropy <- Entropy(all_use_rate)
  if(entropy > args$entropy) {
    print(entropy)
    print(i)
    drop_ingredients <- c(drop_ingredients, i)
  }
}

save(drop_ingredients, file=output_file)