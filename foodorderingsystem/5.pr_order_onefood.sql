/* Procedure to check quantity constraints */
 DROP PROCEDURE pr_update_remainingstock
 DELIMITER $$
CREATE PROCEDURE pr_update_remainingstock(IN i_seatparam INT, IN i_f_id INT, IN i_qty INT)
BEGIN 
DECLARE sum_qty INT;         
DECLARE qty INT;
DECLARE remaining_qty INT;
 IF i_f_id IN(SELECT food_id FROM `food_transaction` WHERE DATE(date_of_order)=CURDATE()) THEN 
    SELECT quantity INTO qty FROM food_stocks WHERE foodid=i_f_id; 
    SELECT SUM(quantity) INTO sum_qty FROM food_transaction WHERE food_id=i_f_id AND order_status='ordered';
    SET remaining_qty=qty-sum_qty;
     ELSE
 SELECT quantity INTO qty FROM food_stocks WHERE foodid=i_f_id; 
 SET remaining_qty=qty;
 END IF;
  IF remaining_qty <> 0 THEN
        IF remaining_qty>=i_qty THEN
 START TRANSACTION;
        SET autocommit=0;
         INSERT INTO food_transaction(seat_no,food_id,quantity) VALUES(i_seatparam,i_f_id,i_qty);
        COMMIT;
        SELECT  'Food is ordered.';
        ELSE   
         SELECT 'Quantity ordered is greater than remaining quantity';
        END IF;
ELSE 
  SELECT 'Sorry, this particular food is over';
END IF; 
 END $$    
DELIMITER ;



/* Procedure to order a single food*/ 
 DELIMITER$$
 CREATE PROCEDURE pr_order_onefood(IN seat_number INT,IN i_food_name VARCHAR(100),IN qty INT)
 BEGIN
 DECLARE foodparam INT;
 DECLARE no_service INT;
 DECLARE f_id INT;
 DECLARE check_food INT;
 SELECT fn_check_service() INTO no_service;
 SELECT is_food_valid(i_food_name) INTO check_food;
IF no_service=1 THEN 
 IF check_food=1 THEN
SELECT food_stocks.foodid INTO f_id FROM food JOIN food_stocks ON food_stocks.foodid=food.id JOIN foodtype ON food_stocks.mealid=foodtype.id
    WHERE food.food_name=i_food_name AND CURTIME() BETWEEN foodtype.from_time AND  foodtype.to_time;
 
    IF EXISTS(SELECT foodid FROM food_stocks WHERE foodid=f_id) THEN
   
   SELECT mealid INTO foodparam FROM food_stocks WHERE foodid=f_id;
    IF (foodparam IN(SELECT id FROM foodtype WHERE  from_time<=CURTIME() AND to_time>=CURTIME())) THEN
   CALL pr_update_remainingstock(seat_number,f_id,qty);
   ELSE
    SELECT 'Sorry food cannot be ordered due to time constraints' AS unordered;
    END IF;
   ELSE
   SELECT 'food not available at the moment' AS aplogies;
  END IF;
 ELSE
 SELECT 'Food not in the list' AS invalid_food;
 END IF;
 ELSE
  SELECT 'Sorry.No service provided at this time' AS apologies;
  END IF;
 END $$
 DELIMITER ; 