CREATE PROCEDURE AddBooking(
    IN p_customer_id INT, -- Input parameter for customer ID
    IN p_trip_id INT      -- Input parameter for trip ID
)
BEGIN
    -- Check if the customer exists
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customer_id = p_customer_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist.';
    END IF;

    -- Check if the trip exists
    IF NOT EXISTS (SELECT 1 FROM Trips WHERE trip_id = p_trip_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Trip does not exist.';
    END IF;

    -- Insert a new booking into the Bookings table
    INSERT INTO Bookings (customer_id, trip_id, booking_date, status)
    VALUES (p_customer_id, p_trip_id, CURRENT_TIMESTAMP, 'CONFIRMED');
END;
