/* 1. ����������� ������� ������� ������������� � ������� users */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age FROM users;

/*
+---------+
| age     |
+---------+
| 29.6667 |
+---------+
*/

/* 2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������.
������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������. */

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


/* 3. (�� �������) ����������� ������������ ����� � ������� ������� */


SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;

/*
+-------------------------+
| ROUND(EXP(SUM(LN(id)))) |
+-------------------------+
|                    5040 |
+-------------------------+

*/