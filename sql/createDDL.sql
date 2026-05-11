-- ==========================================
-- UMBC PARKING MANAGEMENT SYSTEM: DDL
-- ==========================================

-- 1. USERS
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT CHECK (role IN ('student', 'faculty', 'visitor', 'admin')) NOT NULL
);

-- 2. PARKING LOTS
CREATE TABLE ParkingLots (
    lot_id SERIAL PRIMARY KEY,
    lot_name TEXT NOT NULL,
    lot_type TEXT CHECK (lot_type IN ('student','faculty','visitor')) NOT NULL,
    capacity INT CHECK (capacity > 0)
);

-- 3. VEHICLES
CREATE TABLE Vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    license_plate TEXT UNIQUE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 4. PERMITS
CREATE TABLE Permits (
    permit_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    permit_type TEXT NOT NULL,
    expiration_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 5. PARKING SPOTS
CREATE TABLE ParkingSpots (
    spot_id SERIAL PRIMARY KEY,
    lot_id INT NOT NULL,
    spot_number INT NOT NULL,
    status TEXT CHECK (status IN ('available','occupied')) DEFAULT 'available',
    UNIQUE (lot_id, spot_number),
    FOREIGN KEY (lot_id) REFERENCES ParkingLots(lot_id)
);

-- 6. SENSOR EVENTS (Requirement 22)
CREATE TABLE SensorEvents (
    event_id SERIAL PRIMARY KEY,
    spot_id INT REFERENCES ParkingSpots(spot_id),
    vehicle_id INT REFERENCES Vehicles(vehicle_id),
    event_type TEXT CHECK (event_type IN ('ENTRY', 'EXIT')),
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. RESERVATIONS
CREATE TABLE Reservations (
    reservation_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    spot_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    CHECK (start_time < end_time),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (spot_id) REFERENCES ParkingSpots(spot_id)
);

-- 8. TICKETS
CREATE TABLE Tickets (
    ticket_id SERIAL PRIMARY KEY,
    vehicle_id INT NOT NULL,
    spot_id INT NOT NULL,
    violation_type TEXT NOT NULL,
    fine_amount NUMERIC CHECK (fine_amount >= 0),
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (spot_id) REFERENCES ParkingSpots(spot_id)
);

-- 9. PAYMENTS
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    ticket_id INT NOT NULL,
    amount NUMERIC NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

-- VIEWS (Requirement 24)
CREATE OR REPLACE VIEW CurrentLotAvailability AS
SELECT pl.lot_name, pl.lot_type, COUNT(ps.spot_id) AS available_count
FROM ParkingLots pl
JOIN ParkingSpots ps ON pl.lot_id = ps.lot_id
WHERE ps.status = 'available'
GROUP BY pl.lot_name, pl.lot_type;

CREATE OR REPLACE VIEW CurrentActivePermits AS
SELECT u.name, v.license_plate, p.permit_type, p.expiration_date
FROM Users u
JOIN Vehicles v ON u.user_id = v.user_id
JOIN Permits p ON u.user_id = p.user_id
WHERE p.expiration_date >= CURRENT_DATE;