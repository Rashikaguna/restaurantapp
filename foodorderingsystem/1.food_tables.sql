/* table containing name of the food*/
CREATE TABLE food(
id INT PRIMARY KEY,
food_name VARCHAR(30)
)
INSERT INTO food VALUES(1,'idly'),(2,'Dosa'),(3,'vada'),(4,'Pori'),(5,'Pongal'),
(6,'Tea'),(7,'Coffee'),
(8,'SI meals'),(9,'NI thali'),
(10,'Variety rice'),(11,'coffee'),
(12,'tea'),
(13,'snacks'),
(14,'fried rice'),
(15,'roti'),
(16,'chats')



/*Table structure for table `foodtype` */
CREATE TABLE `foodtype` (
  `id` int(11) NOT NULL,
  `meal` varchar(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `from_time` time DEFAULT NULL,
  `to_time` time DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `foodtype` */

insert  into `foodtype`(`id`,`meal`,`quantity`,`from_time`,`to_time`) values 
(1,'Breakfast',100,'08:00:00','11:00:00'),
(2,'Lunch',75,'11:15:00','15:00:00'),
(3,'Refreshments',200,'15:15:00','23:00:00'),
(4,'Dinner',100,'19:00:00','23:00:00');


/* table for meal id,food name id,remaining of food*/
   CREATE TABLE food_stocks(
   sno INT PRIMARY KEY,
   mealid INT,
   foodid INT,
   quantity INT,
      CONSTRAINT meal_id_fk FOREIGN KEY(mealid) REFERENCES foodtype(id),
    CONSTRAINT food_id_fk FOREIGN KEY(foodid) REFERENCES food(id)
    )

SELECT * FROM food_stocks
INSERT INTO food_stocks(sno,mealid,foodid) VALUES(1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),
(6,1,6),(7,1,7),
(8,2,8),(9,2,9),
(10,2,10),(11,3,11),
(12,3,12),
(13,3,13),
(14,4,14),
(15,4,15),
(16,4,16)

/* table for seats verification*/
CREATE TABLE `seats` (
  `sno` int(11) NOT NULL,
  `id` int(11) DEFAULT NULL,
  `seat_status` varchar(20) DEFAULT 'available',
  `availability` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`sno`)
)
 INSERT INTO seats VALUES(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10)

/*table for order transaction*/
CREATE TABLE `food_transaction` ( 
 `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `seat_no` int(11) DEFAULT NULL, 
 `food_id` int(11) DEFAULT NULL, 
 `quantity` int(11) DEFAULT NULL, 
 `order_status` varchar(30) DEFAULT 'ordered',  
`date_of_order` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, 
 `bill_status` varchar(20) DEFAULT 'yet to pay', 
 PRIMARY KEY (`order_no`),  KEY `fk_food_id` (`food_id`), 
 CONSTRAINT `fk_food_id` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`),
 CONSTRAINT `fk_seatno` FOREIGN KEY (`seat_no`) REFERENCES `seats` (`sno`)
)




 