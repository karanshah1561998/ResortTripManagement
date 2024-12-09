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