-- What are the top 5 most popular stations (with most rides)

SELECT
  start_station_name,
  COUNT(1) AS total_rides
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  start_station_name != ""
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  5;

/*
Row | start_station_name     | total_rides
-------------------------------------------
1   | Pershing Square North  | 438077
2   | E 17 St & Broadway     | 423334
3   | W 21 St & 6 Ave        | 403795
4   | 8 Ave & W 31 St        | 401554
5   | West St & Chambers St  | 384116
*/


-- What are the top 5 most popular roads (with most rides)

SELECT
  start_station_name,
  end_station_name,
  COUNT(*) as total_rides
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  start_station_name != "" AND end_station_name != ""
GROUP BY
  1, 2
ORDER BY
  3 DESC
LIMIT
  5;

/*
Row | start_station_name                | end_station_name                  | total_rides
------------------------------------------------------------------------------------------
1   | Central Park S & 6 Ave            | Central Park S & 6 Ave            | 55703
2   | Grand Army Plaza & Central Park S | Grand Army Plaza & Central Park S | 25573
3   | Centre St & Chambers St           | Centre St & Chambers St           | 19670
4   | Broadway & W 60 St                | Broadway & W 60 St                | 19475
5   | 12 Ave & W 40 St                  | West St & Chambers St             | 18667
*/

-- What is the daily distribution?

SELECT
  DATE(starttime) AS dt,
  start_station_name,
  end_station_name,
  COUNT(*) AS total_rides
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  start_station_name != ""
  AND end_station_name != ""
GROUP BY
  1,
  2,
  3
ORDER BY
  1,
  4 DESC;


/*
Trip duration by (user type & Gender & Age)
The AVERAGE trip duration
Maximum / minimum
*/

SELECT
  -- usertype,
  -- gender,
  birth_year,
  ROUND(AVG(tripduration),1) AS AVG_tripduration,
  MIN(tripduration) AS MIN_tripduration,
  MAX(tripduration) AS MAX_tripduration,
  COUNT(1) AS total_trips
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  FLOOR(tripduration / 3600) + 1 < 24
  AND birth_year > 1940
GROUP BY
  1;


-- What is the daily trips and the number of bikes used per day

SELECT
  DATE(starttime) AS dt,
  COUNT(1) AS total_trips,
  COUNT(DISTINCT bikeid) AS total_bikes
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
  starttime IS NOT NULL
GROUP BY
  1
ORDER BY
  1;


-- How many bike had been purchased (first usage) / lost (last usage)

SELECT
  start_date,
  COUNT(bikeid) AS first_seen_bikes
FROM (
  SELECT
    bikeid,
    DATE(MIN(starttime)) AS start_date
  FROM
    `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE
    bikeid IS NOT NULL
  GROUP BY
    1 )
GROUP BY
  1
ORDER BY
  1;


 SELECT
  end_date,
  COUNT(bikeid) AS last_seen_bikes_per_day
FROM (
  SELECT
    bikeid,
    DATE(MAX(stoptime)) AS end_date
  FROM
    `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE
    bikeid IS NOT NULL
  GROUP BY
    1 )
GROUP BY
  1
ORDER BY
  1;