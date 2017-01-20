/*Procedure for ordering a single food*/
DELIMITER $$

USE `rashika_db`$$

DROP PROCEDURE IF EXISTS `one_food`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_order_one_food`(IN seat_number INT,IN i_food_name VARCHAR(100),IN qty INT)
BEGIN
 DECLARE foodparam INT;
 DECLARE no_service INT;
 DECLARE f_id INT;
 DECLARE check_food INT;
 DECLARE counts INT;
 DECLARE amount_req INT;
 DECLARE rem INT;
 SELECT fn_check_service() INTO no_service;
 SELECT is_food_valid(i_food_name) INTO check_food;
IF no_service=1 THEN 
 IF check_food=1 THEN
SELECT food_stocks.foodid INTO f_id FROM food JOIN food_stocks ON food_stocks.foodid=food.id JOIN foodtype ON food_stocks.mealid=foodtype.id
    WHERE food.food_name=i_food_name AND CURTIME() BETWEEN foodtype.from_time AND  foodtype.to_time;
  IF EXISTS(SELECT id FROM seats WHERE id=seat_number) THEN
  IF EXISTS(SELECT foodid FROM food_stocks WHERE foodid=f_id) THEN
   
   SELECT mealid INTO foodparam FROM food_stocks WHERE foodid=f_id;
    IF (foodparam IN(SELECT id FROM foodtype WHERE  from_time<=CURTIME() AND to_time>=CURTIME())) THEN
     IF (f_id IN(SELECT food_id FROM `food_transaction` WHERE DATE(date_of_order)=CURDATE()))
 THEN
	SELECT SUM(quantity) INTO counts FROM `food_transaction` WHERE food_id=f_id AND order_status='ORDERED';
	SELECT quantity INTO amount_req FROM `food_stocks` WHERE mealid=foodparam AND foodid=f_id;
	SET rem = amount_req - counts;
 
 ELSE
	SELECT quantity INTO amount_req FROM food_stocks WHERE mealid=foodparam AND foodid=f_id;
	SET rem=amount_req;
 END IF;
 IF (qty>rem) THEN
   SELECT 'ordered quantity is greater than remaining quantity';
   ELSE
       INSERT INTO food_transaction(seat_no,food_id,quantity) VALUES(seat_number,f_id,qty);
       SELECT 'Food ordered';
 END IF;
   ELSE
    SELECT 'Sorry food cannot be ordered due to time constraints' AS unordered;
    END IF;
   ELSE
   SELECT 'food not available at the moment' AS aplogies;
  END IF;
 ELSE
  SELECT 'Invalid seat number' AS invalid;  
 END IF;
 ELSE
 SELECT 'Food not in the list' AS invalid_food;
 END IF;
 ELSE
  SELECT 'Sorry.No service provided at this time' AS apologies;
  END IF;
 END$$

DELIMITER ;

