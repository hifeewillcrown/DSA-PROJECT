CREATE Database Ife_SQLQuery1

Select * from [dbo].[KMS Sql Case Study]

select * from [dbo].[Order_Status]




------JOIN TABLES------ AND CREATING VIEW-------

Create view KMSORDER
		AS
SELECT	[dbo].[KMS Sql Case Study].ORDER_ID,
		[dbo].[KMS Sql Case Study].Order_Quantity,
		[dbo].[KMS Sql Case Study].Unit_Price,
		[dbo].[KMS Sql Case Study].Discount,
		[dbo].[KMS Sql Case Study].Product_Base_Margin,
		[dbo].[KMS Sql Case Study].Order_Date,
		[dbo].[KMS Sql Case Study].Ship_Date,
		[dbo].[KMS Sql Case Study].Customer_Name,
		[dbo].[KMS Sql Case Study].Customer_Segment,
		[dbo].[KMS Sql Case Study].Province,
		[dbo].[KMS Sql Case Study].Region,
		[dbo].[KMS Sql Case Study].Order_Priority,
		[dbo].[KMS Sql Case Study].Sales,
		[dbo].[KMS Sql Case Study].Profit,
		[dbo].[KMS Sql Case Study].Ship_Mode,
		[dbo].[KMS Sql Case Study].Shipping_Cost,
		[dbo].[KMS Sql Case Study].Product_Container,
		[dbo].[KMS Sql Case Study].Product_Category,
		[dbo].[KMS Sql Case Study].Product_Sub_Category,
		[dbo].[KMS Sql Case Study].Product_Name,
		[dbo].[Order_Status].[Status]
		from [dbo].[KMS Sql Case Study]
		JOIN [dbo].[Order_Status]
		ON [dbo].[Order_Status].Order_Id=[dbo].[KMS Sql Case Study].Order_ID


UPDATE [dbo].[KMSORDER]
SET [Product_Base_Margin] = COALESCE([Product_Base_Margin], 0.00)
WHERE [Product_Base_Margin] IS NULL



		SELECT * FROM [dbo].[KMSORDER]


----Question 1: Which product category had the highest sales?
		
----QUESTION 1 SOLVED----
-----HIGHEST PRODUCT CATEGORY-----

select top 1 Product_Category,
sum(sales) As total_sales
from  [dbo].[KMSORDER]
GROUP BY Product_Category
ORDER BY total_sales DESC

-----Answer: Product Category = (Technology) --- Sales = $605,426.04
---////////////////////////////////////////////////////////////////////////////////


-----Select View------
Select * From [dbo].[KMSORDER]

----Question 2: What are the top 3 and bottom 3 regions in terms of sales------

------QUESTION 2 SOLVED-----
-----TOP 3 and BOTTTOM 3 REGION IN TERMS OF SALES---

--Top 3

Select top 3 Region,
sum(sales) As Total_sales
from [dbo].[KMSORDER]
group by region
order by total_sales desc

---Answer: Top 3 Regions; Ontario = $471,161.63 / West = $375,122.37 / Prarie = $296,732.24 
      -----//////////////////----
--Bottom 3

SELECT top 3 Region,
MIN(SALES) AS Total_sales
from [dbo].[KMSORDER]
group by region
order by total_sales desc

---Answer: B0ttom 3 Regions; Nunavut = $228.41, NorthWest Territories = $35.17, Quebec $16.35
----//////////////////////////////////////////////////////////////////----------


-----Select View------
Select * From [dbo].[KMSORDER]

----Quest 3: What were the total sales of appliances in Ontario?

-------QUESTION 3 SOLVED------
------TOTAL SALES OF APPLIANCES IN ONTARIO-----

SELECT Region,
    SUM(Sales) AS Total_Sales
FROM [dbo].[KMSORDER]
WHERE Region = 'Ontario'
  And Product_Sub_Category = 'appliances'
Group By Region

---Answer: = Total Sales of Appliances in Ontario = $17,648.37
----//////////////////////////////////////////////////////////////////////--------


-----Select View------
Select * From [dbo].[KMSORDER]

