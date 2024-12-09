CREATE FUNCTION GetCustomerBookingCount (p_customer_id INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM Bookings
    WHERE customer_id = p_customer_id;

    RETURN booking_count;
END