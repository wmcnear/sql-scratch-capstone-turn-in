Code
-- Query used to show a sample of the data
SELECT *
FROM page_visits
LIMIT 10;


-- Step 1-a: Query used to count utm_campaign 

SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;


-- Step 1-b: Query used to count utm_source 

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;


-- Step 1-c: Query used to show relationship between campaigns and sources 

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
ORDER BY 2 ASC;



-- Step 2: Query used to identify distinct pages within the website

SELECT DISTINCT page_name
FROM page_visits;



-- Step 3: Query used to identify first-touches and counts for campaigns that brought initial visits to the website

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),

ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
  	 pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)

SELECT ft_attr.utm_campaign,
       ft_attr.utm_source, 
       COUNT(*)
FROM ft_attr
GROUP BY 1
ORDER BY 3 DESC;



-- Step 4: Query used to identify last-touches and counts for each campaign 

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),

lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
  	 pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

SELECT lt_attr.utm_campaign,
       lt_attr.utm_source,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;



-- Step 5: Query used to identify users making purchases

SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';



-- Step 6: Query used to identify last touches on the purchase page for each campaign

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),

lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
  	 pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)

SELECT lt_attr.utm_campaign,
       lt_attr.utm_source,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
