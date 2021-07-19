-- 1st pull

SQL 

SELECT 
subscriber_id, spot_id, brand_id, creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions, 
count(distinct creative_id) count_creatives,
count(distinct date) played_number_of_days_user_saw
FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (30214) 
AND date BETWEEN '20200101' AND '20201231'
GROUP BY 1,2,3,4,5,6
LIMIT 1000

-- 2nd pull
SELECT 
subscriber_id, spot_id, brand_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct date) played_number_of_days_user_saw
FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (30214) 
AND date BETWEEN '20200101' AND '20201231'
GROUP BY 1,2,3,4,5,6
LIMIT 1000


-- 3rd pull
SELECT 
subscriber_id, spot_id, brand_id, creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct date) played_number_of_days_user_saw,
count(distinct creative_id) number_of_creatives_saw
FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (30214) 
AND date BETWEEN '20200101' AND '20200131'
GROUP BY 1,2,3,4,5

-- 4th pull
SELECT 
subscriber_id, spot_id, brand_id, creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct date) played_number_of_days_user_saw,
count(distinct creative_id) number_of_creatives_saw
FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (30214) 
AND date BETWEEN '20200101' AND '20200131'
GROUP BY 1,2,3,4,5

-- 5th pull
SELECT 
subscriber_id, spot_id, brand_id, creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct subscriber_id) unique_households_reached,
count(distinct date) count_dates_with_spot
FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (30214) 
AND date BETWEEN '20200101' AND '20200131'
GROUP BY 1,2,3,4,5

-- 6th pull 
-- main query
(SELECT provider,
subscriber_id, spot_id, brand_id, -- creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct subscriber_id) unique_households_reached,
count(distinct date) count_dates_with_spot
FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349) 
AND date BETWEEN '20210101' AND '20210131' 
GROUP BY 1,2,3,4,5) 
UNION 
(SELECT provider,
subscriber_id, spot_id, brand_id, -- creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct subscriber_id) unique_households_reached,
count(distinct date) count_dates_with_spot
FROM dev_charter_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349) 
AND date BETWEEN '20210101' AND '20210131' 
GROUP BY 1,2,3,4,5)

-- 7th pull
-- ispot db
SELECT 
brand,
brand_id, 
spot_id, 
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(distinct date) count_dates_with_spot_ispot,
count(distinct network_call_sign) unique_networks_ispot,
count(distinct air_date_time_et) num_spots_ispot
FROM "dev_ncc"."ispot_airings_daily" AS original_table
WHERE brand_id IN (21349) 
AND date BETWEEN '20210101' AND '20210131'
GROUP BY 1,2,3,4,5 

-- 8th Pull
-- main query

(SELECT provider,
subscriber_id, spot_id, brand_id, -- creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct subscriber_id) unique_households_reached,
count(distinct date) count_dates_with_spot
FROM dev_cox_data.log_viewing_ispot_data cox
WHERE valid_ad_record = 'true' AND brand_id IN (21349) 
AND date BETWEEN '20210101' AND '20210131' 
GROUP BY 1,2,3,4,5)

UNION 

(SELECT provider,
subscriber_id, spot_id, brand_id, -- creative_id,
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(*) impressions,
count(distinct subscriber_id) unique_households_reached,
count(distinct date) count_dates_with_spot
FROM dev_charter_data.log_viewing_ispot_data charter
WHERE valid_ad_record = 'true' AND brand_id IN (21349) 
AND date BETWEEN '20210101' AND '20210131' 
GROUP BY 1,2,3,4,5) 

-- 9th pull
-- main query
SELECT cox_data.spot_id, count(*) impressions  
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id 
  FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349) 
AND date BETWEEN '20210101' AND '20210131') AS cox_data
GROUP BY cox_data.spot_id

-- 10th pull
-- main query

SELECT cox_data.brand_id, cox_data.spot_id, cox_data.date, count(*) impressions, 
  	count(distinct cox_data.subscriber_id) unique_households_reached, count(distinct date) count_dates_with_spot
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id, 
  subscriber_id
  	FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349, 20467, 21211, 30389) 
AND date BETWEEN '20210101' AND '20210330') AS cox_data
GROUP BY cox_data.brand_id, cox_data.spot_id, cox_data.date
ORDER BY brand_id

-- 11th pull USER THIS ONE

SELECT cox_data.brand_id, cox_data.spot_id, cox_data.date, count(*) impressions, 
  	count(distinct cox_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id, 
  subscriber_id, , count(distinct date) count_dates_with_spot
  	FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349, 20467, 21211, 30389) 
AND date BETWEEN '20210101' AND '20210330') AS cox_data
GROUP BY cox_data.brand_id, cox_data.spot_id, cox_data.date
ORDER BY brand_id

--- MAIN QUERY

