-- 1. Tạo bảng Users (Người dùng)
create database ss14;
use ss14;
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);
-- 2. Tạo bảng Posts (Bài viết)
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
-- 3. Tạo dữ liệu mẫu
INSERT INTO users (username, total_posts) VALUES ('nguyen_van_a', 0);
INSERT INTO users (username, total_posts) VALUES ('le_thi_b', 0);

 delimiter //
 create procedure sp_create_post (in p_user_id INT, in p_content TEXT)
 begin
	start transaction ;
    if ((select username from users where user_id=p_user_id) is null ) then
    signal sqlstate  '45000'
    set message_text ='ng dung khong ton tai';
    rollback;
    end if;
    
    if p_content is null or trim(p_content)='' then
    signal sqlstate  '45000'
    set message_text ='khong hop le';
    signal sqlstate  '45000'
    set message_text ='khong hop le';
	end if;
    
	update users 
	set total_posts=total_posts+1 where user_id=p_user_id;
	insert into posts(user_id,content)
	value (p_user_id,p_content);

 end //
 delimiter ;
 drop procedure sp_create_post;
 call sp_create_post(4,'dsfasd'); 
 
 