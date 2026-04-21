"""
=============================================================
 Mobile App Testing Cycle Tracker — Streamlit Dashboard
 Green University of Bangladesh
 Student : Asraful Islam Tonmoy | ID: 242002127
 Course  : Database Lab (CSE 210) | Section: D4
 Teacher : Feroza Naznin
=============================================================
 HOW TO RUN:
   1. Double-click  RUN_ME.bat  (Windows)
   OR
   2. pip install -r requirements.txt
      streamlit run testing_tracker_streamlit.py
=============================================================
"""

import streamlit as st
import mysql.connector
from mysql.connector import Error
import pandas as pd
import plotly.express as px
import os
import re

# ─────────────────────────────────────────────
#  PAGE CONFIG  ← must be the very first call
# ─────────────────────────────────────────────
st.set_page_config(
    page_title="Testing Cycle Tracker | GUB CSE-210",
    page_icon="🧪",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ─────────────────────────────────────────────
#  CUSTOM CSS — Dark Cyberpunk Theme
# ─────────────────────────────────────────────
st.markdown("""
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Fira+Code:wght@400;500&display=swap');

.stApp {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
    font-family: 'Inter', sans-serif;
}
[data-testid="stSidebar"] {
    background: linear-gradient(180deg, #0f3460 0%, #16213e 100%) !important;
    border-right: 1px solid rgba(0,180,216,0.2);
}
[data-testid="stSidebar"] * { color: #f0f0f0 !important; }
[data-testid="stSidebar"] .stRadio > label {
    color: #00b4d8 !important; font-weight: 600;
    font-size: 0.8rem; letter-spacing: 0.08em; text-transform: uppercase;
}
[data-testid="metric-container"] {
    background: linear-gradient(135deg, #0f3460, #16213e) !important;
    border: 1px solid rgba(0,180,216,0.3); border-radius: 12px;
    padding: 1rem !important; box-shadow: 0 4px 20px rgba(0,0,0,0.4);
}
[data-testid="metric-container"] label {
    color: #a0a0b0 !important; font-size: 0.75rem !important;
    text-transform: uppercase; letter-spacing: 0.1em;
}
[data-testid="metric-container"] [data-testid="stMetricValue"] {
    color: #00b4d8 !important; font-size: 2rem !important; font-weight: 700 !important;
}
[data-testid="stDataFrame"] {
    border-radius: 12px; overflow: hidden; border: 1px solid rgba(0,180,216,0.2);
}
.sql-block {
    background: #0d1b2a; border: 1px solid rgba(0,180,216,0.3);
    border-left: 4px solid #00b4d8; border-radius: 8px;
    padding: 1rem 1.2rem; font-family: 'Fira Code', monospace;
    font-size: 0.85rem; color: #7ec8e3; line-height: 1.6;
    margin: 0.5rem 0 1rem 0; white-space: pre-wrap; word-break: break-word;
}
.section-header {
    font-size: 1.4rem; font-weight: 700; color: #f0f0f0;
    margin-bottom: 0.2rem; display: flex; align-items: center; gap: 0.5rem;
}
.section-sub {
    font-size: 0.88rem; color: #a0a0b0;
    font-style: italic; margin-bottom: 1rem;
}
.top-banner {
    background: linear-gradient(90deg, #0f3460, #1a1a2e);
    border: 1px solid rgba(0,180,216,0.25); border-radius: 16px;
    padding: 1.2rem 1.8rem; margin-bottom: 1.5rem;
    display: flex; justify-content: space-between; align-items: center;
}
.banner-title { font-size: 1.6rem; font-weight: 700; color: #00b4d8; letter-spacing: -0.02em; }
.banner-sub   { font-size: 0.8rem; color: #a0a0b0; margin-top: 0.2rem; }
.banner-badge {
    background: rgba(233,69,96,0.15); border: 1px solid rgba(233,69,96,0.4);
    border-radius: 8px; padding: 0.4rem 0.8rem;
    font-size: 0.78rem; color: #e94560; text-align: right;
}
.status-pill {
    display: inline-block; padding: 0.25rem 0.8rem;
    border-radius: 20px; font-size: 0.78rem; font-weight: 600;
}
.status-ok   { background: rgba(76,175,80,0.15);  color: #4caf50; border: 1px solid rgba(76,175,80,0.4); }
.status-err  { background: rgba(233,69,96,0.15);  color: #e94560; border: 1px solid rgba(233,69,96,0.4); }
.status-warn { background: rgba(255,193,7,0.15);  color: #ffc107; border: 1px solid rgba(255,193,7,0.4); }
.query-info {
    background: rgba(0,180,216,0.07); border: 1px solid rgba(0,180,216,0.25);
    border-radius: 10px; padding: 0.75rem 1rem;
    font-size: 0.88rem; color: #a0a0b0; margin-bottom: 1rem; line-height: 1.6;
}
.setup-box {
    background: linear-gradient(135deg, #0f3460, #1a1a2e);
    border: 2px dashed rgba(0,180,216,0.4); border-radius: 16px;
    padding: 2rem; text-align: center; margin: 1rem 0;
}
.table-pill {
    display: inline-block; background: rgba(0,180,216,0.12);
    border: 1px solid rgba(0,180,216,0.3); border-radius: 6px;
    padding: 0.15rem 0.6rem; font-size: 0.78rem; color: #00b4d8;
    font-family: 'Fira Code', monospace; margin: 0.1rem;
}
hr { border-color: rgba(0,180,216,0.15) !important; margin: 1rem 0 !important; }
.stSelectbox > div > div {
    background: #16213e !important; border-color: rgba(0,180,216,0.3) !important; color: #f0f0f0 !important;
}
div[data-testid="stAlert"] {
    background: rgba(15,52,96,0.6) !important; border-radius: 10px !important;
    border: 1px solid rgba(0,180,216,0.25) !important;
}
</style>
""", unsafe_allow_html=True)

# ─────────────────────────────────────────────
#  DB CONFIG  — change port here if needed
# ─────────────────────────────────────────────
DB_HOST = "127.0.0.1"
DB_PORT = 3307        # ← XAMPP default is 3306; some installs use 3307
DB_USER = "root"
DB_PASS = ""          # XAMPP default: no password
DB_NAME = "testing_tracker"

# SQL file must sit in the SAME folder as this script
SQL_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "testing_tracker.sql")

