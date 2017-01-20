/*procedure to order 5 food items*/
DELIMITER$$
  CREATE PROCEDURE place_orders(IN seatno INT,IN list_of_items MEDIUMTEXT,IN quantity_of_items MEDIUMTEXT)
    BEGIN
          DECLARE _next TEXT DEFAULT NULL ;
          DECLARE _q TEXT DEFAULT NULL;
          DECLARE _qnext INT DEFAULT NULL;
          DECLARE _nextlen INT DEFAULT NULL;
          DECLARE _value TEXT DEFAULT NULL;
          DECLARE _val TEXT DEFAULT NULL;
            DECLARE temp INT;
                SET temp = (LENGTH(list_of_items)-LENGTH(REPLACE(list_of_items,',',''))) + 1;
          IF (temp<=5) THEN 
         iterator :
         LOOP   
            IF LENGTH(TRIM(list_of_items)) = 0 OR list_of_items IS NULL THEN
              LEAVE iterator;
              END IF;
                SET _next = SUBSTRING_INDEX(list_of_items,',',1); 
                SET _q=SUBSTRING_INDEX(quantity_of_items,',',1);
                 SET _nextlen = LENGTH(_next);
                 SET _qnext = LENGTH(_q);
                 SET _value = TRIM(_next);
                 SET _val= TRIM(_q);

               SET list_of_items = INSERT(list_of_items,1,_nextlen + 1,'');
               SET quantity_of_items = INSERT(quantity_of_items,1,_qnext + 1,'');
                CALL `pr_order_onefood`(seatno,_next,_q);
             END LOOP;
   SELECT food_transaction.order_no,food_transaction.seat_no,food.food_name,food_transaction.quantity 
   FROM food_transaction JOIN food 
   ON food_transaction.food_id=food.id WHERE food_transaction.seat_no=seatno AND food_transaction.date_of_order=NOW() ;

       ELSE
        SELECT 'You can order only 5 items' AS comments;
        END IF; 
    END $$
  DELIMITER ;
