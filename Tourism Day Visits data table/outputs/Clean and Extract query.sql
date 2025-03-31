CREATE OR REPLACE TABLE `Tourism_Day_Visits_Regional_All_Trips_Data`

AS

WITH

  -- 1. Trip_Data_Scotland: Filter and clean the base trip data for Scotland-related trips.
  Trip_Data_Scotland AS (
    SELECT
      response_id,
      trip_number,
      monthint,
      DV04_OE_a, -- First place visited local authority
      DV04_OE_c, -- First place visited country
      dv07_oe_1_a, -- Second place visited local authority
      dv07_oe_1_c, -- Second place visited country
      dv07_oe_2_a, -- Third place visited local authority
      dv07_oe_2_c, -- Third place visited country
      dv07_oe_3_a, -- Fourth place visited local authority
      dv07_oe_3_c, -- Fourth place visited country
      REPLACE(REPLACE(INITCAP(D_Q003_d), 'Of', 'of'),'And', 'and') AS region_of_residence, -- Clean and capitalize region of residence
      INITCAP(D_Q003_country) AS country_of_residence, -- Clean and capitalize country of residence
      CONCAT(
        UPPER(SUBSTR(d_main_act,1 ,1)),
        LOWER(SUBSTR(d_main_act, 2)))
      AS main_activity, -- Clean and capitalize main activity
      D_Q005_BND AS age_group,
      CASE
        WHEN D_Q005_BND IN('16-24','25-34') AND CAST(D_FD01_total AS FLOAT64) = 0.0 THEN 'Younger Independents'
        WHEN D_Q005_BND IN('16-24','25-34','35-44','45-54','55-64') AND CAST(D_FD01_total AS FLOAT64) > 0.0 THEN 'Families'
        WHEN D_Q005_BND IN('35-44','45-54','55-64') AND CAST(D_FD01_total AS FLOAT64) = 0.0 THEN 'Older Independents'
        WHEN D_Q005_BND IN('65-74','75+') THEN 'Retirement Age'
      END AS lifestage, -- Derive lifestage based on age and family status
      CASE
        WHEN D_DV12_COMB IN ("car - own/friend's/family's/company car","car - hired/rented","motorbike","motor home/campervan") THEN 'Private motor vehicle'
        WHEN D_DV12_COMB IN ("train","tube/underground train","tram") THEN 'Train, underground train, tram'
        WHEN D_DV12_COMB IN ("public bus/coach","organised coach tour","taxi") THEN 'Bus/Coach/taxi'
        WHEN D_DV12_COMB IN ("walked/on foot","bicycle") THEN 'Walk, Bicycle'
        WHEN D_DV12_COMB IN ("plane","boat","canal boat or barge","ship/ferry") THEN 'Water or Air Transport'
        WHEN D_DV12_COMB IN ("lorry/truck/van","other (please specify)","don't know/can't remember") THEN 'Other'
        ELSE 'Unclassified'
      END AS transport_type, -- Derive transport type
      SAFE_CAST(d_weighted_volume_sco_cap AS FLOAT64) AS place_visits, -- Convert place visits to float
      SAFE_CAST(wc_spend_place_1 AS FLOAT64) AS place_spend_1, -- Convert place 1 spend to float
      SAFE_CAST(wc_spend_place_2 AS FLOAT64) AS place_spend_2, -- Convert place 2 spend to float
      SAFE_CAST(wc_spend_place_3 AS FLOAT64) AS place_spend_3, -- Convert place 3 spend to float
      SAFE_CAST(wc_spend_place_4 AS FLOAT64) AS place_spend_4 -- Convert place 4 spend to float
    FROM `Day Visits.csv`
    WHERE d_tdv = 'yes' -- Filter for tourism day visits
      AND (
        DV04_OE_c = 'scotland' OR DV07_oe_1_c = 'scotland' OR DV07_oe_2_c = 'scotland' OR DV07_oe_3_c = 'scotland' -- Filter for trips that visited Scotland
      )
  ),

  -- 2. scot_la_data: Unpivot the place visit data, creating one row per place visited in Scotland.
  scot_la_data AS (
    SELECT
      *
      ,DV04_OE_a AS local_authority
      ,DV04_OE_c AS country
      ,place_spend_1 AS place_spend
    FROM Trip_Data_Scotland
    WHERE DV04_OE_c = 'scotland'
    UNION ALL
    SELECT
      *
      ,dv07_oe_1_a AS local_authority
      ,dv07_oe_1_c AS country
      ,place_spend_2 AS place_spend
    FROM Trip_Data_Scotland
    WHERE DV07_oe_1_c = 'scotland'
    UNION ALL
    SELECT
      *
      ,dv07_oe_2_a AS local_authority
      ,DV07_oe_2_c AS country
      ,place_spend_3 AS place_spend
    FROM Trip_Data_Scotland
    WHERE DV07_oe_2_c = 'scotland'
    UNION ALL
    SELECT
      *
      ,dv07_oe_3_a AS local_authority
      ,DV07_oe_3_c AS country
      ,place_spend_4 AS place_spend
    FROM Trip_Data_Scotland
    WHERE DV07_oe_3_c = 'scotland'
  ),

  -- 3. scot_region_data: Join with the region lookup table to add region names.
  scot_region_data AS (
    SELECT
      response_id
      ,trip_number
      ,monthint
      ,main_activity
      ,region_of_residence
      ,country_of_residence
      ,age_group
      ,lifestage
      ,transport_type
      ,local_authority
      ,ii.vs_region_name AS region
      ,SAFE_CAST(place_visits AS FLOAT64) AS place_visits
      ,SAFE_CAST(place_spend AS FLOAT64) AS place_spend
    FROM scot_la_data i
    LEFT JOIN `vs_region` ii ON i.local_authority = LOWER(ii.local_authority_name)
  ),

  -- 4. scot_region_agg: Aggregate place visits and spend by trip and region.
  scot_region_agg AS (
    SELECT
      response_id,
      trip_number,
      monthint,
      main_activity,
      region_of_residence,
      country_of_residence,
      age_group,
      lifestage,
      transport_type,
      region,
      MAX(place_visits) AS place_visits, -- Max place visits is taken, as they should all be the same for a trip.
      SUM(place_spend) AS place_spend
    FROM scot_region_data
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  )

