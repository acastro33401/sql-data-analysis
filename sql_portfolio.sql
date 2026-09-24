-- ============================================================
-- SQL Portfolio: Academic Data Analysis Projects
-- Alan Castro | University of Delaware, MISY 330
-- Database Design & Implementation
-- ============================================================


-- ============================================================
-- SECTION 1: FILTERING & CONDITIONAL QUERIES
-- ============================================================

-- Retrieve upper-level courses worth more than 3 credits
SELECT course_num, course_name
FROM Courses
WHERE course_num > 299 AND num_credits > 3;

-- Find students enrolled in a specific course with their grades
SELECT course_num, grade
FROM Enrolls
WHERE student_num = 298;

-- List students located in California or Illinois with grades above 2.0
SELECT student_name, state, grade
FROM Students, Enrolls
WHERE Students.student_num = Enrolls.student_num
  AND grade > 2
  AND state IN ('CA', 'IL');

-- Retrieve employees not based in the USA
SELECT FirstName, LastName, Country
FROM Employees
WHERE Country <> 'USA';

-- Retrieve Mexican customers and non-Madrid Spanish customers
SELECT CompanyName, ContactTitle, City, Country
FROM Customers
WHERE Country = 'Mexico'
   OR (Country = 'Spain' AND City <> 'Madrid');


-- ============================================================
-- SECTION 2: RANGE & PATTERN MATCHING
-- ============================================================

-- Students whose zip codes fall in the 20000–29999 range or live in Erie, PA
SELECT student_name, city, state, zip
FROM Students
WHERE (zip BETWEEN 20000 AND 29999)
   OR city = 'Erie';

-- Students whose zip codes fall outside the 20000–29999 range
SELECT student_name, city, state, zip
FROM Students
WHERE zip NOT BETWEEN 20000 AND 29999;

-- Teachers earning between $30,000 and $35,000
SELECT teacher_name, salary
FROM Teachers
WHERE salary BETWEEN 30000 AND 35000;

-- Courses whose names start with the letter C
SELECT course_name
FROM Courses
WHERE course_name LIKE 'C%';

-- Teachers whose phone numbers do not end in 6
SELECT teacher_name, phone
FROM Teachers
WHERE phone NOT LIKE '%6';


-- ============================================================
-- SECTION 3: SORTING & DISTINCT VALUES
-- ============================================================

-- List all teachers sorted alphabetically (descending)
SELECT teacher_name, phone
FROM Teachers
ORDER BY teacher_name DESC;

-- List students sorted by state, then city within each state
SELECT student_name, state, city
FROM Students
ORDER BY state, city;

-- List all unique states where students are located
SELECT DISTINCT state
FROM Students;

-- Look up a specific teacher's ID number
SELECT teacher_num, teacher_name
FROM Teachers
WHERE teacher_name = 'Dr. Engle';


-- ============================================================
-- SECTION 4: AGGREGATE FUNCTIONS & GROUPING
-- ============================================================

-- Count teachers earning above $30,000
SELECT COUNT(teacher_name) AS teachers_above_30k
FROM Teachers
WHERE salary > 30000;

-- Calculate each teacher's projected new salary with 5.5% raise plus $1,500 bonus
SELECT teacher_name, salary,
       (salary * 1.055) + 1500 AS new_salary
FROM Teachers;

-- Find the highest-paid teacher
SELECT teacher_name, MAX(salary) AS max_salary
FROM Teachers;

-- Count the number of distinct courses offered
SELECT COUNT(DISTINCT course_num) AS num_courses
FROM Courses;

-- List all students grouped by state
SELECT state, GROUP_CONCAT(student_name) AS students
FROM Students
GROUP BY state;

-- Calculate tuition owed per student (450 per credit hour, 1 course = 1 unit)
SELECT student_num,
       COUNT(course_num) * 450 AS tuition
FROM Enrolls
GROUP BY student_num;

-- List courses by department that are exactly 3 credits
SELECT department,
       GROUP_CONCAT(course_name) AS courses,
       num_credits
FROM Courses
WHERE num_credits = 3
GROUP BY department;

-- Show full employee names using string concatenation
SELECT CONCAT(FirstName, ' ', LastName) AS full_name, Country
FROM Employees
WHERE Country <> 'USA';


-- ============================================================
-- SECTION 5: HAVING CLAUSE (POST-AGGREGATION FILTERS)
-- ============================================================

-- Identify students with a GPA below 2.5 and show their course load
SELECT student_num,
       AVG(grade) AS gpa,
       COUNT(*) AS num_courses
FROM Enrolls
GROUP BY student_num
HAVING AVG(grade) < 2.5;

-- Find course sections with 4 or more enrolled students
SELECT course_num, section_num,
       AVG(grade) AS avg_grade,
       COUNT(*) AS num_students
FROM Enrolls
GROUP BY course_num, section_num
HAVING COUNT(*) >= 4;

-- Find cities with more than 2 employees who are Sales Representatives
SELECT City, COUNT(EmployeeID) AS num_employees
FROM Employees
WHERE Title = 'Sales Representative'
GROUP BY City
HAVING COUNT(*) > 2;

-- Find products with an average unit price above $70
SELECT ProductID, AVG(UnitPrice) AS avg_price
FROM Products
GROUP BY ProductID
HAVING AVG(UnitPrice) > 70;

-- Find products with total quantity sold under 200 units
SELECT ProductName, SUM(Quantity) AS total_quantity
FROM `Order Details`
INNER JOIN Products ON `Order Details`.ProductID = Products.ProductID
GROUP BY ProductName
HAVING SUM(Quantity) < 200;


-- ============================================================
-- SECTION 6: JOINS
-- ============================================================

-- Match teachers to the course sections they teach (INNER JOIN)
SELECT Teachers.teacher_num, teacher_name, course_num
FROM Teachers
INNER JOIN Sections ON Teachers.teacher_num = Sections.teacher_num;

-- Show all teachers including those not currently assigned to a section (LEFT JOIN)
SELECT teacher_name, course_num
FROM Teachers
LEFT JOIN Sections ON Teachers.teacher_num = Sections.teacher_num
ORDER BY teacher_name;

-- Three-table join: student names, grades, and course names for PA/CA/CT students
SELECT student_name, grade, course_name
FROM Courses c
INNER JOIN Enrolls e ON c.course_num = e.course_num
INNER JOIN Students s ON s.student_num = e.student_num
WHERE state IN ('PA', 'CA', 'CT')
ORDER BY course_name, student_name;

-- Count employees and customers per city using a LEFT JOIN
SELECT Employees.City,
       COUNT(EmployeeID) AS num_employees,
       COUNT(DISTINCT CustomerID) AS num_customers
FROM Employees
LEFT JOIN Customers ON Employees.City = Customers.City
GROUP BY Employees.City;


-- ============================================================
-- SECTION 7: SUBQUERIES
-- ============================================================

-- Find all products in the Seafood category using a subquery
SELECT ProductName
FROM Products
WHERE CategoryID = (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName = 'Seafood'
);

-- Find students enrolled in courses OTHER than 450, 290, and 730
SELECT student_num
FROM Enrolls
WHERE course_num NOT IN (450, 290, 730);
