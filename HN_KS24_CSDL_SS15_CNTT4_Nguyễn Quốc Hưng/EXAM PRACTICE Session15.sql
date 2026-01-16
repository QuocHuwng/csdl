drop database if exists studentmanagement;
create database studentmanagement;
use studentmanagement;

-- 1. table structure
create table students (
    studentid char(5) primary key,
    fullname varchar(50) not null,
    totaldebt decimal(10,2) default 0
);
create table subjects (
    subjectid char(5) primary key,
    subjectname varchar(50) not null,
    credits int check (credits > 0)
);
create table grades (
    studentid char(5),
    subjectid char(5),
    score decimal(4,2) check (score between 0 and 10),
    primary key (studentid, subjectid),
    constraint fk_grades_students foreign key (studentid) references students(studentid),
    constraint fk_grades_subjects foreign key (subjectid) references subjects(subjectid)
);
create table gradelog (
    logid int auto_increment primary key,
    studentid char(5),
    subjectid char(5),
    oldscore decimal(4,2),
    newscore decimal(4,2),
    changedate datetime default current_timestamp
);
-- 2. seed data
insert into students values
('sv01', 'ho khanh linh', 5000000),
('sv03', 'tran thi khanh huyen', 0);

insert into subjects values
('sb01', 'co so du lieu', 3),
('sb02', 'lap trinh java', 4),
('sb03', 'lap trinh c', 3);
insert into grades values
('sv01', 'sb01', 8.5),
('sv03', 'sb02', 3.0);
-- Phần A
-- trigger check score
delimiter $$
create trigger tg_checkscore
before insert on grades
for each row
begin
    if new.score < 0 then
        set new.score = 0;
    elseif new.score > 10 then
        set new.score = 10;
    end if;
end$$
delimiter ;
-- transaction add new student
start transaction;
insert into students (studentid, fullname)
values ('sv02', 'ha bich ngoc');
update students
set totaldebt = 5000000
where studentid = 'sv02';
commit;
-- Phần B
-- trigger log grade update
delimiter $$

create trigger tg_loggradeupdate
after update on grades
for each row
begin
    if old.score <> new.score then
        insert into gradelog (studentid, subjectid, oldscore, newscore, changedate)
        values (old.studentid, old.subjectid, old.score, new.score, now());
    end if;
end$$

delimiter ;

-- procedure pay tuition
delimiter $$

create procedure sp_paytuition()
begin
    start transaction;

    update students
    set totaldebt = totaldebt - 2000000
    where studentid = 'sv01';

    if (select totaldebt from students where studentid = 'sv01') < 0 then
        rollback;
    else
        commit;
    end if;
end$$

delimiter ;

-- gọi procedure đóng học phí
call sp_paytuition();

-- Phần C
-- trigger prevent update passed subject
delimiter $$

create trigger tg_preventpassupdate
before update on grades
for each row
begin
    if old.score >= 4.0 then
        signal sqlstate '45000'
        set message_text = 'khong duoc sua diem mon da qua';
    end if;
end$$
delimiter ;
-- procedure delete student grade safely
delimiter $$
create procedure sp_deletestudentgrade(
    in p_studentid char(5),
    in p_subjectid char(5)
)
begin
    start transaction;
    insert into gradelog (studentid, subjectid, oldscore, newscore, changedate)
    select studentid, subjectid, score, null, now()
    from grades
    where studentid = p_studentid
      and subjectid = p_subjectid;
    delete from grades
    where studentid = p_studentid
      and subjectid = p_subjectid;
    if row_count() = 0 then
        rollback;
    else
        commit;
    end if;
end$$
delimiter ;
-- gọi procedure hủy môn học
call sp_deletestudentgrade('sv03', 'sb02');
-- output – hien thi ket qua
-- danh sach sinh vien
select * from students;
-- bang diem hien tai
select * from grades;
-- lich su sua / xoa diem
select * from gradelog;