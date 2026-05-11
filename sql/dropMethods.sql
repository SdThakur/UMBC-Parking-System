DROP TRIGGER IF EXISTS trg_update_spot ON SensorEvents CASCADE;
DROP FUNCTION IF EXISTS update_spot_occupancy CASCADE;
DROP PROCEDURE IF EXISTS generate_auto_tickets CASCADE;