use demo02;
CREATE TABLE classes(
class_id int primary key auto_increment,
class_name varchar(20) not null unique,
status bit default 1 
);


CREATE TABLE students(
student_id char(10) ,
full_name varchar(50) not null,
date_of_birth date not null,
gpa decimal (2,1) default(0) ,
sex enum ('Nam', 'Nu') not null,
phone char(10) unique,
email varchar(50) unique,
`profile` blob not null,

class_id int NOT NULL,

constraint chk_01 check(gpa >= 0),
primary key(student_id),
foreign key(class_id) references classes(class_id)
);