# Olist Causal Lab

An end-to-end analytics project using SQL, exploratory data analysis, and causal inference techniques to generate decision-oriented insights from the Brazilian e-commerce dataset.

---

## 📌 Project Status

Current phase: Data infrastructure setup + initial exploratory analysis

This project is being developed incrementally with a focus on:
- Reproducible data workflows (PostgreSQL + SQL transformations)
- Hypothesis-driven exploratory data analysis
- Preparation for causal inference and experimentation design

---

## 🎯 Objectives

The goal of this project is to go beyond descriptive analytics and answer:

> What factors causally impact customer satisfaction and operational performance in an e-commerce marketplace?

Specifically:
- Identify drivers of delivery delays
- Estimate the impact of delays on customer satisfaction (review scores)
- Propose data-driven A/B testing strategies

---

## 🗂️ Dataset

- Source: Olist E-commerce Dataset (Brazilian marketplace data)
- Includes:
  - Orders, customers, sellers
  - Order items and payments
  - Reviews
  - Product metadata
  - Geolocation data

---

## 🏗️ Architecture (Current)

The project is structured as a lightweight analytics stack:

```text
data/          → raw CSV files (source of truth)
database/      → schema definitions (PostgreSQL)
sql/           → transformation layers (staging, marts, features)
src/           → ingestion and utility scripts
notebooks/     → SQL-driven exploratory analysis 
```

### Data Modeling Layers

- raw → immutable source tables (loaded from CSV)
- staging → cleaned and typed tables
- marts → business-level tables (e.g., fact_orders)
- features → analysis-ready variables for ML and causal inference

---

## ⚙️ Tech Stack

- PostgreSQL (Dockerized)
- SQL (data modeling and transformations)
- Python (pandas, SQLAlchemy)
- Jupyter Notebooks

---

## 🔄 Current Workflow

1. Load raw CSV data into PostgreSQL (raw schema)
2. Define transformations in SQL (version-controlled)
3. Query structured data from notebooks
4. Perform hypothesis-driven EDA

---

## 🔍 Initial Focus (EDA)

Exploration is centered around:

- Order lifecycle and delivery timelines
- Distribution of review scores
- Relationship between delivery performance and customer satisfaction
- Basic order-level aggregation (via fact_orders)

EDA is structured to support future causal analysis, not just visualization.

---

## 🧪 Next Steps

- Build feature layer (delivery metrics, behavioral variables)
- Define treatment and outcome variables
- Implement causal inference methods:
  - Propensity Score Matching
  - Inverse Probability Weighting
- Validate assumptions and estimate treatment effects
- Translate findings into A/B testing recommendations

---

## ⚠️ Notes

- Transformations are implemented in SQL to ensure reproducibility
- Raw data is not modified; all logic is layered
- The project prioritizes interpretability and decision relevance over model complexity

---

## 🚀 Long-Term Vision

This project aims to simulate a real-world analytics workflow:
- From raw data ingestion
- To structured modeling
- To causal reasoning
- To actionable business decisions
