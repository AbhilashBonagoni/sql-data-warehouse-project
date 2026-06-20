/*
=======================================================================================
Stored Procedure: Load Silver Layer(bronze -> Silver)
=======================================================================================

Script Purpose:
  This stored procedure performs the ETL(Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
  Actions performed:
  - Truncates the silver tables before loading data.
  - Inserts transformed and cleaned data from Bronze into Silver tables.

Parameters:
None
This stored procedure does not accept any parameters or return any values.

Usage examples:
  EXEC SILVER.LOAD_SILVER
*/

Create or alter procedure SILVER.LOAD_SILVER as
BEGIN
	DECLARE @batchstarttime DATETIME, @Start_time DATETIME, @end_time DATETIME, @batchendtime DATETIME
BEGIN TRY
	set @batchstarttime = getdate();
		PRINT '=======================================================';
		PRINT 'LOADING THE SILVER LAYER';
		PRINT '=======================================================';
	/*=========================================silver.crm_cust_info====================================================================*/
	set @Start_time = GETDATE();

	PRINT '>> Truncating table: silver.crm_cust_info';
	truncate table silver.crm_cust_info;
	PRINT '>> Inserting Data Into: silver.crm_cust_info';

	insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

	select
	cst_id,
	cst_key,
	trim(cst_firstname),
	trim(cst_lastname),
	case when upper(trim(cst_gndr)) = 'F' then 'Female'
		when upper(trim(cst_gndr)) = 'M' then 'Male'
		else 'N/a' end as cst_gndr,
	case when upper(trim(cst_Marital_status)) = 'M' then 'Married'
		when upper(trim(cst_Marital_status)) = 'S' then 'Single'
		else 'N/a' end as cst_Marital_status,
	cst_create_date
	from (
	select *,
	row_number() over(partition by cst_id order by  cst_create_date desc) as flag_last
	from bronze.crm_cust_info
	) as ranking
	where flag_last = 1;
	set @end_time = GETDATE();
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '>>-----------------------------'


	/*=========================================silver.crm_prd_info====================================================================*/
	set @Start_time = GETDATE();

	PRINT '>> Truncating Table: silver.crm_prd_info';
	Truncate table silver.crm_prd_info;
	PRINT '>> Inserting Data Into: silver.crm_prd_info';

	insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)

	select 
		prd_id,
		Replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id, -- Extract Category ID
			SUBSTRING(prd_key,7,len(prd_key)) as prd_key, -- Extract Product ID
		prd_nm,
		isnull(prd_cost,0) prd_cost,
		case when upper(trim(prd_line)) = 'M' then 'Mountain'
		when upper(trim(prd_line)) = 'R' then 'Road'
		when upper(trim(prd_line)) = 'S' then 'Other Sales'
		when upper(trim(prd_line)) = 'T' then 'Touring'
		else 'n/a' end as prd_line, -- Map product line codes to descriptive values
		prd_start_dt,
		LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt) as prd_end_dt -- Calculate end date as one day before next start date
	from bronze.crm_prd_info;

	set @end_time = GETDATE();
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '>>-----------------------------'
	/*=========================================silver.crm_sales_details====================================================================*/
	set @Start_time = GETDATE();
	PRINT '>> Truncate table: silver.crm_sales_details';
	Truncate table silver.crm_sales_details
	PRINT '>> Inserting data into : silver.crm_sales_details'


	insert silver.crm_sales_details(
	sls_ord_num ,
	sls_prd_key	,
	sls_cust_id	,
	sls_order_dt ,
	sls_ship_dt ,
	sls_due_dt ,
	sls_sales ,
	sls_quantity ,
	sls_price 
	)
	select
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,

	case when sls_order_dt <= 0 or len(sls_order_dt) != 8 then NULL
		else cast(cast(sls_order_dt as varchar) as date) end sls_order_dt,
	case when sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then NULL
		else cast(cast(sls_ship_dt as varchar) as date) end as sls_ship_dt,
	case when sls_due_dt <= 0 or len(sls_due_dt) != 8 then NULL
		else cast(cast(sls_due_dt as varchar) as date) end as sls_due_dt,

	case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price) else sls_sales
		end as sls_sales,

	sls_quantity,

	case when sls_price is null or sls_price <= 0 
		then sls_sales/ nullif(sls_quantity,0) else sls_price end as sls_price
	from bronze.crm_sales_details
	set @end_time = GETDATE();
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '>>-----------------------------'
	/*=========================================silver.erp_cust_az12====================================================================*/
	set @Start_time = GETDATE();
	PRINT '>> Truncate table: silver.erp_cust_az12';
	Truncate table silver.erp_cust_az12
	PRINT '>> Inserting data into : silver.erp_cust_az12'

	insert into silver.erp_cust_az12(
	cid,bdate,gen)
	select 
	case when cid like '%NAS%' then SUBSTRING(cid,4,len(cid)) else cid end as cid,
	case when bdate > getdate() then null
		else bdate end as bdate,
	case when trim(gen) in ('F','Female') then 'Female'
		when trim(gen) in ('M','Male') then 'Male'
		else 'n/a' end as gen
		from bronze.erp_cust_az12
	set @end_time = GETDATE();
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '>>-----------------------------'
	/*=========================================silver.erp_loc_a101====================================================================*/
	set @Start_time = GETDATE();
	PRINT '>> Truncate table: silver.erp_loc_a101';
	Truncate table silver.erp_loc_a101
	PRINT '>> Inserting data into : silver.erp_loc_a101'	
	

	insert into silver.erp_loc_a101(
	cid,
	cntry)
	select replace(cid,'-','') as cid,
	case when trim(cntry) = 'DE' then 'Germany'
		when trim(cntry) in ('US','USA','United states') then 'United States'
		when trim(cntry) = '' or cntry is null then 'n/a'
		else trim(cntry) end as cntry
	from bronze.erp_loc_a101
	set @end_time = GETDATE();
	print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '>>-----------------------------'
	/*=========================================silver.erp_px_cat_g1v2====================================================================*/
	set @Start_time = GETDATE();
	PRINT '>> Truncate table: silver.erp_px_cat_g1v2';
	Truncate table silver.erp_px_cat_g1v2
	PRINT '>> Inserting data into : silver.erp_px_cat_g1v2'	
	
	insert into silver.erp_px_cat_g1v2(
	id,cat,subcat,maintenance)
	select * from bronze.erp_px_cat_g1v2
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
end;
