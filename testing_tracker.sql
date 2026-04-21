-- ============================================================
-- Mobile App Testing Cycle Tracker
-- Green University of Bangladesh
-- Student: Asraful Islam Tonmoy | ID: 242002127
-- Course: Database Lab (CSE 210) | Section: D4
-- Teacher: Feroza Naznin
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS testing_tracker;
CREATE DATABASE testing_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE testing_tracker;

-- ============================================================
-- TABLE 1: app_categories
-- ============================================================
CREATE TABLE app_categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50)  NOT NULL,
    description   VARCHAR(200) DEFAULT NULL
) ENGINE=InnoDB;

INSERT INTO app_categories VALUES
(1, 'Utility',       'Tools and utility apps'),
(2, 'Entertainment', 'Games and media apps'),
(3, 'Education',     'Learning and educational apps'),
(4, 'Health',        'Fitness and health tracking apps'),
(5, 'Finance',       'Banking and budget apps');

-- ============================================================
-- TABLE 2: tester_skills
-- ============================================================
CREATE TABLE tester_skills (
    skill_id   INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(50) NOT NULL,
    level      VARCHAR(20) DEFAULT 'Beginner'
) ENGINE=InnoDB;

INSERT INTO tester_skills VALUES
(1, 'UI Testing',          'Advanced'),
(2, 'Performance Testing', 'Intermediate'),
(3, 'Security Testing',    'Expert'),
(4, 'Regression Testing',  'Intermediate'),
(5, 'Exploratory Testing', 'Beginner');

-- ============================================================
-- TABLE 3: tester_groups
-- ============================================================
CREATE TABLE tester_groups (
    group_id     INT AUTO_INCREMENT PRIMARY KEY,
    group_name   VARCHAR(50) NOT NULL,
    created_date DATE        DEFAULT NULL
) ENGINE=InnoDB;

INSERT INTO tester_groups VALUES
(1, 'Alpha Testers',   '2026-01-01'),
(2, 'Beta Testers',    '2026-01-01'),
(3, 'Core Testers',    '2026-01-15'),
(4, 'Reserve Testers', '2026-02-01');

-- ============================================================
-- TABLE 4: testers  (20 testers — matches Google Play requirement)
-- ============================================================
CREATE TABLE testers (
    tester_id INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NOT NULL UNIQUE,
    join_date DATE         DEFAULT NULL,
    group_id  INT          DEFAULT NULL,
    skill_id  INT          DEFAULT NULL,
    is_active TINYINT(1)   DEFAULT 1,
    FOREIGN KEY (group_id) REFERENCES tester_groups(group_id),
    FOREIGN KEY (skill_id) REFERENCES tester_skills(skill_id)
) ENGINE=InnoDB;

INSERT INTO testers VALUES
( 1, 'Asraful Islam',    'asraful@mail.com',   '2026-01-05', 1, 1, 1),
( 2, 'Tanvir Ahmed',     'tanvir@mail.com',    '2026-01-05', 1, 2, 1),
( 3, 'Nusrat Jahan',     'nusrat@mail.com',    '2026-01-06', 1, 1, 1),
( 4, 'Rafi Hossain',     'rafi@mail.com',      '2026-01-06', 1, 3, 1),
( 5, 'Mitu Akter',       'mitu@mail.com',      '2026-01-07', 2, 4, 1),
( 6, 'Shakil Mahmud',    'shakil@mail.com',    '2026-01-07', 2, 2, 1),
( 7, 'Priya Das',        'priya@mail.com',     '2026-01-08', 2, 5, 1),
( 8, 'Jubayer Ali',      'jubayer@mail.com',   '2026-01-08', 2, 1, 1),
( 9, 'Lamia Sultana',    'lamia@mail.com',     '2026-01-09', 3, 3, 1),
(10, 'Nahid Hassan',     'nahid@mail.com',     '2026-01-09', 3, 4, 1),
(11, 'Sadia Rahman',     'sadia@mail.com',     '2026-01-10', 3, 2, 1),
(12, 'Farhan Kabir',     'farhan@mail.com',    '2026-01-10', 3, 5, 1),
(13, 'Tamanna Begum',    'tamanna@mail.com',   '2026-01-11', 4, 1, 1),
(14, 'Imran Khan',       'imran@mail.com',     '2026-01-11', 4, 3, 1),
(15, 'Roksana Khatun',   'roksana@mail.com',   '2026-01-12', 4, 2, 1),
(16, 'Mahfuz Alam',      'mahfuz@mail.com',    '2026-01-12', 1, 4, 1),
(17, 'Tania Islam',      'tania@mail.com',     '2026-01-13', 2, 5, 1),
(18, 'Sabbir Hossain',   'sabbir@mail.com',    '2026-01-13', 3, 1, 1),
(19, 'Nadia Chowdhury',  'nadia@mail.com',     '2026-01-14', 4, 3, 1),
(20, 'Raihan Ahmed',     'raihan@mail.com',    '2026-01-14', 1, 2, 1);

