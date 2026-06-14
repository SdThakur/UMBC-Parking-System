# UMBC Parking Management System

## Overview
This project implements a comprehensive **UMBC Parking Management Database System** using PostgreSQL 16 and Docker. The system automates parking permits, lot availability tracking via ground sensors (triggers), enforcement (stored procedures), and optimized reporting for campus administrators.

---

## System Requirements
* **Docker Desktop** (Must be running)
* **PostgreSQL Client (psql)** or **pgAdmin 4**

---

## Project Folder Structure

umbc-parking-system
│
├── docker-compose.yml       # Docker configuration
├── README.md                # This guide
├── report.pdf               # Final documentation & screenshots
│
└── sql                      # SQL Scripts Folder
    ├── dropMethods.sql      # Cleanup scripts
    ├── dropDDL.sql
    ├── createDDL.sql        # Schema & Views
    ├── createMethods.sql    # Triggers & Stored Procedures
    ├── loadAll.sql          # Sample Data (Alice, Bob, etc.)
    ├── indexAll.sql         # Performance Optimization
    ├── queryAll.sql         # Requirement 25 & 26 Analysis
    ├── transaction.sql      # Concurrency Demo Script
    └── smoke_test.sql       # Initial environment verification

---

## Starting the Environment
1. Open a terminal in the project directory: `cd umbc-parking-system`
2. Start the containers: `docker-compose up -d`
3. Verify status: `docker ps` (You should see `parking_postgres` and `parking_pgadmin` running)

---

## Reproducing the Database (Step-by-Step)
To build the system from scratch exactly as shown in the final report, run these commands in order from your terminal:

```powershell
# 1. Reset Environment
docker exec -it parking_postgres psql -U dbuser -d parkingdb -f /tmp/dropMethods.sql
docker exec -it parking_postgres psql -U dbuser -d parkingdb -f /tmp/dropDDL.sql

# 2. Initialize Schema & Programmable Logic
docker exec -it parking_postgres psql -U dbuser -d parkingdb -f /tmp/createDDL.sql
docker exec -it parking_postgres psql -U dbuser -d parkingdb -f /tmp/createMethods.sql

# 3. Load Sample Data & Apply Indexes
docker exec -it parking_postgres psql -U dbuser -d parkingdb -f /tmp/loadAll.sql
docker exec -it parking_postgres psql -U dbuser -d parkingdb -f /tmp/indexAll.sql

Accessing pgAdmin (Web Interface)
Open your browser to: http://localhost:5050

Login Email: ***

Login Password: ***

Registering the Server in pgAdmin:
Name: UMBC Parking

Host: parking_postgres (Internal Docker hostname)

Port: 5432

Maintenance DB: parkingdb

Username: ****

Password: ****

Concurrency Demo 
The transaction.sql file demonstrates Double Booking Prevention using row-level locking.

Open two separate Query Tool windows in pgAdmin.

Follow the commented steps in transaction.sql to observe how the FOR UPDATE lock forces Session 2 to wait until Session 1 completes, ensuring data integrity during simultaneous reservation attempts.

Author
Satya Dev Thakur
