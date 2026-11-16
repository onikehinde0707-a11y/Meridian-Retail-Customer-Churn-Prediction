# Meridian Retail Group: Customer Churn Prediction

1. Project Overview

This project investigates customer churn at Meridian Retail Group, a retail business operating across online, mobile application, and physical store channels.

The aim is to understand customer purchasing behaviour, identify customers who may stop purchasing, and develop a machine-learning solution that can support customer-retention strategies.

The project applies data analysis, SQL, data visualisation and machine learning to investigate customer churn and provide practical business recommendations.

2. Project Objectives

The main objectives are to:

* Investigate customer purchasing behaviour and churn patterns.
* Identify factors associated with customer churn.
* Develop machine-learning models to predict customer churn.
* Compare model performance and identify a suitable model.
* Provide churn predictions and probability scores through a Flask API.
* Recommend strategies to improve customer retention.

3. Dataset Description and Preparation

The project uses five synthetic datasets:

* Customers
* Orders
* Order Items
* Products
* Customer Support Tickets

The supplied capstone data is synthetic and does not represent real customers or transactions.

Data preparation activities included:

* Investigating missing values.
* Checking duplicate records.
* Reviewing invalid values and potential outliers.
* Standardising inconsistent categorical values.
* Preparing date and numerical fields.
* Creating customer-level features for analysis and machine learning.

4. Churn Definition

The SQL churn analysis used a 180-day inactivity threshold at a snapshot date of 1 July 2026. Under this definition, a customer was classified as churned if they had been inactive beyond the 180-day threshold.

The machine-learning workflow used historical customer behaviour to construct predictive features and future purchasing activity to define the target.

The SQL analysis and machine-learning target use their respective observation windows and should not be assumed to have identical definitions.

5. Machine-Learning Models

The project explored five classification models:

1. Logistic Regression
2. Decision Tree
3. Random Forest
4. Gradient Boosting
5. Neural Network (Multi-Layer Perceptron)

Random Forest and Gradient Boosting were tuned using GridSearchCV with five-fold cross-validation.

The recorded best Gradient Boosting parameters were:

* Learning rate: 0.05
* Maximum tree depth: 2
* Minimum samples per leaf: 10
* Number of estimators: 50
* Best cross-validation F1-score: 0.735

6. Model Evaluation

The executed tuned Gradient Boosting evaluation cell in the Phase 9 notebook recorded the following held-out test results:

Metric	Recorded result
Accuracy	0.674 (67.4%)
Precision	0.658 (65.8%)
Recall	0.865 (86.5%)
F1-score	0.748 (74.8%)
ROC-AUC	0.709 (70.9%)

These values were transcribed from the individual tuned Gradient Boosting evaluation and ROC-AUC outputs.

Important evaluation note: The notebook’s later manually populated model-comparison table and some accompanying markdown descriptions contain different metric values. The final comparison should be reconciled by checking the executed model-evaluation cells before these figures are treated as the definitive comparison or used for operational decisions.

The tuned Gradient Boosting model is presented as the selected model in this project draft, subject to confirmation after the comparison is corrected.

7. Important Features

The Random Forest feature-importance output identified the following leading features:

Feature	Recorded importance
Purchase frequency	0.3809
Purchase recency	0.2191
Monetary value	0.1418
Customer age at cutoff	0.0591
Average support-ticket resolution hours	0.0347

The results suggest that purchasing behaviour is particularly informative when predicting churn.

Feature importance describes how much a model relies on a feature. It does not establish that the feature causes customer churn.

8. Project Structure

The GitHub repository is organised into the following main folders and files:

Meridian-Retail-Customer-Churn-Prediction/
│
├── clean data/
│
├── Notebooks/
│   ├── Phase 2–6
│   ├── Phase 7 – Exploratory Data Analysis
│   ├── Phase 8 – Visualisation
│   └── Phase 9 – Machine Learning
│
├── Visualization/
│
├── deployment/
│   ├── Meridian churn API.py
│   ├── Meridian final churn model.pkl
│   └── Meridian API Test Evidence.json
│
├── presentation/
│
├── Meridian retail excel workbook
├── Final report
├── Meridian retail SQL analysis
├── SQL analysis in PDF
├── README.md
└── requirements.txt

The folders contain the project’s cleaned data, analysis notebooks, visualisation outputs and deployment materials. The root directory also contains the supporting report, Excel workbook and SQL analysis.

9. Saved Machine-Learning Model

The saved model file is:

Meridian final churn model.pkl

The model is intended to include the preprocessing steps required to prepare customer information before predictions are generated.

The saved model should be checked against the model-loading path used by the Flask API to ensure both files belong to the same implementation.

10. Flask API

The project includes a Flask API file:

Meridian churn API.py

The documented prediction endpoint is:

POST /predict

The API is intended to accept customer information in JSON format and return:

* A churn prediction.
* The probability of not churning.
* The probability of churning.
* A prediction interpretation.

Example request

The following is an illustrative request. The exact feature names and valid categories must match those expected by the API implementation.

{
  "recency": 30,
  "frequency": 5,
  "monetary": 5000,
  "age_at_cutoff": 35,
  "ticket_count": 2,
  "avg_resolution_hours": 12,
  "avg_satisfaction": 4,
  "gender": "F",
  "membership_tier": "Gold",
  "preferred_channel": "Online",
  "state": "Lagos",
  "referral_source": "Social Media",
  "marketing_opt_in": 1
}

Running the API

Ensure Python, Flask and the machine-learning dependencies used by the project are installed.

From the project directory, navigate into the deployment folder and run:

cd deployment
python "Meridian churn API.py"

The application is documented to start on port 5000.

For local testing, send a POST request to:

http://127.0.0.1:5000/predict

The API should return the prediction and probability scores as JSON.

11. API Testing and Evidence

The project testing summary reports three Flask test-client scenarios:

1. Valid customer information — returned a churn prediction.
2. Missing customer features — returned an HTTP 400 error.
3. Invalid numerical input — returned an HTTP 400 error with an explanatory message.

The reported evidence file is:

Meridian API Test Evidence.json

This file is included in the deployment materials. The API source file, saved model and test-evidence file should be checked together to ensure they correspond to the same implementation.

12. Business Recommendations

Meridian Retail Group should consider the following actions:

* Monitor customers with declining purchase frequency.
* Identify customers who have not purchased recently.
* Develop targeted customer-retention campaigns.
* Improve customer support and complaint resolution.
* Review model performance regularly.
* Evaluate retention-campaign outcomes using customer data.

13. Model Limitations

The model was trained using historical customer data. Changes in customer behaviour, market conditions and business activities may affect future predictions.

Missing information and unequal representation of customer groups may also affect model performance.

The project uses synthetic data, so the findings should not be interpreted as evidence of actual customer behaviour in a real retail business.

The model should be monitored and updated as new customer data becomes available. Predictions should support business decisions rather than replace human judgement.

Model performance should be reviewed on new data before the API is used for business-critical decisions.

14. Conclusion

This project demonstrates how data analysis, SQL, visualisation and machine learning can be applied to investigate and predict customer churn.

The tuned Gradient Boosting evaluation recorded in the notebook provides a basis for identifying customers at risk of churning and supporting more informed customer-retention decisions.

The Flask API is intended to make predictions accessible through a prediction endpoint.

Before operational use, the final model comparison, saved-model/API consistency and API test evidence should be verified.