ALL_TABLES = [
    "testers", "apps", "activity_logs", "app_categories",
    "tester_skills", "tester_groups", "test_devices", "tester_devices",
    "bug_severity", "bug_reports", "test_sessions", "test_criteria",
    "project_assignments", "tester_feedback", "notifications",
    "play_store_submissions", "app_permissions", "daily_reports",
    "project_milestones", "app_versions",
]

QUERIES = {
    "Q1 — Testers Who Completed 14 Days (HAVING)": {
        "sql": """SELECT t.tester_id, t.name, t.email,
       COUNT(al.test_date) AS days_active
FROM   testers t
JOIN   activity_logs al ON t.tester_id = al.tester_id
WHERE  al.app_id = 1
GROUP  BY t.tester_id, t.name, t.email
HAVING days_active >= 14
ORDER  BY t.tester_id;""",
        "desc": "✅ Finds all testers who tested for at least 14 days.  "
                "Uses COUNT + GROUP BY + HAVING — core proposal query.  "
                "HAVING filters AFTER grouping (unlike WHERE which filters BEFORE).",
        "chart": "bar",
    },
    "Q2 — Which Tester Is Testing Which App (JOIN)": {
        "sql": """SELECT t.tester_id, t.name, a.app_name,
       al.test_date, al.status
FROM   testers t
JOIN   activity_logs al ON t.tester_id = al.tester_id
JOIN   apps a           ON al.app_id   = a.app_id
ORDER  BY t.tester_id, al.test_date
LIMIT  50;""",
        "desc": "🔗 Shows tester-to-app mapping using multi-table JOIN. "
                "Displays who tested which app on which date.",
        "chart": None,
    },
    "Q3 — Total Active Testers Per Day": {
        "sql": """SELECT al.test_date,
       COUNT(DISTINCT al.tester_id) AS active_testers,
       a.app_name
FROM   activity_logs al
JOIN   apps a ON al.app_id = a.app_id
WHERE  al.status = 'active'
GROUP  BY al.test_date, a.app_name
ORDER  BY al.test_date;""",
        "desc": "📅 Counts distinct active testers for each day. "
                "Shows daily participation trend across the 14-day testing cycle.",
        "chart": "line",
    },
    "Q4 — Bug Reports With Tester & Severity Info": {
        "sql": """SELECT br.bug_id, t.name AS tester_name,
       a.app_name, bs.severity_name,
       br.description, br.status, br.reported_date
FROM   bug_reports br
JOIN   testers      t  ON br.tester_id   = t.tester_id
JOIN   apps         a  ON br.app_id      = a.app_id
JOIN   bug_severity bs ON br.severity_id = bs.severity_id
ORDER  BY bs.priority;""",
        "desc": "🐛 Multi-table JOIN showing all bug reports. "
                "Includes tester name, app, severity level, and fix status. "
                "Demonstrates 4-table JOIN with FK relationships.",
        "chart": "pie",
    },
}

