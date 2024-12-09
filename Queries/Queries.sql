-- View all Customers | Trips | Bookings | Payments
SELECT * FROM Customers;
SELECT * FROM Trips;
SELECT * FROM Bookings;
SELECT * FROM Payments;

-- Find Id for Customers | Trips | Bookings | Payments 
SELECT customer_id FROM Customers;
SELECT trip_id FROM Trips;
SELECT booking_id FROM Bookings;
SELECT payment_id FROM Payments;

-- Stored Procedures
CALL AddBooking(200, 20);
CALL GetCustomerPayments(191, @total_payment); SELECT @total_payment;
CALL GetBookingDetailsForCustomer(101); -- Replace with a valid customer_id

-- Cursors
CALL DisplayCustomerPayments();
CALL DisplayPendingPayments();

-- Functions
SELECT GetCustomerTotalPayment(191);
SELECT GetCustomerBookingCount(191);
SELECT GetBookingStatus(191);
SELECT GetTripDetails(150);
SELECT GetTripTotalEarnings(5);
SELECT GetCustomerAddress(191);
SELECT GetMostRecentTrip(191);
SELECT IsBookingFullyPaid(150);
SELECT GetPaymentsByDateRange('2024-11-01', '2024-12-01');


-- Verify
SHOW PROCEDURE STATUS WHERE Db = 'resort_trip_management';
SHOW GRANTS FOR CURRENT_USER;

-- Verify Payments SP
SELECT * FROM Bookings WHERE customer_id = 101;
SELECT * FROM Payments WHERE booking_id IN (SELECT booking_id FROM Bookings WHERE customer_id = 101);
SELECT * FROM Customers WHERE customer_id = 101;
SELECT * FROM Payments WHERE booking_id IN (SELECT booking_id FROM Bookings WHERE customer_id = 101);
SELECT P.amount_paid, B.customer_id FROM Payments P JOIN Bookings B ON P.booking_id = B.booking_id WHERE B.customer_id = 101;
SELECT * FROM Bookings WHERE customer_id = 101;
SELECT * FROM Payments WHERE booking_id IN (SELECT booking_id FROM Bookings WHERE customer_id = 101);
SELECT booking_id FROM Bookings WHERE customer_id = 191;
SELECT booking_id, amount_paid FROM Payments WHERE booking_id IN (101, 116, 150);

-- Verify Cursor
SELECT customer_id, IFNULL(SUM(P.amount_paid), 0) AS total_payment FROM Customers C LEFT JOIN Bookings B ON C.customer_id = B.customer_id LEFT JOIN Payments P ON B.booking_id = P.booking_id GROUP BY customer_id;
SELECT C.customer_id, IFNULL(SUM(P.amount_paid), 0) AS total_payment FROM Customers C LEFT JOIN Bookings B ON C.customer_id = B.customer_id LEFT JOIN Payments P ON B.booking_id = P.booking_id GROUP BY C.customer_id;
SELECT B.customer_id, B.booking_id, IFNULL(SUM(P.amount_paid), 0) AS total_payment, T.price AS trip_price FROM Bookings B JOIN Trips T ON B.trip_id = T.trip_id LEFT JOIN Payments P ON B.booking_id = P.booking_id GROUP BY B.customer_id, B.booking_id, T.price HAVING T.price > IFNULL(SUM(P.amount_paid), 0);
SELECT B.customer_id, B.booking_id, IFNULL(SUM(P.amount_paid), 0) AS total_payment, T.price AS trip_price, (T.price - IFNULL(SUM(P.amount_paid), 0)) AS pending_payment FROM Bookings B JOIN Trips T ON B.trip_id = T.trip_id LEFT JOIN Payments P ON B.booking_id = P.booking_id GROUP BY B.customer_id, B.booking_id, T.price;

-- Triggers Check
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'Payments';
SHOW CREATE TRIGGER BeforeInsertPayments;
SELECT T.price AS trip_price FROM Bookings B JOIN Trips T ON B.trip_id = T.trip_id WHERE B.booking_id = 101; -- Replace with a test booking_id
SELECT IFNULL(SUM(amount_paid), 0) AS total_paid FROM Payments WHERE booking_id = 101; -- Replace with a test booking_id
INSERT INTO Payments (booking_id, amount_paid, payment_date) VALUES (101, 500.00, '2024-12-08'); -- Replace with actual test data.
INSERT INTO Bookings (customer_id, trip_id, booking_date, status) VALUES (200, 20, '2024-12-09', 'CONFIRMED'); -- Replace with test data
UPDATE Payments SET amount_paid = -50.00 WHERE payment_id = 1; -- Replace with an actual payment_id
DELETE FROM Customers WHERE customer_id = 300; -- Replace with a test customer_id


