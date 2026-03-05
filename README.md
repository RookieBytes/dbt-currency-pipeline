# 💱 End-to-End Currency Data Pipeline
**Airflow | Docker | Azure SQL | dbt Cloud**

## 📖 Project Overview
This project demonstrates a production-ready ETL pipeline that automates the extraction, loading, and transformation of global exchange rate data. It bridges the gap between raw API data and structured business intelligence assets.



## 🛠 Tech Stack
* **Orchestration:** Apache Airflow (Dockerized)
* **Storage:** Azure SQL Database (Cloud)
* **Transformation:** dbt Cloud (Analytics Engineering)
* **Language:** Python (Extraction), T-SQL (Transformation)

## 🏗 Pipeline Architecture
1.  **Extraction:** An Airflow DAG fetches the latest exchange rates from a REST API daily.
2.  **Loading:** Raw data is ingested as JSON objects into a staging table within Azure SQL.
3.  **Transformation (dbt):** * Advanced JSON parsing using T-SQL.
    * Data cleaning and restructuring into a "wide" format for BI consumption.
    * Implementation of custom logic for base currency stability (e.g., EUR-to-EUR).

## 🚀 Key Challenge & Engineering Solution
During implementation, I encountered a significant syntax incompatibility between the **dbt-synapse adapter** and the **standard Azure SQL engine** (specifically regarding `RENAME` operations and `COLUMNSTORE INDEX` creation).

**The Solution:** Instead of using standard dbt materializations, I developed a **custom dbt macro** using `run-operation`. This macro performs incremental `INSERT INTO` operations directly. This workaround bypassed adapter limitations, ensuring a stable and cost-effective production run in a standard Azure SQL environment.

## 📊 Data Model (Output Example)
| currency_date | base_currency | rate_eur | rate_usd | rate_gbp | loaded_at |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 2026-03-05 | EUR | 1.0 | 1.1606 | 0.8717 | 2026-03-05 02:44 |

## ⚙️ Setup & Usage
* **Airflow:** Run via Docker Compose.
* **dbt:** Triggered via `dbt run-operation load_currency_data`.
* **Azure:** Requires a configured SQL Server instance and firewall access for dbt Cloud (US Region).

---
*Developed as a portfolio project showcasing cloud integration and problem-solving in Data Engineering.*
