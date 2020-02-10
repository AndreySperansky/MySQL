/*
1. ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders �
�������� ��������.*/


SELECT * FROM users
WHERE EXISTS (SELECT * FROM orders WHERE user_id = users.id) 

/*
+----+---------+-------------+---------------------+---------------------+
| id | name    | birthday_at | created_at          | apdated_at          |
+----+---------+-------------+---------------------+---------------------+
|  2 | ������� | 1984-11-12  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  4 | ������  | 1988-02-14  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
+----+---------+-------------+---------------------+---------------------+
*/


/*
2. �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
*/

SELECT
id , name , ( SELECT name FROM catalogs WHERE id = catalog_id) AS 'catalog'
FROM
products;

/*
+----+-------------------------+------------+
| id | name                    | catalog    |
+----+-------------------------+------------+
|  1 | Intel Core i3-8100      | ���������� |
|  2 | AMD FX-8320E            | ���������� |
|  3 | AMD FX-8320             | ���������� |
|  4 | Gigabyte H310M S2H      | ���.�����  |
|  5 | MSI B250M GAMING PRO    | ���.�����  |
|  6 | Intel Core i5-7400      | ���������� |
| 11 | ASUS ROG MAXIMUS X HERO | ���.�����  |
+----+-------------------------+------------+
*/

/*
3. (�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label,
name). ���� from, to � label �������� ���������� �������� �������, ���� name � �������.
�������� ������ ������ flights � �������� ���������� �������.
*/

USE test;

DROP TABLE IF EXISTS flights;

CREATE TABLE `test`.`flight` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from` VARCHAR(45) NOT NULL,
  `to` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);


INSERT INTO flights (`from`, `to`) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moskow'),
  ('omsk', 'irkutsk'),
  ('moskow', 'kazan');


DROP TABLE IF EXISTS cities;

CREATE TABLE cities (
	`label` VARCHAR (45) NOT NULL,
	`name` VARCHAR (45) NOT NULL
    );
    
INSERT INTO  cities (`label`, `name`) VALUES
('moscow', '������'),
('irkutsk', '�������'),
('novgorod', '��������'),
('kazan', '������'),
('omsk', '����');



SELECT
f.`from`,
f.`to`,
c.name
FROM
flight AS f
JOIN
cities AS c
WHERE
c.`label` = f.`to`;

/*
+----------+---------+---------+
| from     | to      | name    |
+----------+---------+---------+
| irkutsk  | moscow  | ������  |
| omsk     | irkutsk | ������� |
| novgorod | kazan   | ������  |
| moskow   | kazan   | ������  |
| moscow   | omsk    | ����    |
+----------+---------+---------+
*/

/* ���� ������ ��� -(