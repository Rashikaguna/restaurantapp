/* procedure to pay the bill*/
DELIMITER$$
   CREATE PROCEDURE pay_bill(IN i_orderno INT)
   BEGIN
   UPDATE food_transaction SET bill_status='paid' WHERE order_no=i_orderno;
   END $$
   DELIMITER ;