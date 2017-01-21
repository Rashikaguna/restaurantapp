/* Procedure to set the quantity for the foods */
DELIMITER$$
CREATE PROCEDURE set_stock()
BEGIN
DECLARE id_param INT DEFAULT 1;
REPEAT
UPDATE food_stocks SET quantity=(SELECT quantity FROM foodtype WHERE id=id_param) WHERE mealid=id_param ;
SET id_param= id_param+1;
UNTIL (id_param>4) 
 END REPEAT; 
END $$
DELIMITER ;