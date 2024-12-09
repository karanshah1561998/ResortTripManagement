-- ViewFullyPaidBookings
CREATE OR REPLACE VIEW ViewFullyPaidBookings AS
SELECT 
    B.customer_id AS `Customer ID`,
    B.booking_id AS `Booking ID`,
    T.price AS `Trip Price`,
    IFNULL(SUM(P.amount_paid), 0) AS `Total Paid`
FROM 
    Bookings B
JOIN 
    Trips T ON B.trip_id = T.trip_id
LEFT JOIN 
    Payments P ON B.booking_id = P.booking_id
GROUP BY 
    B.customer_id, B.booking_id, T.price
HAVING 
    `Total Paid` >= T.price;
    
-- Show ViewFullyPaidBookings
SELECT * FROM ViewFullyPaidBookings;