-- Insert sample data into Package table
INSERT INTO Package (package_name, package_duration, package_price, package_sale) 
VALUES 
('Standard', '1 month', 50.00, 0),
('Premium', '3 months', 120.00, 10),
('VIP', '6 months', 200.00, 20);

-- Insert sample data into Employee table
INSERT INTO Employee (employee_email, employee_password, employee_name, employee_role) 
VALUES 
('john@example.com', 'password', 'John Doe', 'Trainer'),
('jane@example.com', 'password', 'Jane Smith', 'Receptionist');

-- Insert sample data into Room table
INSERT INTO Room (room_name) 
VALUES 
('Cardio Room'),
('Weightlifting Room'),
('Yoga Studio');

-- Insert sample data into Member table
INSERT INTO Member (member_email, member_password, member_name, member_dob, member_address, member_phone_number) 
VALUES 
('member1@example.com', 'password', 'Alice Johnson', '1990-05-15', '123 Main St, City', '123-456-7890'),
('member2@example.com', 'password', 'Bob Smith', '1985-08-20', '456 Oak St, Town', '456-789-0123'),
('member3@example.com', 'password', 'Charlie Brown', '1992-12-10', '789 Elm St, Village', '789-012-3456');

-- Insert sample data into Register table
INSERT INTO Register (member_id, package_id, register_status, register_time) 
VALUES 
(1, 1, 'Active', CURRENT_TIME),
(2, 2, 'Active', CURRENT_TIME),
(3, 3, 'Active', CURRENT_TIME);

-- Insert sample data into Equipment table
INSERT INTO Equipment (equipment_name, equipment_count, equipment_condition, room_id) 
VALUES 
('Treadmill', 5, 'Good', 1),
('Dumbbells', 10, 'Excellent', 2),
('Yoga Mats', 20, 'Good', 3);

-- Insert sample data into Feedback table
INSERT INTO Feedback (member_id, employee_id, room_id, time, description) 
VALUES 
(1, 1, 1, CURRENT_TIME, 'Great workout today!'),
(2, 2, 2, CURRENT_TIME, 'The weights were well-organized.'),
(3, 1, 3, CURRENT_TIME, 'The yoga instructor was very helpful.');

-- Insert sample data into Access table
INSERT INTO Access (room_id, package_id) 
VALUES 
(1, 1),
(2, 2),
(3, 3);
