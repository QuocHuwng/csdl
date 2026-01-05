/* ===
   TẠO DATABASE
=== */
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

/* ===
   TẠO BẢNG
=== */
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    city VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending','completed','cancelled'),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

/* ===
   THÊM DỮ LIỆU
=== */
INSERT INTO customers (full_name, city) VALUES
('Nguyen Van A','Ha Noi'),
('Tran Thi B','HCM'),
('Le Van C','Da Nang'),
('Pham Thi D','Ha Noi'),
('Hoang Van E','Can Tho');

INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1,'2024-01-01','completed',3000000),
(1,'2024-01-02','completed',4500000),
(1,'2024-01-03','completed',6000000),
(2,'2024-01-02','completed',7000000),
(3,'2024-01-03','completed',2000000),
(4,'2024-01-04','completed',8000000);

INSERT INTO products (product_name, price) VALUES
('Laptop',15000000),
('Phone',8000000),
('Tablet',6000000),
('Headphone',2000000),
('Mouse',500000);

INSERT INTO order_items VALUES
(1,2,1),
(1,5,2),
(2,3,1),
(3,2,1),
(4,1,1),
(5,4,2),
(6,1,1),
(6,5,8);

/* ===
   BÀI 1: KHÁCH HÀNG & ĐƠN HÀNG
=== */
SELECT o.order_id, c.full_name, o.order_date, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name;

SELECT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name;

/* ===
   BÀI 2: TỔNG TIỀN KHÁCH HÀNG
=== */
SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name;

SELECT c.full_name, MAX(o.total_amount) AS max_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name;

SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total_spent DESC;

/* ===
   BÀI 3: DOANH THU THEO NGÀY
=== */
SELECT order_date,
       COUNT(order_id) AS total_orders,
       SUM(total_amount) AS daily_revenue
FROM orders
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;

/* ===
   BÀI 4: SẢN PHẨM & CHI TIẾT ĐƠN
=== */
SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name;

SELECT p.product_name,
       SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;

/* ===
   BÀI 5: KHÁCH HÀNG VIP
=== */
SELECT c.full_name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spent,
       AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING COUNT(o.order_id) >= 3
   AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;

/* ===
   BÀI 6: BÁO CÁO KINH DOANH
=== */
SELECT p.product_name,
       SUM(oi.quantity) AS total_quantity,
       SUM(oi.quantity * p.price) AS total_revenue,
       AVG(p.price) AS avg_price
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY total_revenue DESC
LIMIT 5;