# ═══════════════════════════════════════════════
#  DATABASE HELPERS
# ═══════════════════════════════════════════════

def _base_conn(with_db=True):
    """Open a fresh connection (not cached — used for setup)."""
    cfg = dict(host=DB_HOST, port=DB_PORT, user=DB_USER, password=DB_PASS)
    if with_db:
        cfg["database"] = DB_NAME
    return mysql.connector.connect(**cfg)


def db_exists() -> bool:
    try:
        c = _base_conn(with_db=False)
        cur = c.cursor()
        cur.execute("SHOW DATABASES LIKE 'testing_tracker'")
        found = cur.fetchone() is not None
        cur.close(); c.close()
        return found
    except Exception:
        return False


def import_sql_file() -> tuple[bool, str]:
    """Read testing_tracker.sql and execute it statement-by-statement."""
    if not os.path.exists(SQL_FILE):
        return False, f"SQL file not found at:\n{SQL_FILE}\n\nPut testing_tracker.sql in the SAME folder as this script."
    try:
        with open(SQL_FILE, "r", encoding="utf-8") as f:
            raw = f.read()

        # Split on semicolons (skip blank / comment-only lines)
        statements = [s.strip() for s in raw.split(";") if s.strip()]

        conn = _base_conn(with_db=False)
        conn.autocommit = True
        cur = conn.cursor()

        for stmt in statements:
            # Skip pure-comment blocks and empty
            clean = re.sub(r'--[^\n]*', '', stmt).strip()
            if not clean:
                continue
            try:
                cur.execute(stmt)
            except Error as e:
                # Ignore "Commands out of sync" from multi-result procs
                if e.errno not in (2014,):
                    pass   # best-effort; keep going

        cur.close(); conn.close()
        return True, "✅ Database imported successfully!"
    except Exception as e:
        return False, f"Import failed: {e}"


@st.cache_resource(show_spinner=False)
def get_connection():
    try:
        conn = mysql.connector.connect(
            host=DB_HOST, port=DB_PORT,
            user=DB_USER, password=DB_PASS,
            database=DB_NAME
        )
        return conn, None
    except Error as e:
        return None, str(e)


def run_query(sql: str) -> pd.DataFrame | None:
    conn, err = get_connection()
    if err:
        st.error(f"DB Error: {err}")
        return None
    try:
        if not conn.is_connected():
            conn.reconnect()
        return pd.read_sql(sql, conn)
    except Exception as e:
        st.error(f"Query Error: {e}")
        return None


# ═══════════════════════════════════════════════
#  TOP BANNER
# ═══════════════════════════════════════════════
st.markdown("""
<div class="top-banner">
  <div>
    <div class="banner-title">🧪 Mobile App Testing Cycle Tracker</div>
    <div class="banner-sub">Interactive Database Dashboard — 20 Tables · 4 Key Queries · Real-time MySQL</div>
  </div>
  <div class="banner-badge">
    <div style="font-weight:700;font-size:0.9rem;">Asraful Islam Tonmoy</div>
    <div>ID: 242002127 &nbsp;|&nbsp; CSE 210 — D4</div>
    <div>Green University of Bangladesh</div>
  </div>
</div>
""", unsafe_allow_html=True)

# ═══════════════════════════════════════════════
#  AUTO-SETUP SECTION
# ═══════════════════════════════════════════════
conn, conn_err = get_connection()

