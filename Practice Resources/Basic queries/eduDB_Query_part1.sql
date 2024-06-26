--1. List of subjects having 5 or more credits.

SELECT *
FROM subject
WHERE credit >= 5;


--2. List of students in the class named "CNTT 2 K58".

SELECT s.*
FROM student s
JOIN clazz c ON s.clazz_id = c.clazz_id
WHERE c.name = 'CNTT 2 K58';


--3. List of students in classes whose name contains "CNTT"

SELECT s.*
FROM student s
JOIN clazz c ON s.clazz_id = c.clazz_id
WHERE c.name LIKE '%CNTT%';


--4. Display a list of students who have enrolled in both "Tin học đại cương" and "Cơ sở dữ liệu". 

SELECT s.*
FROM student s
JOIN enrollment e1 ON s.student_id = e1.student_id
JOIN enrollment e2 ON e1.student_id = e2.student_id
WHERE e1.subject_id = 'IT1110' AND e2.subject_id = 'IT3090';


--5. Display a list of students who have enrolled in "Tin hoc đại cương" or "Cơ sở dữ liệu".

SELECT DISTINCT s.*
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
WHERE e.subject_id IN ('IT1110', 'IT3090');


--6. Display subjects that have never been registered by any students

SELECT *
FROM subject
WHERE subject_id NOT IN (SELECT DISTINCT subject_id FROM enrollment);


--7. List of subjects (subject name and credit number corresponding) that student "Nguyen Hoài An" have enrolled in the semester '20171'.

SELECT subj.name, subj.credit
FROM enrollment e
JOIN subject subj ON e.subject_id = subj.subject_id
JOIN student s ON e.student_id = s.student_id
WHERE s.first_name = 'Nguyen Hoài An' AND e.semester = '20171';


--8. Show the list of students who enrolled in 'Co so dữ liệu' in semesters = '20172). This list contains student id, student name, midterm score, final exam score and subject score. Subject score is calculated by the weighted average of midterm score and final exam score: subject score = midterm score * (1- percentage_final_exam/100) + final score *percentage_final_exam/100.

SELECT s.student_id, s.first_name || ' ' || s.last_name AS student_name, e.midterm_score, e.final_score,
       e.midterm_score * (1 - subj.percentage_final_exam/100.0) + e.final_score * subj.percentage_final_exam/100.0 AS subject_score
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN subject subj ON e.subject_id = subj.subject_id
WHERE subj.subject_id = 'IT3090' AND e.semester = '20172';


--9. Display IDs of students who failed the subject with code 'IT1110' in semester '20171'. Note: a student failed a subject if his midterm score or his final exam score is below 3 ; or his subject score is below 4.

SELECT DISTINCT e.student_id
FROM enrollment e
JOIN subject subj ON e.subject_id = subj.subject_id
WHERE subj.name = 'Tin học đại cương' AND e.semester = '20171'
AND (e.midterm_score < 3 OR e.final_score < 3 OR (e.midterm_score * (1 - subj.percentage_final_exam/100.0) + e.final_score * subj.percentage_final_exam/100.0) < 4);


--10. List of all students with their class name, monitor name.

SELECT s.student_id, s.first_name || ' ' || s.last_name AS student_name, c.name AS class_name,
       CONCAT(m.first_name, ' ', m.last_name) AS monitor_name
FROM student s
JOIN clazz c ON s.clazz_id = c.clazz_id
LEFT JOIN student m ON c.monitor_id = m.student_id;
