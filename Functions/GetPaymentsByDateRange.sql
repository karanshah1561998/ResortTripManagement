CREATE FUNCTION GetPaymentsByDateRange (p_start_date DATE, p_end_date DATE) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total_payment DECIMAL(10, 2);

    SELECT IFNULL(SUM(amount_paid), 0)
    INTO total_payment
    FROM Payments
    WHERE payment_date BETWEEN p_start_date AND p_end_date;

    RETURN total_payment;
END