----- Question 4: Advise the management of KMS on what to do to increase the revenue from the bottom 10 customer

Select Top 10
      Customer_Name,
	  Sum(Sales) As Total_Revenue
From [dbo].[KMSORDER]
Group by Customer_Name
Order by Total_Revenue Asc

---Answer: MY ADVISE TO THE MANAGEMENT OF KMS......................

--------- BOTTOM 10 CUSTOMERS-----------------------
--Customer Name          Total Sales

--John Grady       =     $5.06
--Frank Atkinson   =     $10.48
--Sean Wendt       =     $12.80
--Sandra Glassco   =     $16.24
--Katherine Hughes =     $17.77 
--Bobby Elias      =     $22.56
--Noel Staavos     =     $24.91
--Thomas Boland    =     $28.01
--Brad Eason       =     $35.17
--Theresa Swint    =     $38.51
---------//////////////////////////////////////////////--------------------------


-----Select View------
Select * From [dbo].[KMSORDER]

---Question 5: KMS incurred the most shipping cost using which shipping method?

Select Top 1
      Order_Priority, Ship_Mode,
	  Sum(Shipping_Cost) As Total_Cost
From [dbo].[KMSORDER]
Group by Order_Priority, Ship_Mode
Order by Total_Cost Desc

---Answer: Order_Priority = (Low) / Shiping Method = Delevery Struck / Shipping Cost = $1,659.14
-----///////////////////////////////////////////////////////////////////////------------


-----Select View------
Select * From [dbo].[KMSORDER]

------Question 6: Who are the most valuable customers, and what products or services do they typically purchase?

WITH CustomerRevenue AS (
    SELECT
        Customer_Name,
        Customer_Segment,
        SUM(Sales) AS Total_Revenue
    FROM [dbo].[KMSORDER]
    GROUP BY Customer_Name, Customer_Segment
),
CustomerProductRevenue AS (
    SELECT 
        Customer_Name,
        Product_Name,
		Order_Quantity,
        SUM(Sales) AS Product_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_Name 
            ORDER BY SUM(Sales) DESC, Product_Name DESC
        ) AS Product_Rank
    FROM [dbo].[KMSORDER]
    GROUP BY Customer_Name, Product_Name, Order_Quantity
)
SELECT TOP 5
    cr.Customer_Name,
    cr.Customer_Segment,
    cpr.Product_Name AS Top_Product,
	cpr.Order_Quantity,
    cr.Total_Revenue
FROM CustomerRevenue cr
JOIN CustomerProductRevenue cpr 
    ON cr.Customer_Name = cpr.Customer_Name 
    AND cpr.Product_Rank = 1
ORDER BY cr.Total_Revenue DESC

----Answer: We have our Top 5, having that the (top product that are being purchased are as follow:

------Customer_Name       Customer_Segment    Top_Product																	Order_Quantity           Total_Revenue              

---1---John Lucas          Small Business      Chromcraft Bull-Nose Wood 48" x 96" Rectangular Conference Tables				42					 $37,919.43
---2---Lycoris Saunders    Corporate           Bretford CR8500 Series Meeting Room Furniture				                   	45					 $30,948.18
---3---Grant Carroll	   Small Business	   Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind		18					 $26,485.12
---4---Erin Creighton	   Corporate	       Polycom VoiceStation 100															24					 $26,443.02
---5---Peter Fuller	       Corporate	       Panasonic KX-P3626 Dot Matrix Printer											47					 $26,382.21
-----------------//////////////////////////////////////////////////////////////////////////////////////////////////////----------

-----Select View------
Select * From [dbo].[KMSORDER]

---Question 7: Which (Small business customer) had the highest sales?

WITH CustomerRevenue AS (
    SELECT 
        Customer_Name,
        Customer_Segment,
        SUM(Sales) AS Total_Revenue
    FROM [dbo].[KMSORDER]
	Where Customer_Segment = 'Small Business'
    GROUP BY Customer_Name, Customer_Segment
),
CustomerProductRevenue AS (
    SELECT 
        Customer_Name,
        Product_Name,
		Order_Quantity,
        SUM(Sales) AS Product_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_Name 
            ORDER BY SUM(Sales) DESC, Product_Name DESC
        ) AS Product_Rank
    FROM [dbo].[KMSORDER]
    GROUP BY Customer_Name, Product_Name, Order_Quantity
)
SELECT TOP 1
    cr.Customer_Name,
    cr.Customer_Segment,
    cpr.Product_Name AS Top_Product,
	cpr.Order_Quantity,
    cr.Total_Revenue
