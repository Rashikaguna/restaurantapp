
/*Function to check seat available or not*/
  DELIMITER$$
 CREATE FUNCTION fn_is_seat_available(i_id INT)
 RETURNS BOOLEAN
 BEGIN
 DECLARE flag BOOLEAN;
 IF EXISTS(SELECT id FROM seats WHERE  id=i_id AND seat_status='available') THEN
    IF EXISTS(SELECT id FROM seats WHERE id=i_id AND availability=0) THEN
     UPDATE seats SET availability=1 WHERE id=i_id;
     SET flag=TRUE;
     ELSE 
     SET flag=FALSE;
    END IF;
 END IF;
 RETURN flag;
  END $$
  DELIMITER ;

/*procedure to order 5 food items*/
DELIMITER$$
  CREATE PROCEDURE pr_place_orders(IN i_seat INT,IN list_of_items MEDIUMTEXT,IN quantity_of_items MEDIUMTEXT)
    BEGIN
          DECLARE next_item TEXT DEFAULT NULL ;
          DECLARE item_qty TEXT DEFAULT NULL;
          DECLARE next_qty INT DEFAULT NULL;
          DECLARE _nextlen INT DEFAULT NULL;
          DECLARE _value TEXT DEFAULT NULL;
          DECLARE _val TEXT DEFAULT NULL;
           DECLARE seat_no BOOLEAN;

            DECLARE temp INT;
                SET temp = (LENGTH(list_of_items)-LENGTH(REPLACE(list_of_items,',',''))) + 1;
          IF (temp<=5) THEN 
       SELECT fn_is_seat_available(i_seat) INTO seat_no;
   IF seat_no=TRUE THEN
 UPDATE seats SET seat_status='unavailable'  WHERE id=i_seat;
         iterator :
         LOOP   
            IF LENGTH(TRIM(list_of_items)) = 0 OR list_of_items IS NULL THEN
              LEAVE iterator;
              END IF;
                SET next_item = SUBSTRING_INDEX(list_of_items,',',1); 
                SET item_qty=SUBSTRING_INDEX(quantity_of_items,',',1);
                 SET _nextlen = LENGTH(next_item);
                 SET next_qty = LENGTH(item_qty);
                 SET _value = TRIM(next_item);
                 SET _val= TRIM(item_qty);

               SET list_of_items = INSERT(list_of_items,1,_nextlen + 1,'');
               SET quantity_of_items = INSERT(quantity_of_items,1,next_qty + 1,'');
                CALL `pr_order_onefood`(i_seat,next_item,item_qty);
   SELECT food_transaction.order_no,food_transaction.seat_no,food.food_name,food_transaction.quantity 
   FROM food_transaction JOIN food 
   ON food_transaction.food_id=food.id WHERE food_transaction.seat_no=i_seat AND food_transaction.date_of_order=NOW() ;
         END LOOP;
                 UPDATE seats SET  seat_status='available',availability=0 WHERE id=i_seat;

      END IF;
      ELSE
        SELECT 'You can order only 5 items' AS comments;
        END IF;
        
    END $$
  DELIMITER ;