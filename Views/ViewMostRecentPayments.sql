-- ViewMostRecentPayments
CREATE OR REPLACE VIEW ViewMostRecentPayments AS
SELECT 
    P.payment_id,
    P.booking_id,
    B.customer_id,
    MAX(P.payment_date) AS `Most Recent Payment Date`,
    P.amount_paid
FROM 
    Payments P
JOIN 
    Bookings B ON P.booking_id = B.booking_id
GROUP BY 
    P.payment_id, P.booking_id, B.customer_id;

-- Show ViewMostRecentPayments
SELECT * FROM ViewMostRecentPayments;