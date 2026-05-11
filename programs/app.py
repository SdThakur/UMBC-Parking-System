import streamlit as st
import psycopg2
import pandas as pd
from datetime import datetime

# --- CONFIGURATION & STYLING ---
st.set_page_config(
    page_title="UMBC Parking Admin",
    page_icon="🚗",
    layout="wide"
)

# Advanced CSS for table formatting and layout stability
st.markdown("""
    <style>
    .main { background-color: #f5f7f9; }
    
    /* Ensure table headers and cells don't wrap awkwardly */
    [data-testid="stTable"] td, [data-testid="stTable"] th {
        white-space: nowrap !important;
        padding: 10px 20px !important;
    }
    
    /* Custom button styling */
    .stButton>button {
        width: 100%;
        border-radius: 5px;
        height: 3.5em;
        background-color: #FFC20E !important; /* UMBC Gold */
        color: black !important;
        font-weight: bold;
        border: none;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .stButton>button:hover {
        background-color: #e6af0d !important;
        border: 1px solid black;
    }

    /* Fix for overlapping text in containers */
    .stVerticalBlock { gap: 1.5rem; }
    </style>
    """, unsafe_allow_html=True)

# --- DATABASE CONNECTION ---
def get_connection():
    try:
        return psycopg2.connect(
            host="localhost",
            port="5433",
            database="parkingdb",
            user="dbuser",
            password="dbpass",
            connect_timeout=3
        )
    except Exception:
        return None

# --- SIDEBAR ---
with st.sidebar:
    st.image("https://styleguide.umbc.edu/wp-content/uploads/sites/113/2019/02/UMBC-primary-logo-vertical-stack-on-black-300x248.png", width=150)
    st.title("System Control")
    conn = get_connection()
    if conn:
        st.success("✅ Database Online")
        conn.close()
    else:
        st.error("⚠️ Database Offline")
    st.divider()
    st.caption(f"Session: {datetime.now().strftime('%Y-%m-%d %H:%M')}")

# --- MAIN INTERFACE ---
st.title("🚗 UMBC Parking Management System")
st.markdown("---")

col1, col2 = st.columns(2, gap="large")

with col1:
    with st.container(border=True):
        st.subheader("📋 Student Services")
        st.write("View real-time spot availability.")
        if st.button("Refresh Availability"):
            conn = get_connection()
            if conn:
                query = "SELECT * FROM CurrentLotAvailability;"
                # We use the cursor directly to avoid the Pandas SQLAlchemy warning
                df = pd.read_sql_query(query, conn)
                # Fixed: using 'stretch' instead of use_container_width per 2026 update
                st.dataframe(df, width="stretch", hide_index=True)
                conn.close()

with col2:
    with st.container(border=True):
        st.subheader("⚖️ Enforcement Bureau")
        st.write("Generate violations and scan sensors.")
        if st.button("Run Enforcement Scan"):
            conn = get_connection()
            if conn:
                cur = conn.cursor()
                cur.execute("CALL generate_auto_tickets();")
                conn.commit()
                st.toast("Scan Complete!", icon="✅")
                
                # Updated query to show "Paid" clearly
                query = "SELECT ticket_id, vehicle_id, spot_id, violation_type, fine_amount, paid FROM Tickets ORDER BY issue_date DESC LIMIT 5;"
                df_tickets = pd.read_sql_query(query, conn)
                st.write("**Recent Violations Issued:**")
                # Using st.dataframe instead of st.table for better column control
                st.dataframe(df_tickets, width="stretch", hide_index=True)
                cur.close()
                conn.close()

st.markdown("---")

# --- CONCURRENCY ---
st.subheader("🔐 Secure Reservation")
with st.expander("Transaction Demo"):
    c1, c2 = st.columns([1, 2])
    with c1:
        spot_id = st.number_input("Spot ID", min_value=1, step=1)
        if st.button("Attempt Atomic Reservation"):
            conn = get_connection()
            if conn:
                try:
                    cur = conn.cursor()
                    cur.execute("BEGIN;")
                    cur.execute("SELECT * FROM ParkingSpots WHERE spot_id = %s AND status = 'available' FOR UPDATE;", (spot_id,))
                    if cur.rowcount == 0:
                        st.error(f"Spot {spot_id} unavailable.")
                        conn.rollback()
                    else:
                        cur.execute("UPDATE ParkingSpots SET status = 'occupied' WHERE spot_id = %s;", (spot_id,))
                        conn.commit()
                        st.balloons()
                        st.success(f"Spot {spot_id} Reserved!")
                    cur.close()
                except Exception as e:
                    st.error(f"Error: {e}")
                finally:
                    conn.close()