library(e1071)

best_params <- c(5, '3.8', 30)

k <- 5
m <- '3.8'
p <- 30

load(sprintf('data/train_%d.Rdata', k))
raw_train_df <- train_df
drop_ingredients <- as.vector(read.csv(sprintf('data/txt/drop_e%s.txt', m), header=FALSE)$V1)
print(sprintf('Least ingredient used times: %d, Entropy: %s, Most recipe ingredients num: %d', k, m, p))
train_df <- raw_train_df
train_df <- train_df[(train_df$ingredient_num > 2 & train_df$ingredient_num < p),]
train_df <- train_df[,!(names(train_df) %in% drop_ingredients)]

train_accuracy <- 0
test_accuracy <- 0

set.seed(106289)
rgroup <- sample(1:2, size=nrow(train_df), replace=TRUE, prob=c(1, 0))
train_set <- train_df[rgroup == 1,]
test_set <- train_df[rgroup == 2,]

train_labels <- train_set$cuisine
test_labels <- test_set$cuisine

gc()
model <- naiveBayes(cuisine~., data=train_set[-c(1, 3)])

gc()
train_pred <- predict(model, train_set[-c(1,2,3)])
train_compare <- sum(train_pred == train_labels)
train_accuracy <- 0
train_accuracy <- train_accuracy + (train_compare / length(train_labels))
print(sprintf('train accuracy: %f', train_accuracy))
gc()

test_pred <- predict(model, test_set[-c(1,2,3)])
test_compare <- sum(test_pred == test_labels)
test_accuracy <- 0
test_accuracy <- test_accuracy + (test_compare / length(test_labels))
print(sprintf('test accuracy: %f', test_accuracy))
gc()

load('data/test.Rdata')
test_df <- test_df[,!(names(test_df) %in% drop_ingredients)]
final_pred <- predict(model, test_df[-c(1)])
final_df <- data.frame(id=test_df$id, cuisine=final_pred)
write.table(final_df, 'data/submit.csv', quote=FALSE, sep=',', row.names=FALSE)
