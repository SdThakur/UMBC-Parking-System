-- ======================================================
-- ASSIGNMENT 6: CONCURRENCY CONTROL
-- ======================================================

-- SESSION 1 (Alice)
BEGIN;
    -- Alice "claims" spot 5. The FOR UPDATE lock tells the DB 
    -- to make anyone else wait until she is done.
    SELECT * FROM ParkingSpots 
    WHERE spot_id = 5 AND status = 'available' 
    FOR UPDATE; 

-- SESSION 2 (Bob)
BEGIN;
    -- Bob tries to look at spot 5. 
    -- In pgAdmin, you will see this session "hang" or stay in "Running" state.
    SELECT * FROM ParkingSpots 
    WHERE spot_id = 5 AND status = 'available' 
    FOR UPDATE;

-- [GOING BACK TO SESSION 1]
    UPDATE ParkingSpots SET status = 'occupied' WHERE spot_id = 5;
    INSERT INTO Reservations (user_id, spot_id, start_time, end_time) 
    VALUES (1, 5, '2026-05-10 08:00', '2026-05-10 10:00');
COMMIT;

-- [NOW CHECKING SESSION 2]
-- Bob's query will finally finish, but it will return 0 rows 
-- because Alice already changed the status to 'occupied'.
ROLLBACK;