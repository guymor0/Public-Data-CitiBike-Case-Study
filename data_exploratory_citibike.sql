/*
citibike_stations
=================

Validate that each station has a unique name.

Validate that each name has a unique station id

Validate that each short_name has a unique name

Regarding numeric values
latitude	longitude
------------------------------
Validate the distributions. the range of the values make resonable
Explore Max / Min

Ditributions on the other attributes
Search for outliers and ranges.
Do it only you plan to use these fields


citibike_trips
=================
tripduration -
Validate the distributions. the range of the values make resonable
Explore Max / Min


starttime	stoptime
Make sure that starttime < 	stoptime
distribution

dates distribution

start_station_id end_station_id
make sure these id exists in the stations table

bikeid
How many uniques

usertype	birth_year	gender -
Validate the distributions. the range of the values make resonable
Explore Max / Min


*/


-- Validate that each station_id has a unique name and short_name.

SELECT
  station_id,
  COUNT(DISTINCT name) AS t_names_for_station,
  COUNT(DISTINCT short_name) AS t_short_names_for_station
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  station_id
ORDER BY
  2 DESC,
  3 DESC
LIMIT
  10;

/*
It appears that each station_id has both a unique name and a unique short_name.

Row   | station_id                               | t_names_for_station | t_short_names_for_station
------------------------------------------------------------------------------------------------
1     | 55a4dc76-d839-4e06-9bf4-2f343391343c     | 1                   | 1
2     | 2126622241630343402                      | 1                   | 1
3     | 1905837242740508940                      | 1                   | 1
*/


 -- Validate that each name has a unique station id

SELECT
  name,
  COUNT(DISTINCT station_id) AS t_stations_id_for_name
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  name
ORDER BY
  2 DESC
LIMIT
  10;

/*
There are 2 station names that share the same station_id.

Row   | Name                   | t_stations_for_name
-----------------------------------------------------
1     | Clinton St & Grand St  | 2
2     | W 42 St & 6 Ave        | 2
3     | W 35 St & Dyer Ave     | 1
*/

 -- Validate that each name has a unique station id (another option)

SELECT
  t_stations_id_for_name,
  COUNT(1) AS number_of_stations_id
FROM (
  SELECT
    name,
    COUNT(DISTINCT station_id) AS t_stations_id_for_name
  FROM
    `bigquery-public-data.new_york_citibike.citibike_stations`
  GROUP BY
    name )
GROUP BY
  1
ORDER BY
  1 DESC;

/*
Most station names are unique, except for 2 names that are shared by 2 different stations id.

Row   | t_stations_id_for_name | number_of_stations_id
------------------------------------------------
1     | 2                      | 2
2     | 1                      | 2302
*/



-- Validate that each short_name has a unique name

SELECT
  short_name,
  COUNT(DISTINCT name) AS t_names_for_short_name
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  10;

/*
It appears that each short_name has a unique name.

Row   | short_name | t_names_for_short_name
--------------------------------------------
1     | 5074.08    | 1
2     | 2578.17    | 1
3     | 6789.20    | 1
*/


/*
Regarding numeric values
latitude  longitude
------------------------------
Validate the distributions. the range of the values make resonable
Explore Max / Min
*/

