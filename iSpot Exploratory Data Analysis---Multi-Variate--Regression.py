# Author: Artemas Wang

# importing libraries
import numpy as np
import pandas as pd
import matplotlib.pylab as plt
import seaborn as sns
import sklearn
import statsmodels.api as sm
from sklearn.preprocessing import MinMaxScaler
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("--files", dest="files", required = True, help="Folder where static files are at")
#parser.add_argument("--mvpd", dest="files", required = True, help="Folder where static files are at")
parser.add_argument("--count_of_days", dest="count_of_days", required = True, help="Type in number for count of days")
parser.add_argument("--unique_networks", dest="unique_networks", required = True, help="Type in number for unique networks")
parser.add_argument("--number_spots", dest="number_spots", required = True, help="Type in number for number of spots")

args = parser.parse_args()

files = getattr(args,'files')


all_files = [c for c in os.listdir(files) if (c.lower().find('~$')==-1) & (c.lower().find('ds_store')==-1) & (c.lower().find('csv')!=-1)]
if len(files)>0:
	cox_files = [c for c in files if (c.lower().find('ds_store')==-1) & (c.lower().find('cox')!=-1) & (c.lower().find('ispot')==-1)]
	comcast_files = [c for c in files if (c.lower().find('ds_store')==-1) & (c.lower().find('comcast')!=-1) & (c.lower().find('ispot')==-1)]
    charter_files = [c for c in files if (c.lower().find('ds_store')==-1) & (c.lower().find('charter')!=-1) & (c.lower().find('ispot')==-1)]
    all_mvpds = [c for c in files if (c.lower().find('ds_store')==-1) & (c.lower().find('all_mvpds')!=-1) & (c.lower().find('ispot')==-1)]
else:
	comcast_path = 'files/comcast'
    charter_path = 'files/charter'
    cox_path = 'files/cox'
    #create file lists
    comcast_files = [c for c in os.listdir(comcast_path) if (c.lower().find('ds_store')==-1)]
    charter_files = [c for c in os.listdir(charter_path) if (c.lower().find('ds_store')==-1)]
    cox_files = [c for c in os.listdir(cox_path) if (c.lower().find('ds_store')==-1)]



# importing data
#cox_charter = pd.read_csv('cox charter combined q1.csv') 
#ispot_data = pd.read_csv('ispot data Q1-2021.csv') 

# fixing date formats if needed
#ispot_data['date'] = pd.to_datetime(ispot_data['date'], format= '%m/%d/%y')
#cox_charter['date'] = pd.to_datetime(cox_charter['date'], format= '%m/%d/%y')

# merging datasets
merged_df = pd.merge(cox_charter, ispot_data, how='inner', left_on=['brand_id','date'], right_on=['brand_id','date'])
merged_df['frequency'] = merged_df['impressions']/merged_df['unique_households_reached']
merged_df['frequency'] = merged_df['frequency'].round(2)
merged_df.head()


# exporting merged data for qc/checks
merged_df.to_csv('file_name.csv', index = False)

# checking for linearity, number of spots and impressions
plt.scatter(merged_df['num_spots_ispot'], merged_df['impressions'], color='red')
# checking for linearity, unique networks and households reached
plt.scatter(merged_df['num_spots_ispot'], merged_df['unique_households_reached'], color='red')
# checking for linearity, impressions and unique networks
plt.scatter(merged_df['unique_networks_ispot'], merged_df['impressions'], color='green')
# checking for linearity, unique networks and households reached
plt.scatter(merged_df['unique_networks_ispot'], merged_df['unique_households_reached'], color='green')
# checking for linearity, count dates with spot and impressions
plt.scatter(merged_df['count_dates_with_spot_ispot'], merged_df['impressions'], color='blue')
# checking for linearity, count dates with spot and impressions  
plt.scatter(merged_df['count_dates_with_spot_ispot'], merged_df['unique_households_reached'], color='blue')

## PREDICTING IMPRESSIONS ##

# H0 - There exists no relationship between Impressions and Unique Networks and Number of Spots.

