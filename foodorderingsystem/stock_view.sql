/* create view to view stocks*/
CREATE VIEW stock_view AS
SELECT foodtype.meal,food.food_name,food_stocks.remaining,foodtype.from_time,foodtype.to_time
FROM food
JOIN food_stocks 
ON food.id=food_stocks.foodid
 JOIN foodtype
  ON food_stocks.mealid=foodtype.id;

SELECT * FROM stock_view;
