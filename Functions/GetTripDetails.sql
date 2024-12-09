CREATE FUNCTION GetTripDetails (p_booking_id INT) RETURNS json
    DETERMINISTIC
BEGIN
    DECLARE trip_details JSON;

    SELECT JSON_OBJECT(
        'destination', T.destination,
        'start_date', T.start_date,
        'end_date', T.end_date,
        'price', T.price
    )
    INTO trip_details
    FROM Bookings B
    JOIN Trips T ON B.trip_id = T.trip_id
    WHERE B.booking_id = p_booking_id;

    RETURN trip_details;
END