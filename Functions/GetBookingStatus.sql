CREATE FUNCTION GetBookingStatus (p_booking_id INT) RETURNS varchar(20)
    DETERMINISTIC
BEGIN
    DECLARE booking_status VARCHAR(20);

    SELECT status
    INTO booking_status
    FROM Bookings
    WHERE booking_id = p_booking_id;

    RETURN booking_status;
END