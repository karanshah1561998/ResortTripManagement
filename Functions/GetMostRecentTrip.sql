CREATE FUNCTION GetMostRecentTrip (p_customer_id INT) RETURNS varchar(100)
    DETERMINISTIC
BEGIN
    DECLARE recent_trip_destination VARCHAR(100);

    SELECT T.destination
    INTO recent_trip_destination
    FROM Bookings B
    JOIN Trips T ON B.trip_id = T.trip_id
    WHERE B.customer_id = p_customer_id
    ORDER BY B.booking_date DESC
    LIMIT 1;

    RETURN recent_trip_destination;
END