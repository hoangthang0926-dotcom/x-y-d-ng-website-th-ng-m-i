SHOP MVC - KẾT HỢP BUỔI 1 VÀ BUỔI 2

Yêu cầu:
- XAMPP có PHP 8.1 trở lên, MySQL, Apache.
- Bật extension=pdo_mysql và extension=gd trong php.ini.
- Đặt thư mục shop vào C:\xampp\htdocs\shop.

CÀI ĐẶT:
1. Mở XAMPP, bật Apache và MySQL.
2. Mở http://localhost/phpmyadmin
3. Chọn tab Import, nhập database/schema.sql (hoặc mở tab SQL và chạy nội dung file).
4. Kiểm tra config/config.php:
   DB_USER = root
   DB_PASS = ''
   BASE_URL = http://localhost/shop/public/
5. Mở http://localhost/shop/public/

SINH ẢNH SẢN PHẨM:
Mở một lần: http://localhost/shop/database/seed_images.php
Lưu ý: chỉ chạy một lần. Sản phẩm số 3 và 17 được để trống ảnh để thử ảnh mặc định.

TÀI KHOẢN QUẢN TRỊ:
- admin@shop.local / admin123
- staff@shop.local / staff123

CÁC ĐƯỜNG DẪN:
- Trang chủ: /
- Đăng ký: /auth/register
- Đăng nhập khách hàng: /auth/login
- Hồ sơ: /account/profile
- Đăng nhập quản trị: /admin/auth/login
- Tổng quan quản trị: /admin/dashboard
- Quản lý người dùng: /admin/user

GHI CHÚ:
- Menu Danh mục và Sản phẩm ở khu vực quản trị được đặt sẵn cho Buổi 3; hai buổi này chưa xây dựng CRUD các mục đó.
- Đây là dự án học tập chạy local. Trước khi triển khai thật cần cấu hình HTTPS, cookie session an toàn,
  CSRF cho thao tác đăng xuất và các biện pháp bảo mật triển khai bổ sung.
