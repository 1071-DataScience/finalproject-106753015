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

1. Data preprocessing
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```

2. Model tuning
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```

3. Final result
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```

4. Other  
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

#### Data preprocessing
- Handle ingredient string

### code
#### folder
- dirty  
Remain codes that we wrote during final project, most of them are dirty T.T


* Which method do you use?
* What is a null model for comparison?
* How do your perform evaluation? ie. Cross-validation, or extra separated data

### results

* Which metric do you use 
  * precision, recall, R-square
* Is your improvement significant?
* What is the challenge part of your project?
