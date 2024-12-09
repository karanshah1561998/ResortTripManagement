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
