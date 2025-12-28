use demo02;

create table teacher(
teacher_id char(10) primary key,
`name` varchar(30) not null,
email varchar(50) not null
);

create table subject(
subject_id char(10) primary key,
subject_name varchar(30) not null,
credit_number enum("1","2","3","4","5"),
teacher_id char(10) not null,
foreign key(teacher_id) references teacher(teacher_id)
);
