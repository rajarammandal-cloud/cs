-- =====================================================================
-- Cloud-Based Placement Management System
-- ADBMS Minor Project for Cloud Computing
-- Seed Data: database/seed_data.sql
-- =====================================================================

USE placement_db;

-- ---------------------------------------------------------------------
-- 1. Insert Default Admin
-- Password hash for 'admin123' (SHA-256: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9)
-- ---------------------------------------------------------------------
INSERT INTO Admin (admin_id, username, password_hash, email, role) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'placement.officer@university.edu', 'Head Placement Officer');

-- ---------------------------------------------------------------------
-- 2. Insert Students
-- Password hash for 'student123' (SHA-256: cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa)
-- ---------------------------------------------------------------------
INSERT INTO Students (student_id, name, email, password_hash, branch, cgpa, graduation_year) VALUES
(1, 'Rahul Sharma', 'rahul.sharma@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'CSE', 8.75, 2027),
(2, 'Ananya Patel', 'ananya.patel@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'CSE', 9.10, 2027),
(3, 'Vikram Singh', 'vikram.singh@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'IT', 7.80, 2027),
(4, 'Sneha Mukherjee', 'sneha.m@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'ECE', 8.20, 2027),
(5, 'Aman Verma', 'aman.verma@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'ME', 6.90, 2027),
(6, 'Pooja Iyer', 'pooja.iyer@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'CSE', 7.45, 2027),
(7, 'Rohan Das', 'rohan.das@college.edu', 'cd73502828457d15655bbd7a63fb0bc8f86027ac0d513693460fb9e2b57a44fa', 'IT', 6.30, 2027);

-- ---------------------------------------------------------------------
-- 3. Insert Companies
-- ---------------------------------------------------------------------
INSERT INTO Companies (company_id, company_name, industry, email, location) VALUES
(1, 'Google India', 'Cloud & AI / Internet', 'careers.india@google.com', 'Bengaluru, Karnataka'),
(2, 'Microsoft IDC', 'Software Development', 'university-recruiting@microsoft.com', 'Hyderabad, Telangana'),
(3, 'Amazon AWS', 'Cloud Infrastructure & E-Commerce', 'aws-campus@amazon.com', 'Bengaluru, Karnataka'),
(4, 'TCS (Tata Consultancy Services)', 'IT Services & Consulting', 'campus.connect@tcs.com', 'Mumbai, Maharashtra'),
(5, 'Infosys Technologies', 'Software Solutions', 'earlytalent@infosys.com', 'Pune, Maharashtra');

-- ---------------------------------------------------------------------
-- 4. Insert Placement Drives
-- ---------------------------------------------------------------------
INSERT INTO Placement_Drives (drive_id, company_id, job_role, salary_package, minimum_cgpa, application_deadline, status) VALUES
(1, 1, 'Cloud Solutions Engineer', 24.50, 8.50, DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Active'),
(2, 2, 'Software Engineer - Backend', 22.00, 8.00, DATE_ADD(CURDATE(), INTERVAL 20 DAY), 'Active'),
(3, 3, 'DevOps & Systems Associate', 18.00, 7.50, DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Active'),
(4, 4, 'Associate Software Developer (Ninja)', 7.00, 6.50, DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'Active'),
(5, 5, 'Systems Engineer - Full Stack', 6.50, 6.00, DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'Active');

-- ---------------------------------------------------------------------
-- 5. Insert Applications
-- ---------------------------------------------------------------------
INSERT INTO Applications (application_id, student_id, drive_id, application_date, status) VALUES
(1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Interview Scheduled'),
(2, 2, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Selected'),
(3, 2, 2, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Shortlisted'),
(4, 1, 2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Shortlisted'),
(5, 3, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Applied'),
(6, 4, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'Interview Scheduled'),
(7, 5, 4, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Applied'),
(8, 6, 4, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Selected');

-- ---------------------------------------------------------------------
-- 6. Insert Interviews
-- ---------------------------------------------------------------------
INSERT INTO Interviews (interview_id, application_id, interview_date, interview_mode, location_or_link, result) VALUES
(1, 1, DATE_ADD(NOW(), INTERVAL 2 DAY), 'Online', 'https://meet.google.com/abc-xyz-pqr', 'Pending'),
(2, 2, DATE_SUB(NOW(), INTERVAL 2 DAY), 'Online', 'https://meet.google.com/top-cand-123', 'Cleared'),
(3, 6, DATE_ADD(NOW(), INTERVAL 4 DAY), 'Offline', 'Auditorium Interview Room 204', 'Pending');
