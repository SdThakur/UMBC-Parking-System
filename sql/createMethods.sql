-- Create the SensorEvents table to track Alice's parking
CREATE TABLE IF NOT EXISTS SensorEvents (
    event_id SERIAL PRIMARY KEY,
    spot_id INT REFERENCES ParkingSpots(spot_id),
    vehicle_id INT REFERENCES Vehicles(vehicle_id),
    event_type TEXT CHECK (event_type IN ('ENTRY', 'EXIT')),
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1. Trigger Function: Update Spot Status
CREATE OR REPLACE FUNCTION update_spot_occupancy()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.event_type = 'ENTRY' THEN
        UPDATE ParkingSpots SET status = 'occupied' WHERE spot_id = NEW.spot_id;
    ELSIF NEW.event_type = 'EXIT' THEN
        UPDATE ParkingSpots SET status = 'available' WHERE spot_id = NEW.spot_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. The Trigger
CREATE TRIGGER trg_update_spot
AFTER INSERT ON SensorEvents
FOR EACH ROW EXECUTE FUNCTION update_spot_occupancy();

-- 3. Stored Procedure: Auto-Ticketing
CREATE OR REPLACE PROCEDURE generate_auto_tickets()
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Tickets (vehicle_id, spot_id, violation_type, fine_amount)
    SELECT se.vehicle_id, se.spot_id, 'Unauthorized Zone', 50.00
    FROM SensorEvents se
    JOIN ParkingSpots ps ON se.spot_id = ps.spot_id
    JOIN ParkingLots pl ON ps.lot_id = pl.lot_id
    JOIN Vehicles v ON se.vehicle_id = v.vehicle_id
    LEFT JOIN Permits p ON v.user_id = p.user_id AND pl.lot_type = p.permit_type
    WHERE se.event_type = 'ENTRY' 
      AND p.permit_id IS NULL;
END;
$$;