if conn_err:
    st.markdown(f'<span class="status-pill status-err">❌ Cannot connect to MySQL — {conn_err}</span>', unsafe_allow_html=True)
    st.markdown("---")

    # Check if it's a "unknown database" error (DB not imported yet)
    if "Unknown database" in str(conn_err) or "1049" in str(conn_err):
        st.markdown("""
        <div class="setup-box">
            <div style="font-size:2.5rem;margin-bottom:0.5rem;">🗄️</div>
            <div style="font-size:1.2rem;font-weight:700;color:#00b4d8;margin-bottom:0.5rem;">Database Not Found</div>
            <div style="color:#a0a0b0;font-size:0.9rem;margin-bottom:1.5rem;">
                The <code style="color:#ffc107">testing_tracker</code> database doesn't exist yet.<br>
                Click the button below to auto-import <code style="color:#ffc107">testing_tracker.sql</code>
            </div>
        </div>
        """, unsafe_allow_html=True)

        col_btn, col_info = st.columns([1, 2])
        with col_btn:
            if st.button("🚀 Import Database Now", type="primary", use_container_width=True):
                with st.spinner("Importing testing_tracker.sql … please wait"):
                    ok, msg = import_sql_file()
                if ok:
                    st.success(msg)
                    st.cache_resource.clear()
                    st.rerun()
                else:
                    st.error(msg)

        with col_info:
            st.info(
                f"📁 **SQL file expected at:**\n\n`{SQL_FILE}`\n\n"
                "Make sure `testing_tracker.sql` is in the **same folder** as `testing_tracker_streamlit.py`"
            )
    else:
        # Generic connection error (XAMPP not running etc.)
        st.error("**XAMPP / MySQL is not running.** Please start XAMPP and make sure MySQL is active.")
        st.markdown("""
        **Checklist:**
        - ✅ Open XAMPP Control Panel
        - ✅ Click **Start** next to MySQL
        - ✅ MySQL should show green / port 3306 or 3307
        - ✅ Then refresh this page
        """)

        port_col1, port_col2 = st.columns(2)
        with port_col1:
            st.warning(
                f"Current port setting in script: **{DB_PORT}**\n\n"
                "If XAMPP uses port 3306, change `DB_PORT = 3306` at the top of the script."
            )
    st.stop()

# Connected ✅
st.markdown(
    '<span class="status-pill status-ok">✅ Connected — testing_tracker @ MySQL (XAMPP)</span>',
    unsafe_allow_html=True
)
st.markdown("---")

# ═══════════════════════════════════════════════
#  SUMMARY METRICS
# ═══════════════════════════════════════════════
def metric(sql):
    df = run_query(sql)
    return int(df.iloc[0, 0]) if df is not None and len(df) > 0 else "—"

c1, c2, c3, c4, c5 = st.columns(5)
with c1: st.metric("👤 Total Testers",   metric("SELECT COUNT(*) FROM testers"))
with c2: st.metric("📱 Total Apps",      metric("SELECT COUNT(*) FROM apps"))
with c3: st.metric("🐛 Bug Reports",     metric("SELECT COUNT(*) FROM bug_reports"))
with c4: st.metric("📋 Activity Logs",   metric("SELECT COUNT(*) FROM activity_logs"))
with c5: st.metric("🖥️ Test Sessions",  metric("SELECT COUNT(*) FROM test_sessions"))

st.markdown("---")

# ═══════════════════════════════════════════════
#  SIDEBAR
# ═══════════════════════════════════════════════
with st.sidebar:
    st.markdown("""
    <div style='text-align:center;padding:0.5rem 0 1rem;'>
        <div style='font-size:2rem;'>🧪</div>
        <div style='font-size:0.95rem;font-weight:700;color:#00b4d8;'>Testing Tracker</div>
        <div style='font-size:0.72rem;color:#a0a0b0;'>CSE 210 · Section D4 · Spring 2026</div>
    </div>
    """, unsafe_allow_html=True)
    st.markdown("---")

    mode = st.radio("🗂️ VIEW MODE", ["📋 Browse Tables", "🔍 Key Queries"])

    st.markdown("---")

    if mode == "📋 Browse Tables":
        st.markdown(
            "<div style='font-size:0.75rem;color:#ffc107;font-weight:600;"
            "text-transform:uppercase;letter-spacing:0.08em;margin-bottom:0.5rem;'>"
            "20 Database Tables</div>", unsafe_allow_html=True
        )
        selected_table = st.selectbox(
            "table", ALL_TABLES,
            format_func=lambda x: f"📄 {x}",
            label_visibility="collapsed"
        )
    else:
        st.markdown(
            "<div style='font-size:0.75rem;color:#ffc107;font-weight:600;"
            "text-transform:uppercase;letter-spacing:0.08em;margin-bottom:0.5rem;'>"
            "Project Queries</div>", unsafe_allow_html=True
        )
        selected_query = st.radio(
            "query", list(QUERIES.keys()),
            label_visibility="collapsed"
        )

    st.markdown("---")
    st.markdown("""
    <div style='font-size:0.72rem;color:#a0a0b0;line-height:1.7;'>
        <div style='color:#00b4d8;font-weight:600;margin-bottom:0.3rem;'>ℹ️ About This Project</div>
        14-Day testing cycle tracker<br>
        simulating Google Play Store<br>
        publication requirements.<br><br>
        <span style='color:#ffc107;'>Teacher:</span> Feroza Naznin<br>
        <span style='color:#ffc107;'>20 Testers · 20 Tables · 280 Logs</span>
    </div>
    """, unsafe_allow_html=True)

    # Re-import button in sidebar (useful for reset)
    st.markdown("---")
    if st.button("🔄 Re-import Database", use_container_width=True, help="Drop and re-create the database from SQL file"):
        with st.spinner("Re-importing …"):
            ok, msg = import_sql_file()
        if ok:
            st.success("Done! Refreshing …")
            st.cache_resource.clear()
            st.rerun()
        else:
            st.error(msg)

