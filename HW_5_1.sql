/* 1. ѕодсчитайте средний возраст пользователей в таблице users */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;

/*
+---------+
| age     |
+---------+
| 29.6667 |
+---------+
*/

/* 2. ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели.
—ледует учесть, что необходимы дни недели текущего года, а не года рождени€. */

SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W')
 AS day, COUNT(*) AS total FROM users GROUP BY day ORDER BY total DESC;

/*
+-----------+-------+
| day       | total |
+-----------+-------+
| Friday    |     2 |
| Sunday    |     2 |
| Monday    |     1 |
| Thursday  |     1 |
| Wednesday |     1 |
| Saturday  |     1 |
| Tuesday   |     1 |
+-----------+-------+
*/


/* 3. (по желанию) ѕодсчитайте произведение чисел в столбце таблицы */


SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;

/*
+-------------------------+
| ROUND(EXP(SUM(LN(id)))) |
+-------------------------+
|                    5040 |
+-------------------------+

*/