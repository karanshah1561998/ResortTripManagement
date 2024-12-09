-- ViewCustomerPaymentSummary
CREATE OR REPLACE VIEW ViewCustomerPaymentSummary AS
SELECT 
    C.customer_id AS `Customer ID`,
    C.name AS `Customer Name`,
    IFNULL(SUM(P.amount_paid), 0) AS `Total Paid`
FROM 
    Customers C
LEFT JOIN 
    Bookings B ON C.customer_id = B.customer_id
LEFT JOIN 
    Payments P ON B.booking_id = P.booking_id
GROUP BY 
    C.customer_id, C.name;
    
-- Show ViewCustomerPaymentSummary
SELECT * FROM ViewCustomerPaymentSummary;