SELECT
  MIN(latitude) AS min_lat,
  MIN(longitude) AS min_lon,
  MAX(latitude) AS max_lat,
  MAX(longitude) AS max_lon
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`;

/*
The station coordinates are within the expected geographical range for New York City.

Row   | min_lat  | min_lon   | max_lat  | max_lon
--------------------------------------------------
1     | 40.61124 | -74.09368 | 40.88630 | -73.84672
*/


-- Ditribution on region_id

SELECT
  region_id,
  COUNT(1) AS cnt
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  1
ORDER BY
  2 DESC;

/*
Validation check:
Counts how many rows belong to each region_id.

Row   | region_id | cnt
--------------------------------
1     | 71        | 2203
2     | 70        | 65
3     | 311       | 28
4     | 0         | 10

Observation:
Most rows are concentrated in region_id = 71.
region_id = 0 contains 10 rows that do not have an assigned region,
which may indicate missing or incomplete data entries.
*/


-- Ditribution on rental_methods

SELECT
  rental_methods,
  COUNT(1) AS cnt
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  1
ORDER BY
  2 DESC;

/*
Row   | rental_methods  | cnt
------------------------------
1     | KEY, CREDITCARD | 2306

All stations have the same rental method – not relevant for analysis.
*/


-- Ditribution on capacity

SELECT
  capacity,
  COUNT(1) AS cnt
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  1
ORDER BY
  2 DESC;

-- Search for outliers

SELECT
  MIN(capacity) AS min_capacity,
  MAX(capacity) AS max_capacity
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`;

/*
Row   | min_capacity | max_capacity
-----------------------------------
1     | 0            | 123         

Observation:
One or more stations have a capacity of 0 — likely invalid or inactive.
The maximum capacity (123) seems reasonable for large stations.
*/


-- More Ditributions:

SELECT
is_installed,
-- is_renting,
-- is_returning,  
-- eightd_has_available_keys,
  COUNT(1) AS cnt
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  1
ORDER BY
  2 DESC;


-- Ditribution on is_installed

/*
Row   | is_installed | cnt
---------------------------
1     | true         | 2226
2     | false        | 80
*/


-- Ditribution on is_renting
/*
Row   | is_renting | cnt
-------------------------
1     | true       | 2194
2     | false      | 112
*/


-- Ditribution on is_returning

/*
Row   | is_returning | cnt
----------------------------
1     | true         | 2194
2     | false        | 112
*/


-- Ditribution on eightd_has_available_keys

/*
Row   | eightd_has_available_keys | cnt
----------------------------------------
1     | false                     | 2306
*/


-- Ditribution on last_reported

SELECT
  last_reported,
  COUNT(1) AS cnt
FROM
  `bigquery-public-data.new_york_citibike.citibike_stations`
GROUP BY
  1
ORDER BY
  2 DESC;

/*
Observation:
All 'last_reported' timestamps are valid and reflect consistent reporting dates.
*/







/*
citibike_trips
=================
*/
-- tripduration -
-- Validate the distributions. the range of the values make resonable.

SELECT
  CASE
    WHEN tripduration / 60 < 6 THEN "less than 6-min"
    WHEN tripduration / 3600 BETWEEN 0.1
  AND 24 THEN "valid"
    WHEN tripduration / 3600 > 24 THEN "greater than 24-hours"
    ELSE NULL
END
  AS tripduration_group,
  COUNT(1) AS number_of_trips
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
GROUP BY
  1
ORDER BY
  2 DESC;

/*
Row | tripduration_group     | number_of_trips
-----------------------------------------------
1   | valid                  | 41234858
2   | less than 6-min        | 11862350
3   | null                   | 5828994
4   | greater than 24-hours  | 11513
*/


-- tripduration - Explore Max / Min

  SELECT
    MIN(tripduration) as min_tripduration,
    MAX(tripduration) as max_tripduration
  FROM `bigquery-public-data.new_york_citibike.citibike_trips`;

/*
Row | min_tripduration | max_tripduration
------------------------------------------
1   | 60               | 19510049

Observation:
The minimum is only 1 minute of tripduration.
The maximum is 5,419.45 hours of one trip which seems to be outlier.
*/


/*
starttime stoptime
Make sure that starttime <  stoptime
distribution
*/

SELECT
  CASE
    WHEN starttime < stoptime THEN "valid"
    WHEN starttime > stoptime THEN "invalid"
    ELSE "equal"
END
  AS trip_status,
  COUNT(*) AS num_trips
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
GROUP BY 1;

