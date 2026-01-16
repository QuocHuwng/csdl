USE social_network;

CREATE TABLE IF NOT EXISTS delete_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    deleted_by INT,
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT user_id INTO v_owner_id
    FROM posts
    WHERE post_id = p_post_id
    FOR UPDATE;

    IF v_owner_id IS NULL OR v_owner_id <> p_user_id THEN
        ROLLBACK;
    ELSE
        DELETE FROM likes
        WHERE post_id = p_post_id;

        DELETE FROM comments
        WHERE post_id = p_post_id;

        DELETE FROM posts
        WHERE post_id = p_post_id;

        UPDATE users
        SET posts_count = posts_count - 1
        WHERE user_id = p_user_id;

        INSERT INTO delete_log (post_id, deleted_by)
        VALUES (p_post_id, p_user_id);

        COMMIT;
    END IF;
END$$

DELIMITER ;

CALL sp_delete_post(1, 1);
CALL sp_delete_post(2, 1);
