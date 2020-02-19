USE test;

CREATE TABLE prices (
id SERIAL PRIMARY KEY ,
processor DECIMAL ( 11 , 2 ) COMMENT 'Цена процессора' ,
mother DECIMAL ( 11 , 2 ) COMMENT 'Цена мат.платы' ,
memory DECIMAL ( 11 , 2 ) COMMENT 'Цена оперативной памяти' ,
total DECIMAL ( 11 , 2 ) COMMENT 'Результирующая цена'
);


/*1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте
транзакции.*/

USE test;


START TRANSACTION;
INSERT prices SELECT * FROM shop.prices WHERE id = 1;
COMMIT;

SELECT * FROM prices;
/*
+----+-----------+---------+---------+----------+
| id | processor | mother  | memory  | total    |
+----+-----------+---------+---------+----------+
|  1 |   7890.00 | 5060.00 | 4800.00 | 17750.00 |
+----+-----------+---------+---------+----------+*/

/*2. Создайте представление, которое выводит название name товарной позиции из таблицы
products и соответствующее название каталога name из таблицы catalogs.*/

USE shop;

CREATE  VIEW prod AS SELECT  p.name, c.name AS n2 FROM products AS p JOIN catalogs AS c
WHERE c.id = p.catalog_id;

SELECT * FROM prod;
/*
+-------------------------+------------+
| name                    | n2         |
+-------------------------+------------+
| Intel Core i3-8100      | Процессоры |
| AMD FX-8320E            | Процессоры |
| AMD FX-8320             | Процессоры |
| Gigabyte H310M S2H      | Мат.платы  |
| MSI B250M GAMING PRO    | Видеокарты |
| Intel Core i5-7400      | Процессоры |
| ASUS ROG MAXIMUS X HERO | Мат.платы  |
| AMD RYZEN 5 1600        | Процессоры |
| ASUS PRIME Z370-P       | Мат.платы  |
+-------------------------+------------+*/






/*1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый
вечер", с 00:00 до 6:00 — "Доброй ночи".*/



DELIMITER // ;
DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE tme TIMESTAMP; 
    SELECT DATE_FORMAT(NOW(),  "%d.%m.%Y") INTO tme;
    CASE 
        WHEN tme BETWEEN '06:00:00' AND '12:00:00' THEN RETURN "Доброе утро"; 
        WHEN tme BETWEEN '12:00:00' AND '18:00:00' THEN RETURN "Добрый день"; 
		WHEN tme BETWEEN '18:00:00' AND '00:00:00' THEN RETURN "Добрый вечер"; 
        ELSE RETURN "Доброй ночи";  
    END CASE;
END//

SELECT hello()//
/*
+-------------+
| hello()     |
+-------------+
| Доброй ночи |
+-------------+*/

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello(tme TIME)
RETURNS TEXT DETERMINISTIC
BEGIN
    CASE 
        WHEN tme BETWEEN '06:00:00' AND '12:00:00' THEN RETURN "Доброе утро"; 
        WHEN tme BETWEEN '12:00:00' AND '18:00:00' THEN RETURN "Добрый день"; 
		WHEN tme BETWEEN '18:00:00' AND '00:00:00' THEN RETURN "Добрый вечер"; 
        ELSE RETURN "Доброй ночи";  
    END CASE;
END//

SELECT hello('11:00:00')//
+-------------------+
| hello('11:00:00') |
+-------------------+
| Доброе утро       |
+-------------------+

/*2. В таблице products есть два текстовых поля: name с названием товара и description с его
описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
NULL-значение необходимо отменить операцию.*/


DROP PROCEDURE IF EXISTS throw_error_if_true;
CREATE PROCEDURE throw_error_if_true(IN val BOOLEAN)
BEGIN
     DECLARE msg VARCHAR(50) DEFAULT "Only one field maybe NULL";

/*Как я понял если NEW == OLD то значение не поменялось => условие должно покрыть весь массив случаев*/

    IF (val) THEN 
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = msg;
    END IF;
END//
   
DROP TRIGGER IF EXISTS check_products_insert_not_null_fields;
CREATE TRIGGER check_products_insert_not_null_fields BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    DECLARE chk BOOLEAN DEFAULT (NEW.name IS NULL AND NEW.description IS NULL);
    CALL throw_error_if_true(chk);
END//

DROP TRIGGER IF EXISTS check_products_update_not_null_fields;
CREATE TRIGGER check_products_update_not_null_fields BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    DECLARE chk BOOLEAN DEFAULT (NEW.name IS NULL AND NEW.description IS NULL);
    CALL throw_error_if_true(chk);

END//



/*3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
Числами Фибоначчи называется последовательность в которой число равно сумме двух
предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.*/


DROP FUNCTION IF EXISTS FIBONACCI; 
CREATE FUNCTION FIBONACCI(n INT)
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE p1 INT DEFAULT 1;
    DECLARE p2 INT DEFAULT 1;
    DECLARE i INT DEFAULT 2;
    DECLARE res INT DEFAULT 0;
   
    IF (n <= 1) THEN RETURN n;
    ELSEIF (n = 2) THEN RETURN 1;
    END IF;  
    WHILE i < n DO
        SET i = i + 1;
	SET res = p2 + p1;
        SET p2 = p1;
        SET p1 = res;
    END WHILE;
    RETURN res;
 END//
 
 SELECT FIBONACCI(10)//
+---------------+
| FIBONACCI(10) |
+---------------+
| 55            |
+---------------+