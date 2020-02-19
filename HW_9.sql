USE test;

CREATE TABLE prices (
id SERIAL PRIMARY KEY ,
processor DECIMAL ( 11 , 2 ) COMMENT '���� ����������' ,
mother DECIMAL ( 11 , 2 ) COMMENT '���� ���.�����' ,
memory DECIMAL ( 11 , 2 ) COMMENT '���� ����������� ������' ,
total DECIMAL ( 11 , 2 ) COMMENT '�������������� ����'
);


/*1. � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������.
����������� ������ id = 1 �� ������� shop.users � ������� sample.users. �����������
����������.*/

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

/*2. �������� �������������, ������� ������� �������� name �������� ������� �� �������
products � ��������������� �������� �������� name �� ������� catalogs.*/

USE shop;

CREATE  VIEW prod AS SELECT  p.name, c.name AS n2 FROM products AS p JOIN catalogs AS c
WHERE c.id = p.catalog_id;

SELECT * FROM prod;
/*
+-------------------------+------------+
| name                    | n2         |
+-------------------------+------------+
| Intel Core i3-8100      | ���������� |
| AMD FX-8320E            | ���������� |
| AMD FX-8320             | ���������� |
| Gigabyte H310M S2H      | ���.�����  |
| MSI B250M GAMING PRO    | ���������� |
| Intel Core i5-7400      | ���������� |
| ASUS ROG MAXIMUS X HERO | ���.�����  |
| AMD RYZEN 5 1600        | ���������� |
| ASUS PRIME Z370-P       | ���.�����  |
+-------------------------+------------+*/






/*1. �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� ��
�������� ������� �����. � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", �
12:00 �� 18:00 ������� ������ ���������� ����� "������ ����", � 18:00 �� 00:00 � "������
�����", � 00:00 �� 6:00 � "������ ����".*/



DELIMITER // ;
DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE tme TIMESTAMP; 
    SELECT DATE_FORMAT(NOW(),  "%d.%m.%Y") INTO tme;
    CASE 
        WHEN tme BETWEEN '06:00:00' AND '12:00:00' THEN RETURN "������ ����"; 
        WHEN tme BETWEEN '12:00:00' AND '18:00:00' THEN RETURN "������ ����"; 
		WHEN tme BETWEEN '18:00:00' AND '00:00:00' THEN RETURN "������ �����"; 
        ELSE RETURN "������ ����";  
    END CASE;
END//

SELECT hello()//
/*
+-------------+
| hello()     |
+-------------+
| ������ ���� |
+-------------+*/

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello(tme TIME)
RETURNS TEXT DETERMINISTIC
BEGIN
    CASE 
        WHEN tme BETWEEN '06:00:00' AND '12:00:00' THEN RETURN "������ ����"; 
        WHEN tme BETWEEN '12:00:00' AND '18:00:00' THEN RETURN "������ ����"; 
		WHEN tme BETWEEN '18:00:00' AND '00:00:00' THEN RETURN "������ �����"; 
        ELSE RETURN "������ ����";  
    END CASE;
END//

SELECT hello('11:00:00')//
+-------------------+
| hello('11:00:00') |
+-------------------+
| ������ ����       |
+-------------------+

/*2. � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ���
���������. ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ����
��������� �������������� �������� NULL �����������. ��������� ��������, ���������
����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������. ��� ������� ��������� �����
NULL-�������� ���������� �������� ��������.*/


DROP PROCEDURE IF EXISTS throw_error_if_true;
CREATE PROCEDURE throw_error_if_true(IN val BOOLEAN)
BEGIN
     DECLARE msg VARCHAR(50) DEFAULT "Only one field maybe NULL";

/*��� � ����� ���� NEW == OLD �� �������� �� ���������� => ������� ������ ������� ���� ������ �������*/

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



/*3. (�� �������) �������� �������� ������� ��� ���������� ������������� ����� ���������.
������� ��������� ���������� ������������������ � ������� ����� ����� ����� ����
���������� �����. ����� ������� FIBONACCI(10) ������ ���������� ����� 55.*/


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