-- ============================================================
-- TABLE 5: test_devices
-- ============================================================
CREATE TABLE test_devices (
    device_id    INT AUTO_INCREMENT PRIMARY KEY,
    device_name  VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(50)  DEFAULT NULL,
    os_version   VARCHAR(20)  DEFAULT NULL,
    screen_size  VARCHAR(20)  DEFAULT NULL
) ENGINE=InnoDB;

INSERT INTO test_devices VALUES
(1, 'Samsung Galaxy A54',  'Samsung',  'Android 14', '6.4 inch'),
(2, 'Xiaomi Redmi Note 12','Xiaomi',   'Android 13', '6.67 inch'),
(3, 'Realme C55',          'Realme',   'Android 13', '6.72 inch'),
(4, 'Symphony Z50',        'Symphony', 'Android 12', '6.52 inch'),
(5, 'Walton Primo NF8',    'Walton',   'Android 11', '6.55 inch');

-- ============================================================
-- TABLE 6: apps
-- ============================================================
CREATE TABLE apps (
    app_id         INT AUTO_INCREMENT PRIMARY KEY,
    app_name       VARCHAR(100) NOT NULL,
    category_id    INT          DEFAULT NULL,
    developer_name VARCHAR(100) DEFAULT NULL,
    package_name   VARCHAR(100) DEFAULT NULL UNIQUE,
    created_at     DATE         DEFAULT NULL,
    FOREIGN KEY (category_id) REFERENCES app_categories(category_id)
) ENGINE=InnoDB;

INSERT INTO apps VALUES
(1, 'Flashlight 2026',       1, 'GUB Dev Team', 'com.gub.flashlight',   '2026-01-01'),
(2, 'Quick Notes BD',        3, 'GUB Dev Team', 'com.gub.quicknotes',   '2026-01-15'),
(3, 'Fitness Tracker BD',    4, 'GUB Dev Team', 'com.gub.fitness',      '2026-02-01'),
(4, 'BDTaka Budget Manager', 5, 'GUB Dev Team', 'com.gub.bdtaka',       '2026-02-10');

