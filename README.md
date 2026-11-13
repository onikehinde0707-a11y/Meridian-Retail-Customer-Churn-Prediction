# Meridian-Retail-Customer-Churn-Prediction
Reducing Customer Churn at Meridian Retail Group
An End-to-End Data Science Investigation
1. Project Overview
This project investigates customer churn at Meridian Retail Group, a retail business operating through online, mobile application and physical store channels.
The aim is to understand why customers stop purchasing, identify patterns associated with churn, predict customers who may be at risk and recommend practical customer-retention strategies.
2. Business Objectives
The project aims to:
Understand customer purchasing behaviour.
Identify customer churn patterns.
Examine customer segments and support-ticket information.
Analyse sales and customer activity.
Build machine-learning models to predict customer churn.
Recommend strategies to improve customer retention.
3. Dataset Description
The project uses five main datasets:
	●	Customers
	●	Orders
	●	Order Items
	●	Products
	●	Support Tickets
The datasets contain customer information, transaction records, product details and customer-support interactions.

4. Tools and Technologies
The following tools and technologies were used:
Python
Pandas and NumPy
Matplotlib and Plotly
Scikit-learn
SQL and SQLite
Excel / Google Sheets
Google Colab
Flask API
5. Project Workflow
The investigation followed these stages:
Business understanding and problem definition.
Data understanding and inspection.
Excel-based data analysis.
SQL data validation and business analysis.
Python programming and data manipulation.
Data cleaning and preparation.
Exploratory Data Analysis (EDA).
Data visualisation.
Machine-learning modelling and evaluation.
Model saving and API development.
6. Machine-Learning Approach
The project explored several classification models:
Logistic Regression
Decision Tree
Random Forest
Gradient Boosting
Multi-Layer Perceptron Neural Network
Random Forest and Gradient Boosting were also tuned using GridSearchCV.
The tuned Gradient Boosting model achieved the following reported test results:
Metric
Result
Accuracy
67.4%
Precision
65.8%
Recall
86.5%
F1-score
74.8%
ROC-AUC
70.9%

These results indicate moderate predictive performance, with relatively strong recall.
7. Model and API Deliverables
The project includes:
Meridian final churn model.pkl – saved machine-learning model.
Meridian churn API.py – API application.
Meridian API Test Evidence.json – API testing evidence.
API tests demonstrated successful predictions for valid inputs and appropriate error responses for missing or invalid inputs.
The API was tested but has not been confirmed as a live production deployment.
8. Key Business Recommendations
Based on the investigation, Meridian Retail Group should:
	●	Identify customers showing signs of reduced purchasing activity.
	●	Introduce targeted retention campaigns.
	●	Improve customer-support response and resolution.
	●	Monitor customer purchasing frequency and recency.
	●	Develop personalised offers for customers at risk of churn.
	●	Regularly evaluate and update the churn prediction model.

9. Limitations
The project has some limitations:
Some customer and transaction information contains missing values.
Different project stages use different churn definitions and observation periods.
The predictive model has moderate performance and requires further validation.
Predictions may contain false positives and false negatives.
The model should support human decision-making rather than replace it.
10. Project Structure
The project is organised into the following folders:
Kehinde Oni's Capstone Project/
│
├── 00 - Project Brief/
├── 01 - Phase 1 Business Understanding/
├── 02 - Phase 2 Data Understanding/
├── 03 - Phase 3 Excel Analysis/
├── 04 - Phase 4 SQL Analysis/
├── 05 - Python Programming (Phases 2–6)/
├── 06 - Phase 6 Data Cleaning/
├── 07 - Phase 7 Exploratory Data Analysis/
├── 08 - Phase 8 Data Visualisation/
├── 09 - Phase 9 Machine Learning/
│   └── 01 - API and Model Deliverables/
├── 10 - Final Business Report/
│
├── README.md
└── requirements.txt
11. How to Run the Project
The Python notebooks can be opened and executed using Google Colab or Jupyter Notebook.
The SQL analysis can be reviewed and executed using a compatible SQLite environment.
The API application requires its Python dependencies and saved model file to be available in the appropriate project directory.
Install the listed Python dependencies using:
pip install -requirements.txt
12. Conclusion
This project demonstrates an end-to-end data science investigation into customer churn, from understanding and preparing retail data to analysing customer behaviour, building predictive models and developing an API for model testing.
The findings provide a foundation for Meridian Retail Group to develop more informed customer-retention strategies.

