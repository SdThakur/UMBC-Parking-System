-- Speeds up View 1: Lot Availability
CREATE INDEX idx_spots_lot_status ON ParkingSpots(lot_id, status);

-- Speeds up View 2: Active Permits report
CREATE INDEX idx_permit_exp ON Permits(expiration_date);

-- Speeds up joining Vehicles with Users
CREATE INDEX idx_vehicles_user ON Vehicles(user_id);

-- Speeds up ticket history lookups
CREATE INDEX idx_tickets_vehicle ON Tickets(vehicle_id);

-- Speeds up email-based user searches
CREATE INDEX idx_users_email ON Users(email);