# include
tryCatch({
  library('argparse')
}, error = function(e) {
  cat('You need to install "argparse" package before running this code.')
  quit()
})

tryCatch({
  library('stringr')
}, error = function(e) {
  cat('You need to install "stringr" package before running this code.')
  quit()
})

tryCatch({
  library('jsonlite')
}, error = function(e) {
  cat('You need to install "jsonlite" package before running this code.')
  quit()
})

# functions
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

handle_string <- function(str) {
  str <- iconv(str, to='ASCII')
  
  # all string to lower case
  str <- tolower(str)
  
  # remove word behind ,
  if(grepl(',', str)) {
    index <- str_locate(pattern=',', str)
    str <- substr(str, 1, index-1)
  }
  
  # remove word before oz.)
  if(grepl('oz\\.\\) ', str)) {
    index <- str_locate(pattern='oz\\.\\) ', str)[[2]]
    str <- substr(str, index + 1, str_length(str))
  }
  
  # remove !
  str <- gsub('!', '', str)
  # remove %
  str <- gsub('[0-9]+% ', '', str)
  # remove ()
  str <- gsub(" \\(.+\\)", '', str)
  # remove _&
  str <- gsub(' & ', ' ', str)
  # remove &
  str <- gsub('&', '', str)
  # remove lb.
  str <- gsub('.+ lb\\. ', '', str)
  # remove ounc
  str <- gsub('.+ ounc ', '', str)
  # remove 's
  str <- gsub(".+\\'s ", '', str)
  # remove '
  str <- gsub("'", '', str)
  # replace all dash to dot
  str <- gsub('-', '.', str)
  # replace all blank to dot
  str <- gsub(' ', '.', str)
  
  str <- trim(str)
  str
}

init_parser <- function()
{
  parser <- ArgumentParser(description='Data Preprocessing')
  parser$add_argument('--trainin', type="character", required=TRUE,
                      help='your train.json file')
  parser$add_argument('--testin', type="character", required=TRUE,
                      help='your test.json file')
  parser$add_argument('--trainout', type='character', required=TRUE,
                      help='your output train rdata file')
  parser$add_argument('--testout', type='character', required=TRUE,
                      help='your output test rdata file')
  parser$add_argument('--ingth', type='integer', required=FALSE, default=0, choices=c(0:10),
                      help='your ingredient used times threshold')
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

train_file <- gsub('\\\\', '/', args$trainin)
test_file <- gsub('\\\\', '/', args$testin)
train_out_file <- gsub('\\\\', '/', args$trainout)
test_out_file <- gsub('\\\\', '/', args$testout)

# Preprocess train data
print('Preprocessing train data...')
train_json <- fromJSON(train_file)
all_ids <- c()
all_cuisines <- c()
all_ingredients <- c()
all_ingredient_num <- c()
rows <- dim(train_json)[[1]]

for(i in 1:rows) {
  ingredients <- train_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  all_ids <- c(all_ids, train_json[i,]$id)
  all_cuisines <- c(all_cuisines, train_json[i,]$cuisine)
  all_ingredient_num <- c(all_ingredient_num, ingredients_num)
  for(j in 1:ingredients_num) {
    str <- train_json[i,]$ingredients[[1]][[j]]
    str <- handle_string(str)
    train_json[i,]$ingredients[[1]][[j]] <- str
    all_ingredients <- union(all_ingredients, str)
  }
}

rows <- length(all_ids)
cols <- length(all_ingredients)
ingredient_total <- rep(0, cols)

ingredient_matrix <- matrix(rep(FALSE, rows * cols), nrow=rows, ncol=cols)
for(i in 1:rows) {
  ingredients <- train_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  for(j in 1:ingredients_num) {
    ingredient <- train_json[i,]$ingredients[[1]][[j]]
    index <- which(all_ingredients == ingredient)
    if(length(index) == 1) {
      ingredient_matrix[i, index] <- TRUE
      ingredient_total[[index]] <- ingredient_total[[index]] + 1
    }
  }
}

head_df <- data.frame(id=all_ids, cuisine=all_cuisines, ingredient_num=all_ingredient_num)
ingredient_df <- as.data.frame(ingredient_matrix)
colnames(ingredient_df) <- all_ingredients

keep_cols <- ingredient_total >= args$ingth
ingredient_df <- ingredient_df[keep_cols]
train_df <- cbind(head_df, ingredient_df)
train_df$`7.up` <- NULL
save(train_df, file=train_out_file)



# Preprocess test data
print('Preprocessing test data...')
test_json <- fromJSON(test_file)
all_ids <- c()
rows <- dim(test_json)[[1]]

for(i in 1:rows) {
  ingredients <- test_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  all_ids <- c(all_ids, test_json[i,]$id)
  for(j in 1:ingredients_num) {
    str <- test_json[i,]$ingredients[[1]][[j]]
    str <- handle_string(str)
    test_json[i,]$ingredients[[1]][[j]] <- str
  }
}

cols <- length(all_ingredients)

ingredient_matrix <- matrix(rep(FALSE, rows * cols), nrow=rows, ncol=cols)
for(i in 1:rows) {
  ingredients <- test_json[i,]$ingredients[[1]]
  ingredients_num <- length(ingredients)
  for(j in 1:ingredients_num) {
    ingredient <- test_json[i,]$ingredients[[1]][[j]]
    index <- which(all_ingredients == ingredient)
    if(length(index) == 1) {
      ingredient_matrix[i, index] <- TRUE
    }
  }
}

head_df <- data.frame(id=all_ids)
ingredient_df <- as.data.frame(ingredient_matrix)
colnames(ingredient_df) <- all_ingredients
test_df <- cbind(head_df, ingredient_df)

save(test_df, file=test_out_file)
