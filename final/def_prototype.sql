--create database
DROP DATABASE IF EXISTS test_gym;
CREATE DATABASE test_gym;
\c test_gym

-- Tạo bảng Package
CREATE TABLE Package (
    package_id SERIAL PRIMARY KEY,
    package_name VARCHAR(100),
    package_duration VARCHAR(20),
    package_price FLOAT,
    package_sale INT
);

-- Tạo bảng Employee
CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    employee_email VARCHAR(50) NOT NULL,
    employee_password VARCHAR(50) NOT NULL,
    employee_name VARCHAR(50) NOT NULL,
    employee_role VARCHAR(20) NOT NULL
);

-- Tạo bảng Room
CREATE TABLE Room (
    room_id SERIAL PRIMARY KEY,
    room_name VARCHAR(50) NOT NULL
);

-- Tạo bảng Member
CREATE TABLE Member (
    member_id SERIAL PRIMARY KEY,
    member_email VARCHAR(50) NOT NULL,
    member_password VARCHAR(50) NOT NULL,
    member_name VARCHAR(50) NOT NULL,
    member_dob DATE,
    member_address VARCHAR(200),
    member_phone_number VARCHAR(15)
);

-- Tạo bảng Register
CREATE TABLE Register (
    register_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    package_id INT NOT NULL,
    register_status VARCHAR(50),
    register_time TIME,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (package_id) REFERENCES Package(package_id)
);

-- Tạo bảng Equipment
CREATE TABLE Equipment (
    equipment_id SERIAL PRIMARY KEY,
    equipment_name VARCHAR(100) NOT NULL,
    equipment_count INT,
    equipment_condition VARCHAR(15),
    room_id INT NOT NULL,
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

-- Tạo bảng Feedback
CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    employee_id INT,
    room_id INT,
    time TIME,
    description TEXT,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

-- Tạo bảng Access
CREATE TABLE Access (
    access_id SERIAL PRIMARY KEY,
    room_id INT NOT NULL,
    package_id INT NOT NULL,
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (package_id) REFERENCES Package(package_id)
);

-- view

-- View để hiển thị thông tin chi tiết của mỗi gói dịch vụ kèm theo số lần đăng ký
CREATE VIEW Package_Details AS
SELECT p.package_id, p.package_name, p.package_duration, p.package_price, COUNT(r.register_id) AS register_count
FROM Package p
LEFT JOIN Register r ON p.package_id = r.package_id
GROUP BY p.package_id, p.package_name, p.package_duration, p.package_price;

-- View để hiển thị thông tin của mỗi thành viên và gói dịch vụ mà họ đã đăng ký
CREATE VIEW Member_Package AS
SELECT m.member_id, m.member_name, p.package_name, p.package_duration, p.package_price
FROM Member m
JOIN Register r ON m.member_id = r.member_id
JOIN Package p ON r.package_id = p.package_id;

-- View để hiển thị số lượng thiết bị trong từng phòng tập
CREATE VIEW Room_Equipment_Count AS
SELECT r.room_id, r.room_name, COUNT(e.equipment_id) AS equipment_count
FROM Room r
LEFT JOIN Equipment e ON r.room_id = e.room_id
GROUP BY r.room_id, r.room_name;

-- View để hiển thị thông tin chi tiết của từng phản hồi từ thành viên
CREATE VIEW Member_Feedback_Details AS
SELECT f.feedback_id, m.member_name, e.employee_name, r.room_name, f.time, f.description
FROM Feedback f
JOIN Member m ON f.member_id = m.member_id
LEFT JOIN Employee e ON f.employee_id = e.employee_id
LEFT JOIN Room r ON f.room_id = r.room_id;

-- View để hiển thị số lượt truy cập vào từng phòng theo gói dịch vụ
CREATE VIEW Room_Access_Count AS
SELECT r.room_id, r.room_name, p.package_name, COUNT(a.access_id) AS access_count
FROM Room r
JOIN Access a ON r.room_id = a.room_id
JOIN Package p ON a.package_id = p.package_id
GROUP BY r.room_id, r.room_name, p.package_name;

-- function

-- trigger
