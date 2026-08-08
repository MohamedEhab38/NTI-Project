-- 1. Prep Time Bottleneck
SELECT 
    AVG(
        CASE 
            WHEN DATEDIFF(MINUTE, 
                CAST(Time_Orderd AS TIME),
                CAST(Time_Order_picked AS TIME)
            ) < 0 
            THEN DATEDIFF(MINUTE, 
                CAST(Time_Orderd AS TIME),
                CAST(Time_Order_picked AS TIME)
            ) + 1440
            ELSE DATEDIFF(MINUTE, 
                CAST(Time_Orderd AS TIME),
                CAST(Time_Order_picked AS TIME)
            )
        END
    ) AS Avg_Prep_Time_Min
FROM dbo.Cleaned_Data
WHERE Time_Orderd IS NOT NULL 
AND Time_Order_picked IS NOT NULL;
-- 2. Multiple Deliveries Impact
SELECT 
    multiple_deliveries,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
GROUP BY multiple_deliveries
ORDER BY Avg_Delivery_Time DESC;





-- 3. Peak Demand Hours
SELECT 
    DATEPART(HOUR, CAST(Time_Orderd AS TIME)) AS Order_Hour,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
WHERE Time_Orderd IS NOT NULL
GROUP BY DATEPART(HOUR, CAST(Time_Orderd AS TIME))
ORDER BY Total_Orders DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
-- 4. Festival Impact
SELECT 
    Festival,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
GROUP BY Festival
ORDER BY Avg_Delivery_Time DESC;
-- 5. Order Type Popularity
SELECT 
    Type_of_order,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
GROUP BY Type_of_order
ORDER BY Total_Orders DESC;




-- 6. Distance Brackets
SELECT 
    CASE
        WHEN SQRT(
            POWER((Delivery_location_latitude - Restaurant_latitude), 2) +
            POWER((Delivery_location_longitude - Restaurant_longitude), 2)
        ) < 0.05 THEN 'Short Distance'
        WHEN SQRT(
            POWER((Delivery_location_latitude - Restaurant_latitude), 2) +
            POWER((Delivery_location_longitude - Restaurant_longitude), 2)
        ) BETWEEN 0.05 AND 0.15 THEN 'Medium Distance'
        ELSE 'Long Distance'
    END AS Distance_Bracket,
    COUNT(ID) AS Total_Orders,
    ROUND(AVG(CAST(Time_taken_min AS FLOAT)), 2) AS Avg_Delivery_Time
FROM dbo.Cleaned_Data
GROUP BY 
    CASE
        WHEN SQRT(
            POWER((Delivery_location_latitude - Restaurant_latitude), 2) +
            POWER((Delivery_location_longitude - Restaurant_longitude), 2)
        ) < 0.05 THEN 'Short Distance'
        WHEN SQRT(
            POWER((Delivery_location_latitude - Restaurant_latitude), 2) +
            POWER((Delivery_location_longitude - Restaurant_longitude), 2)
        ) BETWEEN 0.05 AND 0.15 THEN 'Medium Distance'
        ELSE 'Long Distance'
    END
ORDER BY Avg_Delivery_Time DESC;








--------Insights-----------
-- 1. Prep Time Bottleneck
-- Average preparation time is around 9 minutes,
-- indicating that restaurant preparation contributes to the overall delivery time.

-- 2. Multiple Deliveries Impact
-- Orders with multiple deliveries show higher average delivery times,
-- indicating that combining orders may increase delivery delays.

-- 3. Peak Demand Hours
-- The highest order volume occurs during evening peak hours (7 PM - 11 PM),
-- increasing delivery pressure and requiring more rider availability.

-- 4. Festival Impact
-- Orders during festival periods have a higher average delivery time (45.52 minutes),
-- indicating that festivals increase delivery pressure and traffic congestion.

-- 5. Order Type Popularity
-- Snack orders have the highest volume, followed closely by Meal and Drinks orders,
-- indicating similar demand levels across different order types.

-- 6. Distance Brackets
-- Long-distance orders have the highest average delivery time (28.69 minutes),
-- indicating that increasing distance negatively affects delivery efficiency.


------------Recommendations-----------
-- 1. Prep Time Bottleneck
-- Improve restaurant preparation speed by setting standard preparation times.
-- Optimize rider assignment timing to reduce waiting time.

-- 2. Multiple Deliveries Impact
-- Set a maximum limit for the number of orders assigned to one rider.
-- Allow multiple deliveries only when orders are in the same geographic route.

-- 3. Peak Demand Hours
-- Increase the number of riders during peak demand hours.
-- Offer promotions during low-demand periods to balance order volume.

-- 4. Festival Impact
-- Prepare additional riders during festival periods.
-- Adjust Estimated Time of Arrival (ETA) during high congestion periods.

-- 5. Order Type Popularity
-- Create offers and menus for the most popular food categories.
-- Collaborate with restaurants to ensure availability of popular meals in high-demand areas.

-- 6. Distance Brackets
-- Increase delivery fees as the distance increases.
-- Prioritize nearby orders to improve delivery speed.