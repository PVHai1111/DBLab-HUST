-- 1. Tìm các hội viên có nhiều feedback nhất
SELECT member_id, COUNT(feedback_id) AS feedback_count
FROM Feedback
GROUP BY member_id
ORDER BY feedback_count DESC;

-- 2. Tìm các nhân viên có nhiều feedback nhất
SELECT employee_id, COUNT(feedback_id) AS feedback_count
FROM Feedback
GROUP BY employee_id
ORDER BY feedback_count DESC;

-- 3. Tìm các phòng có nhiều thiết bị nhất
SELECT room_id, COUNT(equipment_id) AS equipment_count
FROM Equipment
GROUP BY room_id
ORDER BY equipment_count DESC;

-- 4. Tìm các hội viên đăng ký gói tập đắt nhất
SELECT m.member_id, m.member_name, p.package_name, p.package_price
FROM Member m
JOIN Register r ON m.member_id = r.member_id
JOIN Package p ON r.package_id = p.package_id
ORDER BY p.package_price DESC
LIMIT 10;

-- 5. Tìm các hội viên đăng ký nhiều gói tập nhất
SELECT member_id, COUNT(package_id) AS package_count
FROM Register
GROUP BY member_id
ORDER BY package_count DESC;

-- 6. Tìm các gói tập được đăng ký nhiều nhất
SELECT package_id, COUNT(register_id) AS register_count
FROM Register
GROUP BY package_id
ORDER BY register_count DESC;

-- 7. Tìm các thiết bị được sử dụng nhiều nhất
SELECT equipment_name, COUNT(equipment_id) AS usage_count
FROM Equipment
GROUP BY equipment_name
ORDER BY usage_count DESC;

-- 8. Tìm các phòng có nhiều feedback nhất
SELECT room_id, COUNT(feedback_id) AS feedback_count
FROM Feedback
GROUP BY room_id
ORDER BY feedback_count DESC;

-- 9. Tìm tổng doanh thu từ các gói tập
SELECT SUM(package_price) AS total_revenue
FROM Package
JOIN Register ON Package.package_id = Register.package_id;

-- 10. Tìm doanh thu theo từng gói tập
SELECT package_id, SUM(package_price) AS revenue
FROM Package
JOIN Register ON Package.package_id = Register.package_id
GROUP BY package_id;

-- 11. Tìm tổng số hội viên của phòng tập
SELECT COUNT(*) AS total_members
FROM Member;

-- 12. Tìm thông tin các hội viên có ngày sinh trong tháng hiện tại
SELECT member_id, member_name, member_dob
FROM Member
WHERE EXTRACT(MONTH FROM member_dob) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 13. Tìm thông tin các nhân viên có email chứa chuỗi "gmail.com"
SELECT *
FROM Employee
WHERE employee_email LIKE '%gmail.com%';

-- 14. Tìm các gói tập chưa có ai đăng ký
SELECT *
FROM Package
WHERE package_id NOT IN (SELECT DISTINCT package_id FROM Register);

-- 15. Tìm các hội viên có địa chỉ chứa chuỗi "Hà Nội"
SELECT *
FROM Member
WHERE member_address LIKE '%Hà Nội%';

-- 16. Tìm các hội viên có số điện thoại bắt đầu bằng "098"
SELECT *
FROM Member
WHERE member_phone_number LIKE '098%';

-- 17. Tìm các thiết bị có tình trạng "tốt"
SELECT *
FROM Equipment
WHERE equipment_condition = 'tốt';

-- 18. Tìm các phòng chưa có thiết bị
SELECT *
FROM Room
WHERE room_id NOT IN (SELECT DISTINCT room_id FROM Equipment);

-- 19. Tìm thông tin các hội viên đã đăng ký trong ngày hôm nay
SELECT *
FROM Register
WHERE register_time::DATE = CURRENT_DATE;

-- 20. Tìm các thiết bị có số lượng lớn hơn 10
SELECT *
FROM Equipment
WHERE equipment_count > 10;

-- 21. Tìm thông tin các hội viên và gói tập của họ
SELECT m.member_id, m.member_name, p.package_name
FROM Member m
JOIN Register r ON m.member_id = r.member_id
JOIN Package p ON r.package_id = p.package_id;

-- 22. Tìm các phòng có thiết bị tên là "Máy chạy bộ"
SELECT DISTINCT r.room_id, r.room_name
FROM Room r
JOIN Equipment e ON r.room_id = e.room_id
WHERE e.equipment_name = 'Máy chạy bộ';

-- 23. Tìm các gói tập có giá từ 500,000 đến 1,000,000
SELECT *
FROM Package
WHERE package_price BETWEEN 500000 AND 1000000;

-- 24. Tìm tổng số lượt đăng ký của mỗi hội viên
SELECT member_id, COUNT(register_id) AS register_count
FROM Register
GROUP BY member_id;

-- 25. Tìm thông tin phản hồi của các hội viên về nhân viên cụ thể
SELECT f.feedback_id, m.member_name, e.employee_name, f.description
FROM Feedback f
JOIN Member m ON f.member_id = m.member_id
JOIN Employee e ON f.employee_id = e.employee_id
WHERE e.employee_name = 'Nguyễn Văn A';

-- 26. Tìm các hội viên đã đăng ký gói tập trong khoảng thời gian nhất định
SELECT m.member_id, m.member_name, r.register_time, p.package_name
FROM Member m
JOIN Register r ON m.member_id = r.member_id
JOIN Package p ON r.package_id = p.package_id
WHERE r.register_time BETWEEN '2024-01-01' AND '2024-12-31';

-- 27. Tìm các hội viên chưa có feedback nào
SELECT *
FROM Member
WHERE member_id NOT IN (SELECT DISTINCT member_id FROM Feedback);

-- 28. Tìm các nhân viên có vai trò là "pt"
SELECT *
FROM Employee
WHERE employee_role = 'pt';

-- 29. Tìm các gói tập có tên chứa chuỗi "VIP"
SELECT *
FROM Package
WHERE package_name LIKE '%VIP%';

-- 30. Tìm số lượng thiết bị theo từng loại trong mỗi phòng
SELECT room_id, equipment_name, SUM(equipment_count) AS total_count
FROM Equipment
GROUP BY room_id, equipment_name
ORDER BY room_id, equipment_name;
