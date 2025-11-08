 -- Part 1 --

-- Took 30.407 secs --
DROP TABLE IF EXISTS num_table;
DELIMITER //
CREATE PROCEDURE myCreateTable(IN num_entries INT)
BEGIN
	-- Variable to store the random integer
	DECLARE random_value INT;
    
    -- Variable for while loop
    DECLARE i INT DEFAULT 0;

    -- Create the table
    CREATE TABLE num_table (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        random_int INT
    );

    -- Loop to insert entries
    WHILE i < num_entries DO
        -- Generate random integer between 0 and 1000
        SET random_value = FLOOR(RAND() * 1000);

        -- Insert entry into the table
        INSERT INTO num_table (random_int) VALUES (random_value);

        -- Increment counter
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL myCreateTable(20000);

-- Took 9.047 secs --
DELIMITER //
CREATE PROCEDURE mySelectTest(IN target_value INT, IN num_selects INT)
BEGIN
	-- Variable to store the count for the target value
	DECLARE count_result INT;

	-- Variable for while loop
    DECLARE i INT DEFAULT 0;
    
    -- Loop to insert entries
    WHILE i < num_selects DO
		-- Execute select and store the count in the variable
        SELECT COUNT(*) INTO count_result
        FROM num_table
		WHERE random_int = target_value;
        
        -- Increment counter
        SET i = i + 1;
    END WHILE;
    SELECT count_result;
END //
DELIMITER ;
CALL mySelectTest(50, 1000);

-- Running myCreateTable procedure took 32.859 secs --
-- Running mySelectTest procedure took 0.250 secs --
DROP TABLE IF EXISTS num_table;
DELIMITER //
CREATE PROCEDURE myCreateTable(IN num_entries INT)
BEGIN
	-- Variable to store the random integer
	DECLARE random_value INT;
    
    -- Variable for while loop
    DECLARE i INT DEFAULT 0;

    -- Create the table
    CREATE TABLE num_table (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        random_int INT,
        INDEX idx_random_int(random_int)
    );

    -- Loop to insert entries
    WHILE i < num_entries DO
        -- Generate random integer between 0 and 1000
        SET random_value = FLOOR(RAND() * 1000);

        -- Insert entry into the table
        INSERT INTO num_table (random_int) VALUES (random_value);

        -- Increment counter
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;
CALL myCreateTable(20000);

-- Part 2 --
-- Creates an empty table --
CREATE TABLE candy_matview (
    view_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_name VARCHAR(30),
    cust_type_desc VARCHAR(10),
    prod_desc VARCHAR(30),
    pounds FLOAT
);

-- Bulk insert of data into candy_matview table --
INSERT INTO candy_matview (cust_name, cust_type_desc, prod_desc, pounds)
SELECT cust_name, cust_type_desc, prod_desc, pounds
FROM candy_customer INNER JOIN candy_cust_type ON candy_customer.cust_type = candy_cust_type.cust_type INNER JOIN candy_purchase ON candy_purchase.cust_id = candy_customer.cust_id INNER JOIN candy_product ON candy_purchase.prod_id = candy_product.prod_id;

SELECT * FROM candy_matview;

DROP TRIGGER IF EXISTS update_matview_insert;
-- Creates a trigger that stores newly inserted row into candy_purchase table into candy_matview table --
DELIMITER //
CREATE TRIGGER update_matview_insert
AFTER INSERT ON candy_purchase
FOR EACH ROW
BEGIN
    INSERT INTO candy_matview (cust_name, cust_type_desc, prod_desc, pounds)
    SELECT cust_name, cust_type_desc, prod_desc, pounds
    FROM candy_customer INNER JOIN candy_cust_type ON candy_customer.cust_type = candy_cust_type.cust_type INNER JOIN candy_purchase ON candy_purchase.cust_id = candy_customer.cust_id INNER JOIN candy_product ON candy_purchase.prod_id = candy_product.prod_id
    WHERE candy_purchase.cust_id = NEW.cust_id AND candy_product.prod_id = NEW.prod_id;
END //
DELIMITER ;

-- Inserts row into candy_purchase table --
INSERT INTO candy_purchase VALUES
(100, (select prod_id from candy_product where prod_desc = 'Nuts Not Nachos'), (select cust_id from candy_customer where cust_name = 'The Candy Kid'), '2020-11-2', '2020-11-6', 5.2, 'PAID');

SELECT * FROM candy_matview;
