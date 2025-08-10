CREATE TABLE Students2 (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject_name VARCHAR(50),
    marks INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

INSERT INTO Students2 (student_id, student_name, department) VALUES
(1, 'Amit Sharma', 'CSE'),
(2, 'Neha Singh', 'ECE'),
(3, 'Ravi Kumar', 'ME'),
(4, 'Priya Verma', 'CSE'),
(5, 'Vikas Gupta', 'EEE');

INSERT INTO Marks (mark_id, student_id, subject_name, marks) VALUES
(101, 1, 'DBMS', 85),
(102, 1, 'CN', 78),
(103, 2, 'Digital Electronics', 88),
(104, 2, 'Signals', 91),
(105, 3, 'Thermodynamics', 75),
(106, 3, 'Fluid Mechanics', 82),
(107, 4, 'Data Structures', 92),
(108, 4, 'OS', 89),
(109, 5, 'Machines', 84),
(110, 5, 'Power Systems', 65);

CREATE VIEW HighScorers AS
SELECT 
    Students2.student_id,
    Students2.student_name,
    Students2.department,
    Marks.subject_name,
    Marks.marks
FROM Students2
INNER JOIN Marks ON Students2.student_id = Marks.student_id
WHERE Marks.marks > 80;

SELECT 
    department,
    COUNT(*) AS high_score_count
FROM HighScorers
GROUP BY department;


CREATE TABLE Students3 (
    student_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(50),
    department VARCHAR2(50)
);

CREATE TABLE Courses (
    course_id NUMBER PRIMARY KEY,
    course_name VARCHAR2(50),
    department VARCHAR2(50)
);

CREATE TABLE Enrollments3 (
    enrollment_id NUMBER PRIMARY KEY,
    student_id NUMBER REFERENCES Students(student_id),
    course_id NUMBER REFERENCES Courses(course_id),
    grade CHAR(1)
);

INSERT INTO Students3 VALUES (1, 'Amit Sharma', 'Computer Science');
INSERT INTO Students3 VALUES (2, 'Neha Singh', 'Computer Science');
INSERT INTO Students3 VALUES (3, 'Raj Mehta', 'Mathematics');

INSERT INTO Courses VALUES (101, 'DBMS', 'Computer Science');
INSERT INTO Courses VALUES (102, 'Algorithms', 'Computer Science');
INSERT INTO Courses VALUES (201, 'Linear Algebra', 'Mathematics');

INSERT INTO Enrollments3 VALUES (1, 1, 101, 'A');
INSERT INTO Enrollments3 VALUES (2, 1, 102, 'B');
INSERT INTO Enrollments3 VALUES (3, 2, 101, 'A');
INSERT INTO Enrollments3 VALUES (4, 2, 102, 'A');
INSERT INTO Enrollments3 VALUES (5, 3, 201, 'B');

CREATE OR REPLACE PROCEDURE Dept_GPA_Summary(p_department IN VARCHAR2) IS
    CURSOR student_cur IS
        SELECT student_id, full_name
        FROM Students3
        WHERE department = p_department;

    v_student_id Students3.student_id%TYPE;
    v_full_name Students3.full_name%TYPE;
    v_gpa NUMBER;
BEGIN
    FOR stu_rec IN student_cur LOOP
        v_student_id := stu_rec.student_id;
        v_full_name := stu_rec.full_name;

        SELECT AVG(CASE grade
                     WHEN 'A' THEN 10
                     WHEN 'B' THEN 8
                     WHEN 'C' THEN 6
                     WHEN 'D' THEN 4
                     WHEN 'F' THEN 0
                   END)
        INTO v_gpa
        FROM Enrollments3 e
        JOIN Courses c ON e.course_id = c.course_id
        WHERE e.student_id = v_student_id
          AND c.department = p_department;

        DBMS_OUTPUT.PUT_LINE('Student: ' || v_full_name || ', GPA: ' || NVL(TO_CHAR(v_gpa), 'N/A'));
    END LOOP;
END;
/

SET SERVEROUTPUT ON
BEGIN
    Dept_GPA_Summary('Computer Science');
END;
/