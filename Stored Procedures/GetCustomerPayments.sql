CREATE PROCEDURE GetCustomerPayments (
    IN p_customer_id INT,                 -- Input parameter for customer ID
    OUT p_total_payment DECIMAL(10,2)    -- Output parameter for total payment
)
BEGIN
    -- Check if the customer exists
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customer_id = p_customer_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist.';
    END IF;

    -- Check if the customer has bookings
    IF NOT EXISTS (SELECT 1 FROM Bookings WHERE customer_id = p_customer_id) THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Customer has no bookings.';
    END IF;

    -- Check if the customer has payments
    IF NOT EXISTS (
        SELECT 1
        FROM Payments P
        JOIN Bookings B ON P.booking_id = B.booking_id
        WHERE B.customer_id = p_customer_id
    ) THEN
        SIGNAL SQLSTATE '45002'
        SET MESSAGE_TEXT = 'Customer has no payments.';
    END IF;

    -- Check if there are invalid payments
    IF EXISTS (
        SELECT 1
        FROM Payments P
        JOIN Bookings B ON P.booking_id = B.booking_id
        WHERE B.customer_id = p_customer_id AND P.amount_paid < 0
    ) THEN
        SIGNAL SQLSTATE '45003'
        SET MESSAGE_TEXT = 'Invalid payment amount detected.';
    END IF;

    -- Calculate the total amount paid by the customer
    SELECT IFNULL(SUM(P.amount_paid), 0) -- Use IFNULL to handle cases where no payments exist
    INTO p_total_payment
    FROM Payments P
    JOIN Bookings B ON P.booking_id = B.booking_id
    WHERE B.customer_id = p_customer_id; -- Match the customer ID
END