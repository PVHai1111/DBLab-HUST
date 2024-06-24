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

-- 3. Tìm feedback trong ngày hôm nay

SELECT * FROM find_feedbacks_today();

CREATE OR REPLACE FUNCTION count_registers_in_room_id(input_room_id INT)
RETURNS INT
AS $$
DECLARE
    register_count INT;
BEGIN
    RAISE NOTICE 'Input room_id: %', input_room_id;
    SELECT COUNT(package_id)
    INTO register_count
    FROM Access
    WHERE room_id = input_room_id;
    RAISE NOTICE 'Registration count: %', register_count;

    RETURN register_count;
END;
$$ LANGUAGE plpgsql;

SELECT count_registers_in_room_id(22);

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