/*
Row | trip_status | num_trips
-------------------------------
1   | invalid     | 119
2   | equal       | 5828994
3   | valid       | 53108602
*/

-- Distribution dates of starttime and stoptime

SELECT
  DATE(starttime) AS dt,
  -- DATE(DATE_TRUNC(starttime, MONTH)) AS month,
  -- DATE(stoptime) AS dt,
  -- DATE(DATE_TRUNC(stoptime, MONTH)) AS month,
  COUNT(*) AS num_trips
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  starttime IS NOT NULL
GROUP BY
  1
ORDER BY
  1 DESC;

/*
Observation: Data is valid start at 2013 till 2018.
*/

/*
start_station_name end_station_name
make sure these names exists in the stations table
*/

SELECT
  names_stations IS NOT NULL AS exists_in_stations,
  COUNT(1) AS total_stations
FROM (
  SELECT
    DISTINCT a.name AS names_stations,
    b.name AS names_trips
  FROM
    `bigquery-public-data.new_york_citibike.citibike_stations` AS a
  RIGHT JOIN ( (
      SELECT
        DISTINCT start_station_name AS name
      FROM
        `bigquery-public-data.new_york_citibike.citibike_trips`)
    UNION DISTINCT (
      SELECT
        DISTINCT end_station_name AS name
      FROM
        `bigquery-public-data.new_york_citibike.citibike_trips`) ) AS b
  ON
    a.name = b.name )
GROUP BY
  1;

/*
Row | exists_in_stations | total_stations
------------------------------------------
1   | true               | 693
2   | false              | 275

Observation:
275 stations in trips don't exist in stations table, 693 appear in both.
*/


-- Validate if all the stations exist in the trips table

SELECT
  names_trips IS NOT NULL AS has_trip,
  COUNT(1) AS total_stations
FROM (
  SELECT
    DISTINCT a.name AS names_stations,
    b.name AS names_trips
  FROM
    `bigquery-public-data.new_york_citibike.citibike_stations` AS a
  LEFT JOIN ( (
      SELECT
        DISTINCT start_station_name AS name
      FROM
        `bigquery-public-data.new_york_citibike.citibike_trips`)
    UNION DISTINCT (
      SELECT
        DISTINCT end_station_name AS name
      FROM
        `bigquery-public-data.new_york_citibike.citibike_trips`) ) AS b
  ON
    a.name = b.name )
GROUP BY
  1;

/*
Row | has_trip | total_stations
-------------------------------
1   | true     | 693
2   | false    | 1611

Observation:
1,611 stations haven’t been used yet, and only 693 stations were part of trips.
*/


/*
bikeid
How many uniques
*/

SELECT
  COUNT(DISTINCT bikeid) AS total_bikes
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`;

/*
Row | total_bikes
------------------
1   | 17682
*/

-- Daily rides, Daily unique bikid

SELECT
  DATE(starttime) AS dt,
  COUNT(bikeid) AS rides,
  COUNT(DISTINCT bikeid) AS unique_bikes,
  ROUND(COUNT(bikeid) / COUNT(DISTINCT bikeid), 0) AS rides_per_bikes
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  starttime IS NOT NULL
GROUP BY
  1
ORDER BY
  1;


/*
usertype  birth_year  gender -
Validate the distributions. the range of the values make resonable
Explore Max / Min
*/

-- birth_year Min / Max

SELECT
  MIN(birth_year) as min_birth_year,  
  MAX(birth_year) as max_birth_year 
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`;

  /*
Observation: The oldest person that used the bike borned at 1874 which unreasonable,
So I'll take cutoff from 1940.
The youngest person that used the bike borned at 2002.
  */

-- Validate the distributions:

SELECT
  -- birth_year,
  -- usertype,
  gender,
  COUNT(1) AS total
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
GROUP BY 1
ORDER BY 1;

  /*
Observation: Each field contains missing (NULL) value - for example:
5,828,994 records have no gender.
  */