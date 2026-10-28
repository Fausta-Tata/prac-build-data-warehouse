/*
===============================================================================
Script Name : ddl_bronze.sql
Description : Create Bronze layer tables for CRM and ERP source data.
===============================================================================

Overview:
    This script creates tables in the Bronze layer to store raw data
    ingested from CRM and ERP source systems.

Tables Created:
    CRM:
        - bronze.crm_cust_info
        - bronze.crm_prd_info
        - bronze.crm_sales_details

    ERP:
        - bronze.erp_cust_az12
        - bronze.erp_loc_a101
        - bronze.erp_px_cat_g1v2

Notes:
    - Existing tables are dropped before being recreated.
    - The tables store raw source data without transformation.
    - Data types and column structures follow the source data requirements.

WARNING:
    Dropping existing tables will permanently remove their data.

===============================================================================
*/


/*
===============================================================================
CRM: CUSTOMER INFORMATION
===============================================================================
Purpose:
    Store customer demographic and identification data from the CRM source.
*/
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATETIME
);


/*
===============================================================================
CRM: PRODUCT INFORMATION
===============================================================================
Purpose:
    Store product details, including product name, cost, category line,
    and product validity dates.
*/
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);


/*
===============================================================================
CRM: SALES DETAILS
===============================================================================
Purpose:
    Store sales transaction details, including customer, product,
    order dates, sales amount, quantity, and price.
*/
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATETIME,
    sls_ship_dt DATETIME,
    sls_due_dt DATETIME,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);


/*
===============================================================================
ERP: CUSTOMER INFORMATION
===============================================================================
Purpose:
    Store customer-related information from the ERP source, including
    customer identifiers, birth dates, and gender.
*/
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);


/*
===============================================================================
ERP: CUSTOMER LOCATION
===============================================================================
Purpose:
    Store customer location information, including customer identifiers
    and country codes or names.
*/
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101(
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);


/*
===============================================================================
ERP: PRODUCT CATEGORY
===============================================================================
Purpose:
    Store product classification data, including category, subcategory,
    and maintenance-related information.
*/
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    mainenance NVARCHAR(50)
);
