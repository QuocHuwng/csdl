use demo02;
create table student(
student_id char(10) primary key ,
`name` varchar(30)not null
);
create table subject (
subject_id char(10) primary key,
subject_name varchar(30) not null,
credit_number enum("1","2","3","4","5")
);
create table register_subject(
student_id char(10) not null,
subject_id char(10) not null unique,
register_date date not null,
foreign key(student_id)  references student(student_id) ,
foreign key(subject_id) references subject(subject_id)
);