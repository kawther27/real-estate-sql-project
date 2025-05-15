# 🏡 Real Estate Management System – SQL Project

This project was developed as part of a college assignment at *Collège La Cité*. It simulates a full-featured **real estate agency system** using T-SQL, and includes:

- Stored procedures
- Triggers
- Temporary tables
- Cursors
- System-level export to CSV using `xp_cmdshell` and `bcp`

---

## 📘 Project Overview

The database used is `HouseSalesDB`, and the system covers the following domains:
- Agent performance reporting (annually and monthly)
- Customer payment reminders
- Open house scheduling
- Integrity protection on house deletion
- CSV data export for analytics

---

## 🛠️ Technologies & Concepts

- Microsoft SQL Server (T-SQL)
- Stored Procedures
- Cursors
- Temporary Tables (`#` and `##`)
- Triggers (`INSTEAD OF DELETE`)
- Security management (`xp_cmdshell`)
- BCP (Bulk Copy Program)

---

## 📁 Files and Functionality

| File Name                                       | Description |
|------------------------------------------------|-------------|
| `create_house_sales_db_schema.sql`             | Creates the full database schema including tables and foreign key relations. |
| `generate_yearly_agent_performance_report.sql` | Produces an annual report with total sales, commissions, and agent ratings. Results are exported to CSV. |
| `add_house_and_schedule_open_house.sql`        | Adds a new house and schedules an open house on a future date with validation. |
| `send_payment_reminders.sql`                   | Sends custom reminders for each customer based on sales made today using a cursor. |
| `trigger_prevent_house_deletion.sql`           | Trigger that prevents deletion of houses tied to sales or appointments. |
| `generate_monthly_agent_commission.sql`        | Summarizes commissions per agent for a specific month/year using a stored procedure. |

---

## 🔎 Documentation of Each SQL Component

### ✅ Stored Procedures
Used to encapsulate complex logic and improve code reuse:
- `GenerateYearlyAgentPerformanceReport`
- `GenerateAgentCommissionReport`
- `AddHouseAndScheduleOpenHouse`
- `SendPaymentReminders`

### ✅ Triggers
- `trg_PreventHouseDeletion` ensures business rules are enforced when deletion is attempted.

### ✅ Temporary Tables
Used to store intermediate or result data for report generation and easier querying.

### ✅ Cursors
Implemented in `SendPaymentReminders` and `trg_PreventHouseDeletion` to process rows one by one.

### ✅ CSV Export
`xp_cmdshell` and `bcp` are used in Q1 to export reports into readable files for business users.

---

## 📦 How to Run the Project

1. Execute `create_house_sales_db_schema.sql` to create tables.
2. Insert mock data or connect to your own dataset.
3. Run each script depending on the functionality needed.
4. Ensure `xp_cmdshell` is enabled for CSV export, then disable it again.

---

## 🔐 Security Notes
- `xp_cmdshell` is temporarily enabled only during export and immediately disabled afterward.
- Triggers are used to protect integrity in the system.

---

## 👩‍💻 Author

**Kawther Khlif**  
🎓 Graduate of Collège La Cité – Programming  
📫 kawtherkhlif20@gmail.com  
📍 Based in Montréal/Ottawa  
🔗 [LinkedIn](https://linkedin.com/in/kawther-khlif)  