-- 5. Final SELECT: Summarize the aggregated data by survey year, quarter, and other dimensions.
SELECT
  CAST(SAFE_CAST(LEFT(monthint,4) AS FLOAT64) AS INT64) AS survey_year
  ,CASE
    WHEN CAST(SAFE_CAST(RIGHT(LEFT(monthint,6),2) AS FLOAT64) AS INT64) IN (1,2,3) THEN 'QTR 1'
    WHEN CAST(SAFE_CAST(RIGHT(LEFT(monthint,6),2) AS FLOAT64) AS INT64) IN (4,5,6) THEN 'QTR 2'
    WHEN CAST(SAFE_CAST(RIGHT(LEFT(monthint,6),2) AS FLOAT64) AS INT64) IN (7,8,9) THEN 'QTR 3'
    WHEN CAST(SAFE_CAST(RIGHT(LEFT(monthint,6),2) AS FLOAT64) AS INT64) IN (10,11,12) THEN 'QTR 4'
    ELSE 'Unassigned'
  END AS survey_quarter
  ,DATE(CAST(SAFE_CAST(LEFT(monthint,4) AS FLOAT64) AS INT64) AS INT64),CAST(SAFE_CAST(RIGHT(LEFT(monthint,6),2) AS FLOAT64) AS INT64),1) AS month_start_date,
  region,
  main_activity,
  region_of_residence,
  country_of_residence,
  age_group,
  lifestage,
  transport_type,
  SUM(place_visits) AS place_visits,
  SUM(place_spend) AS place_spend,
  COUNT(*) AS sample -- Count the number of trips in each group.
FROM scot_region_agg
WHERE CAST(SUBSTR(monthint, 1, 4) AS INT64) >= 2022 -- Filter for survey year 2022 or later.
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
ORDER BY 1, 2, 3, 4, 5;
