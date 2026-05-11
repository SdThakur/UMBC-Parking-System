-- 1. List users and their vehicles
SELECT u.name, v.license_plate FROM Users u JOIN Vehicles v ON u.user_id = v.user_id;

-- 2. Count users by role
SELECT role, COUNT(*) FROM Users GROUP BY role;

-- 3. Vehicles with active permits
SELECT * FROM Vehicles WHERE user_id IN (SELECT user_id FROM Permits WHERE expiration_date > CURRENT_DATE);

-- 4. EXPENSIVE QUERY: Join Reservations and Spots
EXPLAIN ANALYZE SELECT * FROM Reservations r JOIN ParkingSpots s ON r.spot_id = s.spot_id;

-- 5. Unpaid tickets
SELECT * FROM Tickets WHERE paid = FALSE;

-- 6. Ticket count per user
SELECT u.name, COUNT(t.ticket_id) FROM Users u JOIN Vehicles v ON u.user_id = v.user_id JOIN Tickets t ON v.vehicle_id = t.vehicle_id GROUP BY u.name;

-- 7. View Test: Active permits
SELECT * FROM CurrentActivePermits;

-- 8. View Test: Lot availability
SELECT * FROM CurrentLotAvailability;

-- 9. EXPENSIVE QUERY 2: Join Tickets and Vehicles
EXPLAIN ANALYZE SELECT * FROM Tickets t JOIN Vehicles v ON t.vehicle_id = v.vehicle_id;

-- 10. EXPENSIVE QUERY 3: Filter available spots
EXPLAIN ANALYZE SELECT * FROM ParkingSpots WHERE status='available';