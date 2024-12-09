CREATE PROCEDURE DisplayCustomerPayments ()
BEGIN
    -- Declare variables for cursor
    DECLARE done INT DEFAULT 0;
    DECLARE customer_id INT;
    DECLARE total_payment DECIMAL(10,2);

    -- Declare a cursor
    DECLARE cur CURSOR FOR
    SELECT C.customer_id, IFNULL(SUM(P.amount_paid), 0) AS total_payment
    FROM Customers C
    LEFT JOIN Bookings B ON C.customer_id = B.customer_id
    LEFT JOIN Payments P ON B.booking_id = P.booking_id
    GROUP BY C.customer_id;

    -- Handle end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Create a temporary table to store the results
    CREATE TEMPORARY TABLE IF NOT EXISTS CustomerPayments (
        customer_id INT,
        total_payment DECIMAL(10, 2)
    );

    -- Open cursor
    OPEN cur;

    -- Loop through the cursor rows
    REPEAT
        FETCH cur INTO customer_id, total_payment;

        -- Store row in temporary table
        IF NOT done THEN
            INSERT INTO CustomerPayments (customer_id, total_payment)
            VALUES (customer_id, total_payment);
        END IF;

    UNTIL done END REPEAT;

    -- Close cursor
    CLOSE cur;

    -- Return results from the temporary table
    SELECT * FROM CustomerPayments;

    -- Drop the temporary table (optional, as it's session-specific)
    DROP TEMPORARY TABLE IF EXISTS CustomerPayments;
END