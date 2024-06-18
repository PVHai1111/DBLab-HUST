--1. Tìm các phòng có nhiều thiết bị nhất 

SELECT r.room_name, COUNT(e.equipment_id) AS equipment_count
FROM Room r
JOIN Equipment e ON r.room_id = e.room_id
GROUP BY r.room_name
ORDER BY equipment_count DESC;


--2. Tìm các gói tập có lượng đăng ký lớn nhất 

SELECT p.package_name, COUNT(r.register_id) AS register_count
FROM Package p
JOIN Register r ON p.package_id = r.package_id
GROUP BY p.package_name
ORDER BY register_count DESC;


--3. Tìm các thiết bị có số lượng nhiều nhất 

SELECT equipment_name, equipment_count
FROM Equipment
ORDER BY equipment_count DESC;


--4. Tìm các phòng có nhiều feedback nhất 

SELECT r.room_name, COUNT(f.feedback_id) AS feedback_count
FROM Room r
JOIN Feedback f ON r.room_id = f.room_id
GROUP BY r.room_name
ORDER BY feedback_count DESC;


--5. Tìm các nhân viên có nhiều feedback nhất 

SELECT e.employee_name, COUNT(f.feedback_id) AS feedback_count
FROM Employee e
JOIN Feedback f ON e.employee_id = f.employee_id
GROUP BY e.employee_name
ORDER BY feedback_count DESC;


--6. Tìm các các gói tập có doanh thu cao nhất 

SELECT p.package_name, SUM(p.package_price) AS total_revenue
FROM Package p
JOIN Register r ON p.package_id = r.package_id
GROUP BY p.package_name
ORDER BY total_revenue DESC;


--7. Tìm các thiết bị có tình trạng “Bad” 

SELECT * FROM Equipment
WHERE equipment_condition = 'Bad';


--8. Tìm các phòng có nhiều thiết bị với tình trạng “Bad” nhất 

SELECT r.room_name, COUNT(e.equipment_id) AS bad_equipment_count
FROM Room r
JOIN Equipment e ON r.room_id = e.room_id
WHERE e.equipment_condition = 'Bad'
GROUP BY r.room_name
ORDER BY bad_equipment_count DESC;


--9. Tìm thông tin các hội viên đăng ký trong ngày  

SELECT * 
FROM Member m
JOIN Register r ON m.member_id = r.member_id
WHERE DATE(r.register_time) = CURRENT_DATE;


--10. Tìm các phòng tập với doanh thu cao đến thấp 

SELECT r.room_name, SUM(p.package_price) AS total_revenue
FROM Room r
JOIN Access a ON r.room_id = a.room_id
JOIN Package p ON a.package_id = p.package_id
JOIN Register rg ON p.package_id = rg.package_id
GROUP BY r.room_name
ORDER BY total_revenue DESC;


--11. Tìm các gói tập có giá cao nhất kèm doanh thu 

SELECT p.package_name, p.package_price, SUM(p.package_price) AS total_revenue
FROM Package p
JOIN Register r ON p.package_id = r.package_id
GROUP BY p.package_name, p.package_price
ORDER BY p.package_price DESC;


--12. Tìm các gói tập chứa chuỗi “VIP” 

SELECT * FROM Package
WHERE package_name LIKE '%VIP%';


--13. Tìm các hội viên có nhiều feedback nhất 

SELECT m.member_name, COUNT(f.feedback_id) AS feedback_count
FROM Member m
JOIN Feedback f ON m.member_id = f.member_id
GROUP BY m.member_name
ORDER BY feedback_count DESC;


--14. Tìm các gói tập có giá trên 500 

SELECT * FROM Package
WHERE package_price > 500;


--15. Tìm các phòng tập có nhiều hội viên đăng ký nhất 

SELECT r.room_name, COUNT(rg.register_id) AS member_count
FROM Room r
JOIN Access a ON r.room_id = a.room_id
JOIN Package p ON a.package_id = p.package_id
JOIN Register rg ON p.package_id = rg.package_id
GROUP BY r.room_name
ORDER BY member_count DESC;


--16. Tìm thông tin các hội viên có ngày sinh trong tháng hiện  

SELECT * FROM Member
WHERE EXTRACT(MONTH FROM member_dob) = EXTRACT(MONTH FROM CURRENT_DATE);


--17. Tìm thông tin các hội viên đăng ký trong ngày hôm nay 

SELECT * FROM Member
JOIN Register r ON m.member_id = r.member_id
WHERE DATE(r.register_time) = CURRENT_DATE;


--18. Tìm các hội viên có phản hồi trong tháng hiện tại 

SELECT m.member_name, COUNT(f.feedback_id) AS feedback_count
FROM Member m
JOIN Feedback f ON m.member_id = f.member_id
WHERE EXTRACT(MONTH FROM f.time) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY m.member_name
ORDER BY feedback_count DESC;


--19. Tìm doanh thu các gói trong tháng hiện tại 

SELECT SUM(p.package_price) AS total_revenue
FROM Package p
JOIN Register r ON p.package_id = r.package_id
WHERE EXTRACT(MONTH FROM r.register_time) = EXTRACT(MONTH FROM CURRENT_DATE);


--20. Tìm các gói tập có đăng ký nhiều nhất trong tháng hiện tại 

SELECT r.room_name, COUNT(rg.register_id) AS new_register_count
FROM Room r
JOIN Access a ON r.room_id = a.room_id
JOIN Package p ON a.package_id = p.package_id
JOIN Register rg ON p.package_id = rg.package_id
WHERE EXTRACT(MONTH FROM rg.register_time) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY r.room_name
ORDER BY new_register_count DESC;