# ═══════════════════════════════════════════════
#  MAIN CONTENT
# ═══════════════════════════════════════════════

if mode == "📋 Browse Tables":
    col_title, col_badge = st.columns([5, 1])
    with col_title:
        st.markdown(f'<div class="section-header">📄 {selected_table}</div>', unsafe_allow_html=True)

    sql = f"SELECT * FROM `{selected_table}`"
    st.markdown(f'<div class="sql-block">{sql};</div>', unsafe_allow_html=True)

    df = run_query(sql)
    if df is not None:
        with col_badge:
            st.markdown(
                f'<div style="padding-top:0.6rem;text-align:right;">'
                f'<span class="status-pill status-ok">{len(df)} rows</span></div>',
                unsafe_allow_html=True
            )
        cols_html = " ".join(
            f'<code style="background:rgba(0,180,216,0.1);border-radius:3px;padding:0 4px;color:#00b4d8;">{c}</code>'
            for c in df.columns
        )
        st.markdown(f'<div class="section-sub">Columns: {cols_html}</div>', unsafe_allow_html=True)
        st.dataframe(df, use_container_width=True, height=420, hide_index=True)

        # Quick chart
        num_cols = df.select_dtypes(include="number").columns.tolist()
        txt_cols = df.select_dtypes(include="object").columns.tolist()
        if num_cols and txt_cols and len(df) <= 100:
            st.markdown("---")
            st.markdown('<div class="section-header" style="font-size:1rem;">📊 Quick Visualization</div>', unsafe_allow_html=True)
            chosen_y = st.selectbox("Numeric column", num_cols, key="qchart_y")
            fig = px.bar(
                df.head(30), x=txt_cols[0], y=chosen_y,
                color_discrete_sequence=["#00b4d8"],
                template="plotly_dark",
                text=chosen_y,
            )
            fig.update_traces(textposition="outside", textfont_color="#f0f0f0")
            fig.update_layout(
                paper_bgcolor="rgba(0,0,0,0)",
                plot_bgcolor="rgba(15,52,96,0.2)",
                font_color="#f0f0f0",
                xaxis_tickangle=-30,
            )
            st.plotly_chart(fig, use_container_width=True)

