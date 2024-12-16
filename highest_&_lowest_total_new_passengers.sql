WITH RankedCities AS (
    SELECT 
        dc.city_name,
        SUM(fps.new_passengers) AS total_new_passengers,
        RANK() OVER (ORDER BY SUM(fps.new_passengers) DESC) AS rank_desc,
        RANK() OVER (ORDER BY SUM(fps.new_passengers) ASC) AS rank_asc
    FROM 
        fact_passenger_summary fps
    JOIN 
        dim_city dc 
        ON fps.city_id = dc.city_id
    GROUP BY 
        dc.city_name
),
CategorizedCities AS (
    SELECT 
        city_name,
        total_new_passengers,
        CASE 
            WHEN rank_desc <= 3 THEN 'Top 3'
            WHEN rank_asc <= 3 THEN 'Bottom 3'
            ELSE NULL
        END AS city_category
    FROM 
        RankedCities
)
SELECT 
    city_name,
    total_new_passengers,
    city_category
FROM 
    CategorizedCities
WHERE 
    city_category IS NOT NULL
ORDER BY 
    city_category, total_new_passengers DESC;
