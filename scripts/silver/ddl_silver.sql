/*
===============================================================================
Script Name : ddl_silver.sql
Description : Create Silver layer tables for CRM and ERP data.
===============================================================================

Overview:
    This script creates tables in the Silver layer to store data from CRM
    and ERP source systems after the data has been cleaned and transformed.

Tables Created:
    CRM:
        - silver.crm_cust_info
        - silver.crm_prd_info
        - silver.crm_sales_details

    ERP:
        - silver.erp_cust_az12
        - silver.erp_loc_a101
        - silver.erp_px_cat_g1v2

Design Notes:
    - Silver tables contain cleaned and standardized data.
    - The dwh_create_date column records when a row is inserted if no
      explicit value is provided.
    - Existing tables are dropped before being recreated.

WARNING:
    Dropping existing tables permanently removes their data.

===============================================================================
*/


/*
===============================================================================
CRM: CUSTOMER INFORMATION
===============================================================================
Purpose:
    Store cleaned and standardized customer information from the CRM source.
*/
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATETIME,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


/*
===============================================================================
CRM: PRODUCT INFORMATION
===============================================================================
Purpose:
    Store cleaned product details, including product name, cost, product line,
    and product validity dates.
*/
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


/*
===============================================================================
CRM: SALES DETAILS
===============================================================================
Purpose:
    Store cleaned sales transaction data, including customer and product
    references, order dates, sales amounts, quantities, and prices.
*/
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


/*
===============================================================================
ERP: CUSTOMER INFORMATION
===============================================================================
Purpose:
    Store cleaned customer-related information from the ERP source,
    including customer identifiers, birth dates, and gender.
*/
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


/*
===============================================================================
ERP: CUSTOMER LOCATION
===============================================================================
Purpose:
    Store standardized customer location information, including customer
    identifiers and country codes or names.
*/
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101(
    cid NVARCHAR(50),
    cntry NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


/*
===============================================================================
ERP: PRODUCT CATEGORY
===============================================================================
Purpose:
    Store product classification data, including categories, subcategories,
    and maintenance-related information.
*/
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    mainenance NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
