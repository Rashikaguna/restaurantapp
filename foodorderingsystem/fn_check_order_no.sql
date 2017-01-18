 /* function to check order number*/
 DELIMITER $$
 CREATE FUNCTION fn_check_order_no(i_order_no INT)
 RETURNS BOOLEAN
 BEGIN
 RETURN  EXISTS(SELECT order_no FROM food_transaction WHERE order_no=i_order_no ); /*1 - true  0-false*/
 END $$
 DELIMITER ;