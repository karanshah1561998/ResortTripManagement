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