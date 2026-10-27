/*
===============================================================================
Script Name : init_database.sql
Description : Initialize the DataWarehouse database and create the Bronze,
              Silver, and Gold schemas.
===============================================================================

Overview:
    1. Drop the existing DataWarehouse database if it exists.
    2. Create a new DataWarehouse database.
    3. Create the Bronze, Silver, and Gold schemas.

Schemas:
    - bronze : Stores raw data ingested from source systems.
    - silver : Stores cleaned and transformed data.
    - gold   : Stores curated data ready for analytics and reporting.

WARNING:
    This script drops the existing DataWarehouse database and all its data
    before recreating it. Use with caution.

===============================================================================
*/

USE master;
GO

-- Drop & Recreate Database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create The Database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create The Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
