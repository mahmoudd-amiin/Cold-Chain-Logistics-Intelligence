
SELECT
    Status,
    COUNT(*) AS Total_Shipments,
    SUM(Quantity) AS Total_Quantity,
    SUM(Weight_KG) AS Total_Weight_KG,
    SUM(Shipping_Cost) AS Total_Shipping_Cost,
    AVG(Shipping_Cost) AS Avg_Shipping_Cost
FROM Shipments
GROUP BY Status
ORDER BY Total_Shipments DESC;
---------------------------------------
SELECT
    COUNT(*) AS Total_Shipments,

    SUM(CASE WHEN Status = 'Delivered'
        THEN 1 ELSE 0 END) AS Delivered_Shipments,

    SUM(CASE WHEN Status = 'Delayed'
        THEN 1 ELSE 0 END) AS Delayed_Shipments,

    SUM(CASE WHEN Status = 'Cancelled'
        THEN 1 ELSE 0 END) AS Cancelled_Shipments,

    CAST(
        100.0 * SUM(CASE WHEN Status = 'Delivered'
        THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS Delivery_Rate,

    SUM(Quantity) AS Total_Quantity,

    SUM(Weight_KG) AS Total_Weight_KG,

    SUM(Shipping_Cost) AS Total_Shipping_Cost,

    AVG(Shipping_Cost) AS Average_Shipping_Cost

FROM Shipments;
-----------------------------------------------------------
SELECT
    Status,
    COUNT(*) AS Total_Shipments,

    COUNT(Actual_Delivery) AS Delivered_With_Actual_Date,

    CAST(
        AVG(
            DATEDIFF(
                MINUTE,
                Expected_Delivery,
                Actual_Delivery
            ) / 60.0
        ) AS DECIMAL(10,2)
    ) AS Avg_Delay_Hours,

    MAX(
        DATEDIFF(
            MINUTE,
            Expected_Delivery,
            Actual_Delivery
        ) / 60.0
    ) AS Max_Delay_Hours

FROM Shipments
WHERE Actual_Delivery IS NOT NULL
GROUP BY Status
ORDER BY Total_Shipments DESC;
-------------------------
SELECT
    Status,
    COUNT(*) AS Total_Shipments,

    SUM(CASE
        WHEN Actual_Delivery > Expected_Delivery
        THEN 1 ELSE 0
    END) AS Late_Deliveries,

    SUM(CASE
        WHEN Actual_Delivery = Expected_Delivery
        THEN 1 ELSE 0
    END) AS On_Time_Deliveries,

    SUM(CASE
        WHEN Actual_Delivery < Expected_Delivery
        THEN 1 ELSE 0
    END) AS Early_Deliveries

FROM Shipments
WHERE Actual_Delivery IS NOT NULL
GROUP BY Status
ORDER BY Status;
-------------------------------------
SELECT
    COUNT(*) AS Total_Delivered,

    SUM(CASE
        WHEN Actual_Delivery <= Expected_Delivery
        THEN 1 ELSE 0
    END) AS On_Time_Deliveries,

    SUM(CASE
        WHEN Actual_Delivery > Expected_Delivery
        THEN 1 ELSE 0
    END) AS Late_Deliveries,

    CAST(
        100.0 * SUM(CASE
            WHEN Actual_Delivery <= Expected_Delivery
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS On_Time_Delivery_Rate,

    CAST(
        100.0 * SUM(CASE
            WHEN Actual_Delivery > Expected_Delivery
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS Late_Delivery_Rate

FROM Shipments
WHERE Status IN ('Delivered', 'Delayed')
AND Actual_Delivery IS NOT NULL;
------------------------
SELECT
    p.Product_Category,

    COUNT(t.Reading_ID) AS Total_Readings,

    SUM(CASE
        WHEN t.Temperature_C < p.Temperature_Min
          OR t.Temperature_C > p.Temperature_Max
        THEN 1 ELSE 0
    END) AS Out_Of_Range_Readings,

    SUM(CASE
        WHEN t.Temperature_C BETWEEN
             p.Temperature_Min AND p.Temperature_Max
        THEN 1 ELSE 0
    END) AS Compliant_Readings,

    CAST(
        100.0 * SUM(CASE
            WHEN t.Temperature_C BETWEEN
                 p.Temperature_Min AND p.Temperature_Max
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(t.Reading_ID), 0)
        AS DECIMAL(6,2)
    ) AS Compliance_Rate

FROM Temperature_Readings t
INNER JOIN Shipments s
    ON t.Shipment_ID = s.Shipment_ID
INNER JOIN Products p
    ON s.Product_ID = p.Product_ID

GROUP BY p.Product_Category
ORDER BY Compliance_Rate ASC;
-------------------------
SELECT
    p.Product_Category,

    COUNT(t.Reading_ID) AS Violation_Count,

    CAST(AVG(
        CASE
            WHEN t.Temperature_C < p.Temperature_Min
                THEN p.Temperature_Min - t.Temperature_C
            WHEN t.Temperature_C > p.Temperature_Max
                THEN t.Temperature_C - p.Temperature_Max
        END
    ) AS DECIMAL(8,2)) AS Avg_Temperature_Deviation,

    CAST(MAX(
        CASE
            WHEN t.Temperature_C < p.Temperature_Min
                THEN p.Temperature_Min - t.Temperature_C
            WHEN t.Temperature_C > p.Temperature_Max
                THEN t.Temperature_C - p.Temperature_Max
        END
    ) AS DECIMAL(8,2)) AS Max_Temperature_Deviation

FROM Temperature_Readings t
INNER JOIN Shipments s
    ON t.Shipment_ID = s.Shipment_ID
INNER JOIN Products p
    ON s.Product_ID = p.Product_ID

WHERE t.Temperature_C < p.Temperature_Min
   OR t.Temperature_C > p.Temperature_Max

GROUP BY p.Product_Category
ORDER BY Avg_Temperature_Deviation DESC;
------------------------ 
SELECT TOP 10
    s.Shipment_ID,
    p.Product_Name,
    p.Product_Category,
    COUNT(t.Reading_ID) AS Violation_Count,

    CAST(AVG(
        CASE
            WHEN t.Temperature_C < p.Temperature_Min
                THEN p.Temperature_Min - t.Temperature_C
            WHEN t.Temperature_C > p.Temperature_Max
                THEN t.Temperature_C - p.Temperature_Max
        END
    ) AS DECIMAL(8,2)) AS Avg_Deviation,

    CAST(MAX(
        CASE
            WHEN t.Temperature_C < p.Temperature_Min
                THEN p.Temperature_Min - t.Temperature_C
            WHEN t.Temperature_C > p.Temperature_Max
                THEN t.Temperature_C - p.Temperature_Max
        END
    ) AS DECIMAL(8,2)) AS Max_Deviation

FROM Temperature_Readings t
INNER JOIN Shipments s
    ON t.Shipment_ID = s.Shipment_ID
INNER JOIN Products p
    ON s.Product_ID = p.Product_ID

WHERE t.Temperature_C < p.Temperature_Min
   OR t.Temperature_C > p.Temperature_Max

GROUP BY
    s.Shipment_ID,
    p.Product_Name,
    p.Product_Category

ORDER BY
    Violation_Count DESC,
    Max_Deviation DESC;
--------------------------
SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Type,
    c.City,
    c.Country,

    COUNT(s.Shipment_ID) AS Total_Shipments,

    SUM(s.Quantity) AS Total_Quantity,

    CAST(SUM(s.Weight_KG) AS DECIMAL(12,2)) AS Total_Weight_KG,

    CAST(SUM(s.Shipping_Cost) AS DECIMAL(12,2)) AS Total_Shipping_Cost

FROM Customers c
LEFT JOIN Shipments s
    ON c.Customer_ID = s.Customer_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Type,
    c.City,
    c.Country

ORDER BY
    Total_Shipments DESC;
---------------------------
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Product_Category,

    COUNT(s.Shipment_ID) AS Total_Shipments,

    SUM(s.Quantity) AS Total_Quantity,

    CAST(SUM(s.Weight_KG) AS DECIMAL(12,2)) AS Total_Weight_KG,

    CAST(SUM(s.Shipping_Cost) AS DECIMAL(12,2)) AS Total_Shipping_Cost,

    CAST(AVG(s.Shipping_Cost) AS DECIMAL(12,2)) AS Avg_Shipping_Cost

FROM Products p
LEFT JOIN Shipments s
    ON p.Product_ID = s.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Product_Category

ORDER BY
    Total_Shipments DESC;
---------------------------------
SELECT
    v.Vehicle_ID,
    v.Vehicle_Type,
    v.Refrigeration_Type,
    v.Vehicle_Status,

    COUNT(s.Shipment_ID) AS Total_Shipments,

    SUM(CASE
        WHEN s.Status = 'Delivered' THEN 1
        ELSE 0
    END) AS Delivered_Shipments,

    SUM(CASE
        WHEN s.Status = 'Delayed' THEN 1
        ELSE 0
    END) AS Delayed_Shipments,

    SUM(CASE
        WHEN s.Status = 'Cancelled' THEN 1
        ELSE 0
    END) AS Cancelled_Shipments,

    CAST(SUM(s.Weight_KG) AS DECIMAL(12,2)) AS Total_Weight_KG,

    CAST(SUM(s.Shipping_Cost) AS DECIMAL(12,2)) AS Total_Shipping_Cost,

    CAST(AVG(s.Shipping_Cost) AS DECIMAL(12,2)) AS Avg_Shipping_Cost

FROM Vehicles v
LEFT JOIN Shipments s
    ON v.Vehicle_ID = s.Vehicle_ID

GROUP BY
    v.Vehicle_ID,
    v.Vehicle_Type,
    v.Refrigeration_Type,
    v.Vehicle_Status

ORDER BY
    Total_Shipments DESC;
----------------------------------
SELECT
    f.Facility_ID,
    f.Facility_Name,
    f.City,
    f.Facility_Type,
    f.Storage_Capacity,

    COUNT(DISTINCT s.Shipment_ID) AS Total_Shipments,

    COUNT(DISTINCT CASE
        WHEN s.Origin_Facility_ID = f.Facility_ID
        THEN s.Shipment_ID
    END) AS Outgoing_Shipments,

    COUNT(DISTINCT CASE
        WHEN s.Destination_Facility_ID = f.Facility_ID
        THEN s.Shipment_ID
    END) AS Incoming_Shipments,

    CAST(SUM(s.Weight_KG) AS DECIMAL(12,2)) AS Total_Weight_KG,

    CAST(SUM(s.Shipping_Cost) AS DECIMAL(12,2)) AS Total_Shipping_Cost

FROM Facilities f
LEFT JOIN Shipments s
    ON f.Facility_ID = s.Origin_Facility_ID
    OR f.Facility_ID = s.Destination_Facility_ID

GROUP BY
    f.Facility_ID,
    f.Facility_Name,
    f.City,
    f.Facility_Type,
    f.Storage_Capacity

ORDER BY
    Total_Shipments DESC;




