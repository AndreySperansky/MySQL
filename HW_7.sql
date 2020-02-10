/*
1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в
интернет магазине.*/


SELECT * FROM users
WHERE EXISTS (SELECT * FROM orders WHERE user_id = users.id) 

/*
+----+---------+-------------+---------------------+---------------------+
| id | name    | birthday_at | created_at          | apdated_at          |
+----+---------+-------------+---------------------+---------------------+
|  2 | Наталья | 1984-11-12  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
|  4 | Сергей  | 1988-02-14  | 2020-02-05 16:59:41 | 2020-02-05 16:59:41 |
+----+---------+-------------+---------------------+---------------------+
*/


/*
2. Выведите список товаров products и разделов catalogs, который соответствует товару.
*/

SELECT
id , name , ( SELECT name FROM catalogs WHERE id = catalog_id) AS 'catalog'
FROM
products;

/*
+----+-------------------------+------------+
| id | name                    | catalog    |
+----+-------------------------+------------+
|  1 | Intel Core i3-8100      | Процессоры |
|  2 | AMD FX-8320E            | Процессоры |
|  3 | AMD FX-8320             | Процессоры |
|  4 | Gigabyte H310M S2H      | Мат.платы  |
|  5 | MSI B250M GAMING PRO    | Мат.платы  |
|  6 | Intel Core i5-7400      | Процессоры |
| 11 | ASUS ROG MAXIMUS X HERO | Мат.платы  |
+----+-------------------------+------------+
*/

/*
3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
name). Поля from, to и label содержат английские названия городов, поле name — русское.
Выведите список рейсов flights с русскими названиями городов.
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
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');



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
| irkutsk  | moscow  | Москва  |
| omsk     | irkutsk | Иркутск |
| novgorod | kazan   | Казань  |
| moskow   | kazan   | Казань  |
| moscow   | omsk    | Омск    |
+----------+---------+---------+
*/

/* Смог только так -(