## 🚀 The Look eCommerce Analytics Project

This dbt (data build tool) project creates a robust, centralized analytical data mart on Google BigQuery using The Look eCommerce dataset.

It implements a modern **Dimensional Model** (Star Schema) focused on Customer Lifetime Value (LTV), Product Profitability, and Sales performance.

### 📊 Project Goals

1.  **Establish a Single Source of Truth (SSOT):** Centralize business logic and metric definitions (LTV, AOV, Gross Profit) to ensure consistent reporting.
2.  **Dimensional Modeling:** Build clean `dim_` (Dimension) and `fct_` (Fact) tables optimized for fast query performance and intuitive consumption in BI tools (e.g., Looker Studio).
3.  **Data Quality:** Implement automated data tests to ensure the integrity and reliability of core business metrics.

---

## 🛠️ Data Stack

| Component                | Tool                       | Purpose                                                                     |
| :----------------------- | :------------------------- | :-------------------------------------------------------------------------- |
| **Data Warehouse**       | Google BigQuery            | Scalable, serverless environment for storing and querying transformed data. |
| **Transformation Layer** | **dbt** (data build tool)  | Orchestrates all SQL transformations and implements governance.             |
| **Raw Data**             | The Look eCommerce Dataset | Source data for users, orders, products, and inventory.                     |
| **Consumption**          | Looker Studio (or similar) | Visualization and dashboarding.                                             |

---

## 📦 Data Model Overview

The project creates three main business-ready tables in the `marts` schema:

| Model           | Type          | Description                                                                       | Granularity                            | Key Metrics                                                 |
| :-------------- | :------------ | :-------------------------------------------------------------------------------- | :------------------------------------- | :---------------------------------------------------------- |
| `dim_customers` | **Dimension** | Customer attributes, demographics, and **Customer Lifetime Value (LTV)** metrics. | One row per customer (`customer_key`). | LTV, Recency (days since last order), Cohort.               |
| `dim_products`  | **Dimension** | Product catalog attributes and **calculated average profitability**.              | One row per product (`product_key`).   | Average Retail Price, Average Cost, Average Gross Margin %. |
| `fct_sales`     | **Fact**      | All sales transactions, linking customers and products.                           | One row per **order line item**.       | Gross Revenue, **Cost of Goods Sold (COGS)**, Gross Profit. |

---

## ⚙️ Running the Project

### Prerequisites

1.  **BigQuery Access:** You must have read access to the raw The Look eCommerce dataset and write access to your target project/dataset.
2.  **dbt CLI:** dbt Core must be installed.
3.  **Packages:** The project uses `dbt-utils` for date macros.

### Setup and Installation

1.  **Clone the Repository:**

    ```bash
    git clone [your-repo-link]
    cd the_look_ecommerce_analytics
    ```

2.  **Configure Profile:**
    Ensure your BigQuery credentials are set up in your `~/.dbt/profiles.yml` file under the profile name specified in `dbt_project.yml` (`profile: google_cloud_analytics`).

3.  **Install Dependencies:**
    This installs the `dbt-utils` package:

    ```bash
    dbt deps
    ```

4.  **Run Transformations:**
    This command will build all models in BigQuery according to the configurations in `dbt_project.yml`.

    ```bash
    dbt run
    ```

5.  **Run Data Quality Tests:**
    Check that all defined tests (not-null, unique, relationships) pass:

    ```bash
    dbt test
    ```

---

## 📁 Project Structure

The project adheres to the standard dbt staging/intermediate/marts structure:

| Folder                     | Purpose                                                                                                                           | Key Models                                                 |
| :------------------------- | :-------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------- |
| `models/staging/the_look/` | **Ingestion & Cleaning.** Selects, renames, and formats columns from raw BigQuery tables. Defines raw `sources` in `sources.yml`. | `stg_users.sql`, `stg_orders.sql`                          |
| `models/intermediate/`     | **Complex Logic.** Aggregates and calculates metrics across multiple staged tables.                                               | `int_customer_order_summary.sql` (Calculates LTV, Recency) |
| `models/marts/`            | **Final BI Layer.** The dimensional model ready for consumption.                                                                  | `dim_customers.sql`, `fct_sales.sql`                       |

---

## 🔍 Key Business Logic & Metrics

### Customer Lifetime Value (LTV)

Calculated in `int_customer_order_summary.sql` and stored in `dim_customers`.

- **`customer_cohort_month`**: Defined as the user's sign-up month (`YYYY-MM`).
- **`days_since_last_order`**: Calculated using the `dbt_utils.date_diff` macro.
- **`customer_status_90_day`**: Classified based on `days_since_last_order` (Active, Dormant, or New).

### Product Profitability

Calculated in `int_product_margin.sql` and stored in `dim_products`.

- **`average_margin_percent`**: Derived from `(retail_price - cost) / retail_price`.

### Gross Profit

Calculated directly in the final sales mart (`fct_sales.sql`).

- **`gross_profit`**: Calculated as `gross_revenue` (from `order_items.sale_price`) minus `cost_of_goods_sold` (from `inventory_items.cost`).
