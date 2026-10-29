/*
===============================================================================
Procedure Name : silver.load_silver
Description    : Clean, standardize, and transform raw CRM and ERP data from
                 the Bronze layer into the Silver layer.
===============================================================================

Overview:
    This stored procedure transforms raw source data stored in the Bronze
    layer into cleaned and standardized data in the Silver layer.

Transformation Steps:
    CRM:
        - Remove duplicate customer records.
        - Trim whitespace and standardize customer attributes.
        - Transform product keys and standardize product categories.
        - Derive product validity end dates.
        - Validate sales dates and standardize sales values.

    ERP:
        - Standardize customer identifiers and demographic information.
        - Validate customer birth dates.
        - Standardize customer location and country names.
        - Load product category and subcategory information.

Monitoring:
    - Display loading progress for each target table.
    - Measure individual table loading durations.
    - Measure total batch execution duration.
    - Catch and display errors using TRY...CATCH.

Source Layer : Bronze
Target Layer : Silver

Target Tables:
    CRM:
        - silver.crm_cust_info
        - silver.crm_prd_info
        - silver.crm_sales_details

    ERP:
        - silver.erp_cust_az12
        - silver.erp_loc_a101
        - silver.erp_px_cat_g1v2

WARNING:
    Target tables are truncated before loading.
    If a loading operation fails, previously truncated data may be lost.
    The TRY...CATCH block reports errors but does not automatically roll back
    changes made by previous operations.

Usage:
    EXEC silver.load_silver;

===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    -- Declare variables for table-level and batch-level execution timing
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @start_batch_time DATETIME,
        @end_batch_time DATETIME;

    BEGIN TRY
        -- Record the start time of the entire Silver loading process
        SET @start_batch_time = GETDATE();

        PRINT '======================================';
        PRINT '-------- LOADING CRM TABLES ----------';
        PRINT '======================================';

        -- Load cleaned and deduplicated CRM customer information
        SET @start_time = GETDATE();

        -- Clear existing customer data
        PRINT '>> TRUNCATE TABLE: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        -- Trim names, standardize marital status and gender,
        -- and retain the latest record for each customer ID
        PRINT '>> INSERTING DATA: silver.crm_cust_info';

        -- [Keep your existing INSERT ... SELECT query here]

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load standardized CRM product information
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        -- Standardize product keys and product lines,
        -- replace missing costs, and derive product validity end dates
        PRINT '>> INSERTING DATA: silver.crm_prd_info';

        -- [Keep your existing INSERT ... SELECT query here]

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load validated CRM sales transaction details
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        -- Validate sales dates and standardize sales amounts and prices
        PRINT '>> INSERTING DATA: silver.crm_sales_details';

        -- [Keep your existing INSERT ... SELECT query here]

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        PRINT '======================================';
        PRINT '-------- LOADING ERP TABLES ----------';
        PRINT '======================================';


        -- Load standardized ERP customer information
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        -- Standardize customer IDs and gender,
        -- and remove future birth dates
        PRINT '>> INSERTING DATA: silver.erp_cust_az12';

        -- [Keep your existing INSERT ... SELECT query here]

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load standardized ERP customer location data
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        -- Standardize customer IDs and country names
        PRINT '>> INSERTING DATA: silver.erp_loc_a101';

        -- [Keep your existing INSERT ... SELECT query here]

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load ERP product category information
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        -- Transfer product category data from the Bronze source
        PRINT '>> INSERTING DATA: silver.erp_px_cat_g1v2';

        -- [Keep your existing INSERT ... SELECT query here]
        -- IMPORTANT: Use bronze.erp_px_cat_g1v2 as the source table.

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Record and display the total batch execution duration
        SET @end_batch_time = GETDATE();

        PRINT '==========================================';
        PRINT 'LOAD SILVER PROCESS DURATION: '
            + CAST(DATEDIFF(SECOND, @start_batch_time, @end_batch_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        -- Display error details when the loading process fails
        PRINT '==========================================';
        PRINT '------------ ERROR FOUND -----------------';
        PRINT '==========================================';

        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR(20));
    END CATCH;
END;
GO

-- Execute the Silver loading procedure
EXEC silver.load_silver;
