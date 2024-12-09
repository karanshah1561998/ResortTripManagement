CREATE FUNCTION GetTripTotalEarnings (p_trip_id INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total_earnings DECIMAL(10, 2);

    SELECT IFNULL(SUM(P.amount_paid), 0)
    INTO total_earnings
    FROM Payments P
    JOIN Bookings B ON P.booking_id = B.booking_id
    WHERE B.trip_id = p_trip_id;

    RETURN total_earnings;
END