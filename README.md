# EXAI Titanic – Explainable AI Dashboard
Demonstration of [ExAI](https://github.com/anuragpp08/ExAI) package. 

## Overview

EXAI Titanic is an end-to-end Explainable AI (XAI) project built to demonstrate how machine learning predictions can be made transparent, interpretable, and trustworthy.

Instead of treating models as black boxes, this project uses ExAI and SHAP to explain model behavior across classification, regression, and multiclass classification tasks using the Titanic dataset.

The project is fully containerized using Docker and deployed on Render, while addressing real-world challenges such as dependency conflicts, serialization issues, memory limits, and framework deprecations.

## Installation
install with `pip install ExAI`

## Github

[www.github.com/anuragpp08/ExAI](https://github.com/anuragpp08/ExAI)

## graphviz buildpack

In order to enable graphviz on heroku enable the following buildpack:

[https://github.com/weibeld/heroku-buildpack-graphviz.git](https://github.com/weibeld/heroku-buildpack-graphviz.git)

## uninstallng xgboost

dtreeviz comes with a xgboost dependency that takes a lot of space, making Wer slug size >500MB.
To uninstall it, first enable the shell buildpack: https://github.com/niteoweb/heroku-buildpack-shell.git

and then add `pip uninstall -y xgboost` to `.heroku/run.sh` 
## Documentation

<!-- [ExAI.readthedocs.io](http://ExAI.readthedocs.io). -->

Example [notebook](https://github.com/anuragpp08/ExAI/dashboard_examples.ipynb).


## Project Goals

The primary objectives of this project are:
To demonstrate practical Explainable AI techniques
To visualize how features influence model predictions
To compare explainability across different ML problem types
To build a production-ready ML dashboard
To handle real deployment and compatibility challenges





## Machine Learning Problems Covered

### 1. Binary Classification – Survival Prediction

#### Problem
- Predict whether a passenger survived the Titanic disaster.
- Model Type
- Binary Classification (RandomForestClassifier)
- Why Explainability Matters
- Understand why a passenger was predicted to survive or not
- Identify the influence of features like age, sex, passenger class, and fare
- Improve trust in predictions by exposing decision logic





### 2.Regression – Ticket Fare Prediction

#### Problem
- Predict the ticket fare paid by a passenger.
- odel Type
- Regression (RandomForestRegressor)
- Why Explainability Matters
- Quantify how each feature increases or decreases fare prediction
- Understand numeric contribution instead of only final output
- Analyze relationships between socio-economic features and pricing





### 3. Multiclass Classification – Embarkation Port Prediction

#### Problem
- Predict the port from which a passenger boarded the ship.
- Model Type
- Why Explainability Matters
- Explain why one class is chosen over others
- Visualize class-wise feature importance
- Demonstrate SHAP explanations for multiclass outputs





## Key Features

- Feature importance plots
- SHAP value visualizations
- Individual prediction explanations
- Partial dependence plots
- Feature interaction plots
- What-if analysis
- Multiple dashboards served from a single application





## Technology Stack

- Python 3.9
- Scikit-learn
- ExAI
- SHAP
- Dash
- Flask- 
- DockerRender (Deployment)





## Application Architecture
```python
User Browser
   ↓
Render (Docker Container)
   ↓
Gunicorn
   ↓
Flask Server
   ↓
Dash Applications
   ↓
ExAI
   ↓
SHAP + Machine Learning Models
```



## Deployment Strategy

- Application is containerized using Docker
- Models are trained dynamically at runtime
- No serialized explainers are stored
- Gunicorn-  is used as the WSGI server
- Render handles container deployment and hosting





## Challenges Faced and Solutions

### 1. Dependency and Version Conflicts

#### Issue
- Incompatibility between ExAI, shap, dtreeviz, dash, and sklearn
- Older examples relied on deprecated APIs

#### Solution
- Avoided aggressive version pinning
- Removed deprecated parameters
- Used supported APIs only
- Let pip resolve compatible versions





### 2. Pickle and Joblib Serialization Failures

#### Issue

Errors such as:
ModuleNotFoundError: numpy._core
code() takes at most 16 arguments
Inconsistent scikit-learn version warnings

### Root Cause
Pickled models are not portable across environments

#### Solution
Removed all serialized explainer files
Rebuilt models and explainers dynamically at application startup


### 3. SHAP Output Shape Errors

#### Issue

- AssertionError: shap_values should be 2d, instead shape=(n, features, classes)
- Root Cause
- Binary and multiclass classifiers return class-wise SHAP values
- Older dashboard logic assumed 2D arrays

#### Solution

- Used supported ExAI defaults
- Avoided unsupported SHAP interaction overrides
- Let the framework handle SHAP internally


### 4. Memory and Worker Crashes

#### Issue
- Render free tier has limited RAM
- SHAP interaction plots are memory intensive

#### Solution

- Reduced model complexity
- Disabled unnecessary interaction-heavy components
- Avoided pre-computing expensive SHAP values







# Docker Configuration

## Dockerfile
```Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["gunicorn", "dashboard:app", "--bind", "0.0.0.0:10000"]

```


## Live Deployment

> Live URL will be available soon.




## Key Learnings

Explainable AI requires careful handling of model internals
Serialization is fragile across environments
Dependency management is a critical engineering skill
Deployment exposes hidden assumptions in ML projects
Debugging production failures is part of real-world ML engineering

## Conclusion

This project demonstrates not only machine learning and explainability concepts, but also real-world problem solving involving deployment, compatibility, and system design.
It reflects a complete journey from experimentation to production, highlighting both technical depth and engineering resilience.
