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

## 📥 Data Loading Process

The dataset is loaded into a PostgreSQL database running inside a Docker container. The process is fully automated and reproducible.

### 1. Database Initialization

On first startup, Docker initializes a PostgreSQL instance and executes all SQL scripts located in: `/database/init`

These scripts are executed in order:

1. `01_schema.sql`  
   Creates database schemas:
   - `raw`
   - `staging`
   - `marts`
   - `features`

2. `02_raw_tables.sql`  
   Defines raw tables that mirror the original dataset structure.  
   No transformations or constraints are applied at this stage.

3. `03_load_data.sql`  
   Loads CSV files directly into raw tables using PostgreSQL `COPY` for efficient bulk ingestion.

---

### 2. Data Source

All raw data originates from the Olist e-commerce dataset and is mounted into the container at: `/data/raw`
This allows PostgreSQL to access CSV files directly during ingestion.

---

### 3. Loading Mechanism

Data ingestion is performed using PostgreSQL’s `COPY` command:

```sql
COPY raw.orders
FROM '/data/raw/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;
```

This approach ensures fast and efficient bulk loading of large datasets.

---

4. Important Design Principles

- Raw layer is immutable
    - Data is loaded exactly as provided in source files
    - No cleaning or transformations are applied
- No primary keys or constraints in raw tables
    - Ensures ingestion is not blocked by data quality issues
    - Data validation is handled in later layers
- Reproducibility
    - The entire database can be rebuilt from scratch using:

```Bash
docker compose down -v
docker compose up -d
```

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
