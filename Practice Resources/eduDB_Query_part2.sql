--11. Students aged 25 and above. Given information: student name, age

SELECT first_name, last_name, DATE_PART('year', current_date) - DATE_PART('year', dob) AS age
FROM student
WHERE DATE_PART('year', current_date) - DATE_PART('year', dob) >= 25;


--12. Students were born in June 1999.

SELECT *
FROM student
WHERE EXTRACT(month FROM dob) = 6 AND EXTRACT(year FROM dob) = 1987;



--13. Display class name and number of students corresponding in each class. Sort the result descending order by the number of students

SELECT c.name AS class_name, COUNT(s.student_id) AS num_students
FROM clazz c
LEFT JOIN student s ON c.clazz_id = s.clazz_id
GROUP BY c.clazz_id
-- group by name -> cac lop trung ten nhau se bi gop lai -> nen group by id
ORDER BY num_students DESC;



--14. Display the lowest, highest and average scores on the mid-term test of "Mạng máy tính" in semester '20172'.

SELECT MIN(midterm_score) AS lowest_score, MAX(midterm_score) AS highest_score, AVG(midterm_score) AS average_score
FROM enrollment e
JOIN subject s ON e.subject_id = s.subject_id
WHERE s.name = 'Mạng máy tính' AND e.semester = '20172';



--15. Give number of subjects that each lecturer can teach. List must contain: lecturer id, lecturer's fullname, number of subjects.

SELECT l.lecturer_id, CONCAT(l.first_name, ' ', l.last_name) AS full_name, COUNT(t.subject_id) AS num_subjects
FROM lecturer l
LEFT JOIN teaching t ON l.lecturer_id = t.lecturer_id
GROUP BY l.lecturer_id, full_name;



--16. List of subjects which have at least 2 lecturers in charge.

SELECT s.subject_id, s.name, COUNT(t.lecturer_id) AS num_lecturers
FROM subject s
JOIN teaching t ON s.subject_id = t.subject_id
GROUP BY s.subject_id, s.name
HAVING COUNT(t.lecturer_id) >= 2;



--17. List of subjects which have less than 2 lecturers in charge.

SELECT s.subject_id, s.name, COUNT(t.lecturer_id) AS num_lecturers
FROM subject s
LEFT JOIN teaching t ON s.subject_id = t.subject_id
GROUP BY s.subject_id, s.name
HAVING COUNT(t.lecturer_id) < 2;


--18. List of students who obtained the highest score in subject whose id is 'IT3080', in the semester '20172'.

SELECT s.first_name, s.last_name, (e.midterm_score * (1 - subj.percentage_final_exam/100.0) + e.final_score * subj.percentage_final_exam/100.0) AS score
FROM enrollment e
JOIN student s ON e.student_id = s.student_id
JOIN subject subj ON e.subject_id = subj.subject_id
WHERE e.subject_id = 'IT3080' AND e.semester = '20172'
AND (e.midterm_score * (1 - subj.percentage_final_exam/100.0) + e.final_score * subj.percentage_final_exam/100.0) = (
select max (e.midterm_score * (1 - subj.percentage_final_exam/100.0) + e.final_score * subj.percentage_final_exam/100.0)
from enrollment e
JOIN student s ON e.student_id = s.student_id
JOIN subject subj ON e.subject_id = subj.subject_id
WHERE e.subject_id = 'IT3080' AND e.semester = '20172'
);

SELECT student.student_id, (enrollment.midterm_score * (1 - subject.percentage_final_exam::numeric / 100) + enrollment.final_score * subject.percentage_final_exam::numeric / 100) AS total_score
FROM student
JOIN enrollment ON enrollment.student_id = student.student_id
JOIN clazz ON student.clazz_id=clazz.clazz_id
JOIN subject ON enrollment.subject_id = subject.subject_id
WHERE enrollment.subject_id='IT3080'
    AND enrollment.semester='20172'
    AND (enrollment.midterm_score * (1 - subject.percentage_final_exam::numeric / 100) + enrollment.final_score * subject.percentage_final_exam::numeric / 100) = (
        SELECT MAX(enrollment.midterm_score * (1 - subject.percentage_final_exam::numeric / 100) + enrollment.final_score * subject.percentage_final_exam::numeric / 100)
        FROM enrollment
        WHERE enrollment.subject_id = 'IT3080' AND enrollment.semester = '20172'
    );

--19. Which subject has the most students enrolled in semester 20172

SELECT s.name AS subject_name, COUNT(e.student_id) AS num_students
FROM subject s
JOIN enrollment e ON s.subject_id = e.subject_id
WHERE e.semester = '20172'
GROUP BY s.name
HAVING COUNT(e.student_id) = (
    SELECT MAX(student_count)
    FROM (
        SELECT COUNT(enrollment.student_id) AS student_count
        FROM subject
        JOIN enrollment ON subject.subject_id = enrollment.subject_id
        WHERE enrollment.semester = '20172'
        GROUP BY subject.subject_id
    ) AS max_student_count
);

SELECT s.name AS subject_name, COUNT(e.student_id) AS num_students
FROM subject s
JOIN enrollment e ON s.subject_id = e.subject_id
WHERE e.semester = '20172'
GROUP BY s.name
HAVING COUNT(e.student_id) >= all(
    SELECT (student_count)
    FROM (
        SELECT COUNT(enrollment.student_id) AS student_count
        FROM subject
        JOIN enrollment ON subject.subject_id = enrollment.subject_id
        WHERE enrollment.semester = '20172'
        GROUP BY subject.subject_id
    )
);







