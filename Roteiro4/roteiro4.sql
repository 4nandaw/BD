-- 1.
SELECT * FROM department;

-- 2.
SELECT * FROM dependent;

-- 3.
SELECT * FROM dept_locations;

-- 4.
SELECT * FROM employee;

-- 5.
SELECT * FROM project;

-- 6.
SELECT * FROM works_on;

-- 7.
SELECT fname, lname FROM employee WHERE sex = 'M';

-- 8.
SELECT fname FROM employee WHERE superssn is null AND sex = 'M';

-- 9.
SELECT e.fname, s.fname FROM employee e, employee s WHERE e.superssn = s.ssn;

-- 10.
SELECT e.fname FROM employee e, employee s WHERE e.superssn = s.ssn AND s.fname = 'Franklin';

-- 11.
SELECT d.dname, l.dlocation FROM department d, dept_locations l WHERE d.dnumber = l.dnumber;

-- 12.
SELECT d.dname FROM department d, dept_locations l WHERE d.dnumber = l.dnumber AND l.dlocation LIKE 'S%';

-- 13.
SELECT e.fname, e.lname, d.dependent_name FROM employee e, dependent d WHERE d.essn = e.ssn;

-- 14.
SELECT (fname ||  ' ' || minit ||  ' ' || lname) AS full_name, salary FROM employee WHERE salary > 50000;

-- 15.
SELECT p.pname, d.dname FROM project p, department d WHERE p.dnum = d.dnumber;

-- 16.
SELECT p.pname, e.fname FROM project p, employee e, department d WHERE d.mgrssn = e.ssn AND p.dnum = d.dnumber AND p.pnumber > 30;

-- 17.
SELECT p.pname, e.fname FROM project p, employee e, works_on w WHERE e.ssn = w.essn AND p.pnumber = w.pno;

-- 18.
SELECT e.fname, d.dependent_name, d.relationship FROM employee e, dependent d, works_on w WHERE d.essn = e.ssn AND w.essn = e.ssn AND w.pno = 91;