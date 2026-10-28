/*
===============================================================================
Procedure Name : bronze.load_bronze
Description    : Load raw CRM and ERP data into the Bronze layer, while
                 logging loading progress, execution duration, and errors.
===============================================================================

Overview:
    This stored procedure loads raw data from CRM and ERP CSV files into
    the corresponding Bronze layer tables.

Process:
    1. Record the start time of the overall loading batch.
    2. Truncate existing data from each target table.
    3. Bulk insert raw data from the corresponding CSV file.
    4. Log the loading duration for each table.
    5. Log the total batch execution duration.
    6. Catch and report errors if the loading process fails.

Target Tables:
    CRM:
        - bronze.crm_cust_info
        - bronze.crm_prd_info
        - bronze.crm_sales_details

    ERP:
        - bronze.erp_cust_az12
        - bronze.erp_loc_a101
        - bronze.erp_px_cat_g1v2

Error Handling:
    TRY...CATCH captures errors encountered during execution and prints
    the error message and line number.

WARNING:
    Existing table data is truncated before loading.
    Ensure that all source files are accessible before execution.

Usage:
    EXEC bronze.load_bronze;

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    -- Declare variables for table-level and batch-level execution timing
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @start_batch_time DATETIME,
        @end_batch_time DATETIME;

    BEGIN TRY
        -- Record the start time of the entire loading process
        SET @start_batch_time = GETDATE();

        PRINT '======================================';
        PRINT '-------- LOADING CRM TABLES ----------';
        PRINT '======================================';

        -- Load CRM customer information
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> INSERTING DATA: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load CRM product information
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> INSERTING DATA: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load CRM sales transaction details
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> INSERTING DATA: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        PRINT '======================================';
        PRINT '-------- LOADING ERP TABLES ----------';
        PRINT '======================================';


        -- Load ERP customer information
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> INSERTING DATA: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load ERP customer location data
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> INSERTING DATA: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Load ERP product category data
        SET @start_time = GETDATE();

        PRINT '>> TRUNCATE TABLE: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> INSERTING DATA: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'LOAD DURATION: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';


        -- Record and display the total batch execution duration
        SET @end_batch_time = GETDATE();

        PRINT '==========================================';
        PRINT 'LOAD BRONZE PROCESS DURATION: '
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

-- Execute the Bronze loading procedure
EXEC bronze.load_bronze;
