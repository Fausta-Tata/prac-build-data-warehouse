/*
===============================================================================
Script Name : load_bronze.sql
Description : Load raw data from CRM and ERP CSV files into Bronze tables.
===============================================================================

Overview:
    This script loads raw data from CSV source files into the Bronze layer
    of the DataWarehouse database.

Loading Strategy:
    1. Truncate existing table data before loading.
    2. Bulk insert records from the corresponding CSV files.
    3. Skip the header row in each CSV file.
    4. Use TABLOCK to optimize bulk loading operations.

Source Systems:
    CRM:
        - cust_info.csv
        - prd_info.csv
        - sales_details.csv

    ERP:
        - cust_az12.csv
        - loc_a101.csv
        - px_cat_g1v2.csv

WARNING:
    TRUNCATE TABLE removes all existing records from the target table.
    Ensure the source files are available and the target tables exist
    before executing this script.

===============================================================================
*/


/*
===============================================================================
CRM: CUSTOMER INFORMATION
===============================================================================
Purpose:
    Load customer data from cust_info.csv into bronze.crm_cust_info.
*/
TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


/*
===============================================================================
CRM: PRODUCT INFORMATION
===============================================================================
Purpose:
    Load product data from prd_info.csv into bronze.crm_prd_info.
*/
TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


/*
===============================================================================
CRM: SALES DETAILS
===============================================================================
Purpose:
    Load sales transaction data from sales_details.csv into
    bronze.crm_sales_details.
*/
TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


/*
===============================================================================
ERP: CUSTOMER INFORMATION
===============================================================================
Purpose:
    Load customer-related data from cust_az12.csv into bronze.erp_cust_az12.
*/
TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


/*
===============================================================================
ERP: CUSTOMER LOCATION
===============================================================================
Purpose:
    Load customer location data from loc_a101.csv into bronze.erp_loc_a101.
*/
TRUNCATE TABLE bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);


/*
===============================================================================
ERP: PRODUCT CATEGORY
===============================================================================
Purpose:
    Load product category data from px_cat_g1v2.csv into
    bronze.erp_px_cat_g1v2.
*/
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
