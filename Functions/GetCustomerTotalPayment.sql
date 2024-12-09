CREATE FUNCTION GetCustomerTotalPayment (p_customer_id INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total_payment DECIMAL(10, 2);

    SELECT IFNULL(SUM(P.amount_paid), 0) 
    INTO total_payment
    FROM Payments P
    JOIN Bookings B ON P.booking_id = B.booking_id
    WHERE B.customer_id = p_customer_id;

    RETURN total_payment;
END