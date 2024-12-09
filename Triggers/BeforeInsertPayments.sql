-- BeforeInsertPayments
DELIMITER //
CREATE TRIGGER BeforeInsertPayments
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE trip_price DECIMAL(10, 2);
    DECLARE total_paid DECIMAL(10, 2);

    SELECT T.price INTO trip_price
    FROM Bookings B
    JOIN Trips T ON B.trip_id = T.trip_id
    WHERE B.booking_id = NEW.booking_id;

    SELECT IFNULL(SUM(amount_paid), 0) INTO total_paid
    FROM Payments
    WHERE booking_id = NEW.booking_id;

    IF (total_paid + NEW.amount_paid) > trip_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total payment exceeds trip price.';
    END IF;
END //
DELIMITER ;