-- ispot db
SELECT 
brand,
brand_id, 
spot_id, 
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(distinct date) count_dates_with_spot_ispot,
count(distinct network_call_sign) unique_networks_ispot,
count(distinct air_date_time_et) num_spots_ispot
FROM "dev_ncc"."ispot_airings_daily" AS original_table
WHERE brand_id IN (21349, 21058, 30257, 20161, 30566, 30763) 
AND date BETWEEN '20200101' AND '20201231'
GROUP BY 1,2,3,4,5 

-- COX & CHARTER
SELECT cox_data.brand_id, cox_data.spot_id, cox_data.date, count(*) impressions, 
  	count(distinct cox_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id, 
  subscriber_id
  	FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349, 21058, 30257, 20161, 30566, 30763) 
AND date BETWEEN '20200101' AND '20200131') AS cox_data
GROUP BY cox_data.brand_id, cox_data.spot_id, cox_data.date
UNION
SELECT charter_data.brand_id, charter_data.spot_id, charter_data.date, count(*) impressions, 
  	count(distinct charter_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id, 
  subscriber_id
  	FROM dev_charter_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349, 21058, 30257, 20161, 30566, 30763) 
AND date BETWEEN '20200101' AND '20200131') AS charter_data
GROUP BY charter_data.brand_id, charter_data.spot_id, charter_data.date
ORDER BY brand_id

-- aggregating cox and charter
SELECT brand_id, spot_id, date, sum(impressions) impressions, sum(unique_households_reached) unique_households_reached
FROM 
(SELECT cox_data.brand_id, cox_data.spot_id, cox_data.date, count(*) impressions, 
  	count(distinct cox_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id, 
  subscriber_id
  	FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349, 21058, 30566, 30484, 20598) 
AND date BETWEEN '20210101' AND '20210330') AS cox_data
GROUP BY cox_data.brand_id, cox_data.spot_id, cox_data.date
UNION
SELECT charter_data.brand_id, charter_data.spot_id, charter_data.date, count(*) impressions, 
  	count(distinct charter_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, spot_id, 
  subscriber_id
  	FROM dev_charter_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND brand_id IN (21349, 21058, 30566, 30484, 20598) 
AND date BETWEEN '20210101' AND '20210330') AS charter_data
GROUP BY charter_data.brand_id, charter_data.spot_id, charter_data.date
ORDER BY brand_id) s
GROUP BY 1,2,3

### NESTED QUERY TIPS ### 
# WITH ispot example AS --> creates temporary table one can call from additional query, will make it faster
# 1) union charter and cox data
# 2) do the aggregation 

### TO DO ### 
# get SIP data (comcast), keep my script the way that it is, dont aggregate within sql but with python
# get unique networks
# get estimate by MVPD
# next things to test, instead of doing it a spot level try it at a brand level

# SQL Pull July 8, 2021

-- COX Data From 1-01-2021 to 3-30-2021
SELECT cox_data.brand_id, cox_data.date, count(*) impressions, 
    count(distinct cox_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, 
  subscriber_id
    FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND date BETWEEN '20210101' AND '20210330') AS cox_data
GROUP BY cox_data.brand_id, cox_data.date

-- CHARTER Data From 1-01-2021 to 3-30-2021
SELECT charter_data.brand_id, charter_data.date, count(*) impressions, 
    count(distinct charter_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, 
  subscriber_id
    FROM dev_charter_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND date BETWEEN '20210101' AND '20210330') AS charter_data
GROUP BY charter_data.brand_id, charter_data.date

-- iSpot Data From 1-01-2021 to 3-30-2021
SELECT 
brand,
brand_id, 
date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date,
'monthly' version,
count(distinct date) count_dates_with_spot_ispot,
count(distinct network_call_sign) unique_networks_ispot,
count(distinct air_date_time_et) num_spots_ispot
FROM "dev_ncc"."ispot_airings_daily" AS original_table
WHERE date BETWEEN '20210101' AND '20210330'
GROUP BY 1,2,3,4 

-- aggregating cox and charter  From 1-01-2021 to 3-30-2021
SELECT brand_id, date, sum(impressions) impressions, sum(unique_households_reached) unique_households_reached
FROM 
(SELECT cox_data.brand_id, cox_data.date, count(*) impressions, 
    count(distinct cox_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version, 
  subscriber_id
    FROM dev_cox_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND date BETWEEN '20210101' AND '20210330') AS cox_data
GROUP BY cox_data.brand_id, cox_data.date
UNION
SELECT charter_data.brand_id, charter_data.date, count(*) impressions, 
    count(distinct charter_data.subscriber_id) unique_households_reached
FROM (
  SELECT brand_id, date_format(date_trunc('month',date_parse(date,'%Y%m%d')), '%Y-%m-%d') date, 'monthly' version,
  subscriber_id
    FROM dev_charter_data.log_viewing_ispot_data
WHERE valid_ad_record = 'true' AND date BETWEEN '20210101' AND '20210330') AS charter_data
GROUP BY charter_data.brand_id, charter_data.date
ORDER BY brand_id) s
GROUP BY 1,2