FROM CustomerRevenue cr
JOIN CustomerProductRevenue cpr 
    ON cr.Customer_Name = cpr.Customer_Name 
    AND cpr.Product_Rank = 1
ORDER BY cr.Total_Revenue DESC

---Answer: The Custormer_Segment = (Small Business) / Customer_Name = (John Lucas) Order_Quantity= 42 / Total_Revenue = $37,919.43
----------////////////////////////////////////////////////////////////////////////////-----------------------------

-----Select View------
Select * From [dbo].[KMSORDER]

----Question 8: Which (Corporate Customer) placed the most (number of orders) in (2009 – 2012)?

SELECT TOP 1
   Customer_Segment, Customer_Name,
    SUM(Order_Quantity) AS Total_Orders
FROM [dbo].[KMSORDER]
WHERE Customer_Segment = 'Corporate'
    AND Ship_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Orders DESC

----Answer: The corporate customer with the most placed order in 2009 - 2012 Is; Customer_Name = Erin Creighton, Total_Orders = 261

-----Select View------
Select * From [dbo].[KMSORDER]

---Question 9: Which (Consumer customer) was the (most profitable one)?

SELECT TOP 1
    Customer_Segment, Customer_Name,
    SUM(Sales) AS Total_Revenue
FROM [dbo].[KMSORDER]
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Revenue Desc

---Answer: The most profitable (Consumer Customer); Customer_Name = Darren Budd / Profitability = $23,034.35
--------------------------///////////////////////////////////////////////////////////////////////////////-----------------

-----Select View------
Select * From [dbo].[KMSORDER]

----Question 10: Which customer returned items? And what segment do they belong to?

SELECT TOP 872
   Customer_Name, Customer_Segment,
    max([Status]) AS Total_Returned_Items
FROM [dbo].[KMSORDER]
GROUP BY Customer_Segment, Customer_Name, [Status]
ORDER BY Total_Returned_Items Desc

----Answer: All customers returned their items-------

-----Select View------
Select * From [dbo].[KMSORDER]

-----Question 11....

---If the delivery truck is the most economical but the slowest shipping method and 
---Express Air is the fastest but the most expensive one, do you think the company 
---appropriately spent shipping costs based on the Order Priority? (Explain your answer)

-----Select View------
Select * From [dbo].[KMSORDER]


SELECT  
    Order_Priority,  
    Ship_Mode,  
    SUM(Shipping_Cost) AS Total_Cost  
FROM  [dbo].[KMSORDER] 
WHERE Ship_Mode IN ('Express Air', 'Delivery Truck')  
GROUP BY Order_Priority, Ship_Mode  
ORDER BY Ship_Mode, Total_Cost DESC

----Answer:		Based on Order Priority				Ship Mode					Total Cost

---------		Low									Delivery Truck				$1,659.14
---------		High								Delivery Truck				$1,274.98
---------		Not	Specified						Delivery Truck				$1,040.76
---------		Medium								Delivery Truck				$925.25
--------		Critical							Delivery Truck				$829.01
--------		Low									Express Air					$289.95
--------		Not	Specified						Express Air					$257.40
--------		Critical							Express Air					$195.19
--------		Medium								Express Air					$167.27
--------		High								Express Air					$108.92

------Was shipping cost appropriately spent based on Order Priority?
----a- Appropriate spending depends on matching high-priority orders with fast (Express Air) shipping and low-priority orders with economical (Delivery Truck) methods.
----b- If there are mismatches (e.g., urgent items shipped via Delivery Truck), the spending is inappropriate.
----c- A proper audit of the data would confirm alignment.
--------//////////////////////////////////////////////////////////////////////////////-------------------------------------////////////
