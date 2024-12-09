CREATE FUNCTION IsBookingFullyPaid (p_booking_id INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE total_payment DECIMAL(10, 2);
    DECLARE trip_price DECIMAL(10, 2);

    SELECT IFNULL(SUM(P.amount_paid), 0)
    INTO total_payment
    FROM Payments P
    WHERE P.booking_id = p_booking_id;

    SELECT T.price
    INTO trip_price
    FROM Bookings B
    JOIN Trips T ON B.trip_id = T.trip_id
    WHERE B.booking_id = p_booking_id;

    RETURN total_payment >= trip_price;
END