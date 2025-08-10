CREATE TABLE Author (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(50),
    country VARCHAR(30)
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

INSERT INTO Author (author_id, author_name, country) VALUES
(1, 'Chetan Bhagat', 'India'),
(2, 'Ruskin Bond', 'India'),
(3, 'Amish Tripathi', 'India');

INSERT INTO Book (book_id, title, author_id) VALUES
(101, 'Five Point Someone', 1),
(102, 'The Blue Umbrella', 2),
(103, 'The Immortals of Meluha', 3);

SELECT 
    Book.title,
    Author.author_name,
    Author.country
FROM 
    Book
INNER JOIN Author
    ON Book.author_id = Author.author_id;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Department (dept_id, dept_name) VALUES
(1, 'Computer Science'),
(2, 'Electronics'),
(3, 'Mechanical'),
(4, 'Civil'),
(5, 'Electrical');

INSERT INTO Course (course_id, course_name, dept_id) VALUES
(101, 'DBMS', 1),
(102, 'Data Structures', 1),
(103, 'Operating Systems', 1),
(104, 'Digital Electronics', 2),
(105, 'Microprocessors', 2),
(106, 'Thermodynamics', 3),
(107, 'Fluid Mechanics', 3),
(108, 'Structural Analysis', 4),
(109, 'Electrical Machines', 5),
(110, 'Power Systems', 5);

SELECT 
    dept_name,
    (SELECT COUNT(*) 
     FROM Course 
     WHERE Course.dept_id = Department.dept_id) AS total_courses
FROM Department
WHERE (SELECT COUNT(*) 
       FROM Course 
       WHERE Course.dept_id = Department.dept_id) > 2;

GRANT SELECT ON Course TO 'student_user';

CREATE TABLE Students1 (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

CREATE TABLE Courses1 (
    course_id INT PRIMARY KEY,
    course_title VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students1(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses1(course_id)
);

INSERT INTO Students1 (student_id, student_name) VALUES
(1, 'Amit Sharma'),
(2, 'Neha Singh'),
(3, 'Ravi Kumar');

INSERT INTO Courses1 (course_id, course_title) VALUES
(101, 'Database Management'),
(102, 'Computer Networks'),
(103, 'Operating Systems');

START TRANSACTION;

INSERT INTO Enrollments (enrollment_id, student_id, course_id, grade) VALUES
(1, 1, 101, 'A');

SAVEPOINT sp1;


INSERT INTO Enrollments (enrollment_id, student_id, course_id, grade) VALUES
(2, 5, 102, 'B');

ROLLBACK TO sp1;

COMMIT;

SELECT 
    Students1.student_name,
    Courses1.course_title,
    Enrollments.grade
FROM Enrollments
INNER JOIN Students1 ON Enrollments.student_id = Students1.student_id
INNER JOIN Courses1 ON Enrollments.course_id = Courses1.course_id;