-- 1.  số lượng member thuộc thành phố %input% 

DROP FUNCTION IF EXISTS count_members_in_city (VARCHAR);

CREATE OR REPLACE FUNCTION count_members_in_city(in_city VARCHAR(100))
RETURNS BIGINT AS $$
DECLARE
    total_members_count BIGINT;
BEGIN
    SELECT COUNT(DISTINCT member_id)
    INTO total_members_count
    FROM Member
    WHERE member_address LIKE '%' || in_city || '%';

    RETURN total_members_count;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM count_members_in_city('New York');

-- 2. Tìm "input" nhân viên có nhiều feedback nhất 

CREATE OR REPLACE FUNCTION find_top_feedback_employees(input_count INT)
RETURNS TABLE (
    emp_id INT,
    feedback_count BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        F.employee_id AS emp_id,
        COUNT(F.feedback_id) AS feedback_count
    FROM
        Feedback F
    GROUP BY
        F.employee_id
    ORDER BY
        feedback_count DESC
    LIMIT input_count;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_top_feedback_employees(5);


-- 3. Tìm các phòng có nhiều thiết bị nhất 

CREATE INDEX idx_equipment_room_id ON Equipment(room_id);

SELECT room_id, COUNT(equipment_id) AS equipment_count
FROM Equipment
GROUP BY room_id
ORDER BY equipment_count DESC;

-- 4. Tìm số lượng member đã đăng ký gói tập trong thành phố %input%

CREATE OR REPLACE FUNCTION count_registered_members_in_city(in_city VARCHAR(100))
RETURNS BIGINT AS $$
DECLARE
    registered_members_count BIGINT;
BEGIN
    SELECT COUNT(DISTINCT R.member_id)
    INTO registered_members_count
    FROM Register R
    JOIN Member M ON R.member_id = M.member_id
    WHERE M.member_address LIKE '%' || in_city || '%';

    RETURN registered_members_count;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM count_registered_members_in_city('Ohio');


-- 5. Tìm top hội viên đăng ký nhiều gói tập nhất

DROP FUNCTION IF EXISTS find_top_member_packages (INT);

CREATE INDEX idx_register_member_id ON Register(member_id);

CREATE OR REPLACE FUNCTION find_top_member_packages(input_count INT)
RETURNS TABLE (
    member_id INT,
    package_count BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        R.member_id,
        COUNT(R.package_id) AS package_count
    FROM
        Register R
    GROUP BY
        R.member_id
    ORDER BY
        package_count DESC
    LIMIT input_count;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_top_member_packages(10); -- Lấy top 10 hội viên có nhiều gói nhất


-- 6. Tìm các gói tập có số lượng đăng ký lớn hơn input

CREATE OR REPLACE FUNCTION find_packages_with_more_registers(input_count INT)
RETURNS TABLE (
    package_id INT,
    register_count BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        R.package_id,
        COUNT(R.register_id) AS register_count
    FROM
        Register R
    GROUP BY
        R.package_id
    HAVING
        COUNT(R.register_id) > input_count
    ORDER BY
        register_count DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_packages_with_more_registers(1450); -- Lấy các gói tập có số lượng đăng ký lớn hơn 50


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

-- 9. Tìm thông tin được feedback trong ngày hôm nay

CREATE OR REPLACE FUNCTION find_feedbacks_today()
RETURNS TABLE (
    feedback_id INT,
    member_id INT,
    employee_id INT,
    room_id INT,
    time_stamp DATE,
    description TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        f.feedback_id,
        f.member_id,
        f.employee_id,
        f.room_id,
        f.time AS time_stamp,
        f.description
    FROM
        Feedback f
    WHERE
        DATE(f.time) = CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_feedbacks_today();


-- 10. Tìm doanh thu theo từng gói tập

DROP FUNCTION IF EXISTS calculate_package_revenue();

CREATE OR REPLACE FUNCTION calculate_package_revenue()
RETURNS TABLE (
    package_id INT,
    package_name VARCHAR(100),
    total_registers BIGINT, 
    package_price FLOAT,
    total_revenue FLOAT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        P.package_id,
        P.package_name,
        COUNT(R.register_id) AS total_registers,
        P.package_price,
        COUNT(R.register_id) * P.package_price AS total_revenue
    FROM
        Package P
    LEFT JOIN
        Register R ON P.package_id = R.package_id
    GROUP BY
        P.package_id, P.package_name, P.package_price;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM calculate_package_revenue();

-- 11. Tìm số lượng đăng ký của phòng có id = input

CREATE OR REPLACE FUNCTION count_registers_in_room_id(input_room_id INT)
RETURNS INT
AS $$
DECLARE
    register_count INT;
BEGIN
    -- Debugging: Output input_room_id to verify the parameter passed
    RAISE NOTICE 'Input room_id: %', input_room_id;

    -- Perform a count query to get the number of registrations for the input room_id
    SELECT COUNT(package_id)
    INTO register_count
    FROM Access
    WHERE room_id = input_room_id;

    -- Debugging: Output register_count to verify the count obtained
    RAISE NOTICE 'Registration count: %', register_count;

    RETURN register_count;
END;
$$ LANGUAGE plpgsql;

SELECT count_registers_in_room_id(22);

-- 12. -- Tìm thông tin các hội viên có ngày sinh trong tháng hiện tại

CREATE INDEX idx_member_dob ON Member(member_dob);

SELECT member_id, member_name, member_dob
FROM Member
WHERE EXTRACT(MONTH FROM member_dob) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 13. Tạo hàm tìm số lượng hội viên trong độ tuổi “input”

DROP FUNCTION IF EXISTS GetMemberCountByAgeRange(INT, INT);

CREATE OR REPLACE FUNCTION GetMemberCountByAgeRange(min_age INT, max_age INT)
RETURNS INT
AS $$
DECLARE
    number_of_members INT;
BEGIN
    SELECT COUNT(*)
    INTO number_of_members
    FROM Member
    WHERE EXTRACT(YEAR FROM AGE(current_date, member_dob)) BETWEEN min_age AND max_age;

    RETURN number_of_members;
END;
$$ LANGUAGE plpgsql;

SELECT GetMemberCountByAgeRange(25, 30);

-- 14. Tìm top "input" gói tập có ít đăng ký nhất

CREATE OR REPLACE FUNCTION get_top_least_registered_packages(input INT)
RETURNS TABLE(package_name VARCHAR, registration_count INT) AS $$
BEGIN
    RETURN QUERY
    SELECT         p.package_name,
        CAST(COUNT(r.package_id) AS INT) AS registration_count
    FROM 
        Package p
    LEFT JOIN 
        Register r ON p.package_id = r.package_id
    GROUP BY 
        p.package_name
    ORDER BY 
        registration_count ASC
    LIMIT 
        input;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_top_least_registered_packages(5);

-- 15. Tất cả nhân viên có role "input"

CREATE OR REPLACE FUNCTION find_employees_by_role(input_role VARCHAR)
RETURNS TABLE (employee_name VARCHAR, employee_role VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT
        E.employee_name,
        E.employee_role
    FROM
        Employee E
    WHERE
        E.employee_role = input_role;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_employees_by_role('manage');


-- 16. Tìm các hội viên có số điện thoại bắt đầu bằng "input"

CREATE OR REPLACE FUNCTION find_members_by_phone_prefix(input_prefix VARCHAR)
RETURNS TABLE (
    member_id INT,
    member_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.member_id,
        m.member_name
    FROM
        member m
    WHERE
        m.member_phone_number LIKE input_prefix || '%';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_members_by_phone_prefix('167');

-- 17. Tìm các thiết bị có tình trạng "Bad" 

SELECT *
FROM Equipment
WHERE equipment_condition = 'Bad';

-- 18. Tìm các phòng nhiều thiết bị có tình trạng "Bad" nhất

SELECT room_id, COUNT(*) AS bad_equipment_count
FROM Equipment
WHERE equipment_condition = 'Bad'
GROUP BY room_id
ORDER BY bad_equipment_count DESC
LIMIT 1;

-- 19. -- Tìm thông tin các hội viên đã đăng ký trong ngày hôm nay

CREATE INDEX idx_register_time ON Register(register_time);

SELECT *
FROM Register
WHERE register_time::DATE = CURRENT_DATE;

-- 20. Tìm top input_count phòng tập có doanh thu cao nhất

CREATE OR REPLACE FUNCTION FindTopRevenueRooms(input_count INT)
RETURNS TABLE (
    room_id INT,
    room_name VARCHAR(50),
    total_revenue FLOAT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        R.room_id, 
        R.room_name, 
        SUM(P.package_price * COALESCE(RG.count, 0)) AS total_revenue
    FROM 
        Room R
    JOIN 
        Access A ON R.room_id = A.room_id
    JOIN 
        Package P ON A.package_id = P.package_id
    LEFT JOIN (
        SELECT 
            package_id, 
            COUNT(*) AS count
        FROM 
            Register
        GROUP BY 
            package_id
    ) RG ON P.package_id = RG.package_id
    GROUP BY 
        R.room_id, R.room_name
    ORDER BY 
        total_revenue DESC
    LIMIT 
        input_count;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM FindTopRevenueRooms(5);

-- 21. -- Tìm thông tin hội viên có tên = "input" và gói tập của họ

CREATE OR REPLACE FUNCTION FindMembersByNamePrefix(input_prefix VARCHAR)
RETURNS TABLE (
    member_id INT,
    member_name VARCHAR,
    package_name VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.member_id, 
        m.member_name, 
        p.package_name
    FROM 
        Member m
    JOIN 
        Register r ON m.member_id = r.member_id
    JOIN 
        Package p ON r.package_id = p.package_id
    WHERE 
        m.member_name LIKE input_prefix || '%';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM FindMembersByNamePrefix('Kylie ');

-- 22. Tìm các phòng có thiết bị tên là "input" 

CREATE OR REPLACE FUNCTION find_rooms_with_equipment(input_equipment_name VARCHAR)
RETURNS TABLE (
    room_id INT,
    room_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        R.room_id,
        R.room_name
    FROM
        Room R
    JOIN
        Equipment E ON R.room_id = E.room_id
    WHERE
        E.equipment_name ILIKE '%' || input_equipment_name || '%';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_rooms_with_equipment('Tạ đòn');

-- 23. Tìm các gói tập có giá từ min đến max

CREATE OR REPLACE FUNCTION find_packages_by_price_range(
    min_price FLOAT,
    max_price FLOAT
)
RETURNS TABLE (
    package_id INT,
    package_name VARCHAR(100),
    package_duration VARCHAR(20),
    package_price FLOAT,
    package_sale INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.package_id,
        p.package_name,
        p.package_duration,
        p.package_price,
        p.package_sale
    FROM
        Package p
    WHERE
        p.package_price BETWEEN min_price AND max_price;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_packages_by_price_range(500.0, 1000.0);

-- 24. Hàm tìm tất cả thông tin về gói tập đã được member có id = "input" đăng ký

CREATE OR REPLACE FUNCTION get_member_registered_package_info(
    input_member_id INT
)
RETURNS TABLE (
    package_id INT,
    package_name VARCHAR(100),
    package_duration VARCHAR(20),
    package_price FLOAT,
    package_sale INT,
    register_status VARCHAR(50),
    register_time DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.package_id,
        p.package_name,
        p.package_duration,
        p.package_price,
        p.package_sale,
        r.register_status,
        r.register_time
    FROM
        Register r
    JOIN
        Package p ON r.package_id = p.package_id
    WHERE
        r.member_id = input_member_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_member_registered_package_info(12);


-- 25. Truy vấn tổng các gói tập có tình trạng là 'Active'

SELECT 
    COUNT(*) AS active_count,
    p.package_name,
    SUM(p.package_price) AS total_price
FROM 
    Package p
JOIN 
    Register r ON p.package_id = r.package_id
WHERE 
    r.register_status = 'Active'
GROUP BY 
    p.package_name
ORDER BY 
    active_count DESC, p.package_name;


-- 26. Tìm các hội viên đã đăng ký gói tập trong khoảng thời gian nhất định 

CREATE OR REPLACE FUNCTION FindMembersByRegisterTime(start_date DATE, end_date DATE)
RETURNS TABLE (
    member_id INT,
    member_name VARCHAR(50),
    register_time DATE,
    package_name VARCHAR(100)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        Member.member_id, 
        Member.member_name, 
        Register.register_time, 
        Package.package_name
    FROM 
        Register
    JOIN 
        Member ON Register.member_id = Member.member_id
    JOIN 
        Package ON Register.package_id = Package.package_id
    WHERE 
        Register.register_time BETWEEN start_date AND end_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM FindMembersByRegisterTime('2024-06-10', '2024-06-15');

-- 27. Tìm các nhân viên chưa có feedback nào 

SELECT Employee.employee_id, Employee.employee_name
FROM Employee
LEFT JOIN Feedback ON Employee.employee_id = Feedback.employee_id
WHERE Feedback.feedback_id IS NULL;

-- 28. 


-- 29. Tìm các gói tập có tên chứa chuỗi "VIP"

SELECT *
FROM Package
WHERE package_name LIKE '%VIP%';

-- 30. Tìm số lượng thiết bị theo từng loại trong phòng có id = "input" 

DROP FUNCTION IF EXISTS FindEquipmentByType(input_room_id INT);

CREATE OR REPLACE FUNCTION FindEquipmentByType(input_room_id INT)
RETURNS TABLE (
    equipment_name VARCHAR(100),
    equipment_count BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        EQ.equipment_name,
        COUNT(*) AS equipment_count
    FROM
        Equipment EQ
    WHERE
        EQ.room_id = input_room_id
    GROUP BY
        EQ.equipment_name;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM FindEquipmentByType(3);