# Multiple Linear Regression, will use IVs, unique_networks and num_spots because of the following reasons:
# 1) according to plots above, most linear relationship
# 2) multicollinearity betweeen num_spots and count_dates_with spot, they have a relationship with one another
x = merged_df[['unique_networks_ispot','num_spots_ispot']] # selecting independent variables
y = merged_df[['impressions']] # selecting dependent variable
z = merged_df[['impressions','num_spots_ispot']]
# Splitting Data in train and test data
from sklearn.model_selection import train_test_split
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.25, random_state = 0)

# Training the Multiple Linear Regeression model on the training set
from sklearn import linear_model
regressor = linear_model.LinearRegression()
regressor.fit(x_train, y_train)

# Printing intercept and coeffients
print('Intercept: \n', regressor.intercept_)
print('Coefficients: \n', regressor.coef_)

# Predicting Impressions based on inputs: Unique Networks and Number of Spots
predicted_outcome = regressor.predict([[10,1000]]) 

# Printing the predicted Impressions
predicted_outcome = np.around(predicted_outcome)
predicted_outcome = predicted_outcome.astype(int)
print('\nPredicted IMPRESSIONS based on Unique Networks and Number of Spots:')
print(predicted_outcome) 

# Predicting test set, run y_pred for list
y_pred = regressor.predict(x_test)
y_pred = np.around(y_pred)
y_pred = y_pred.astype(int)

# Descriptive Statistics of Model t-statistic and p-values
x = sm.add_constant(x)
model = sm.OLS(y,x)
results = model.fit()
#results.params
#results.tvalues
results.summary()

# Checking scores on our train and y test 90%
print(regressor.score(x_test, y_test))
print(regressor.score(x_train, y_train))

# Lasso Regression
lasso_reg = linear_model.Lasso(alpha=100, max_iter=200, tol=0.1)
lasso_reg.fit(x_train, y_train)

print(lasso_reg.score(x_test, y_test))
print(lasso_reg.score(x_train, y_train))

# Ridge Regression
from sklearn.linear_model import Ridge
ridge_reg = Ridge(alpha=100, max_iter=200, tol=0.1)
ridge_reg.fit(x_train, y_train)

print(ridge_reg.score(x_test, y_test))
print(ridge_reg.score(x_train, y_train))

## PREDICTING REACH ##

# H0 - There exists no relationship between Reach and Unique Networks and Number of Spots.

# Multiple Linear Regression, will use IVs, unique_networks and num_spots because of the following reasons:
# 1) according to plots above, most linear relationship
# 2) multicollinearity betweeen num_spots and count_dates_with spot, they have a relationship with one another
x1 = merged_df[['unique_networks_ispot','num_spots_ispot']] # selecting independent variables
y1 = merged_df[['unique_households_reached']] # selecting dependent variable

# Splitting Data in train and test data
from sklearn.model_selection import train_test_split
x1_train, x1_test, y1_train, y1_test = train_test_split(x1, y1, test_size = 0.25, random_state = 0)

# Training the Multiple Linear Regeression model on the training set
from sklearn import linear_model
regressor1 = linear_model.LinearRegression()
regressor1.fit(x1_train, y1_train)

# Printing Intercept and Coefficients
print('Intercept: \n', regressor1.intercept_)
print('Coefficients: \n', regressor1.coef_)

# Predicting Reach based on inputs: Unique Networks and Number of Spots
predicted_outcome1 = regressor1.predict([[35, 1500]]) 

# Printing the predicted Reach
predicted_outcome1 = np.around(predicted_outcome1)
predicted_outcome1 = predicted_outcome1.astype(int)
print('\nPredicted REACH based on Unique Networks and Number of Spots:')
print(predicted_outcome1) # prints predicted impressions and/or unique households reached

# Descriptive Statistics of Model t-statistic and p-values
x1 = sm.add_constant(x1)
model1 = sm.OLS(y1,x1)
results1 = model.fit()
#results1.params
#results1.tvalues
results1.summary()

print('\nPredicted IMPRESSIONS, REACH, and FREQUENCY based on Unique Networks and Number of Spots:\n')
print('Impressions:')
print(predicted_outcome)
print('Reach:')
print(predicted_outcome1)
print('Frequency:')
(predicted_outcome/predicted_outcome1)