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