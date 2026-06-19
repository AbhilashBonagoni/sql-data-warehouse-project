-- DATA DEFINITION LANGUAGE

/*

============================================================================================================
DDL Script: Create Bronze Tables
============================================================================================================

Script Purpose:
	This script creates tables in the 'bronze' schema, dropping existing tabes
	if they already exist.
	Run this script to re-define the DDL structure of bronze tables
============================================================================================================
*/


IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP table bronze.crm_cust_info;


create table bronze.crm_cust_info (
cst_id int,
cst_key	NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);

IF OBJECT_ID('Bronze.crm_prd_info','U') IS NOT NULL
	DROP table Bronze.crm_prd_info;

CREATE TABLE Bronze.crm_prd_info(
prd_id	int,
prd_key	NVARCHAR(50),
prd_nm	NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt date,
prd_end_dt date
)

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP table bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key	NVARCHAR(50),
sls_cust_id	INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
)

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
	DROP table bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12(
cid	NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50)
)

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP table bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101(
cid	NVARCHAR(50),
cntry NVARCHAR(50)
)

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP table bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2(
id	NVARCHAR(50),
cat	NVARCHAR(50),
subcat	NVARCHAR(50),
maintenance NVARCHAR(50)
)

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
