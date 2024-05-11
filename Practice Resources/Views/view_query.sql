-- Show all views
SELECT viewname AS view_name, definition AS view_definition
FROM pg_views
WHERE schemaname = 'public';

-- Show all tables
SELECT tablename AS table_name
FROM pg_tables
WHERE schemaname = 'public';

--Create a view from eduDB, named class_infos, this view contains: class_id, class name,
--number of students in this class.

CREATE VIEW class_infos AS
SELECT c.clazz_id, c.name AS class_name, COUNT(s.student_id) AS num_students
FROM clazz c
LEFT JOIN student s ON c.clazz_id = s.clazz_id
GROUP BY c.clazz_id, c.name;

--Create a view from eduDB, named enrollment_20171 for enrollment information in
--semester 20171, this view contains student_id, subject_id,, midterm_score, final_score

CREATE VIEW enrollment_20171 AS
SELECT student_id, subject_id, midterm_score, final_score
FROM enrollment
WHERE semester = '20171';

--1. List of subjects having 5 or more credits.

SELECT *
FROM subject
WHERE credit >= 5;

--2. List of students in the class named "CNTT 2 K58".

SELECT *
FROM student_class_shortinfos
WHERE class_name = 'CNTT 2 K58';

--3. List of students in classes whose name contains "CNTT"

SELECT *
FROM student_class_shortinfos
WHERE class_name LIKE '%CNTT%';

--4. Display a list of students who have enrolled in both "Lập trình Java" (Java Programming) and
--"Lập trình nhúng" (Embedded Programming).

SELECT *
FROM student_class_shortinfos
WHERE subject_name IN ('Lập trình Java', 'Lập trình nhúng')
GROUP BY student_id
HAVING COUNT(DISTINCT subject_name) = 2;

--5. Display a list of students who have enrolled in ”Tin học đại cương" (Java Programming) or
--”Cơ sở dữ liệu" (Object-oriented Programming).

SELECT *
FROM student_class_shortinfos
WHERE subject_name IN ('Tin học đại cương', 'Cơ sở dữ liệu');

--6. Display subjects that have never been registered by any students

SELECT *
FROM class_infos
WHERE num_students = 0;

--7. List of subjects (subject name and credit number corresponding) that student "Nguyễn Hoài
--An" have enrolled in the semester '20171'.

SELECT *
FROM enrollment_20171
WHERE student_id = (
    SELECT student_id
    FROM student_shortinfos
    WHERE first_name = 'Nguyễn' AND last_name = 'Hoài An'
) AND semester = '20171';

--8. Show the list of students who enrolled in 'Cơ sở dữ liệu' in semesters = '20171'). This list
--contains student id, student name, midterm score, final exam score and subject score. Subject
--score is calculated by the weighted average of midterm score and final exam score : subject
--score = midterm score * (1- percentage_final_exam/100) + final score
--*percentage_final_exam/100.

SELECT ssi.student_id, ssi.full_name, e.midterm_score, e.final_score,
    e.midterm_score * (1 - s.percentage_final_exam / 100) + e.final_score * s.percentage_final_exam / 100 AS subject_score
FROM student_shortinfos ssi
JOIN enrollment_20171 e ON ssi.student_id = e.student_id
JOIN subject s ON e.subject_id = s.subject_id
WHERE s.name = 'Cơ sở dữ liệu';

--9. Display IDs of students who failed the subject with code 'IT1110' in semester '20171'. Note: a
--student failed a subject if his midterm score or his final exam score is below 3 ; or his subject
--score is below 4.

SELECT student_id
FROM enrollment_20171
WHERE subject_id = 'IT1110'
AND (midterm_score < 3 OR final_score < 3 OR
    midterm_score * (1 - percentage_final_exam / 100) + final_score * percentage_final_exam / 100 < 4);

--10. List of all students with their class name, monitor name.

SELECT *
FROM student_class_shortinfos;

--11. Students aged 25 and above. Given information: student name, age

SELECT full_name, DATE_PART('year', current_date) - DATE_PART('year', dob) AS age
FROM student_shortinfos
WHERE DATE_PART('year', current_date) - DATE_PART('year', dob) >= 25;

--12. Students were born in June 1999.

SELECT full_name
FROM student_shortinfos
WHERE DATE_PART('month', dob) = 6 AND DATE_PART('year', dob) = 1999;

--13. Display class name and number of students corresponding in each class. Sort the result
--in descending order by the number of students.

SELECT class_name, COUNT(student_id) AS num_students
FROM student_class_shortinfos
GROUP BY class_name
ORDER BY num_students DESC;

--14. Display the lowest, highest and average scores on the mid-term test of "Mạng máy tính"
--in semester '20172'.

SELECT MIN(midterm_score) AS lowest_score, MAX(midterm_score) AS highest_score, AVG(midterm_score) AS average_score
FROM enrollment_20172
WHERE subject_id = 'IT3080';

--15. Give number of subjects that each lecturer can teach. List must contain: lecturer id,
--lecturer's fullname, number of subjects.

SELECT t.lecturer_id, CONCAT(l.first_name, ' ', l.last_name) AS lecturer_fullname, COUNT(t.subject_id) AS num_subjects_taught
FROM teaching t
JOIN lecturer l ON t.lecturer_id = l.lecturer_id
GROUP BY t.lecturer_id, lecturer_fullname;

--16. List of subjects which have at least 2 lecturers in charge.

SELECT s.subject_id, s.name AS subject_name, COUNT(t.lecturer_id) AS num_lecturers
FROM teaching t
JOIN subject s ON t.subject_id = s.subject_id
GROUP BY s.subject_id, subject_name
HAVING COUNT(t.lecturer_id) >= 2;

--17. List of subjects which have less than 2 lecturers in charge.

SELECT s.subject_id, s.name AS subject_name, COUNT(t.lecturer_id) AS num_lecturers
FROM teaching t
JOIN subject s ON t.subject_id = s.subject_id
GROUP BY s.subject_id, subject_name
HAVING COUNT(t.lecturer_id) < 2;

--18. List of students who obtained the highest score in subject whose id is 'IT3080', in the
--semester '20172'.

SELECT ssi.student_id, ssi.full_name, e.final_score
FROM student_shortinfos ssi
JOIN enrollment_20172 e ON ssi.student_id = e.student_id
WHERE e.subject_id = 'IT3080' AND e.final_score = (
    SELECT MAX(final_score)
    FROM enrollment_20172
    WHERE subject_id = 'IT3080'
);
