/* create view to view stocks*/
CREATE VIEW  view_stockdetails AS
SELECT foodtype.meal,food.food_name,(food_stocks.quantity-SUM(food_transaction.quantity)) AS remaining 
FROM food JOIN food_stocks ON food.id=food_stocks.foodid
JOIN foodtype ON food_stocks.mealid=foodtype.id
JOIN food_transaction ON food_stocks.foodid=food_transaction.food_id
WHERE DATE(date_of_order)=CURDATE() GROUP BY food_transaction.food_id;

SELECT * FROM view_stockdetails;
