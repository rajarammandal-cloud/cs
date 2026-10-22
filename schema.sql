-- =====================================================================
-- Cloud-Based Placement Management System
-- ADBMS Minor Project for Cloud Computing
-- Database Schema: placement_db
-- =====================================================================

CREATE DATABASE IF NOT EXISTS placement_db;
USE placement_db;

-- ---------------------------------------------------------------------
-- Table 1: Students
-- Stores student profiles, academic details, and authentication hashes
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS Interviews;
DROP TABLE IF EXISTS Applications;
DROP TABLE IF EXISTS Placement_Drives;
DROP TABLE IF EXISTS Companies;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Students;

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    branch VARCHAR(50) NOT NULL,
    cgpa DECIMAL(3, 2) NOT NULL,
    graduation_year INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_cgpa CHECK (cgpa >= 0.00 AND cgpa <= 10.00),
    CONSTRAINT chk_grad_year CHECK (graduation_year >= 2020 AND graduation_year <= 2035)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Table 2: Companies
-- Stores recruiter companies registered with the placement cell
-- ---------------------------------------------------------------------
CREATE TABLE Companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Table 3: Placement_Drives
-- Stores job opportunities, eligibility cutoff CGPA, and deadlines
-- ---------------------------------------------------------------------
CREATE TABLE Placement_Drives (
    drive_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    job_role VARCHAR(100) NOT NULL,
    salary_package DECIMAL(10, 2) NOT NULL, -- Annual Package in LPA (Lakhs Per Annum)
    minimum_cgpa DECIMAL(3, 2) NOT NULL DEFAULT 6.00,
    application_deadline DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active', -- Active, Closed, Completed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_drive_cgpa CHECK (minimum_cgpa >= 0.00 AND minimum_cgpa <= 10.00),
    CONSTRAINT chk_salary CHECK (salary_package > 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Table 4: Applications
-- Resolves Many-to-Many relationship between Students and Placement Drives
-- ---------------------------------------------------------------------
CREATE TABLE Applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    drive_id INT NOT NULL,
    application_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Applied', -- Applied, Shortlisted, Interview Scheduled, Selected, Rejected
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (drive_id) REFERENCES Placement_Drives(drive_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_student_drive UNIQUE (student_id, drive_id) -- Prevents duplicate applications
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Table 5: Admin
-- Stores Placement Officers / Administrators credentials
-- ---------------------------------------------------------------------
CREATE TABLE Admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(50) DEFAULT 'Placement Officer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Table 6: Interviews
-- Tracks interview schedules, modes, and outcomes
-- ---------------------------------------------------------------------
CREATE TABLE Interviews (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    interview_date DATETIME NOT NULL,
    interview_mode VARCHAR(30) NOT NULL DEFAULT 'Online', -- Online, Offline
    location_or_link VARCHAR(255),
    result VARCHAR(30) NOT NULL DEFAULT 'Pending', -- Pending, Cleared, Failed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES Applications(application_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- ADBMS ADVANCED CONCEPTS: INDEXES, VIEWS, TRIGGERS & PROCEDURES
-- =====================================================================

-- Indexes to optimize search queries on CGPA, branch, and drive status
CREATE INDEX idx_student_cgpa ON Students(cgpa);
CREATE INDEX idx_student_branch ON Students(branch);
CREATE INDEX idx_drive_status ON Placement_Drives(status);
CREATE INDEX idx_app_status ON Applications(status);

-- ---------------------------------------------------------------------
-- View 1: v_active_placement_drives
-- Joins Placement Drives with Company details
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_active_placement_drives AS
SELECT 
    d.drive_id,
    c.company_id,
    c.company_name,
    c.industry,
    c.location,
    d.job_role,
    d.salary_package,
    d.minimum_cgpa,
    d.application_deadline,
    d.status,
    DATEDIFF(d.application_deadline, CURDATE()) AS days_left
FROM Placement_Drives d
JOIN Companies c ON d.company_id = c.company_id
WHERE d.status = 'Active';

-- ---------------------------------------------------------------------
-- View 2: v_student_applications_detailed
-- Joins Applications, Students, Drives, and Companies
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_student_applications_detailed AS
SELECT 
    a.application_id,
    s.student_id,
    s.name AS student_name,
    s.email AS student_email,
    s.branch,
    s.cgpa,
    c.company_name,
    p.job_role,
    p.salary_package,
    a.application_date,
    a.status AS application_status,
    i.interview_id,
    i.interview_date,
    i.interview_mode,
    i.result AS interview_result
FROM Applications a
JOIN Students s ON a.student_id = s.student_id
JOIN Placement_Drives p ON a.drive_id = p.drive_id
JOIN Companies c ON p.company_id = c.company_id
LEFT JOIN Interviews i ON a.application_id = i.application_id;

-- ---------------------------------------------------------------------
-- View 3: v_placement_summary_stats
-- Aggregate placement statistics by department/branch
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_placement_summary_stats AS
SELECT 
    s.branch,
    COUNT(DISTINCT s.student_id) AS total_students,
    COUNT(DISTINCT CASE WHEN a.status = 'Selected' THEN s.student_id END) AS placed_students,
    ROUND(AVG(s.cgpa), 2) AS average_cgpa,
    ROUND(
        (COUNT(DISTINCT CASE WHEN a.status = 'Selected' THEN s.student_id END) * 100.0) / 
        NULLIF(COUNT(DISTINCT s.student_id), 0), 2
    ) AS placement_percentage
FROM Students s
LEFT JOIN Applications a ON s.student_id = a.student_id
GROUP BY s.branch;

-- ---------------------------------------------------------------------
-- Trigger: trg_validate_student_eligibility
-- Ensures that student CGPA >= drive minimum_cgpa before an application is inserted
-- ---------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER trg_validate_student_eligibility
BEFORE INSERT ON Applications
FOR EACH ROW
BEGIN
    DECLARE student_cgpa DECIMAL(3, 2);
    DECLARE min_required_cgpa DECIMAL(3, 2);
    DECLARE drive_deadline DATE;

    -- Fetch student's CGPA
    SELECT cgpa INTO student_cgpa FROM Students WHERE student_id = NEW.student_id;

    -- Fetch drive's minimum CGPA & deadline
    SELECT minimum_cgpa, application_deadline INTO min_required_cgpa, drive_deadline 
    FROM Placement_Drives WHERE drive_id = NEW.drive_id;

    -- Check CGPA eligibility
    IF student_cgpa < min_required_cgpa THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ineligible application: Student CGPA is lower than the minimum required CGPA for this drive.';
    END IF;

    -- Check deadline
    IF NEW.application_date > drive_deadline THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Application deadline has passed for this placement drive.';
    END IF;
END$$
DELIMITER ;

-- ---------------------------------------------------------------------
-- Stored Procedure: sp_apply_for_drive
-- Encapsulates business logic for student application with error handling
-- ---------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE sp_apply_for_drive(
    IN in_student_id INT,
    IN in_drive_id INT,
    OUT out_status_message VARCHAR(100)
)
BEGIN
    DECLARE v_count INT;

    -- Check if student already applied
    SELECT COUNT(*) INTO v_count 
    FROM Applications 
    WHERE student_id = in_student_id AND drive_id = in_drive_id;

    IF v_count > 0 THEN
        SET out_status_message = 'ERROR: You have already applied for this placement drive.';
    ELSE
        INSERT INTO Applications (student_id, drive_id, application_date, status)
        VALUES (in_student_id, in_drive_id, CURDATE(), 'Applied');
        SET out_status_message = 'SUCCESS: Application submitted successfully.';
    END IF;
END$$
DELIMITER ;
