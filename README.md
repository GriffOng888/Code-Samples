## Summary of Code Samples

### Data Wrangling 
This code sample involves cleaning and merging two separate data files about total employment by industry within a given U.S. state over time. The end result is a clean dataframe that can be used for further analysis or visualization. 

### Natural Language Processing (NLP)
This code sample parses a sample press release and assigns sentiments to each word using three different libraries (nrc, afinn, and bing). Three plots are produced that provide visualizations of the overall sentiment of the press release according to each library. 

### Plotting and Shiny 
This code sample takes a cleaned dataframe from the NYC Open Data portal. The dataframe includes information on demographic information and home broadband uptake by ZIP code. This script uses the shapefiles in the folder to produce a chloropleth that describes home broadband uptake in each ZIP code across New York City. The "app.R" script takes things one step further and creates an interactive Shiny app that can be used to filter the data and customize the plot. 

### Statistical Analysis
This code sample utilizes a cleaned dataframe from an evaluation of a fictitious rural electrification program in Kenya. The evaluation is intended to measure the treatment effect of the program on annual electricity payments. The first half of the code generates a balance table that measures how comparable the treatment and control groups are on certain observable characteristics. After confirming the randomization in the experiment was successful in creating two similar treatment and control groups, the code goes on to run a simple regression that evaluates the effect of the treatment (participation in the electrification program) on the electricity payments. In this case, the program was predicted to decrease electricity payments in the treatment group by a statistically significant margin as compared to individuals in the control group. 

### Machine Learning
This code sample utilizes a sample dataset from smart health devices that classifies movements into activity patterns (e.g. standing, walking, going up/down stairs, etc.). Here, I trained a random forest model on a portion of the data, and then applied the model to the test set. The final model classified activity patterns in the test set with approximately 92% accuracy. In addition to random forest, I am capable of running KNN (K-nearest neighbors), logistic regressions, decision trees, bagging, boosting, and neural networks in the h2o package. From these models, I can create ROC and AUC curves as well as confusion matrices to determine expected probabilities, costs, and benefits. 
