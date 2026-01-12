USE social_network_pro;

DELIMITER $$

-- =========================================
-- 1. LẤY DANH SÁCH BÀI VIẾT THEO USER
-- =========================================
CREATE PROCEDURE get_posts_by_user(IN p_user_id INT)
BEGIN
    SELECT 
        post_id AS PostID,
        content AS NoiDung,
        created_at AS ThoiGianTao
    FROM posts
    WHERE user_id = p_user_id
    ORDER BY created_at DESC;
END $$


-- =========================================
-- 2. TÍNH TỔNG SỐ LIKE CỦA BÀI VIẾT
-- =========================================
CREATE PROCEDURE CalculatePostLikes(
    IN p_post_id INT,
    OUT total_likes INT
)
BEGIN
    SELECT COUNT(*)
    INTO total_likes
    FROM likes
    WHERE post_id = p_post_id;
END $$


-- =========================================
-- 3. TÍNH ĐIỂM THƯỞNG USER (INOUT)
-- =========================================
CREATE PROCEDURE CalculateBonusPoints(
    IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE post_count INT;

    SELECT COUNT(*)
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    IF post_count >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF post_count >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    END IF;
END $$


-- =========================================
-- 4. TẠO BÀI VIẾT CÓ KIỂM TRA NỘI DUNG
-- =========================================
CREATE PROCEDURE CreatePostWithValidation(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT result_message VARCHAR(255)
)
BEGIN
    IF CHAR_LENGTH(p_content) < 5 THEN
        SET result_message = 'Nội dung quá ngắn';
    ELSE
        INSERT INTO posts(user_id, content, created_at)
        VALUES (p_user_id, p_content, NOW());

        SET result_message = 'Thêm bài viết thành công';
    END IF;
END $$


-- =========================================
-- 5. TÍNH ĐIỂM HOẠT ĐỘNG USER
-- =========================================
CREATE PROCEDURE CalculateUserActivityScore(
    IN p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE post_count INT DEFAULT 0;
    DECLARE comment_count INT DEFAULT 0;
    DECLARE like_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO comment_count
    FROM comments
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO like_count
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    SET activity_score = post_count * 10
                       + comment_count * 5
                       + like_count * 3;

    CASE
        WHEN activity_score > 500 THEN
            SET activity_level = 'Rất tích cực';
        WHEN activity_score BETWEEN 200 AND 500 THEN
            SET activity_level = 'Tích cực';
        ELSE
            SET activity_level = 'Bình thường';
    END CASE;
END $$


-- =========================================
-- 6. ĐĂNG BÀI + GỬI THÔNG BÁO CHO BẠN BÈ
-- =========================================
CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE new_post_id INT;
    DECLARE poster_name VARCHAR(255);

    SELECT full_name
    INTO poster_name
    FROM users
    WHERE user_id = p_user_id;

    INSERT INTO posts(user_id, content, created_at)
    VALUES (p_user_id, p_content, NOW());

    SET new_post_id = LAST_INSERT_ID();

    INSERT INTO notifications(user_id, type, content, created_at)
    SELECT 
        CASE 
            WHEN f.user_id = p_user_id THEN f.friend_id
            ELSE f.user_id
        END,
        'new_post',
        CONCAT(poster_name, ' đã đăng một bài viết mới'),
        NOW()
    FROM friends f
    WHERE f.status = 'accepted'
      AND (f.user_id = p_user_id OR f.friend_id = p_user_id)
      AND (
            CASE 
                WHEN f.user_id = p_user_id THEN f.friend_id
                ELSE f.user_id
            END
          ) <> p_user_id;
END $$

DELIMITER ;
