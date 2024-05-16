--Add a new attribute to the clazz table
ALTER TABLE clazz ADD COLUMN number_students INT;

--Define the number_of_students function
CREATE FUNCTION number_of_students(classID INT)
RETURNS INT AS $$
DECLARE
    student_count INT;
BEGIN
    SELECT COUNT(*)
    INTO student_count
    FROM enrollment e
    WHERE e.class_id = classID;

    RETURN student_count;
END;
$$ LANGUAGE plpgsql;

--Define the update_number_students function
CREATE OR REPLACE FUNCTION update_number_students()
RETURNS VOID AS $$
BEGIN
    UPDATE clazz c
    SET number_students = (
        SELECT COUNT(*)
        FROM enrollment e
        WHERE e.class_id = c.clazz_id
    );
END;
$$ LANGUAGE plpgsql;

--Check values before calling the function
SELECT clazz_id, number_students FROM clazz;

--Call the function to update number_students
SELECT update_number_students();

--Check values after calling the function
SELECT clazz_id, number_students FROM clazz;