-- ============================================================
-- TABLE 7: app_versions
-- ============================================================
CREATE TABLE app_versions (
    version_id     INT AUTO_INCREMENT PRIMARY KEY,
    app_id         INT         DEFAULT NULL,
    version_number VARCHAR(20) DEFAULT NULL,
    release_date   DATE        DEFAULT NULL,
    is_current     TINYINT(1)  DEFAULT 1,
    FOREIGN KEY (app_id) REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO app_versions VALUES
(1, 1, '1.0.0', '2026-01-01', 0),
(2, 1, '1.1.0', '2026-02-01', 0),
(3, 1, '1.2.0', '2026-03-01', 1),
(4, 2, '1.0.0', '2026-01-15', 0),
(5, 2, '1.1.0', '2026-02-15', 1),
(6, 3, '1.0.0', '2026-02-01', 1),
(7, 4, '1.0.0', '2026-02-10', 1);

-- ============================================================
-- TABLE 8: tester_devices
-- ============================================================
CREATE TABLE tester_devices (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    tester_id     INT  DEFAULT NULL,
    device_id     INT  DEFAULT NULL,
    assigned_date DATE DEFAULT NULL,
    FOREIGN KEY (tester_id) REFERENCES testers(tester_id),
    FOREIGN KEY (device_id) REFERENCES test_devices(device_id)
) ENGINE=InnoDB;

INSERT INTO tester_devices VALUES
( 1,  1, 1, '2026-01-05'),( 2,  2, 2, '2026-01-05'),
( 3,  3, 3, '2026-01-06'),( 4,  4, 4, '2026-01-06'),
( 5,  5, 5, '2026-01-07'),( 6,  6, 1, '2026-01-07'),
( 7,  7, 2, '2026-01-08'),( 8,  8, 3, '2026-01-08'),
( 9,  9, 4, '2026-01-09'),(10, 10, 5, '2026-01-09'),
(11, 11, 1, '2026-01-10'),(12, 12, 2, '2026-01-10'),
(13, 13, 3, '2026-01-11'),(14, 14, 4, '2026-01-11'),
(15, 15, 5, '2026-01-12'),(16, 16, 1, '2026-01-12'),
(17, 17, 2, '2026-01-13'),(18, 18, 3, '2026-01-13'),
(19, 19, 4, '2026-01-14'),(20, 20, 5, '2026-01-14');

-- ============================================================
-- TABLE 9: activity_logs  (KEY TABLE — 20 testers × 14 days)
-- ============================================================
CREATE TABLE activity_logs (
    log_id    INT AUTO_INCREMENT PRIMARY KEY,
    tester_id INT  DEFAULT NULL,
    app_id    INT  DEFAULT NULL,
    test_date DATE DEFAULT NULL,
    status    ENUM('active','inactive','skipped') DEFAULT 'active',
    device_id INT  DEFAULT NULL,
    FOREIGN KEY (tester_id) REFERENCES testers(tester_id),
    FOREIGN KEY (app_id)    REFERENCES apps(app_id),
    FOREIGN KEY (device_id) REFERENCES test_devices(device_id)
) ENGINE=InnoDB;

-- 20 testers × 14 days = 280 log entries (all active — qualified for Play Store)
INSERT INTO activity_logs (tester_id, app_id, test_date, status, device_id) VALUES
-- Tester 1 — 14 days
(1,1,'2026-03-01','active',1),(1,1,'2026-03-02','active',1),(1,1,'2026-03-03','active',1),
(1,1,'2026-03-04','active',1),(1,1,'2026-03-05','active',1),(1,1,'2026-03-06','active',1),
(1,1,'2026-03-07','active',1),(1,1,'2026-03-08','active',1),(1,1,'2026-03-09','active',1),
(1,1,'2026-03-10','active',1),(1,1,'2026-03-11','active',1),(1,1,'2026-03-12','active',1),
(1,1,'2026-03-13','active',1),(1,1,'2026-03-14','active',1),
-- Tester 2
(2,1,'2026-03-01','active',2),(2,1,'2026-03-02','active',2),(2,1,'2026-03-03','active',2),
(2,1,'2026-03-04','active',2),(2,1,'2026-03-05','active',2),(2,1,'2026-03-06','active',2),
(2,1,'2026-03-07','active',2),(2,1,'2026-03-08','active',2),(2,1,'2026-03-09','active',2),
(2,1,'2026-03-10','active',2),(2,1,'2026-03-11','active',2),(2,1,'2026-03-12','active',2),
(2,1,'2026-03-13','active',2),(2,1,'2026-03-14','active',2),
-- Tester 3
(3,1,'2026-03-01','active',3),(3,1,'2026-03-02','active',3),(3,1,'2026-03-03','active',3),
(3,1,'2026-03-04','active',3),(3,1,'2026-03-05','active',3),(3,1,'2026-03-06','active',3),
(3,1,'2026-03-07','active',3),(3,1,'2026-03-08','active',3),(3,1,'2026-03-09','active',3),
(3,1,'2026-03-10','active',3),(3,1,'2026-03-11','active',3),(3,1,'2026-03-12','active',3),
(3,1,'2026-03-13','active',3),(3,1,'2026-03-14','active',3),
-- Tester 4
(4,1,'2026-03-01','active',4),(4,1,'2026-03-02','active',4),(4,1,'2026-03-03','active',4),
(4,1,'2026-03-04','active',4),(4,1,'2026-03-05','active',4),(4,1,'2026-03-06','active',4),
(4,1,'2026-03-07','active',4),(4,1,'2026-03-08','active',4),(4,1,'2026-03-09','active',4),
(4,1,'2026-03-10','active',4),(4,1,'2026-03-11','active',4),(4,1,'2026-03-12','active',4),
(4,1,'2026-03-13','active',4),(4,1,'2026-03-14','active',4),
-- Tester 5
(5,1,'2026-03-01','active',5),(5,1,'2026-03-02','active',5),(5,1,'2026-03-03','active',5),
(5,1,'2026-03-04','active',5),(5,1,'2026-03-05','active',5),(5,1,'2026-03-06','active',5),
(5,1,'2026-03-07','active',5),(5,1,'2026-03-08','active',5),(5,1,'2026-03-09','active',5),
(5,1,'2026-03-10','active',5),(5,1,'2026-03-11','active',5),(5,1,'2026-03-12','active',5),
(5,1,'2026-03-13','active',5),(5,1,'2026-03-14','active',5),
-- Tester 6
(6,1,'2026-03-01','active',1),(6,1,'2026-03-02','active',1),(6,1,'2026-03-03','active',1),
(6,1,'2026-03-04','active',1),(6,1,'2026-03-05','active',1),(6,1,'2026-03-06','active',1),
(6,1,'2026-03-07','active',1),(6,1,'2026-03-08','active',1),(6,1,'2026-03-09','active',1),
(6,1,'2026-03-10','active',1),(6,1,'2026-03-11','active',1),(6,1,'2026-03-12','active',1),
(6,1,'2026-03-13','active',1),(6,1,'2026-03-14','active',1),
-- Tester 7
(7,1,'2026-03-01','active',2),(7,1,'2026-03-02','active',2),(7,1,'2026-03-03','active',2),
(7,1,'2026-03-04','active',2),(7,1,'2026-03-05','active',2),(7,1,'2026-03-06','active',2),
(7,1,'2026-03-07','active',2),(7,1,'2026-03-08','active',2),(7,1,'2026-03-09','active',2),
(7,1,'2026-03-10','active',2),(7,1,'2026-03-11','active',2),(7,1,'2026-03-12','active',2),
(7,1,'2026-03-13','active',2),(7,1,'2026-03-14','active',2),
-- Tester 8
(8,1,'2026-03-01','active',3),(8,1,'2026-03-02','active',3),(8,1,'2026-03-03','active',3),
(8,1,'2026-03-04','active',3),(8,1,'2026-03-05','active',3),(8,1,'2026-03-06','active',3),
(8,1,'2026-03-07','active',3),(8,1,'2026-03-08','active',3),(8,1,'2026-03-09','active',3),
(8,1,'2026-03-10','active',3),(8,1,'2026-03-11','active',3),(8,1,'2026-03-12','active',3),
(8,1,'2026-03-13','active',3),(8,1,'2026-03-14','active',3),
-- Tester 9
(9,1,'2026-03-01','active',4),(9,1,'2026-03-02','active',4),(9,1,'2026-03-03','active',4),
(9,1,'2026-03-04','active',4),(9,1,'2026-03-05','active',4),(9,1,'2026-03-06','active',4),
(9,1,'2026-03-07','active',4),(9,1,'2026-03-08','active',4),(9,1,'2026-03-09','active',4),
(9,1,'2026-03-10','active',4),(9,1,'2026-03-11','active',4),(9,1,'2026-03-12','active',4),
(9,1,'2026-03-13','active',4),(9,1,'2026-03-14','active',4),
-- Tester 10
(10,1,'2026-03-01','active',5),(10,1,'2026-03-02','active',5),(10,1,'2026-03-03','active',5),
(10,1,'2026-03-04','active',5),(10,1,'2026-03-05','active',5),(10,1,'2026-03-06','active',5),
(10,1,'2026-03-07','active',5),(10,1,'2026-03-08','active',5),(10,1,'2026-03-09','active',5),
(10,1,'2026-03-10','active',5),(10,1,'2026-03-11','active',5),(10,1,'2026-03-12','active',5),
(10,1,'2026-03-13','active',5),(10,1,'2026-03-14','active',5),
-- Tester 11
(11,1,'2026-03-01','active',1),(11,1,'2026-03-02','active',1),(11,1,'2026-03-03','active',1),
(11,1,'2026-03-04','active',1),(11,1,'2026-03-05','active',1),(11,1,'2026-03-06','active',1),
(11,1,'2026-03-07','active',1),(11,1,'2026-03-08','active',1),(11,1,'2026-03-09','active',1),
(11,1,'2026-03-10','active',1),(11,1,'2026-03-11','active',1),(11,1,'2026-03-12','active',1),
(11,1,'2026-03-13','active',1),(11,1,'2026-03-14','active',1),
-- Tester 12
(12,1,'2026-03-01','active',2),(12,1,'2026-03-02','active',2),(12,1,'2026-03-03','active',2),
(12,1,'2026-03-04','active',2),(12,1,'2026-03-05','active',2),(12,1,'2026-03-06','active',2),
(12,1,'2026-03-07','active',2),(12,1,'2026-03-08','active',2),(12,1,'2026-03-09','active',2),
(12,1,'2026-03-10','active',2),(12,1,'2026-03-11','active',2),(12,1,'2026-03-12','active',2),
(12,1,'2026-03-13','active',2),(12,1,'2026-03-14','active',2),
-- Tester 13
(13,1,'2026-03-01','active',3),(13,1,'2026-03-02','active',3),(13,1,'2026-03-03','active',3),
(13,1,'2026-03-04','active',3),(13,1,'2026-03-05','active',3),(13,1,'2026-03-06','active',3),
(13,1,'2026-03-07','active',3),(13,1,'2026-03-08','active',3),(13,1,'2026-03-09','active',3),
(13,1,'2026-03-10','active',3),(13,1,'2026-03-11','active',3),(13,1,'2026-03-12','active',3),
(13,1,'2026-03-13','active',3),(13,1,'2026-03-14','active',3),
-- Tester 14
(14,1,'2026-03-01','active',4),(14,1,'2026-03-02','active',4),(14,1,'2026-03-03','active',4),
(14,1,'2026-03-04','active',4),(14,1,'2026-03-05','active',4),(14,1,'2026-03-06','active',4),
(14,1,'2026-03-07','active',4),(14,1,'2026-03-08','active',4),(14,1,'2026-03-09','active',4),
(14,1,'2026-03-10','active',4),(14,1,'2026-03-11','active',4),(14,1,'2026-03-12','active',4),
(14,1,'2026-03-13','active',4),(14,1,'2026-03-14','active',4),
-- Tester 15
(15,1,'2026-03-01','active',5),(15,1,'2026-03-02','active',5),(15,1,'2026-03-03','active',5),
(15,1,'2026-03-04','active',5),(15,1,'2026-03-05','active',5),(15,1,'2026-03-06','active',5),
(15,1,'2026-03-07','active',5),(15,1,'2026-03-08','active',5),(15,1,'2026-03-09','active',5),
(15,1,'2026-03-10','active',5),(15,1,'2026-03-11','active',5),(15,1,'2026-03-12','active',5),
(15,1,'2026-03-13','active',5),(15,1,'2026-03-14','active',5),
-- Tester 16
(16,1,'2026-03-01','active',1),(16,1,'2026-03-02','active',1),(16,1,'2026-03-03','active',1),
(16,1,'2026-03-04','active',1),(16,1,'2026-03-05','active',1),(16,1,'2026-03-06','active',1),
(16,1,'2026-03-07','active',1),(16,1,'2026-03-08','active',1),(16,1,'2026-03-09','active',1),
(16,1,'2026-03-10','active',1),(16,1,'2026-03-11','active',1),(16,1,'2026-03-12','active',1),
(16,1,'2026-03-13','active',1),(16,1,'2026-03-14','active',1),
-- Tester 17
(17,1,'2026-03-01','active',2),(17,1,'2026-03-02','active',2),(17,1,'2026-03-03','active',2),
(17,1,'2026-03-04','active',2),(17,1,'2026-03-05','active',2),(17,1,'2026-03-06','active',2),
(17,1,'2026-03-07','active',2),(17,1,'2026-03-08','active',2),(17,1,'2026-03-09','active',2),
(17,1,'2026-03-10','active',2),(17,1,'2026-03-11','active',2),(17,1,'2026-03-12','active',2),
(17,1,'2026-03-13','active',2),(17,1,'2026-03-14','active',2),
-- Tester 18
(18,1,'2026-03-01','active',3),(18,1,'2026-03-02','active',3),(18,1,'2026-03-03','active',3),
(18,1,'2026-03-04','active',3),(18,1,'2026-03-05','active',3),(18,1,'2026-03-06','active',3),
(18,1,'2026-03-07','active',3),(18,1,'2026-03-08','active',3),(18,1,'2026-03-09','active',3),
(18,1,'2026-03-10','active',3),(18,1,'2026-03-11','active',3),(18,1,'2026-03-12','active',3),
(18,1,'2026-03-13','active',3),(18,1,'2026-03-14','active',3),
-- Tester 19
(19,1,'2026-03-01','active',4),(19,1,'2026-03-02','active',4),(19,1,'2026-03-03','active',4),
(19,1,'2026-03-04','active',4),(19,1,'2026-03-05','active',4),(19,1,'2026-03-06','active',4),
(19,1,'2026-03-07','active',4),(19,1,'2026-03-08','active',4),(19,1,'2026-03-09','active',4),
(19,1,'2026-03-10','active',4),(19,1,'2026-03-11','active',4),(19,1,'2026-03-12','active',4),
(19,1,'2026-03-13','active',4),(19,1,'2026-03-14','active',4),
-- Tester 20
(20,1,'2026-03-01','active',5),(20,1,'2026-03-02','active',5),(20,1,'2026-03-03','active',5),
(20,1,'2026-03-04','active',5),(20,1,'2026-03-05','active',5),(20,1,'2026-03-06','active',5),
(20,1,'2026-03-07','active',5),(20,1,'2026-03-08','active',5),(20,1,'2026-03-09','active',5),
(20,1,'2026-03-10','active',5),(20,1,'2026-03-11','active',5),(20,1,'2026-03-12','active',5),
(20,1,'2026-03-13','active',5),(20,1,'2026-03-14','active',5);

-- ============================================================
-- TABLE 10: bug_severity
-- ============================================================
CREATE TABLE bug_severity (
    severity_id   INT AUTO_INCREMENT PRIMARY KEY,
    severity_name VARCHAR(30) NOT NULL,
    priority      INT DEFAULT 1
) ENGINE=InnoDB;

INSERT INTO bug_severity VALUES
(1, 'Critical', 1),
(2, 'High',     2),
(3, 'Medium',   3),
(4, 'Low',      4),
(5, 'Minor',    5);

-- ============================================================
-- TABLE 11: bug_reports
-- ============================================================
CREATE TABLE bug_reports (
    bug_id        INT AUTO_INCREMENT PRIMARY KEY,
    tester_id     INT  DEFAULT NULL,
    app_id        INT  DEFAULT NULL,
    severity_id   INT  DEFAULT NULL,
    description   TEXT,
    reported_date DATE DEFAULT NULL,
    status        ENUM('open','fixed','wontfix') DEFAULT 'open',
    FOREIGN KEY (tester_id)   REFERENCES testers(tester_id),
    FOREIGN KEY (app_id)      REFERENCES apps(app_id),
    FOREIGN KEY (severity_id) REFERENCES bug_severity(severity_id)
) ENGINE=InnoDB;

INSERT INTO bug_reports VALUES
(1,  1, 1, 2, 'App crashes on Android 14 cold start', '2026-03-03', 'fixed'),
(2,  3, 1, 3, 'Flashlight button slow to respond',    '2026-03-05', 'fixed'),
(3,  5, 1, 4, 'Minor UI alignment issue on home',     '2026-03-07', 'open'),
(4,  7, 1, 1, 'Null pointer exception on device rotation','2026-03-09','fixed'),
(5, 10, 1, 2, 'Battery drain higher than expected',   '2026-03-11', 'open'),
(6, 12, 1, 3, 'Back button does not dismiss dialog',  '2026-03-12', 'wontfix'),
(7, 15, 1, 5, 'Spelling mistake in about screen',     '2026-03-13', 'fixed'),
(8, 18, 1, 4, 'App icon not sharp on HDPI screens',   '2026-03-14', 'open');

-- ============================================================
-- TABLE 12: test_sessions
-- ============================================================
CREATE TABLE test_sessions (
    session_id       INT AUTO_INCREMENT PRIMARY KEY,
    tester_id        INT      DEFAULT NULL,
    app_id           INT      DEFAULT NULL,
    session_date     DATE     DEFAULT NULL,
    duration_minutes INT      DEFAULT 0,
    FOREIGN KEY (tester_id) REFERENCES testers(tester_id),
    FOREIGN KEY (app_id)    REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO test_sessions VALUES
( 1,  1, 1, '2026-03-01', 25),( 2,  2, 1, '2026-03-01', 30),
( 3,  3, 1, '2026-03-02', 20),( 4,  4, 1, '2026-03-02', 35),
( 5,  5, 1, '2026-03-03', 28),( 6,  6, 1, '2026-03-03', 22),
( 7,  7, 1, '2026-03-04', 40),( 8,  8, 1, '2026-03-04', 18),
( 9,  9, 1, '2026-03-05', 32),(10, 10, 1, '2026-03-05', 27),
(11, 11, 1, '2026-03-06', 24),(12, 12, 1, '2026-03-06', 31),
(13, 13, 1, '2026-03-07', 29),(14, 14, 1, '2026-03-07', 23),
(15, 15, 1, '2026-03-08', 36),(16, 16, 1, '2026-03-08', 19),
(17, 17, 1, '2026-03-09', 33),(18, 18, 1, '2026-03-09', 26),
(19, 19, 1, '2026-03-10', 21),(20, 20, 1, '2026-03-10', 38);

-- ============================================================
-- TABLE 13: test_criteria
-- ============================================================
CREATE TABLE test_criteria (
    criteria_id          INT AUTO_INCREMENT PRIMARY KEY,
    criteria_name        VARCHAR(100) NOT NULL,
    min_days_required    INT DEFAULT 14,
    min_testers_required INT DEFAULT 20,
    description          TEXT
) ENGINE=InnoDB;

INSERT INTO test_criteria VALUES
(1, 'Google Play Closed Testing', 14, 20, 'Minimum 20 testers active for 14 consecutive days'),
(2, 'Internal Alpha Testing',      7, 10, 'Minimum 10 testers active for 7 days'),
(3, 'Open Beta Testing',          30,  5, 'Minimum 5 testers active for 30 days');

-- ============================================================
-- TABLE 14: project_assignments
-- ============================================================
CREATE TABLE project_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    tester_id     INT         DEFAULT NULL,
    app_id        INT         DEFAULT NULL,
    assigned_date DATE        DEFAULT NULL,
    role          VARCHAR(50) DEFAULT 'Tester',
    FOREIGN KEY (tester_id) REFERENCES testers(tester_id),
    FOREIGN KEY (app_id)    REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO project_assignments VALUES
( 1,  1, 1, '2026-02-28', 'Lead Tester'),
( 2,  2, 1, '2026-02-28', 'Tester'),
( 3,  3, 1, '2026-02-28', 'Tester'),
( 4,  4, 1, '2026-02-28', 'Security Tester'),
( 5,  5, 1, '2026-02-28', 'Tester'),
( 6,  6, 1, '2026-02-28', 'Tester'),
( 7,  7, 1, '2026-02-28', 'Tester'),
( 8,  8, 1, '2026-02-28', 'Tester'),
( 9,  9, 1, '2026-02-28', 'Tester'),
(10, 10, 1, '2026-02-28', 'Tester'),
(11, 11, 1, '2026-02-28', 'Tester'),
(12, 12, 1, '2026-02-28', 'Tester'),
(13, 13, 1, '2026-02-28', 'Tester'),
(14, 14, 1, '2026-02-28', 'Tester'),
(15, 15, 1, '2026-02-28', 'Performance Tester'),
(16, 16, 1, '2026-02-28', 'Tester'),
(17, 17, 1, '2026-02-28', 'Tester'),
(18, 18, 1, '2026-02-28', 'Tester'),
(19, 19, 1, '2026-02-28', 'Tester'),
(20, 20, 1, '2026-02-28', 'Tester');

-- ============================================================
-- TABLE 15: tester_feedback
-- ============================================================
CREATE TABLE tester_feedback (
    feedback_id   INT AUTO_INCREMENT PRIMARY KEY,
    tester_id     INT  DEFAULT NULL,
    app_id        INT  DEFAULT NULL,
    rating        INT  DEFAULT NULL CHECK (rating BETWEEN 1 AND 5),
    comments      TEXT,
    feedback_date DATE DEFAULT NULL,
    FOREIGN KEY (tester_id) REFERENCES testers(tester_id),
    FOREIGN KEY (app_id)    REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO tester_feedback VALUES
( 1,  1, 1, 5, 'Very smooth and fast!',           '2026-03-14'),
( 2,  2, 1, 4, 'Works well, minor UI suggestions','2026-03-14'),
( 3,  3, 1, 5, 'Love the simplicity',             '2026-03-14'),
( 4,  4, 1, 3, 'A few bugs found but fixed fast', '2026-03-14'),
( 5,  5, 1, 4, 'Good app overall',                '2026-03-14'),
( 6,  6, 1, 5, 'No issues in 14 days',            '2026-03-14'),
( 7,  7, 1, 4, 'Rotation bug was annoying',       '2026-03-14'),
( 8,  8, 1, 5, 'Fast response time',              '2026-03-14'),
( 9,  9, 1, 4, 'Battery use could be lower',      '2026-03-14'),
(10, 10, 1, 3, 'Drain issue needs fixing',        '2026-03-14');

-- ============================================================
-- TABLE 16: notifications
-- ============================================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    tester_id       INT        DEFAULT NULL,
    message         TEXT,
    sent_date       DATE       DEFAULT NULL,
    is_read         TINYINT(1) DEFAULT 0,
    FOREIGN KEY (tester_id) REFERENCES testers(tester_id)
) ENGINE=InnoDB;

INSERT INTO notifications VALUES
( 1,  1, 'You have completed Day 1 of testing!',  '2026-03-01', 1),
( 2,  2, 'You have completed Day 1 of testing!',  '2026-03-01', 1),
( 3,  3, 'Reminder: Please log your activity today','2026-03-06', 1),
( 4,  5, 'Reminder: Please log your activity today','2026-03-06', 1),
( 5, 10, 'You have completed Day 7! Halfway there!','2026-03-07', 1),
( 6, 15, 'You have completed Day 7! Halfway there!','2026-03-07', 1),
( 7,  1, 'Congratulations! 14 days completed!',    '2026-03-14', 1),
( 8,  5, 'Congratulations! 14 days completed!',    '2026-03-14', 0),
( 9, 10, 'Congratulations! 14 days completed!',    '2026-03-14', 0),
(10, 20, 'Congratulations! 14 days completed!',    '2026-03-14', 0);

-- ============================================================
-- TABLE 17: play_store_submissions
-- ============================================================
CREATE TABLE play_store_submissions (
    submission_id   INT AUTO_INCREMENT PRIMARY KEY,
    app_id          INT  DEFAULT NULL,
    submission_date DATE DEFAULT NULL,
    status          ENUM('pending','approved','rejected') DEFAULT 'pending',
    reviewer_notes  TEXT,
    FOREIGN KEY (app_id) REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO play_store_submissions VALUES
(1, 1, '2026-03-15', 'pending',  'Awaiting Google review after 14-day test cycle'),
(2, 2, '2026-02-20', 'approved', 'All requirements met'),
(3, 3, '2026-02-25', 'rejected', 'Needs more testers'),
(4, 4, '2026-03-10', 'pending',  'Under review');

-- ============================================================
-- TABLE 18: app_permissions
-- ============================================================
CREATE TABLE app_permissions (
    permission_id   INT AUTO_INCREMENT PRIMARY KEY,
    app_id          INT         DEFAULT NULL,
    permission_name VARCHAR(100) NOT NULL,
    is_required     TINYINT(1)  DEFAULT 1,
    FOREIGN KEY (app_id) REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO app_permissions VALUES
(1, 1, 'CAMERA',             1),
(2, 1, 'FLASHLIGHT',         1),
(3, 1, 'WAKE_LOCK',          1),
(4, 2, 'READ_EXTERNAL_STORAGE',1),
(5, 2, 'WRITE_EXTERNAL_STORAGE',1),
(6, 3, 'ACTIVITY_RECOGNITION',1),
(7, 3, 'BODY_SENSORS',       0),
(8, 4, 'INTERNET',           1),
(9, 4, 'ACCESS_NETWORK_STATE',1),
(10,1, 'FOREGROUND_SERVICE', 0);

-- ============================================================
-- TABLE 19: daily_reports
-- ============================================================
CREATE TABLE daily_reports (
    report_id            INT AUTO_INCREMENT PRIMARY KEY,
    report_date          DATE DEFAULT NULL,
    app_id               INT  DEFAULT NULL,
    total_active_testers INT  DEFAULT 0,
    total_logs           INT  DEFAULT 0,
    completion_percent   DECIMAL(5,2) DEFAULT 0.00,
    FOREIGN KEY (app_id) REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO daily_reports VALUES
( 1, '2026-03-01', 1, 20, 20, 100.00),
( 2, '2026-03-02', 1, 20, 20, 100.00),
( 3, '2026-03-03', 1, 20, 20, 100.00),
( 4, '2026-03-04', 1, 20, 20, 100.00),
( 5, '2026-03-05', 1, 20, 20, 100.00),
( 6, '2026-03-06', 1, 20, 20, 100.00),
( 7, '2026-03-07', 1, 20, 20, 100.00),
( 8, '2026-03-08', 1, 20, 20, 100.00),
( 9, '2026-03-09', 1, 20, 20, 100.00),
(10, '2026-03-10', 1, 20, 20, 100.00),
(11, '2026-03-11', 1, 20, 20, 100.00),
(12, '2026-03-12', 1, 20, 20, 100.00),
(13, '2026-03-13', 1, 20, 20, 100.00),
(14, '2026-03-14', 1, 20, 20, 100.00);

-- ============================================================
-- TABLE 20: project_milestones
-- ============================================================
CREATE TABLE project_milestones (
    milestone_id   INT AUTO_INCREMENT PRIMARY KEY,
    app_id         INT         DEFAULT NULL,
    milestone_name VARCHAR(100) NOT NULL,
    target_date    DATE        DEFAULT NULL,
    achieved_date  DATE        DEFAULT NULL,
    status         ENUM('pending','achieved','missed') DEFAULT 'pending',
    FOREIGN KEY (app_id) REFERENCES apps(app_id)
) ENGINE=InnoDB;

INSERT INTO project_milestones VALUES
(1, 1, 'Recruit 20 Testers',          '2026-01-15', '2026-01-14', 'achieved'),
(2, 1, 'Start 14-Day Testing Cycle',   '2026-03-01', '2026-03-01', 'achieved'),
(3, 1, 'Complete Day 7 Checkpoint',    '2026-03-07', '2026-03-07', 'achieved'),
(4, 1, 'All 20 Testers Complete 14d',  '2026-03-14', '2026-03-14', 'achieved'),
(5, 1, 'Submit to Play Store',         '2026-03-15', '2026-03-15', 'achieved'),
(6, 1, 'Play Store Approval',          '2026-03-25', NULL,         'pending'),
(7, 2, 'Recruit Testers',              '2026-02-01', '2026-02-01', 'achieved'),
(8, 2, 'Complete Testing Cycle',       '2026-02-15', '2026-02-15', 'achieved');

COMMIT;
-- ============================================================
-- END OF SQL — 20 Tables Created Successfully
-- Mobile App Testing Cycle Tracker | GUB | CSE 210
-- ============================================================
