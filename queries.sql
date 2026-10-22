-- =====================================================================
-- Cloud-Based Placement Management System
-- ADBMS Minor Project for Cloud Computing
-- Important SQL Queries for Viva & Practical Demo
-- =====================================================================

USE placement_db;

-- ---------------------------------------------------------------------
-- QUERY 1: Basic SELECT with WHERE condition
-- Objective: Retrieve all students with CGPA >= 7.50
-- ---------------------------------------------------------------------
SELECT student_id, name, branch, cgpa, graduation_year
FROM Students
WHERE cgpa >= 7.50
ORDER BY cgpa DESC;

-- ---------------------------------------------------------------------
-- QUERY 2: Multi-Table INNER JOIN
-- Objective: Retrieve complete application details (Student, Company, Role, Status)
-- ---------------------------------------------------------------------
SELECT 
    s.name AS student_name,
    s.branch,
    s.cgpa,
    c.company_name,
    p.job_role,
    p.salary_package,
    a.application_date,
    a.status
FROM Applications a
JOIN Students s ON a.student_id = s.student_id
JOIN Placement_Drives p ON a.drive_id = p.drive_id
JOIN Companies c ON p.company_id = c.company_id
ORDER BY a.application_date DESC;

-- ---------------------------------------------------------------------
-- QUERY 3: LEFT OUTER JOIN
-- Objective: List all students and their application status, including students who haven't applied yet
-- ---------------------------------------------------------------------
SELECT 
    s.student_id,
    s.name,
    s.branch,
    s.cgpa,
    COALESCE(c.company_name, 'No Applications Yet') AS company_applied,
    COALESCE(a.status, 'Not Applied') AS status
FROM Students s
LEFT JOIN Applications a ON s.student_id = a.student_id
LEFT JOIN Placement_Drives p ON a.drive_id = p.drive_id
LEFT JOIN Companies c ON p.company_id = c.company_id
ORDER BY s.student_id;

-- ---------------------------------------------------------------------
-- QUERY 4: Aggregate Functions & GROUP BY with HAVING
-- Objective: Count total applications per company and show only companies with >= 2 applications
-- ---------------------------------------------------------------------
SELECT 
    c.company_name,
    c.industry,
    COUNT(a.application_id) AS total_applications,
    ROUND(AVG(p.salary_package), 2) AS avg_package_lpa
FROM Companies c
JOIN Placement_Drives p ON c.company_id = p.company_id
JOIN Applications a ON p.drive_id = a.drive_id
GROUP BY c.company_id, c.company_name, c.industry
HAVING COUNT(a.application_id) >= 2
ORDER BY total_applications DESC;

-- ---------------------------------------------------------------------
-- QUERY 5: Nested Subquery using IN
-- Objective: Find all students who applied for drives offering salary package > 20 LPA
-- ---------------------------------------------------------------------
SELECT student_id, name, branch, cgpa
FROM Students
WHERE student_id IN (
    SELECT a.student_id
    FROM Applications a
    JOIN Placement_Drives p ON a.drive_id = p.drive_id
    WHERE p.salary_package > 20.00
);

-- ---------------------------------------------------------------------
-- QUERY 6: Subquery with NOT EXISTS
-- Objective: Find eligible drives that a specific student (e.g., student_id = 1) has NOT applied to yet
-- ---------------------------------------------------------------------
SELECT 
    p.drive_id,
    c.company_name,
    p.job_role,
    p.salary_package,
    p.minimum_cgpa
FROM Placement_Drives p
JOIN Companies c ON p.company_id = c.company_id
WHERE p.status = 'Active'
  AND (SELECT cgpa FROM Students WHERE student_id = 1) >= p.minimum_cgpa
  AND NOT EXISTS (
      SELECT 1 
      FROM Applications a 
      WHERE a.drive_id = p.drive_id AND a.student_id = 1
  );

-- ---------------------------------------------------------------------
-- QUERY 7: Querying Pre-created Database Views
-- Objective: Demonstrate abstraction and security using SQL Views
-- ---------------------------------------------------------------------
-- View 1: Active Placement Drives
SELECT * FROM v_active_placement_drives;

-- View 2: Detailed Applications with Interview details
SELECT * FROM v_student_applications_detailed;

-- View 3: Department-wise placement summary statistics
SELECT * FROM v_placement_summary_stats;

-- ---------------------------------------------------------------------
-- QUERY 8: Executing Stored Procedure
-- Objective: Demonstrate procedural SQL and encapsulated business logic
-- ---------------------------------------------------------------------
CALL sp_apply_for_drive(3, 4, @msg);
SELECT @msg AS execution_result;
