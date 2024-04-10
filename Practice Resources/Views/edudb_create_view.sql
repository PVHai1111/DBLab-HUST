--Create a view from eduDB, named student_shortinfos, this view contains some information from student table: student_id, firstname, lastname, gender, dob, clazz_id

CREATE VIEW student_shortinfos AS
SELECT student_id, first_name, last_name, gender, dob, clazz_id
FROM student;

--Insert

INSERT INTO student_shortinfos (student_id, first_name, last_name, gender, dob, clazz_id)
VALUES ('20240001', 'John', 'Doe', 'M', '1990-05-15', '20162101');

--Update

UPDATE student_shortinfos
SET first_name = 'Jane'
WHERE student_id = '20240001';

--Delete

DELETE FROM student_shortinfos
WHERE student_id = '20240001';

--1.3. Suppose you do not have permission to access student table
--a) Give a list of students: student id, fullname, gender and class name.

edudb_v2=# SELECT student_id, first_name || ' ' || last_name AS full_name, gender, c.name AS class_name
edudb_v2-# FROM student_shortinfos
edudb_v2-# LEFT JOIN clazz c 
ON student_shortinfos.clazz_id = c.clazz_id;

--b) List of class (class id, class name) and the number of students in each class

SELECT c.clazz_id, c.name AS class_name, COUNT(ss.student_id) AS num_students
FROM clazz c
LEFT JOIN student_shortinfos ss ON c.clazz_id = ss.clazz_id
GROUP BY c.clazz_id, c.name
ORDER BY num_students DESC;

--Please change dob of a student and check if this infos is also updated in student_shortinfos view
-- Update the DOB of a student in the student table
UPDATE student
SET dob = '1990-01-01'
WHERE student_id = '20160001';

-- Check if the information is updated in the student_shortinfos view
SELECT *
FROM student_shortinfos
WHERE student_id = '20160001';
-- Yes, the data is changed in the view

-- Please insert a new record into student table and then check if you can see the new student on student_shortinfos view ?
-- Insert a new record into the student table
INSERT INTO student (student_id, first_name, last_name, dob, gender, clazz_id)
VALUES ('20240001', 'John', 'Doe', '1995-05-15', 'M', '20162101');

-- Check if the new student appears in the student_shortinfos view
SELECT *
FROM student_shortinfos
WHERE student_id = '20240001';

-- Set address attribute of student table to NOT NULL è then try insert a new record into student_shortinfos view: check if the record is insert into student table
-- Alter the student table to set address attribute as NOT NULL
ALTER TABLE student
ALTER COLUMN address SET NOT NULL;

-- Try to insert a new record into the student_shortinfos view
INSERT INTO student_shortinfos (student_id, first_name, last_name, gender, dob, clazz_id)
VALUES ('20240002', 'Alice', 'Smith', 'F', '1996-08-20', '20162101');

--Create a view from eduDB, named student_class_shortinfos, this
--view contains: student_id, firstname, lastname, gender, class
--name.

CREATE VIEW student_class_shortinfos AS
SELECT s.student_id, s.first_name, s.last_name, s.gender, c.name AS class_name
FROM student s
JOIN clazz c ON s.clazz_id = c.clazz_id;

--Try to insert/update/delete a record into/from student_class_shortinfos
--Check if this record is inserted/updated/deleted from student table /
--class table ?

--Since `student_class_shortinfos` is a view, you cannot directly insert/update/delete records from it. The view is essentially a virtual table derived from the underlying tables (`student` and `clazz` in this case) and reflects changes made to those tables.

--To insert/update/delete records, you would need to do so directly on the `student` and `clazz` tables. Any changes made to these tables will be reflected in the `student_class_shortinfos` view upon subsequent queries.

--Create a view from eduDB, named class_infos, this view contains:
--class_id, class name, number of students in this class.

CREATE VIEW class_infos AS
SELECT c.clazz_id AS class_id, c.name AS class_name, COUNT(s.student_id) AS num_students
FROM clazz c
LEFT JOIN student s ON c.clazz_id = s.clazz_id
GROUP BY c.clazz_id, c.name;

--3.1 Display all records from this view.

SELECT * FROM class_infos;

--3.2 Try to insert/update/delete a record into/from class_infos
--Since class_infos is a view, you cannot directly insert/update/delete records from it because it is a virtual representation of the data from other tables. However, you can perform these operations on the underlying tables (clazz and student tables in this case) and the changes will be reflected in the view.


