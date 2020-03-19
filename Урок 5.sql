-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users 
	SET creted_at = now() WHERE created_ad IS NULL,
	SET updated_at = now() WHERE updated_ad IS NULL
;
	
	
	
/*Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR
и в них долгое время помещались значения в формате "20.10.2017 8:10". 
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.*/

CHANGE COLUMN created_at created_at DATETIME DEFAULT CURRENT TIMESTAMP, 
CHANGE COLUMN updated_at created_at DATETIME DEFAULT CURRENT TIMESTAMP ON UPDATE CURRENT TIMESTAMP;


/*В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
0, если товар закончился и выше нуля, если на складе имеются запасы. 
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
Однако, нулевые запасы должны выводиться в конце, после всех записей.*/

SELECT value, id FROM storehouses_products;

SELECT value FROM storehouses_products ORDER BY CASE WHEN valeu = 0 THEN 1 ELSE 0 end, value; 
SELECT id, value FROM storehouses_products ORDER BY CASE WHEN valeu = 0 THEN 1 ELSE 0 end, value;


-- Подсчитайте средний возраст пользователей в таблице users

SELECT round(avg(to_days(now()) - to_days(birthday_at)) / 365,25), 0) AS avg_age FROM users;



/*Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/


-- Сложновато
