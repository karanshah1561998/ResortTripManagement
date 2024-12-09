-- BeforeUpdateBookings
DELIMITER //
CREATE TRIGGER BeforeUpdateBookings
BEFORE UPDATE ON Bookings
FOR EACH ROW
BEGIN
    DECLARE total_payment DECIMAL(10, 2);
    DECLARE trip_price DECIMAL(10, 2);

    SELECT IFNULL(SUM(P.amount_paid), 0) INTO total_payment
    FROM Payments P
    WHERE P.booking_id = NEW.booking_id;

    SELECT T.price INTO trip_price
    FROM Trips T
    JOIN Bookings B ON T.trip_id = B.trip_id
    WHERE B.booking_id = NEW.booking_id;

    IF NEW.status = 'CONFIRMED' AND total_payment < trip_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot confirm booking with pending payments.';
    END IF;
END //
DELIMITER ;