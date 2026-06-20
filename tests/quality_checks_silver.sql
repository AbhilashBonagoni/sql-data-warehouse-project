/*
===========================================================================
Quality checks
===========================================================================
Script Purpose
	This script performs various quality tasks for data consistency, accuracy,
	and standardisation across the 'silver schema'. It includes checks for:
	-Null or duplicate primary keys
	-Unwanted spaces in string fields
	-Data Standardization and consistency
	-Invalid date ranges and orders
	-Data Consistency between related fields

Usage Notes:
	- Run these checks after data loading silver layer
	- Investigate and resolve any discrepancies found during the checks	
===========================================================================
*/

--=========================================================================
-- Checking 'silver.crm_cust_info'
--=========================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
select
	cst_id,
	count(*)
	from silver.crm_cust_info
	group by cst_id
	having count(*) > 1 or cst_id is null;


-- Check for unwanted spaces
-- Expectation: No Results
SELECT
	cst_key
FROM silver.crm_cust_info
WHERE cst_key != trim(cst_key);

-- Data Standardisation & Consistency

select DISTINCT
	cst_marital_status
	from silver.crm_cust_info;

--=========================================================================
-- Checking 'silver.crm_prd_info'
--=========================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
select
	prd_id,
	count(*)
	from silver.crm_prd_info
	group by prd_id
	having count(*) > 1 or prd_id is null;

-- Check for unwanted spaces
-- Expectation: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != trim(prd_nm);


--Check for Nulls or Negative values in cost
-- Expectation: No Results

select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null;

-- Data Standardisation & Consistency

select DISTINCT
	prd_line
	from silver.crm_prd_info;

--Check for invalid date order(Start date > End date)
-- Expectation: No Results

select *
	from silver.crm_prd_info
	where prd_end_dt < prd_start_dt;

--=========================================================================
-- Checking 'silver.crm_sales_details'
--=========================================================================
--Check for invalid dates
-- Expectation: No Results

select 
Nullif(sls_due_dt,0) as sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <= 0
	or len(sls_due_dt) != 8
	or sls_due_dt > 20250101
	or sls_due_dt < 19000101;

-- Check for Invalid Date Orders(Order Date > Shipping/Due Dates)
-- Expectation: No Results
Select
*
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt
	or sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expecatation: No Results

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales is null
	or sls_quantity is null
	or sls_price is null
	or sls_sales <= 0
	or sls_quantity <= 0
	or sls_price <= 0
order by sls_sales,sls_quantity,sls_price;

--=========================================================================
-- Checking 'silver.erp_cust_az12'
--=========================================================================
--identify out of range dates
-- Expectation: no results

select distinct
	bdate
from silver.erp_cust_az12
where bdate < '1924-01-01'
	or bdate > getdate();


-- Data Standardisation & Consistency

select distinct gen  from silver.erp_cust_az12;

--=========================================================================
-- Checking 'silver.erp_loc_a101'
--=========================================================================
-- Data Standardisation & Consistency
select distinct
CNTRY
FROM silver.erp_loc_a101
order by cntry;

--=========================================================================
-- Checking 'silver.erp_px_cat_g1v2'
--=========================================================================

-- Check for unwanted spaces
-- Expectation: No Results

select *
from silver.erp_px_cat_g1v2
where cat != trim(cat)
	or subcat != trim(subcat)
	or maintenance != trim(maintenance);

-- Data Standardisation & Consistency

select distinct maintenance from silver.erp_px_cat_g1v2
