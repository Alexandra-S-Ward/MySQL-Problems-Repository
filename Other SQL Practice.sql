
create table students( -- Student table, autoincrement the ID 
	id int primary key auto_increment,
    fname varchar(15),
    lname varchar(15)
    );

create table marks( -- Marks table.
	student_id int,
    subjects enum("Python", "Scala"),
    scores tinyint,
    foreign key (student_id) references students(id)
    );
    
insert into students (fname, lname) values ("Alexandra", "Ward");
insert into students (fname, lname) values ("Rupali", "Waykole");
insert into students(fname, lname) values ("Join", "Testing");
insert into marks (student_id, subjects, scores) values (1, "Python", 50);
insert into marks (student_id, subjects, scores) values (1, "Scala", 70);
insert into marks (student_id, subjects, scores) values (2, "Python", 85);


-- Inner Join should produce Alexandra twice and Rupali once.
-- Left Join shuold produce Alexandra twice, Rupali once, Join Testing
-- Right join shuold produce the same as inner join as Join Testing will return null
INSERT into marks (student_id, subjects, scores) values (2, "S", 100);

-- Show above average scores for students in all subjects
select 
	m.student_id,
    CONCAT(s.fname,' ', s.lname) as "Student Name",
    m.subjects as "Subject",
    m.scores
FROM
	students s inner join marks m on s.id = m.student_id
    where m.scores > (SELECT AVG(scores) from marks); -- Subquery should return student ID 1/Scala and 2/Python.


-- Get student's scores in each subject and compare it against the class average
SELECT
	m.student_id as "Student ID",
	CONCAT(s.fname,' ', s.lname) as "Student Name", -- Concat names
    m.subjects as "Subject",
    AVG(m.scores) as "Average Subject Score",
    m.scores as "Student Score",
    (Select (AVG(m.scores)-MAX(m.scores))) as Delta, -- Get delta between average and student
    CASE -- Case to determine if above or below average
		WHEN  m.scores = AVG(m.scores) then "Average"
		WHEN m.scores > AVG(m.scores) then "Above average"
		WHEN m.scores < AVG(m.scores) then "Below Average"
    END AS 'Status'
FROM
	students s inner join marks m ON s.id = m.student_id
GROUP BY m.subjects
ORDER BY m.scores desc;