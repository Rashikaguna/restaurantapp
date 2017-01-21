DELIMITER $$                                                                              
CREATE PROCEDURE pr_sub_cancel(IN mealnumber INT,IN foodparam INT, IN i_order INT,IN i_qty INT)
BEGIN
 IF (mealnumber IN(SELECT id FROM foodtype WHERE  from_time<=CURTIME() AND to_time>=CURTIME())) THEN
   UPDATE food_transaction SET quantity=quantity-i_qty WHERE  order_no=i_order;
ELSE
SELECT 'Sorry it is too late. Cancellation cannot be done' AS apologies;
END IF;
END $$
DELIMITER ;

/*procedure to cancel some quantity of ordered food */
DELIMITER $$
CREATE PROCEDURE pr_cancel_perfoodquantity(IN i_orderparam INT,IN quantityparam INT)
BEGIN
DECLARE foodparam INT;
DECLARE foodnumber INT;
DECLARE q_param INT;
DECLARE order_param INT;
DECLARE check_bill INT;
SELECT fn_check_order_no(i_orderparam) INTO order_param;
SELECT fn_check_billstatus(i_orderparam)INTO check_bill;
 IF check_bill = 1 THEN
 SELECT 'Cancellation failed because bill is paid';
 ELSE IF order_param=1 THEN
SELECT food_id INTO foodparam FROM food_transaction WHERE order_no=i_orderparam ;
SELECT mealid INTO foodnumber FROM `food_stocks` WHERE foodid=foodparam;
SELECT quantity INTO q_param FROM food_transaction WHERE order_no=i_orderparam;
IF (quantityparam < q_param) THEN
CALL pr_sub_cancel(foodnumber,foodparam,i_orderparam,quantityparam);
ELSE
   SELECT 'Sorry,you are trying to cancel a greater quantity than ordered.Enter a valid quantity' AS comments;
 END IF;
ELSE
 SELECT 'Invalid order number.Please enter a valid order number' AS comments;
 END IF;
 END IF;
 SELECT 'Your order has been successfully cancelled' AS cancellation;
END $$
DELIMITER ;
