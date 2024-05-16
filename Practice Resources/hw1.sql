CREATE FUNCTION number_of_students(classID INT)
RETURNS INT AS $$
DECLARE
    student_count INT;
BEGIN
    SELECT COUNT(*)
    INTO student_count
    FROM enrollment e
    JOIN clazz c ON e.class_id = c.clazz_id
    WHERE c.clazz_id = classID;

    RETURN student_count;
END;
$$ LANGUAGE plpgsql;