# Cloud-Based Placement Management System
### ADBMS Minor Project for Cloud Computing

A centralized, automated web application developed for college placement departments to digitize campus recruitment activities, enforce automated CGPA cutoff eligibility checks, eliminate duplicate applications, and coordinate student interviews.

---

## 🚀 Quick Start (Instant 1-Click Run)

You can launch and test the complete system immediately in your browser with **zero external dependencies**:

### Option 1: Windows 1-Click Launcher
Double-click:
```
runner/run.bat
```

### Option 2: Command Line
```bash
python runner/app.py
```
Open your browser and navigate to:
👉 **[http://localhost:8080](http://localhost:8080)**

---

## 🔑 Pre-Configured Demo Credentials

| Role | Username / Email | Password | Access Features |
|---|---|---|---|
| **Placement Officer (Admin)** | `admin` | `admin123` | Post drives, register companies, review all applications, view analytics. |
| **Student** | `rahul.sharma@college.edu` | `student123` | View eligible drives, check CGPA cutoffs, apply, track status. |
| **Student (High CGPA)** | `ananya.patel@college.edu` | `student123` | Eligible for all drives (CGPA 9.10). |
| **Recruiter Portal** | Via Admin or Direct URL | `/recruiter` | Schedule online/offline interviews, record hire results. |

---

## 🛠️ Technology Stack & Architecture

- **Architecture:** Model-View-Controller (MVC) with DAO Pattern
- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5, Bootstrap Icons
- **Backend:** Java 17/21/26 (Servlets, JSP, JDBC, Session Management)
- **Database:** MySQL 8.0 (InnoDB Engine, ACID Transactions) / AWS RDS
- **Cloud Infrastructure:** AWS EC2 (Apache Tomcat 9/10) + AWS RDS (Managed MySQL)

---

## 📂 Project Structure

```
d:/CU Practical/sql project/
├── database/
│   ├── schema.sql                 # Complete DDL, 6 tables, constraints, views, triggers, stored procedures
│   ├── seed_data.sql              # Realistic seed data (Students, Companies, Drives, Applications, Interviews)
│   └── queries.sql                # Demonstration queries for project viva (JOINs, aggregations, subqueries)
├── src/
│   ├── main/
│   │   ├── java/com/placement/
│   │   │   ├── config/DBConnection.java       # Database connection manager with SHA-256 hashing
│   │   │   ├── model/                         # Java Beans (Student, Company, Drive, Application, etc.)
│   │   │   ├── dao/                           # JDBC DAO Layer with PreparedStatements
│   │   │   └── servlet/                       # MVC Controllers (Auth, Student, Admin, Recruiter)
│   │   └── webapp/
│   │       ├── WEB-INF/web.xml                # Deployment descriptor
│   │       ├── css/style.css                  # Modern responsive stylesheet
│   │       ├── js/main.js                     # Interactive table filters & validation
│   │       ├── common/                        # Reusable header.jsp & footer.jsp
│   │       ├── index.jsp                      # Landing page
│   │       ├── login.jsp                      # Unified login (Student & Admin)
│   │       ├── register.jsp                   # Student registration
│   │       ├── student-dashboard.jsp          # Student KPI cards & application status
│   │       ├── student-profile.jsp            # Academic profile editor
│   │       ├── available-drives.jsp           # Drives with automated CGPA eligibility badges
│   │       ├── my-applications.jsp            # Application progress tracker
│   │       ├── admin-dashboard.jsp            # Placement Cell dashboard
│   │       ├── admin-companies.jsp            # Company management
│   │       ├── admin-drives.jsp               # Drive creation & status toggling
│   │       ├── admin-applications.jsp         # Candidate review & hiring status updates
│   │       ├── admin-reports.jsp              # Department placement statistics & charts
│   │       └── recruiter-dashboard.jsp        # Interview scheduler & result recorder
├── docs/
│   ├── PROJECT_REPORT.md                      # Complete academic project report
│   ├── VIVA_QUESTIONS.md                      # Comprehensive 15+ Viva Q&A with detailed answers
│   ├── AWS_DEPLOYMENT_GUIDE.md                # Step-by-step AWS EC2 + RDS deployment tutorial
│   └── er_diagram.svg                         # High-res SVG Entity-Relationship diagram
├── runner/
│   ├── app.py                                 # Zero-dependency local test server
│   └── run.bat                                # Windows 1-click batch launcher
└── README.md                                  # This documentation file
```

---

## 🗄️ MySQL Database Setup (For Eclipse / Tomcat Deployment)

1. Open **MySQL Workbench** or terminal:
   ```bash
   mysql -u root -p
   ```
2. Execute the schema script:
   ```sql
   SOURCE database/schema.sql;
   SOURCE database/seed_data.sql;
   ```
3. To test the queries for your viva presentation:
   ```sql
   SOURCE database/queries.sql;
   ```

---

## 🎓 Academic Documents Included

- 📄 **[Academic Project Report](docs/PROJECT_REPORT.md)**: Full report with Abstract, Problem Statement, Objectives, System Architecture, Database Schema, and Conclusion.
- 🎯 **[Viva Preparation Guide](docs/VIVA_QUESTIONS.md)**: Detailed answers to all viva questions covering JDBC, MySQL, Normalization, ACID, Views, Triggers, and Cloud concepts.
- ☁️ **[AWS Cloud Deployment Guide](docs/AWS_DEPLOYMENT_GUIDE.md)**: Complete steps to provision AWS EC2, install Apache Tomcat, launch an Amazon RDS MySQL instance, and deploy.
- 📊 **[Entity-Relationship Diagram](docs/er_diagram.svg)**: Visual ER diagram showing all 6 tables, primary/foreign keys, and 1:N cardinalities.
