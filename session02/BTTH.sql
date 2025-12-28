create database demo02;
use demo02;

create table sinhvien(
student_id char(10) primary key,
full_name varchar(50) not null,
email varchar(50) not null
);

create table monhoc(
subject_id char(10) primary key,
subject_name varchar(50) not null,
credits int not null
);

create table dangky(
student_id char(10) not null,
subject_id char(10) not null,
semester varchar(10) not null,
register_date date not null default ("01/01/2025"),
primary key(student_id, subject_id),
foreign key(student_id) references sinhvien(student_id),
foreign key(subject_id) references monhoc(subject_id)
);

alter table sinhvien
add phone varchar(15);

alter table sinhvien
add unique(email);

alter table dangky
modify semester int;

alter table monhoc
add check(credits >= 1 and credits <= 5);

alter table dangky
drop column register_date;
