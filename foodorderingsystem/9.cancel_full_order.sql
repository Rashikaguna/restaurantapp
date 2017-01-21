
/* Procedure to cancel one food*/
DELIMITER$$
CREATE PROCEDURE pr_cancel_full_order(IN i_order_param INT)
BEGIN
DECLARE qty_param INT;
DECLARE order_param INT;
DECLARE check_bill INT;
SELECT fn_check_order_no(i_order_param) INTO order_param;
SELECT `fn_check_billstatus`(i_order_param) INTO check_bill;
IF order_param=1 THEN
IF check_bill=1 THEN
    SELECT 'Cancellation failed because bill is paid';
ELSE
   UPDATE food_transaction SET order_status='cancelled'  WHERE order_no=i_order_param ;   
   SELECT 'Your order has been successfully cancelled' AS cancellation;
  END IF;
 ELSE
  SELECT 'Sorry cancellation failed.Please enter the correct order number' AS apologies;
  END IF;
END $$
DELIMITER ;