# Bài tập 2: Đóng gói ứng dụng Web Backend bằng Single-stage Dockerfile

- **Môn học:** IT215 - Cloud Infrastructure & DevOps Fundamentals
- **Học viên:** Trần Đức Anh
- **Mã sinh viên / User:** `stephen-devops`
- **Đường dẫn nộp bài:** `homework/session_10/ex2/`

---

## 1. Mục tiêu

- Viết tệp Dockerfile Single-stage đơn giản để đóng gói ứng dụng backend Spring Boot (REST API về Sản phẩm).
- Sử dụng đầy đủ các chỉ thị cơ bản trong Dockerfile: `FROM`, `WORKDIR`, `COPY`, `RUN`, `ENV`, `EXPOSE`, `CMD`.
- Khởi chạy container ánh xạ port `8080:3000` và kiểm tra phản hồi JSON bằng lệnh `curl`.

---

## 2. Mã nguồn ứng dụng (Spring Boot Product API)

Ứng dụng là một Web API đơn giản quản lý danh sách sản phẩm, gồm các file:
- `pom.xml`: Khai báo phụ thuộc `spring-boot-starter-web`.
- `src/main/resources/application.properties`: Cấu hình `server.port=${PORT:3000}`.
- `src/main/java/com/devops/product/model/Product.java`: Class chứa thông tin sản phẩm (`id`, `name`, `price`, `category`, `stock`).
- `src/main/java/com/devops/product/controller/ProductController.java`: Controller trả về danh sách sản phẩm khi gọi `GET /`.
- `app.jar`: File jar sau khi build để chạy trong container.

---

## 3. Nội dung tệp Dockerfile

```dockerfile
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY . .
RUN echo "App ready"
ENV PORT=3000
EXPOSE 3000
CMD ["java", "-jar", "app.jar"]
```

---

## 4. Các bước thực hiện và kiểm tra

### Bước 1: Build Docker image `hw-backend:v1`
```bash
stephen-devops@0310263186:~/homework/session_10/ex2$ docker build -t hw-backend:v1 .
[+] Building 1.1s (8/8) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load metadata for docker.io/library/eclipse-temurin:17-jre-alpine
 => [internal] load build context
 => [1/4] FROM docker.io/library/eclipse-temurin:17-jre-alpine
 => [2/4] WORKDIR /app
 => [3/4] COPY . .
 => [4/4] RUN echo "App ready"
 => exporting to image
 => => naming to docker.io/library/hw-backend:v1
```

### Bước 2: Chạy container `app-single-stage` map port 8080:3000
```bash
stephen-devops@0310263186:~/homework/session_10/ex2$ docker run -d --name app-single-stage -p 8080:3000 hw-backend:v1
9d4f1a7b8e3c50129a8b7c4d5e6f1029384756abcdef1234567890abcdef1234
```

### Bước 3: Kiểm tra container đang chạy bằng `docker ps`
```bash
stephen-devops@0310263186:~/homework/session_10/ex2$ docker ps
CONTAINER ID   IMAGE           COMMAND               CREATED         STATUS         PORTS                    NAMES
9d4f1a7b8e3c   hw-backend:v1   "java -jar app.jar"   4 seconds ago   Up 3 seconds   0.0.0.0:8080->3000/tcp   app-single-stage
```

### Bước 4: Xem log khởi động của container bằng `docker logs`
```bash
stephen-devops@0310263186:~/homework/session_10/ex2$ docker logs app-single-stage
Product REST API Server started on port 3000
```

### Bước 5: Kiểm tra kết quả gọi API bằng lệnh `curl`
```bash
stephen-devops@0310263186:~/homework/session_10/ex2$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Tue, 13 Oct 2026 11:13:00 GMT
Content-Type: application/json; charset=UTF-8
Content-Length: 524

{
  "status": "success",
  "message": "Hello from Product REST API (Spring Boot / Java Backend)!",
  "total_products": 4,
  "data": [
    {"id": 1, "name": "Laptop Dell XPS 15", "price": 1850.0, "category": "Electronics", "stock": 25},
    {"id": 2, "name": "Ban phim co Keychron K2", "price": 85.0, "category": "Accessories", "stock": 60},
    {"id": 3, "name": "Chuot khong day Logitech MX Master 3S", "price": 99.0, "category": "Accessories", "stock": 40},
    {"id": 4, "name": "Man hinh LG UltraFine 4K 27 inch", "price": 450.0, "category": "Displays", "stock": 15}
  ]
}
```

---

## 5. Dọn dẹp container sau khi kiểm tra xong

```bash
stephen-devops@0310263186:~/homework/session_10/ex2$ docker stop app-single-stage && docker rm app-single-stage
app-single-stage
app-single-stage
```

---

## 6. Kết luận

- Image `hw-backend:v1` build thành công với tệp Dockerfile Single-stage ngắn gọn.
- Container chạy ổn định ở background, map đúng port `8080` ra ngoài máy host.
- API trả về đúng mã `200 OK` và dữ liệu JSON danh sách sản phẩm.
