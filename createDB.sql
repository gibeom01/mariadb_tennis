-- 사용자 외부 접근 허용
DROP USER IF EXISTS 'root'@'%';
CREATE USER 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- pratice_board 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS pratice_board;

-- pratice_board 데이터베이스 사용
USE pratice_board;

-- member 테이블 생성 및 데이터 삽입
CREATE TABLE IF NOT EXISTS member (
    id VARCHAR(30) PRIMARY KEY,
    name VARCHAR(30),
    pwd VARCHAR(30)
);

INSERT INTO member (id, name, pwd) VALUES ('ssongCoding', 'park gibeom', 'aaaaa');
INSERT INTO member (id, name, pwd) VALUES ('tennisking', 'gibeom', 'bbbbb');
INSERT INTO member (id, name, pwd) VALUES ('programmers', 'beomki', 'ccccc');

-- orderlist 테이블 생성 및 데이터 삽입
CREATE TABLE IF NOT EXISTS orderlist (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(30),
    order_date DATE
);

INSERT INTO orderlist (product_id, order_date) VALUES ('gibeom111', '2024-11-01');
INSERT INTO orderlist (product_id, order_date) VALUES ('gibeom222', '2024-11-02');
INSERT INTO orderlist (product_id, order_date) VALUES ('gibeom333', '2024-11-03');
INSERT INTO orderlist (product_id, order_date) VALUES ('gibeom444', '2024-11-04');

-- MariaDB 서버에 연결된 외부 사용자에게 접근 권한 부여
GRANT ALL PRIVILEGES ON pratice_board.* TO 'user'@'%';
FLUSH PRIVILEGES;

