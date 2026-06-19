/*
=======================================================================================
Stored Procedure: Load Bronze Layer(Source -> Bronze)
=======================================================================================

Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external csv files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
None
This stored procedure does not aceept any parameters or return any values.

Usage examples:
  EXEC BRONZE.LOAD_BRONZE
*/


CREATE OR ALTER PROCEDURE BRONZE.LOAD_BRONZE AS
BEGIN
	DECLARE @batchstarttime DATETIME, @Start_time DATETIME, @end_time DATETIME, @batchendtime DATETIME 
	BEGIN TRY
		set @batchstarttime = getdate();
		PRINT '=======================================================';
		PRINT 'LOADING THE BRONZE LAYER';
		PRINT '=======================================================';

		PRINT '-------------------------------------------------------';
		PRINT 'LOADING CRM TABLE';
		PRINT '-------------------------------------------------------';
		-- LOAD DATA INTO THE VARIABLES CREATED IN THE TABLE
		-- USE BULK INSERT TO IMPORT ALL THE DATA
		
		set @Start_time = GETDATE();
		--FULL LOAD
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;


		PRINT '>> Inserting Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Abhilash Bonagoni\SQL\Data_Warehouse\bronze.crm_cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>>-----------------------------'

		-----------------------------------------------------------
		set @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Table: bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info
		FROM 'D:\Abhilash Bonagoni\SQL\Data_Warehouse\Bronze.crm_prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
			print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>>-----------------------------'
		-----------------------------------------------------------
		set @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Abhilash Bonagoni\SQL\Data_Warehouse\bronze.crm_sales_details.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
			print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>>-----------------------------'
		----------------------------------------------------------

		PRINT '-------------------------------------------------------';
		PRINT 'LOADING ERP TABLE';
		PRINT '-------------------------------------------------------';
		set @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Abhilash Bonagoni\SQL\Data_Warehouse\bronze.erp_cust_az12.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
			print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>>-----------------------------'

		-----------------------------------------------------------
		set @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Table: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Abhilash Bonagoni\SQL\Data_Warehouse\bronze.erp_loc_a101.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
			print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>>-----------------------------'

		-----------------------------------------------------------
		set @Start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Table: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Abhilash Bonagoni\SQL\Data_Warehouse\bronze.erp_px_cat_g1v2.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = GETDATE();
			print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>>-----------------------------'
		set @batchendtime = getdate();
		print '>> Complete Batch load duration" ' + cast(datediff(second,@batchstarttime,@batchendtime) as nvarchar) + 'seconds';
	END TRY
	BEGIN CATCH
		PRINT '================================================='
		PRINT 'ERROR OCCURED DURING BRONZE LAYER'
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================='
	END CATCH
END;
