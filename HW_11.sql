/*1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
catalogs и products в таблицу logs помещается время и дата создания записи, название
таблицы, идентификатор первичного ключа и содержимое поля name.*/

CREATE TABLE logs (
tablename varchar(255) COMMENT 'Название таблицы',
external_id INT COMMENT 'Первичный ключ таблицы tablename',
name VARCHAR(255) COMMENT 'Поле таблицы tablename',
creataed_at DATETIME DEFAULT current_timestamp
) COMMENT = 'Журнал интернет-магазина' ENGINE = ARCHIVE;


DELIMITER //

CREATE TRIGGER  log_after_insert_to_users AFTER INSERT ON users
FOR EACH ROW BEGIN
	INSERT INTO logs (tablename, external_id, name) VALUES('users', NEW.id, NEW.name);
END//

CREATE TRIGGER  log_after_insert_to_catalogs AFTER INSERT ON catalogs
FOR EACH ROW BEGIN
	INSERT INTO logs (tablename, external_id, name) VALUES('catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER  log_after_insert_to_products AFTER INSERT ON products
FOR EACH ROW BEGIN
	INSERT INTO logs (tablename, external_id, name) VALUES('products', NEW.id, NEW.name);
END//


INSERT INTO users (name, birthday_at) VALUES ('Геннадий', '1990-10-05')//

 SELECT * FROM users//
 /*
+----+-----------+-------------+---------------------+---------------------+
| id | name      | birthday_at | created_at          | apdated_at          |
+----+-----------+-------------+---------------------+---------------------+
|  1 | Геннадий  | 1990-10-05  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  2 | Наталья   | 1984-11-12  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  3 | Александр | 1985-05-20  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  4 | Сергей    | 1988-02-14  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  5 | Иван      | 1998-01-12  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  6 | Мария     | 1992-08-29  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  8 | Светлана  | 1988-02-04  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  9 | Олег      | 1998-03-20  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
| 10 | Юлия      | 2006-07-12  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
| 11 | Геннадий  | 1990-10-05  | 2020-02-27 17:32:23 | 2020-02-27 17:32:23 |<- 
+----+-----------+-------------+---------------------+---------------------+	*/
 
 SELECT * FROM logs//
 /*
+-----------+-------------+----------+---------------------+
| tablename | external_id | name     | creataed_at         |
+-----------+-------------+----------+---------------------+
| users     |          11 | Геннадий | 2020-02-27 17:32:23 |
+-----------+-------------+----------+---------------------+*/
 
 
INSERT INTO catalogs (name) VALUES ('Блоки питания')//
 
 SELECT * FROM catalogs//
 /*
+----+----------------------+
| id | name                 |
+----+----------------------+
|  1 | Процессоры           |
|  2 | Мат.платы            |
|  3 | Видеокарты           |
|  4 | SDD                  |
|  5 | Сетевое оборудование |
|  6 | Жесткие диски        |
|  7 | Оперативная память   |
|  8 | Мониторы             |
| 10 | Блоки питания        |
+----+----------------------+*/
 
 SELECT * FROM logs//
 
 
 INSERT INTO products 
 	(name, description, price, catalog_id)
 VALUES
 	('ASUS PRIME Z370-P', 'HDMI, SATA3, PCI EXPRESS 3.0, USB 3.1', 9450.00, 2)//
 
 SELECT * FROM logs//
 /*
+-----------+-------------+-------------------+---------------------+
| tablename | external_id | name              | creataed_at         |
+-----------+-------------+-------------------+---------------------+
| users     |          11 | Геннадий          | 2020-02-27 17:32:23 |
| products  |          17 | ASUS PRIME Z370-P | 2020-02-27 17:52:40 |
+-----------+-------------+-------------------+---------------------+*/
 


/*2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.*/

CREATE TABLE samples (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'Имя покупателя',
birthday_at DATE,
created_at DATETIME DEFAULT current_timestamp,
updated_at DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp
) COMMENT = 'Покупатели'//

 
INSERT INTO samples (name, birthday_at) VALUES 
	('Геннадий', '1990-10-05'),
	('Наталья', '1984-11-12'),
	('Алексадр', '1985-05-20'),
	('Сукгей', '1988-02-14'),
	('Иван', '1998-01-12'),
	('Мария', '1992-08-29'),
	('Аркадий', '1994-03-17'),
	('Ольга', '1981-07-10'),
	('Владимир', '1988-06-12'),
	('Екатерина', '1992-09-20')//
	
	
 
> SELECT COUNT(*) FROM
    samples as fst,
    samples as snd,
    samples as thd,
    samples as fth,
    samples as fif,
    samples as sth//
/*     
+----------+
| COUNT(*) |
+----------+
|  1000000 |
+----------+*/

INSERT  INTO 
	users (name, birthday_at)
SELECT 
	fst.name,
	fst.birthday_at
FROM
	samples as fst,
    samples as snd,
    samples as thd,
    samples as fth,
    samples as fif,
    samples as sth//
    
SELECT * FROM users LIMIT 10//    
  



    
    
    