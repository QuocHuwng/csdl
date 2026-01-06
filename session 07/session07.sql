/* ===
   TẠO DATABASE
=== */
DROP DATABASE IF EXISTS sesion07;
CREATE DATABASE sesion07;
USE sesion07;

/* ====
   TẠO BẢNG
=== */
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);

/* ===
   THÊM DỮ LIỆU MẪU
=== */

/* customers (7 dữ liệu) */
INSERT INTO customers (name, email) VALUES
('An', 'an@gmail.com'),
('Bình', 'binh@gmail.com'),
('Chi', 'chi@gmail.com'),
('Dũng', 'dung@gmail.com'),
('Hà', 'ha@gmail.com'),
('Lan', 'lan@gmail.com'),
('Minh', 'minh@gmail.com');

/* orders (7 dữ liệu) */
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-06-01', 500),
(1, '2024-06-15', 1200),
(2, '2024-06-20', 800),
(3, '2024-07-01', 1500),
(4, '2024-07-05', 300),
(5, '2024-07-10', 2000),
(6, '2024-07-15', 700);

/* products (7 dữ liệu) */
INSERT INTO products (name, price) VALUES
('Laptop', 1500),
('Chuột', 20),
('Bàn phím', 50),
('Tai nghe', 100),
('Màn hình', 300),
('USB', 15),
('Ổ cứng', 120);

/* order_items */
INSERT INTO order_items VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 1),
(4, 1, 1),
(5, 5, 2),
(6, 7, 1);

/* ====
   BÀI 1: Subquery cơ bản trong WHERE
   Lấy danh sách khách hàng đã từng đặt hàng
=== */
SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
);

/* ===
   BÀI 2: Subquery trả về nhiều dòng (IN)
   Lấy danh sách sản phẩm đã từng được bán
=== */
SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);

/* ===
   BÀI 3: Subquery với AVG
   Đơn hàng có giá trị > trung bình tất cả đơn hàng
=== */
SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);

/* ===
   BÀI 4: Subquery trong SELECT
   Hiển thị tên khách + số lượng đơn hàng
   KHÔNG JOIN, KHÔNG GROUP BY
=== */
SELECT 
    name,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.customer_id = customers.id
    ) AS so_don_hang
FROM customers;

/* ===
   BÀI 5: Truy vấn lồng nhiều cấp
   Khách hàng có tổng tiền mua lớn nhất
   SUM + MAX, ít nhất 2 subquery
=== */
SELECT *
FROM customers
WHERE id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(tong_tien)
        FROM (
            SELECT SUM(total_amount) AS tong_tien
            FROM orders
            GROUP BY customer_id
        ) AS temp
    )
);

/* ===
   BÀI 6: Subquery kết hợp HAVING
   Khách hàng có tổng tiền mua > trung bình tất cả khách
=== */
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(tong_tien)
    FROM (
        SELECT SUM(total_amount) AS tong_tien
        FROM orders
        GROUP BY customer_id
    ) AS avg_table
);
