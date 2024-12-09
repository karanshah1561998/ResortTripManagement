-- ViewPendingPayments
CREATE OR REPLACE VIEW ViewPendingPayments AS
SELECT 
    B.customer_id AS `Customer ID`, 
    B.booking_id AS `Booking ID`, 
    IFNULL(SUM(P.amount_paid), 0) AS `Total Paid`, 
    T.price AS `Trip Price`,
    (T.price - IFNULL(SUM(P.amount_paid), 0)) AS `Pending Payment`
FROM 
    Bookings B
JOIN 
    Trips T ON B.trip_id = T.trip_id
LEFT JOIN 
    Payments P ON B.booking_id = P.booking_id
GROUP BY 
    B.customer_id, B.booking_id, T.price
HAVING 
    `Pending Payment` > 0;
    
-- Show ViewPendingPayments
SELECT * FROM ViewPendingPayments;