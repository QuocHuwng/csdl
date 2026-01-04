/* ====
   TẠO DATABASE=== */

DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;


/* ===TẠO BẢNG=== */

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    stock INT,
    sold_quantity INT,
    status ENUM('active','inactive')
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status ENUM('active','inactive')
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    status ENUM('pending','completed','cancelled')
);


/* ===INSERT DỮ LIỆU MẪU=== */

INSERT INTO products (product_name, price, stock, sold_quantity, status) VALUES
('Laptop Dell', 25000000, 10, 50, 'active'),
('Chuột Logitech', 500000, 100, 120, 'active'),
('Bàn phím cơ', 1500000, 30, 80, 'active'),
('Màn hình LG', 3500000, 20, 40, 'inactive'),
('Tai nghe Sony', 1800000, 25, 90, 'active'),
('USB 32GB', 300000, 200, 300, 'active'),
('Ổ cứng SSD', 2800000, 15, 60, 'active'),
('Webcam', 1200000, 40, 35, 'inactive');

INSERT INTO customers (full_name, email, city, status) VALUES
('Nguyễn Văn An', 'an@gmail.com', 'TP.HCM', 'active'),
('Trần Thị Bình', 'binh@gmail.com', 'Hà Nội', 'active'),
('Lê Minh Châu', 'chau@gmail.com', 'Đà Nẵng', 'inactive'),
('Phạm Quốc Dũng', 'dung@gmail.com', 'TP.HCM', 'active');

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 6000000, '2024-10-01', 'completed'),
(2, 3000000, '2024-10-02', 'pending'),
(1, 8000000, '2024-10-03', 'completed'),
(3, 2000000, '2024-10-04', 'cancelled'),
(2, 9000000, '2024-10-05', 'completed'),
(4, 4000000, '2024-10-06', 'completed'),
(1, 12000000, '2024-10-07', 'completed'),
(2, 2500000, '2024-10-08', 'pending');


/* ===
   BÀI 1: DANH SÁCH SẢN PHẨM TRONG CỬA HÀNG
   === */

SELECT * FROM products;

SELECT * FROM products
WHERE status = 'active';

SELECT * FROM products
WHERE price > 1000000;

SELECT * FROM products
WHERE status = 'active'
ORDER BY price ASC;


/* ===
   BÀI 2: QUẢN LÝ KHÁCH HÀNG
   === */

SELECT * FROM customers;

SELECT * FROM customers
WHERE city = 'TP.HCM';

SELECT * FROM customers
WHERE status = 'active'
AND city = 'Hà Nội';

SELECT * FROM customers
ORDER BY full_name ASC;


/* ===
   BÀI 3: ĐƠN HÀNG CỦA CỬA HÀNG
   === */

SELECT * FROM orders
WHERE status = 'completed';

SELECT * FROM orders
WHERE total_amount > 5000000;

SELECT * FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT * FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;


/* ===
   BÀI 4: SẢN PHẨM BÁN CHẠY
   === */

SELECT * FROM products
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT * FROM products
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

SELECT * FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;


/* ===
   BÀI 5: PHÂN TRANG DANH SÁCH ĐƠN HÀNG
   === */

SELECT * FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT * FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT * FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;


/* ===
   BÀI 6: TÌM KIẾM VÀ SẮP XẾP SẢN PHẨM NÂNG CAO
   === */

SELECT * FROM products
WHERE status = 'active'
AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;

SELECT * FROM products
WHERE status = 'active'
AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;
