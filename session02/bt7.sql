use demo02;

create table class(
class_id char(10) primary key,
class_name varchar(30) not null
);

create table student(
student_id char(10) primary key,
`name` varchar(30) not null,
class_id char(10) not null,
foreign key(class_id) references class(class_id)
);

create table teacher(
teacher_id char(10) primary key,
`name` varchar(30) not null,
email varchar(50) not null unique
);

create table subject(
subject_id char(10) primary key,
subject_name varchar(30) not null,
credit_number enum("1","2","3","4","5"),
teacher_id char(10) not null,
foreign key(teacher_id) references teacher(teacher_id)
);

create table register_subject(
student_id char(10) not null,
subject_id char(10) not null,
register_date date not null,
primary key(student_id, subject_id),
foreign key(student_id) references student(student_id),
foreign key(subject_id) references subject(subject_id)
);

create table score(
student_id char(10) not null,
subject_id char(10) not null,
process_score decimal(4,2) check(process_score between 0 and 10),
final_score decimal(4,2) check(final_score between 0 and 10),
primary key(student_id, subject_id),
foreign key(student_id, subject_id)
references register_subject(student_id, subject_id)
);
