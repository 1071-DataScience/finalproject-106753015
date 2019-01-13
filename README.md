# Enaak!

![Enaak](/logo.png)

### Groups
* 吳明倫, 106753015
* 柳桓任, 106753040

### Goal
This is a `food style classification` challenge from Kaggle's competition "What's Cooking?".  
We were given two datasets, a training dataset with a lot of recipes with cuisine(food style), and a testing dataset without cuisine.  
We used the `data science` knowledge that we learned from this semester to finish this challenge.  
And of course, we achieved this goal by using R language entirely, though it is `EXTREMELY` new to us!

### demo
You can reproduce some works of our project by using the following command.

1. Set working directory to this project folder first. I believe you know how to do that.

2. Data preprocessing
```R
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --trainout "data/input format/train.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 4 --trainout "data/input format/train_4.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 5 --trainout "data/input format/train_5.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 6 --trainout "data/input format/train_6.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 7 --trainout "data/input format/train_7.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 8 --trainout "data/input format/train_8.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 9 --trainout "data/input format/train_9.Rdata" --testout "data/input format/test.Rdata"
Rscript code/data_preprocessing.R --trainin data/source/train.json --testin data/source/test.json --ingth 10 --trainout "data/input format/train_10.Rdata" --testout "data/input format/test.Rdata"
```

3. Entropy
```R
Rscript code/entropy.R --train "data/input format/train.Rdata" --entropy 3.5 --output data/entropy/drop_e3.5.txt
Rscript code/entropy.R --train "data/input format/train.Rdata" --entropy 3.8 --output data/entropy/drop_e3.8.txt
Rscript code/entropy.R --train "data/input format/train.Rdata" --entropy 4.0 --output data/entropy/drop_e4.0.txt
Rscript code/entropy.R --train "data/input format/train.Rdata" --entropy 4.2 --output data/entropy/drop_e4.2.txt
```

4. Model tuning (No parameter needed, but you need to generate the above files first.)
```R
Rscript code/tune_model.R
```

5. Use best parameters to predict
```R
Rscript code/best_params.R --test "data/input format/test.Rdata" --ingth 5 --entropy 3.8 --resth 30 --output data/submit.csv
```

6. Submit to Kaggle to get your score!

7. Other  
There are some dirty codes we produced during project to achieve some data exploring mission.  
They are really dirty, but they are opened, put under `code/dirty`, read at your own risk :)

## Folder organization and its related information

### docs
#### folder
- references  
Some paper that we refer to during this project.

### data
#### folder
- source  
Training and testing dataset from Kaggle.

- input format  
Type of Dataset from Kaggle is `JSON`, we converted them into `Rdata` after preprocessing.

- entropy  
Ingredients dropped lists that reach our entropy threshold.

- visualization  
Some pictures we created for exploring data more easily.

#### data preprocessing
- Handle ingredient string
  - Remove words after comma
  - Remove words inside parentheses
  - Remove special character (`!`, `&`, `® `, `™`, etc.)
  - Remove unit (`oz.`, `lb.`, etc.)
  - etc.

#### feature selection
- Ingredients amount inside a recipes.
- Ingredients used times in whole dataset.
- Entropy of ingredients used times in each cuisine.

### code
#### folder
- dirty  
Remain codes that we wrote during final project, most of them are dirty T.T

#### modeling
- We use `Naive Bayes` as our classification model algorithm.
- We guess all cuisine as `italian` as null model.
- We use 10-fold cross-validation to perform evaluation

### results

![best result](/results/best.png)

- We use `recall` as metric: right cuisines that our model predicted / all true cuisines.
- We got a great improvement after done well data preprocessing, and got a little good improvement after done well feature selection.
- Challenge
  - It is hard to preprocessing this dataset, because it is not a clean csv but a json file
  - We do a lot of data exploring works, and find out a lot of things that are not the key for data preprocessing
  - Data volume is a little quite huge, we can not run the modeling process on laptop, and take a long time on every try
  - `Hungry every night that we discussed our project`