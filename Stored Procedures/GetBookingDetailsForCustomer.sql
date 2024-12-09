CREATE PROCEDURE GetBookingDetailsForCustomer (
    IN p_customer_id INT
)
BEGIN
    -- Check if customer exists
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customer_id = p_customer_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist.';
    END IF;

    -- Fetch booking details
    SELECT B.booking_id, B.booking_date, B.status, T.destination, T.start_date, T.end_date, T.price,
           IFNULL(SUM(P.amount_paid), 0) AS total_paid,
           CASE
               WHEN IFNULL(SUM(P.amount_paid), 0) >= T.price THEN 'Fully Paid'
               ELSE 'Pending'
           END AS payment_status
    FROM Bookings B
    JOIN Trips T ON B.trip_id = T.trip_id
    LEFT JOIN Payments P ON B.booking_id = P.booking_id
    WHERE B.customer_id = p_customer_id
    GROUP BY B.booking_id;
END