else:
    # ── Key Query View ──────────────────────────
    q = QUERIES[selected_query]
    st.markdown(f'<div class="section-header">🔍 {selected_query}</div>', unsafe_allow_html=True)
    st.markdown(f'<div class="query-info">{q["desc"]}</div>', unsafe_allow_html=True)

    st.markdown("**SQL Statement:**")
    st.markdown(f'<div class="sql-block">{q["sql"]}</div>', unsafe_allow_html=True)

    df = run_query(q["sql"])

    if df is not None:
        col_a, col_b = st.columns([5, 1])
        with col_a:
            st.markdown('<div class="section-sub">Query Results</div>', unsafe_allow_html=True)
        with col_b:
            st.markdown(
                f'<div style="padding-top:0.3rem;">'
                f'<span class="status-pill status-ok">{len(df)} rows</span></div>',
                unsafe_allow_html=True
            )
        st.dataframe(df, use_container_width=True, height=350, hide_index=True)
        st.markdown("---")

        chart_type = q.get("chart")

        # Q1 — bar chart (days active per tester)
        if chart_type == "bar" and "days_active" in df.columns and "name" in df.columns:
            st.markdown('<div class="section-header" style="font-size:1rem;">📊 Days Active per Tester</div>', unsafe_allow_html=True)
            fig = px.bar(
                df, x="name", y="days_active",
                color="days_active",
                color_continuous_scale=[[0,"#0f3460"],[0.5,"#00b4d8"],[1,"#e94560"]],
                template="plotly_dark", text="days_active",
                labels={"name":"Tester Name","days_active":"Days Active"},
            )
            fig.update_traces(textposition="outside", textfont_color="#f0f0f0")
            fig.add_hline(y=14, line_dash="dash", line_color="#ffc107",
                          annotation_text="14-Day Threshold ✅",
                          annotation_font_color="#ffc107")
            fig.update_layout(
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(15,52,96,0.2)",
                font_color="#f0f0f0", coloraxis_showscale=False, xaxis_tickangle=-30,
            )
            st.plotly_chart(fig, use_container_width=True)

        # Q3 — line chart (active testers per day)
        elif chart_type == "line" and "test_date" in df.columns and "active_testers" in df.columns:
            st.markdown('<div class="section-header" style="font-size:1rem;">📈 Active Testers Per Day — 14-Day Cycle</div>', unsafe_allow_html=True)
            fig = px.line(
                df, x="test_date", y="active_testers",
                color="app_name" if "app_name" in df.columns else None,
                markers=True, template="plotly_dark",
                color_discrete_sequence=["#00b4d8","#e94560","#ffc107","#4caf50"],
                labels={"test_date":"Date","active_testers":"Active Testers"},
            )
            fig.update_traces(line_width=2.5, marker_size=9)
            fig.update_layout(
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(15,52,96,0.2)",
                font_color="#f0f0f0", legend_bgcolor="rgba(0,0,0,0)",
            )
            st.plotly_chart(fig, use_container_width=True)

        # Q4 — pie + status bar
        elif chart_type == "pie" and "severity_name" in df.columns:
            st.markdown('<div class="section-header" style="font-size:1rem;">🥧 Bug Distribution</div>', unsafe_allow_html=True)
            sev = df["severity_name"].value_counts().reset_index()
            sev.columns = ["Severity", "Count"]

            col_pie, col_bar = st.columns(2)
            with col_pie:
                st.markdown('<div class="section-sub">By Severity Level</div>', unsafe_allow_html=True)
                fig = px.pie(
                    sev, names="Severity", values="Count", hole=0.4,
                    color_discrete_sequence=["#e94560","#ffc107","#00b4d8","#4caf50","#a78bfa"],
                    template="plotly_dark",
                )
                fig.update_layout(paper_bgcolor="rgba(0,0,0,0)", font_color="#f0f0f0",
                                  legend_bgcolor="rgba(0,0,0,0)")
                st.plotly_chart(fig, use_container_width=True)

            with col_bar:
                if "status" in df.columns:
                    st.markdown('<div class="section-sub">By Fix Status</div>', unsafe_allow_html=True)
                    sta = df["status"].value_counts().reset_index()
                    sta.columns = ["Status", "Count"]
                    fig2 = px.bar(
                        sta, x="Status", y="Count", color="Status",
                        color_discrete_sequence=["#4caf50","#e94560","#ffc107"],
                        template="plotly_dark", text="Count",
                    )
                    fig2.update_traces(textposition="outside", textfont_color="#f0f0f0")
                    fig2.update_layout(
                        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(15,52,96,0.2)",
                        font_color="#f0f0f0", showlegend=False,
                    )
                    st.plotly_chart(fig2, use_container_width=True)

# ─────────────────────────────────────────────
#  ALL TABLES PILLS (bottom)
# ─────────────────────────────────────────────
st.markdown("---")
st.markdown('<div class="section-header" style="font-size:1rem;">🗃️ All 20 Database Tables</div>', unsafe_allow_html=True)
pills = " ".join(f'<span class="table-pill">{t}</span>' for t in ALL_TABLES)
st.markdown(f'<div style="line-height:2.4;">{pills}</div>', unsafe_allow_html=True)

# ─────────────────────────────────────────────
#  FOOTER
# ─────────────────────────────────────────────
st.markdown("---")
st.markdown("""
<div style='text-align:center;color:#a0a0b0;font-size:0.78rem;padding:0.5rem 0;'>
    🧪 Mobile App Testing Cycle Tracker &nbsp;|&nbsp; Database Lab (CSE 210) — Spring 2026<br>
    Asraful Islam Tonmoy (242002127) &nbsp;·&nbsp; Section D4 &nbsp;·&nbsp;
    Teacher: Feroza Naznin &nbsp;·&nbsp; Green University of Bangladesh
</div>
""", unsafe_allow_html=True)
