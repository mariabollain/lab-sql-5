use sakila;

# Drop column picture from staff.

ALTER TABLE staff
DROP COLUMN picture;

# A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

SELECT * FROM staff;

SELECT * FROM customer
WHERE first_name = "Tammy" AND last_name = "Sanders";

INSERT INTO staff VALUES (3,"Tammy","Sanders",79,"Tammy.Sanders@sakilastaff.com",2,1,"","", "2023-02-25 12:09:00");

# Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

SELECT * FROM rental
ORDER BY rental_id DESC
LIMIT 1;

select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER'; # customer id is 130

SELECT * FROM film
WHERE title regexp "Academy Dinosaur"; # film id is 1, rental duration is 6 days

SELECT * FROM inventory
WHERE film_id = 1 AND store_id = 1; # there are 4 copies of the movie in store 1: inventory_id 1,2,3 and 4

# I'm going to check if they are all available 

SELECT * FROM rental
WHERE inventory_id = 1 OR inventory_id = 2 OR inventory_id =3 OR inventory_id =4; 
# all have been returned so I will use inventory_id = 1

SELECT staff_id FROM staff
WHERE first_name = "Mike" AND last_name = "Hillyer"; # staff id is 1

INSERT INTO rental VALUES (16050,"2023-02-25 12:12:00",1,130,"2023-03-03 12:12:00",1,"2023-02-25 12:12:00");

# Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

## Check if there are any non-active users

SELECT * FROM customer
WHERE active = 0;

## Create a table backup table as suggested

CREATE TABLE backup_table (
    customer_id int(11) default null,
    store_id int(11) default null,
    first_name text,
    last_name text,
    email text,
    address_id int(11) default null,
    active BOOLEAN,
    create_date DATETIME,
    last_update DATETIME
);

SELECT * FROM backup_table;

## Insert the non active users in the table backup table


INSERT INTO backup_table VALUES (16,2,"SANDRA","MARTIN","SANDRA.MARTIN@sakilacustomer.org",20,0,"2006-02-14 22:04:36","2006-02-15 04:57:20"), 
(64,2,"JUDITH","COX","JUDITH.COX@sakilacustomer.org",68,0,"2006-02-14 22:04:36","2006-02-15 04:57:20"), 
(124,1,"SHEILA","WELLS","SHEILA.WELLS@sakilacustomer.org",128,0,"2006-02-14 22:04:36","2006-02-15 04:57:20"),
(169,2,"ERICA","MATTHEWS","ERICA.MATTHEWS@sakilacustomer.org",173,0,"2006-02-14 22:04:36","2006-02-15 04:57:20"),
(241,2,"HEIDI","LARSON","HEIDI.LARSON@sakilacustomer.org",245,0,"2006-02-14 22:04:36","2006-02-15 04:57:20"),
(271,1,"PENNY","NEAL","PENNY.NEAL@sakilacustomer.org",276,0,"2006-02-14 22:04:36","2006-02-15 04:57:20"),
(315,2,"KENNETH","GOODEN","KENNETH.GOODEN@sakilacustomer.org",320,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"),
(368,1,"HARRY","ARCE","HARRY.ARCE@sakilacustomer.org",373,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"),
(406,1,"NATHAN","RUNYON","NATHAN.RUNYON@sakilacustomer.org",411,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"),
(446,2,"THEODORE","CULP","THEODORE.CULP@sakilacustomer.org",451,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"),
(482,1,"MAURICE","CRAWLEY","MAURICE.CRAWLEY@sakilacustomer.org",487,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"),
(510,2,"BEN","EASTER","BEN.EASTER@sakilacustomer.org",515,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"), 
(534,1,"CHRISTIAN","JUNG","CHRISTIAN.JUNG@sakilacustomer.org",540,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"), 
(558,1,"JIMMIE","EGGLESTON","JIMMIE.EGGLESTON@sakilacustomer.org",564,0,"2006-02-14 22:04:37","2006-02-15 04:57:20"), 
(592,1,"TERRANCE","ROUSH","TERRANCE.ROUSH@sakilacustomer.org",598,0,"2006-02-14 22:04:37","2006-02-15 04:57:20");

# Another (much better) way 

CREATE TABLE backup_table2 AS
    SELECT customer_id,store_id,first_name,last_name,email,address_id,active,create_date,last_update
    FROM customer
    WHERE active = 0;

SELECT * FROM backup_table2;

## Delete the non active users from the table customer

SET SQL_SAFE_UPDATES = 0;
DELETE FROM customer 
WHERE active = 0; 
SET SQL_SAFE_UPDATES = 1;

# with this I get an error, "a foreign key constraint fails", because this customer_id appears as a foreign key in other tables in the database. 
# To maintain the integrity, I should delete those rows too in the other tables.
# Nevertheless, If I still wanted to delete the rows in the customer table without deleting the others, I could use:
#SET FOREIGN_KEY_CHECKS=0;
#SET FOREIGN_KEY_CHECKS=1;