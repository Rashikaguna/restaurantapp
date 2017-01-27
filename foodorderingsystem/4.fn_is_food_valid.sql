DELIMITER$$
CREATE FUNCTION is_food_valid(i_foodname VARCHAR(30))
RETURNS BOOLEAN
BEGIN
RETURN EXISTS(SELECT id FROM food WHERE food_name=i_foodname);/*returns 1 if food is present in the table*/
END $$
DELIMITER ;

DELIMITER$$
CREATE FUNCTION fn_check_service()
RETURNS INT
BEGIN
RETURN EXISTS(SELECT id FROM foodtype WHERE CURTIME() BETWEEN from_time AND to_time);/* returns 1 if valid else 0*/
END $$
DELIMITER ;

DELIMITER$$
CREATE FUNCTION fn_check_service()
RETURNS INT
BEGIN
RETURN EXISTS(SELECT id FROM foodtype WHERE CURTIME() BETWEEN from_time AND to_time);/* returns 1 if valid else 0*/
END $$
DELIMITER ;
