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

-- AfterInsertBookings
DELIMITER //
CREATE TRIGGER AfterInsertBookings
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    INSERT INTO Logs (log_message, log_date)
    VALUES (CONCAT('New booking created: Booking ID = ', NEW.booking_id), NOW());
END //
DELIMITER ;

-- BeforeUpdatePayments
DELIMITER //
CREATE TRIGGER BeforeUpdatePayments
BEFORE UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.amount_paid < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount cannot be negative.';
    END IF;
END //
DELIMITER ;

-- AfterDeleteCustomers
DELIMITER //
CREATE TRIGGER AfterDeleteCustomers
AFTER DELETE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (log_message, log_date)
    VALUES (CONCAT('Customer deleted: Customer ID = ', OLD.customer_id), NOW());
END //
DELIMITER ;

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
