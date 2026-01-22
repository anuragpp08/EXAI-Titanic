# explainingtitanic
Demonstration of [ExAI](https://github.com/anuragpp08/ExAI) package. 

A Dash dashboard app that that displays model quality, permutation importances, SHAP values and interactions, and individual trees for sklearn compatible models.

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

<!-- [explainerdashboard.readthedocs.io](http://explainerdashboard.readthedocs.io). -->

Example [notebook](https://github.com/anuragpp08/ExAI/dashboard_examples.ipynb).

EXAI Titanic – Explainable AI Dashboard

An end-to-end Explainable AI (XAI) project that demonstrates classification, regression, and multiclass classification using the Titanic dataset, built with ExplainerDashboard, SHAP, Dash, and Flask, and deployed using Docker on Render.




Project Objective

The goal of this project is not just prediction, but explanation.

Traditional machine learning models act as black boxes. This project focuses on:

Explaining why a prediction was made

Visualizing feature importance

Understanding feature interactions

Making ML decisions transparent and trustworthy





What This Project Explains

The project contains three explainable ML dashboards, each solving a different ML problem:

Classifier Dashboard – Survival Prediction

Problem: Did a passenger survive the Titanic disaster?

Type: Binary Classification

Why explainable?

To understand how age, gender, class, fare, etc. influence survival probability

Helps answer “Why was this passenger predicted to survive?”






Regression Dashboard – Ticket Fare Prediction

Problem: What was the ticket fare paid by a passenger?

Type: Regression

Why explainable?

Shows how each feature increases or decreases the predicted fare

Useful for understanding numeric impact instead of just predictions






Multiclass Dashboard – Embarkation Port Prediction

Problem: From which port did the passenger board the ship?

Type: Multiclass Classification (3 classes)

Why explainable?

Explains why one class was chosen over others

Demonstrates class-wise SHAP explanations and interactions






Tech Stack

Python 3.9

Scikit-learn

ExplainerDashboard

SHAP

Dash & Flask

Docker

Render (Deployment)





Features & Visualizations

Feature importance plots

SHAP value plots

Individual prediction explanations

Partial dependence plots

Feature interaction plots

What-if analysis

Multiple dashboards under one application





Architecture Overview

User → Browser
     → Render (Docker)
     → Gunicorn
     → Flask Server
     → Dash Apps
     → ExplainerDashboard
     → SHAP + ML Models




Challenges Faced (REAL TALK)

This project faced serious real-world engineering challenges:

1. Version Incompatibility Hell

explainerdashboard, shap, dtreeviz, dash, sklearn

Old Heroku examples relied on outdated pinned versions

New environments broke old assumptions


Fix:

Removed serialized explainer .joblib files

Regenerated explainers at runtime

Stopped relying on deprecated APIs





2. Pickle / Joblib Failures

Errors like:

ModuleNotFoundError: numpy._core

code() takes at most 16 arguments

InconsistentVersionWarning


Root cause: Pickled models are NOT portable across versions.

Fix:

No pickling explainers

Train models dynamically at app startup





3. SHAP Shape Errors

AssertionError: shap_values should be 2d, instead shape=(200, 21, 2)

Root cause:

Binary classifiers produce class-wise SHAP outputs

Older dashboard code expected 2D arrays


Fix:

Switched to supported explainer patterns

Avoided deprecated parameters like shap_interaction

Used default ExplainerDashboard behavior





4. Memory & Worker Crashes

Render free tier has limited RAM

SHAP interaction plots are expensive


Fix:

Reduced model complexity

Disabled unnecessary interaction-heavy components

Avoided overloading Gunicorn workers





5. Heroku vs Render Differences

Heroku previously allowed older Python stacks

Render uses modern Linux + stricter dependency resolution


Lesson: “If it runs on Heroku, it doesn’t mean it will run everywhere.”




Final Stable Approach (Option A)

✔ Use current versions
✔ No pickled explainers
✔ Train models inside dashboard.py
✔ Let ExplainerDashboard manage SHAP internally
✔ Dockerize everything

This approach:

Works with modern environments

Avoids fragile serialization

Is production-safe





Docker Setup

Dockerfile

FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["gunicorn", "dashboard:app", "--bind", "0.0.0.0:10000"]




requirements.txt (Important Notes)

Avoid pinning too aggressively

Let pip resolve compatible versions

Do not include Python version here





Live Deployment

Live URL will be available soon.
 
> Still working on deployment.






Key Learnings

Explainability ≠ plug-and-play

Version compatibility matters more than code correctness

Serialization is fragile

Deployment exposes hidden assumptions

Debugging logs is a real engineering skill





Why This Project Matters

This project proves that:

We understood ML

We understood XAI

We understood deployment

We can debug real production failures

We didn’t give up when things broke





Final Note

This project was difficult by nature, not because of lack of skill.
we didn’t copy-paste. We fought the system, understood it, and adapted.

