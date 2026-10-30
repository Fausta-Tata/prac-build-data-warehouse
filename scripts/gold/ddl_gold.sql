/*
===============================================================================
Script Name : ddl_gold.sql
Description : Create Gold layer views for analytical reporting and business
              intelligence.
===============================================================================

Overview:
    This script creates analytical views in the Gold layer by combining
    cleaned and transformed data from the Silver layer.

    The Gold layer follows a dimensional modeling approach, consisting
    of dimension views and a fact view to support analytical queries,
    reporting, and business intelligence.

Views Created:
    Dimension Views:
        - gold.dim_product
        - gold.dim_customer

    Fact View:
        - gold.fact_sales

Data Modeling:
    - Dimension Views provide descriptive business information about
      customers and products.
    - Fact View contains sales transactions and measurable business metrics.
    - Surrogate keys are generated using ROW_NUMBER().
    - LEFT JOINs are used to combine related data while retaining
      records from the primary source tables.

===============================================================================
*/


/*
===============================================================================
DIMENSION: PRODUCT
===============================================================================
Purpose:
    Create a product dimension view containing product details,
    category information, and product attributes.

Source Tables:
    - silver.crm_prd_info
    - silver.erp_px_cat_g1v2

Transformation:
    - Generate a surrogate product key.
    - Combine CRM product information with ERP product categories.
*/
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;

CREATE OR ALTER VIEW gold.dim_product AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY cp.prd_start_dt, cp.prd_key) product_key,
    cp.prd_id product_id,
    cp.prd_key product_number,
    cp.prd_nm product_name,
    cp.cat_id category_id,
    ep.cat category,
    ep.subcat subcategory,
    ep.mainenance,
    cp.prd_cost cost,
    cp.prd_line product_line,
    cp.prd_start_dt start_date
FROM silver.crm_prd_info cp
LEFT JOIN silver.erp_px_cat_g1v2 ep
    ON cp.cat_id = ep.id;
GO


/*
===============================================================================
DIMENSION: CUSTOMER
===============================================================================
Purpose:
    Create a customer dimension view containing customer information,
    demographic attributes, and geographical details.

Source Tables:
    - silver.crm_cust_info
    - silver.erp_cust_az12
    - silver.erp_loc_a101

Transformation:
    - Generate a surrogate customer key.
    - Combine CRM and ERP customer information.
    - Use ERP gender information when CRM gender is unavailable.
    - Include customer country and creation date.
*/
IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer;

CREATE OR ALTER VIEW gold.dim_customer AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY ci.cst_id) customer_key,
    ci.cst_id customer_id,
    ci.cst_key customer_number,
    ci.cst_firstname first_name,
    ci.cst_lastname last_name,
    cl.cntry country,
    ci.cst_marital_status marital_status,
    CASE 
        WHEN ci.cst_gndr = 'n/a' THEN c.gen
        ELSE ci.cst_gndr
    END gender,
    CAST(ci.cst_create_date AS DATE) create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 c
    ON ci.cst_key = c.cid
LEFT JOIN silver.erp_loc_a101 cl
    ON ci.cst_key = cl.cid;
GO


/*
===============================================================================
FACT: SALES
===============================================================================
Purpose:
    Create a sales fact view containing transaction details and measurable
    sales metrics, linked to customer and product dimensions.

Source Tables:
    - silver.crm_sales_details
    - gold.dim_product
    - gold.dim_customer

Transformation:
    - Retrieve product and customer surrogate keys.
    - Connect sales transactions with their corresponding dimensions.
    - Include order dates, shipping dates, sales amounts, quantities,
      and prices.

Measures:
    - sales_amount
    - quantity
    - price
*/
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    cs.sls_ord_num order_number,
    dp.product_key,
    dc.customer_key,
    cs.sls_order_dt order_date,
    cs.sls_ship_dt shipping_date,
    cs.sls_due_dt due_date,
    cs.sls_sales sales_amount,
    cs.sls_quantity quantity,
    cs.sls_price price
FROM silver.crm_sales_details cs
LEFT JOIN gold.dim_product dp
    ON cs.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customer dc
    ON cs.sls_cust_id = dc.customer_id;
GO
