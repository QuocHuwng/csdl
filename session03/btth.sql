insert into student (student_id,full_name,date_of_bitrh,gender)
value ('SV01', 'Nguyen Van A', '2004-01-10', 'Nam'),
('SV02', 'Nguyen Van B', '2004-02-12', 'Nam'),
('SV03', 'Nguyen Van C', '2004-03-15', 'Nam'),
('SV04', 'Nguyen Van D', '2004-04-18', 'Nam'),
('SV05', 'Nguyen Van E', '2004-05-20', 'Nam'),
('SV06', 'Tran Thi F', '2004-06-22', 'Nu'),
('SV07', 'Tran Thi G', '2004-07-25', 'Nu'),
('SV08', 'Tran Thi H', '2004-08-27', 'Nu'),
('SV09', 'Le Van I', '2004-09-30', 'Nam'),
('SV10', 'Le Thi K', '2004-10-05', 'Nu');


INSERT INTO MonHoc (subject_id,subject_name,credit_number)
VALUES
('MH01', 'Co so du lieu', 3),
('MH02', 'Lap trinh C', 3),
('MH03', 'Lap trinh Java', 4),
('MH04', 'Mang may tinh', 3),
('MH05', 'He dieu hanh', 3),
('MH06', 'Cong nghe Web', 3),
('MH07', 'Tri tue nhan tao', 3),
('MH08', 'An toan thong tin', 3),
('MH09', 'Phan tich thiet ke HT', 3),
('MH10', 'Kiem thu phan mem', 2);
insert into register_subject(student_id,subject_id,semester)
value('SV01', 'MH01', 1),
('SV02', 'MH02', 1),
('SV03', 'MH03', 1),
('SV04', 'MH04', 1),
('SV05', 'MH05', 1),
('SV06', 'MH06', 2),
('SV07', 'MH07', 2),
('SV08', 'MH08', 2),
('SV09', 'MH09', 2),
('SV10', 'MH10', 2);