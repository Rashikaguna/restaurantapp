DELIMITER$$
CREATE FUNCTION is_food_valid(i_foodname VARCHAR(30))
RETURNS BOOLEAN
BEGIN
RETURN EXISTS(SELECT id FROM food WHERE food_name=i_foodname);/*returns 1 if food is present in the table*/
END $$
DELIMITER ;
