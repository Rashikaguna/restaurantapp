/*funtion to check bill status*/
   DELIMITER $$
   CREATE FUNCTION fn_check_billstatus(i_order_no INT)
   RETURNS BOOLEAN
   BEGIN
      RETURN (SELECT bill_status FROM food_transaction WHERE order_no=i_order_no)='paid' ; /* returns 1 if billstatus is paid*/
END $$
DELIMITER ;