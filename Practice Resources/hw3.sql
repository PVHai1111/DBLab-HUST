--Create student_results table
CREATE TABLE student_results (
    student_id INT,
    semester VARCHAR(10),
    GPA FLOAT,
    CPA FLOAT
);

--Define function to update GPA and CPA for a specific student in a semester
CREATE FUNCTION updateGPA_student(studentid INT, semester VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE student_results
    SET GPA = (
        SELECT AVG((midterm_score + final_score) / 2.0)
        FROM enrollment
        WHERE student_id = studentid AND semester = semester
    ),
    CPA = (
        SELECT AVG((midterm_score + final_score) / 2.0)
        FROM enrollment
        WHERE student_id = studentid AND semester <= semester
    )
    WHERE student_id = studentid AND semester = semester;
END;
$$ LANGUAGE plpgsql;

--Define function to update GPA and CPA for all students in a specified semester
CREATE FUNCTION updateGPA(semester VARCHAR)
RETURNS VOID AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT DISTINCT student_id FROM enrollment WHERE semester = semester
    LOOP
        UPDATE student_results
        SET GPA = (
            SELECT AVG((midterm_score + final_score) / 2.0)
            FROM enrollment
            WHERE student_id = rec.student_id AND semester = semester
        ),
        CPA = (
            SELECT AVG((midterm_score + final_score) / 2.0)
            FROM enrollment
            WHERE student_id = rec.student_id AND semester <= semester
        )
        WHERE student_id = rec.student_id AND semester = semester;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

--Insert sample data into student_results
INSERT INTO student_results (student_id, semester, GPA, CPA)
VALUES (1, '2023S1', NULL, NULL),
       (2, '2023S1', NULL, NULL),
       (3, '2023S1', NULL, NULL);

--Check values before calling the functions
SELECT * FROM student_results;

--Call function to update GPA and CPA for a specific student
SELECT updateGPA_student(1, '2023S1');

--Call function to update GPA and CPA for all students in a specified semester
SELECT updateGPA('2023S1');

--Check values after calling the functions
SELECT * FROM student_results;