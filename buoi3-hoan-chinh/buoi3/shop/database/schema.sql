CREATE DATABASE IF NOT EXISTS shop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shop_db;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE users (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(120) NOT NULL,
 email VARCHAR(190) NOT NULL UNIQUE,
 password VARCHAR(255) NOT NULL,
 role ENUM('admin','staff','customer') NOT NULL DEFAULT 'customer',
 status ENUM('active','locked') NOT NULL DEFAULT 'active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE categories (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(150) NOT NULL,
 slug VARCHAR(180) NOT NULL UNIQUE,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products (
 id INT AUTO_INCREMENT PRIMARY KEY,
 category_id INT NOT NULL,
 sku VARCHAR(80) NOT NULL UNIQUE,
 name VARCHAR(200) NOT NULL,
 brand VARCHAR(120) DEFAULT '',
 description TEXT,
 price DECIMAL(12,2) NOT NULL,
 stock INT NOT NULL DEFAULT 0,
 is_featured TINYINT(1) NOT NULL DEFAULT 0,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_products_category FOREIGN KEY(category_id) REFERENCES categories(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE product_images (
 id INT AUTO_INCREMENT PRIMARY KEY,
 product_id INT NOT NULL,
 file_name VARCHAR(255) NOT NULL,
 original_name VARCHAR(255) NOT NULL,
 alt_text VARCHAR(255) DEFAULT '',
 is_primary TINYINT(1) NOT NULL DEFAULT 0,
 sort_order INT NOT NULL DEFAULT 0,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_images_product FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,
 INDEX idx_product_images(product_id,is_primary,sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO users(name,email,password,role,status) VALUES
('Quản trị viên','admin@shop.local','$2y$12$Mr4KymYWxra/wHbuGNt.w./ul5oqNKsJi65VtOcygw7bPewcL8fde','admin','active'),
('Nhân viên','staff@shop.local','$2y$12$4dtWwaAA06JoeLgQ4Tctj.9zIJuwMOg0eH.CX5Ly9m6ctd/cd.wSi','staff','active');

INSERT INTO categories(name,slug,status) VALUES
('Laptop','laptop','active'),('Máy tính PC','may-tinh-pc','active'),('Phụ kiện','phu-kien','active'),('Màn hình','man-hinh','active'),('Máy tính bảng','may-tinh-bang','active');

INSERT INTO products(category_id,sku,name,brand,description,price,stock,is_featured,status) VALUES
(1,'LAP-DELL-001','Dell Inspiron 15','Dell','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',15990000,12,1,'active'),
(1,'LAP-DELL-002','Dell Vostro 3520','Dell','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',16990000,8,1,'active'),
(1,'LAP-HP-001','HP 15s','HP','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',14990000,10,1,'active'),
(1,'LAP-LEN-001','Lenovo IdeaPad Slim 3','Lenovo','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',13990000,9,1,'active'),
(1,'LAP-ASUS-001','ASUS Vivobook 15','ASUS','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',15490000,7,1,'active'),
(2,'PC-GAME-001','PC Gaming Core i5','Build PC','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',18990000,5,0,'active'),
(2,'PC-GAME-002','PC Gaming Ryzen 5','Build PC','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',19990000,4,0,'active'),
(2,'PC-OFF-001','PC Văn phòng i3','Build PC','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',8990000,11,0,'active'),
(2,'PC-GAME-003','PC Gaming RTX 4060','Build PC','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',25990000,3,0,'active'),
(2,'PC-OFF-002','PC Văn phòng i5','Build PC','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',11990000,6,0,'active'),
(3,'ACC-MOU-001','Chuột Logitech M331','Logitech','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',399000,30,0,'active'),
(3,'ACC-KB-001','Bàn phím cơ RGB','Akko','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',990000,18,0,'active'),
(3,'ACC-HEAD-001','Tai nghe Gaming Havit','Havit','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',590000,22,0,'active'),
(3,'ACC-MOU-002','Chuột Gaming Logitech G102','Logitech','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',499000,25,0,'active'),
(3,'ACC-PAD-001','Lót chuột cỡ lớn','Generic','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',150000,40,0,'active'),
(4,'MON-001','Màn hình LG 24 inch','LG','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',2890000,13,0,'active'),
(4,'MON-002','Màn hình Dell 27 inch','Dell','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',5490000,7,0,'active'),
(4,'MON-003','Màn hình MSI Gaming 165Hz','MSI','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',4990000,6,0,'active'),
(5,'TAB-001','Máy tính bảng TabOne 10','TabOne','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',3990000,9,0,'active'),
(5,'TAB-002','Máy tính bảng Android 11 inch','Generic','Sản phẩm mẫu phục vụ thực hành quản lý cửa hàng.',5290000,5,0,'active');

INSERT INTO product_images(product_id,file_name,original_name,alt_text,is_primary,sort_order) VALUES
(1,'prod_01_lap_dell_001.jpg','prod_01_lap_dell_001.jpg','Dell Inspiron 15',1,0),
(2,'prod_02_lap_dell_002.jpg','prod_02_lap_dell_002.jpg','Dell Vostro 3520',1,0),
(3,'prod_03_lap_hp_001.jpg','prod_03_lap_hp_001.jpg','HP 15s',1,0),
(4,'prod_04_lap_len_001.jpg','prod_04_lap_len_001.jpg','Lenovo IdeaPad Slim 3',1,0),
(5,'prod_05_lap_asus_001.jpg','prod_05_lap_asus_001.jpg','ASUS Vivobook 15',1,0),
(6,'prod_06_pc_game_001.jpg','prod_06_pc_game_001.jpg','PC Gaming Core i5',1,0),
(7,'prod_07_pc_game_002.jpg','prod_07_pc_game_002.jpg','PC Gaming Ryzen 5',1,0),
(8,'prod_08_pc_off_001.jpg','prod_08_pc_off_001.jpg','PC Văn phòng i3',1,0),
(9,'prod_09_pc_game_003.jpg','prod_09_pc_game_003.jpg','PC Gaming RTX 4060',1,0),
(10,'prod_10_pc_off_002.jpg','prod_10_pc_off_002.jpg','PC Văn phòng i5',1,0),
(11,'prod_11_acc_mou_001.jpg','prod_11_acc_mou_001.jpg','Chuột Logitech M331',1,0),
(12,'prod_12_acc_kb_001.jpg','prod_12_acc_kb_001.jpg','Bàn phím cơ RGB',1,0),
(13,'prod_13_acc_head_001.jpg','prod_13_acc_head_001.jpg','Tai nghe Gaming Havit',1,0),
(14,'prod_14_acc_mou_002.jpg','prod_14_acc_mou_002.jpg','Chuột Gaming Logitech G102',1,0),
(15,'prod_15_acc_pad_001.jpg','prod_15_acc_pad_001.jpg','Lót chuột cỡ lớn',1,0),
(16,'prod_16_mon_001.jpg','prod_16_mon_001.jpg','Màn hình LG 24 inch',1,0),
(17,'prod_17_mon_002.jpg','prod_17_mon_002.jpg','Màn hình Dell 27 inch',1,0),
(18,'prod_18_mon_003.jpg','prod_18_mon_003.jpg','Màn hình MSI Gaming 165Hz',1,0),
(19,'prod_19_tab_001.jpg','prod_19_tab_001.jpg','Máy tính bảng TabOne 10',1,0),
(20,'prod_20_tab_002.jpg','prod_20_tab_002.jpg','Máy tính bảng Android 11 inch',1,0);
