CREATE FUNCTION GetCustomerAddress (p_customer_id INT) RETURNS text
    DETERMINISTIC
BEGIN
    DECLARE customer_address TEXT;

    SELECT address
    INTO customer_address
    FROM Customers
    WHERE customer_id = p_customer_id;

    RETURN customer_address;
END