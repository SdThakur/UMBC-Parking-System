-- ======================================
-- UMBC PARKING SYSTEM
-- ======================================

-- -----------------
-- 1. USERS
-- -----------------
INSERT INTO Users (name, email, role) VALUES
('Alice','alice@umbc.edu','student'),
('Bob','bob@umbc.edu','faculty'),
('Charlie','charlie@umbc.edu','student'),
('David','david@umbc.edu','visitor'),
('Emma','emma@umbc.edu','student'),
('Frank','frank@umbc.edu','faculty'),
('Grace','grace@umbc.edu','visitor'),
('Hank','hank@umbc.edu','student'),
('Ivy','ivy@umbc.edu','faculty'),
('Jack','jack@umbc.edu','visitor');

-- -----------------
-- 2. PARKING LOTS
-- -----------------
INSERT INTO ParkingLots (lot_name, lot_type, capacity) VALUES
('Lot A','student',100),
('Lot B','faculty',50),
('Lot C','visitor',30),
('Lot D','student',80),
('Lot E','faculty',60),
('Lot F','visitor',40),
('Lot G','student',70),
('Lot H','faculty',55),
('Lot I','visitor',25),
('Lot J','student',90);

-- -----------------
-- 3. VEHICLES
-- -----------------
INSERT INTO Vehicles (license_plate, user_id) VALUES
('ABC123',1),('XYZ999',2),('CAR456',3),('VIS111',4),
('AAA222',5),('BBB333',6),('CCC444',7),('DDD555',8),
('EEE666',9),('FFF777',10);

-- -----------------
-- 4. PERMITS
-- -----------------
INSERT INTO Permits (user_id, permit_type, expiration_date) VALUES
(1,'student','2026-12-31'),
(2,'faculty','2026-12-31'),
(3,'student','2025-01-01'),
(4,'visitor','2026-06-01'),
(5,'student','2026-12-31'),
(6,'faculty','2026-12-31'),
(7,'visitor','2026-06-01'),
(8,'student','2026-12-31'),
(9,'faculty','2025-01-01'),
(10,'visitor','2026-06-01');

-- -----------------
-- 5. PARKING SPOTS
-- -----------------
INSERT INTO ParkingSpots (lot_id, spot_number, status) VALUES
(1,1,'available'),(1,2,'occupied'),
(2,1,'available'),(3,1,'available'),
(4,1,'occupied'),(5,1,'available'),
(6,1,'available'),(7,1,'occupied'),
(8,1,'available'),(9,1,'available');

-- -----------------
-- 6. RESERVATIONS
-- -----------------
INSERT INTO Reservations (user_id, spot_id, start_time, end_time) VALUES
(4,3,'2026-04-01 10:00','2026-04-01 12:00'),
(7,4,'2026-04-02 09:00','2026-04-02 11:00'),
(10,6,'2026-04-03 08:00','2026-04-03 10:00'),
(4,7,'2026-04-04 10:00','2026-04-04 12:00'),
(7,8,'2026-04-05 09:00','2026-04-05 11:00'),
(10,9,'2026-04-06 08:00','2026-04-06 10:00'),
(4,10,'2026-04-07 10:00','2026-04-07 12:00'),
(7,1,'2026-04-08 09:00','2026-04-08 11:00'),
(10,2,'2026-04-09 08:00','2026-04-09 10:00'),
(4,5,'2026-04-10 10:00','2026-04-10 12:00');

-- -----------------
-- 7. TICKETS
-- -----------------
INSERT INTO Tickets (vehicle_id, spot_id, violation_type, fine_amount, paid) VALUES
(3,2,'Unauthorized Parking',50,FALSE),
(6,5,'Expired Permit',75,TRUE),
(8,7,'Visitor Lot Violation',60,FALSE);

-- -----------------
-- 8. PAYMENTS
-- -----------------
INSERT INTO Payments (ticket_id, amount) VALUES
(2,75);