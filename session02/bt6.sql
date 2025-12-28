use demo02;

create table student(
student_id char(10) primary key,
`name` varchar(30) not null
);

create table subject(
subject_id char(10) primary key,
subject_name varchar(30) not null
);

create table score(
student_id char(10) not null,
subject_id char(10) not null,
process_score decimal(4,2) check(process_score between 0 and 10),
final_score decimal(4,2) check(final_score between 0 and 10),
primary key(student_id, subject_id),
foreign key(student_id) references student(student_id),
foreign key(subject_id) references subject(subject_id)
);
