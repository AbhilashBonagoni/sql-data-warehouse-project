/*
============================================================================================================
Create Database and Schemas
============================================================================================================

Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
	within the database: 'bronze','silver' and 'gold'.


Warning:
	Running this script will drop the entire 'DataWarehouse' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution
	and ensure you have proper backups before running this script.
*/


USE MASTER;
GO

-- Drop and recreate the 'DataWarehouse' database
If Exists (select 1 from sys.databases where name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO;

-- Create Database 'DataWarehouse'

CREATE DATABASE DataWarehouse;

Use DataWarehouse;

-- folder structure

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

