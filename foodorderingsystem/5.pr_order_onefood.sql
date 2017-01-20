 /* Procedure to check quantity constraints */
 DELIMITER $$
CREATE PROCEDURE update_stock(IN i_seatparam INT, IN f_id INT, IN i_qty INT)
BEGIN 
DECLARE remaining_qty INT;
IF i_qty>0 THEN    /* Checking whether the given quantity of food is not negative*/
  SELECT remaining INTO remaining_qty FROM food_stocks WHERE foodid=f_id;
  IF  remaining_qty <>0   THEN      /* to check whether the food is in stock or not*/
   IF remaining_qty >=i_qty THEN /*to check whether the quantity ordered is not greater than the remaining quantity of the given food */
     UPDATE food_stocks SET remaining=remaining-i_qty WHERE foodid=f_id ;
        INSERT INTO food_transaction(seat_no,food_id,quantity) VALUES(i_seatparam,f_id,i_qty);
          SELECT  'Food is ordered.';
   ELSE
     SELECT 'Quantity ordered is greater than remaining quantity';
   END IF;
ELSE 
  SELECT 'Sorry, this particular food is over';
END IF;
ELSE
 SELECT 'Please enter a valid quantity ';
 END IF;
 END $$
DELIMITER ;


/* Function to check no service*/
DELIMITER $$
DROP FUNCTION IF EXISTS `checkservice`$$

CREATE  FUNCTION `checkservice`()
 RETURNS INT
BEGIN
         
    IF (CURTIME() BETWEEN (SELECT to_Time FROM `foodtype` WHERE foodtype.`id`=1) AND (SELECT from_Time FROM foodtype WHERE foodtype.`id`=2)) THEN
      
       
       RETURN 0; /* 0 indicates No service */
   ELSEIF (CURTIME() BETWEEN (SELECT to_Time FROM `foodtype` WHERE foodtype.`id`=2) AND (SELECT from_Time FROM foodtype WHERE foodtype.`id`=3))  THEN 
       RETURN 0;/* 0 indicates No service */
       
    ELSEIF (CURTIME() > (SELECT to_Time FROM foodtype WHERE foodtype.`id`=3)) THEN
    
       RETURN 0; /* 0 indicates No service */
       
           ELSEIF (CURTIME() > (SELECT to_Time FROM foodtype WHERE foodtype.`id`=4)) THEN
    
      RETURN 0; /* 0 indicates No service */
     END IF; 
      RETURN 1 ;      /* 1 indicates order in process */ 
    END$$

DELIMITER ;
   CALL pr_order_onefood(1,'idly',5)
   
  /* Procedure to order a single food*/ /*food not in the list under construction*/
 DELIMITER$$
 CREATE PROCEDURE pr_order_onefood(IN seat_number INT,IN i_food_name VARCHAR(100),IN qty INT)
 BEGIN
 DECLARE foodparam INT;
 DECLARE no_service INT;
 DECLARE f_id INT;
 DECLARE check_food INT;
 SELECT checkservice() INTO no_service;
 SELECT is_food_valid(i_food_name) INTO check_food;
IF no_service=1 THEN 
 IF check_food=1 THEN
SELECT food_stocks.foodid INTO f_id FROM food JOIN food_stocks ON food_stocks.foodid=food.id JOIN foodtype ON food_stocks.mealid=foodtype.id
    WHERE food.food_name=i_food_name AND CURTIME() BETWEEN foodtype.from_time AND  foodtype.to_time;
  IF EXISTS(SELECT id FROM seats WHERE id=seat_number) THEN
  IF EXISTS(SELECT foodid FROM food_stocks WHERE foodid=f_id) THEN
   
   SELECT mealid INTO foodparam FROM food_stocks WHERE foodid=f_id;
    IF (foodparam IN(SELECT id FROM foodtype WHERE  from_time<=CURTIME() AND to_time>=CURTIME())) THEN
   CALL update_stock(seat_number,f_id,qty);
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
 SELECT 'FOod not in the list' AS invalid_food;
 END IF;
 ELSE
  SELECT 'Sorry.No service provided at this time' AS apologies;
  END IF;
 END $$
 DELIMITER ; 
