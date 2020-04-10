DROP DATABASE IF EXISTS coursework;
CREATE DATABASE coursework;
USE coursework;

CREATE TABLE departs(
	d_id SERIAL, 
	d_name varchar(100) NOT NULL, 
	PRIMARY KEY (d_id, d_name),
	INDEX d_name_idx(d_name)
);

CREATE TABLE rooms(
	r_depart_id SERIAL, 
	room INT not null,
	phone bigint, 
	unique(room, phone),
	FOREIGN KEY (r_depart_id) REFERENCES departs(d_id),
	PRIMARY KEY(room, phone)
);

create table posts ( 
	id SERIAL,			/*таблица должности, post - должность, salary - оклад*/
	name varchar(100), 
	salary INT not null check(salary>=4500),
	PRIMARY KEY(id, name),
	INDEX id_name_salary_idx(id, name, salary)
);

create table employees ( 
	e_id SERIAL primary key, 
	firstname varchar(50) not null, 
	lastname varchar(50) not null, 
	born date not null, 
	sex char(1) check(sex in ('ж','м')), 
	depart_name varchar(50),      /* отдел  */
	post_name varchar(50), /*должность*/
	e_room INT not null, 
	e_phone bigint not null, 
	FOREIGN KEY(e_room,e_phone) REFERENCES rooms(room, phone),
	FOREIGN KEY (depart_name) REFERENCES departs(d_name),
	INDEX e_id_firstname_lastname_idx(e_id, firstname, lastname)
); 

create table edu ( 
	u_id  SERIAL PRIMARY KEY, /*id сотрудника*/
	u_spec  enum('начальное', 'среднее', 'высшее', 'средне-специальное'), 
	u_year int not null,
	FOREIGN KEY (u_id) REFERENCES employees(e_id),
	INDEX u_id_idx(u_id)
); 

create table adrphones (	/*адреса и телефоны */
	a_id SERIAL PRIMARY KEY, /*  id сотрудника */
	a_adr  varchar(50), 
	a_phone BIGINT NULL,
	FOREIGN KEY (a_id) REFERENCES employees(e_id),
	INDEX a_id_a_adr_a_phone_idx(a_id, a_adr, a_phone)
);

create table clients (
	c_id  SERIAL  primary key, 
	c_company varchar(40)  not null, 
	c_adr  varchar(50)  not null, 
	c_person  varchar(50)  not null, 
	c_phone BIGINT,
	INDEX c_id_idx(c_id)
);
ALTER TABLE coursework.clients MODIFY COLUMN c_adr varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL;


create table projects ( 
	p_id  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	p_title  varchar(100)  not null, 
	p_depart BIGINT NULL,              /*  отдел  */
	p_company_id BIGINT UNSIGNED NOT NULL,   /*  заказчик */
	p_chief varchar(50) NOT NULL,
	p_begin  date not null, 
	p_end  date not null, 
	p_cost  BIGINT not null check(p_cost>0), 
	check (p_end>p_begin), 
	FOREIGN KEY (p_id) REFERENCES departs(d_id),
	FOREIGN KEY (p_company_id) REFERENCES clients(c_id),
	INDEX p_id_p_company_idx(p_id, p_company_id)
); 



create table stages (              /*  Этапы проекта */
	s_pro_id  SERIAL PRIMARY KEY, 
	s_num  INT not null,    /* Номер этапа */
	s_title  varchar(200)  not null, /* Название этапа */
	s_begin  date   not null, /* дата начала  */
	s_finish  date   not null,  /*  Дата окончания  */
	s_cost  numeric(10)  not null,  /*  стоимость этапа */
	check (s_cost>0), 
	check (s_finish>s_begin), 
	INDEX s_pro_id_idx(s_pro_id)
);


create table job ( 
	j_pro varchar(50),  /*  Проект  */
	j_emp_id SERIAL PRIMARY KEY, /*  Сотрудник  */
	j_role  ENUM ('исполнитель', 'консультант') not null,  
	check(j_role in ('исполнитель', 'консультант')),
	FOREIGN KEY (j_emp_id) REFERENCES employees (e_id)
);

INSERT INTO departs VALUES
(1, 'advertising department'),
(2, 'finance department'),
(3, 'IT'),
(4, 'legal department'),
(5, 'marketing department'),
(6, 'orders'),      /*отдел заказов*/
(7, 'accounting department')
;

INSERT INTO rooms (r_depart_id, room, phone) VALUES 
(1, 1001, 123322),
(2, 1005, 112211),
(3, 2002, 257895),
(4, 3002, 395874),
(5, 3025, 357831),
(6, 1125, 135554),
(7, 5217, 502145)
;

INSERT INTO posts (id, name, salary) VALUES
(1, 'marketing and advertising director', 150000.00),
(2, 'specialist of the advertising department', 120000.00),
(3, 'sales manager', 80000.00),
(4, 'project manager', 90000.00),
(5, 'specialist of financial department', 60000.00),
(6, 'finance director', 150000.00),
(7, 'assistant accountant', 40000.00),
(8, 'IT project manager', 90000.00),
(9, 'web developer', 120000.00),
(10, 'web programmer', 120000.00),
(11, 'web designer', 120000.00),
(12, 'solicitor ', 60000.00), /*юрисконсульт*/
(13, 'lawyer', 80000.00),
(14, 'head of legal department', 150000.00),
(15, 'junior specialist of the marketing department', 40000.00),
(16, 'marketer', 100000.00),
(17, 'senior internet marketer', 120000.00),
(18, 'head of marketing department', 150000.00),
(19, 'head of orders', 120000.00),
(20, 'specialist of orders', 70000.00),
(21, 'chief accauntant', 150000.00),
(22, 'accountant', 60000.00)
;

REPLACE INTO employees (e_id, firstname, lastname, born, sex, depart_name, post_name, e_room, e_phone) VALUES
(1, 'Robert','Miller', '1970-10-25', 'м', 'advertising department', 'marketing and advertising director', '1001', '123322'),
(2, 'Augustine','Bishop',  '1972-03-02', 'м', 'advertising department', 'specialist of the advertising department', '1001', '123322'),
(3, 'Christopher','Reed',  '1976-07-10', 'м', 'advertising department', 'specialist of the advertising department', '1001', '123322'),
(4, 'Maurice','Reynolds', '1981-05-31', 'м', 'finance department', 'specialist of financial department', '1005', '112211'),
(5, 'Jeremy', 'Moody', '1970-06-06', 'м', 'finance department', 'finance director', '1005', '112211'),
(6, 'Samuel','Walker',  '1979-02-25', 'м', 'finance department', 'specialist of financial department', '1005', '112211'),
(7, 'Sybil', 'Francis', '1984-10-15', 'ж', 'finance department', 'specialist of financial department', '1005', '112211'),
(8, 'Carol', 'Bryant', '1982-09-13', 'ж', 'finance department', 'specialist of financial department', '1005', '112211'),
(9, 'Bonnie', 'Carpenter', '1986-01-10', 'ж', 'IT', 'IT project manager', '2002', '257895'),
(10, 'Lindsay','Ferguson', '1983-04-22', 'ж', 'IT', 'web developer', '2002', '257895'),
(11, 'Bethanie', 'Woods', '1980-12-02', 'ж', 'IT', 'web developer', '2002', '257895'),
(12, 'Oliver', 'Powell', '1987-03-15', 'м', 'IT', 'web programmer', '2002', '257895'),
(13, 'Jared', 'Gordon', '1990-01-20', 'м', 'IT', 'web programmer', '2002', '257895'),
(14, 'Lenard','Curtis', '1984-08-20', 'м', 'IT', 'web designer', '2002', '257895'),
(15, 'Jeffrey', 'Harmon', '1970-12-02', 'м', 'IT', 'web developer', '2002', '257895'),
(16, 'Rosa', 'Thompson', '1978-03-12', 'ж', 'legal department', 'head of legal department', 3002, 395874),
(17, 'Emma', 'Bennett', '1983-07-31', 'ж', 'legal department', 'lawyer', 3002, 395874),
(18, 'Christine', 'Murphy', '1988-05-12', 'ж', 'marketing department', 'head of marketing department', 3025, 357831),
(19, 'Irma', 'Evans', '1990-03-15', 'ж', 'marketing department', 'senior internet marketer', 3025, 357831),
(20, 'Irene', 'Martin', '1989-04-01', 'ж', 'marketing department', 'marketer', 3025, 357831), 
(21, 'Adele', 'Lynch', '1993-05-07', 'ж', 'orders', 'specialist of orders', '1125','135554'),
(22, 'Marianna', 'Garrett', '1986-05-15', 'ж', 'orders', 'specialist of orders', '1125', '135554'),
(23, 'Betty', 'Davis', '1970-02-22', 'ж', 'orders', 'head of orders', '1125', '135554'),
(24, 'Bonnie', 'Hicks', '1985-11-11', 'м', 'accounting department', 'accauntant', '5217', '502145'),
(25, 'Thomas', 'Warren', '1974-04-21', 'м', 'accounting department', 'accauntant', '5217', '502145'),
(26, 'Nicholas', 'Elliott', '1981-08-18', 'м', 'accounting department', 'chief accauntant', '5217', '502145'),
(27, 'Jeffery', 'Bradford', '1986-09-29', 'м', 'accounting department', 'accauntant', '5217', '502145'),
(28, 'Nicholas', 'Miller', '1990-10-24', 'м', 'accounting department', 'assistant accauntant', '5217', '502145')
;

REPLACE INTO edu (u_id, u_spec, u_year) VALUES  /* 'начальное', 'среднее', 'высшее', 'средне-специальное' */
(1, 'высшее', 1993 ),
(2, 'высшее', 1995),
(2, 'средне-специальное', 1996),
(4, 'средне-специальное', 2002),
(5, 'высшее', 1993),
(6, 'высшее', 2001),
(7, 'высшее', 2007),
(8, 'высшее', 2005),
(9, 'высшее', 2009),
(10, 'высшее', 2006),
(11, 'высшее', 2003),
(12, 'высшее', 2010),
(13, 'высшее', 2013),
(14, 'высшее', 2007),
(15, 'высшее', 1993),
(16, 'высшее', 2000),
(17, 'высшее', 2006),
(18, 'высшее', 2010),
(19, 'высшее', 2009),
(20, 'средне-специальное', 2006),
(21, 'среднее', 2000),
(22, 'средне-специальное', 2006),
(23, 'высшее', 1992),
(24, 'высшее', 2007),
(25, 'средне-специальное', 1994),
(26, 'высшее', 2003),
(27, 'высшее', 2008),
(28, 'среднее', 2007)
;


REPLACE INTO adrphones (a_id, a_adr, a_phone) VALUES 
(1, NULL, 45621457),
(2, NULL, 12346547),
(3, NULL, 79864204),
(4, NULL, 40325411),
(5, NULL, 89654123),
(6, NULL, 15412456),
(7, NULL, 46545631),
(8, NULL, 45789615),
(9, NULL, 96541251),
(10, NULL, 6541258),
(11, NULL, 3451546),
(12, NULL, 7896545),
(13, NULL, 2435645),
(14, NULL, 6548975),
(15, NULL, 5487458),
(16, NULL, 9874563),
(17, NULL, 1012312),
(18, NULL, 2454544),
(19, NULL, 4657982),
(20, NULL, 0154252),
(21, NULL, 2578963),
(22, NULL, 3216547),
(23, NULL, 6547125),
(24, NULL, 9765214),
(25, NULL, 3654225),
(26, NULL, 8745636),
(27, NULL, 2859630),
(28, NULL, 5554446)
;


INSERT INTO clients (c_id, c_company, c_adr, c_person, c_phone) VALUES
(1, 'Citrus', NULL, 'Steven Horton', 1649765),
(2, 'Metromarket', NULL, 'GregoryRiley', 6654458),
(3, 'Atlantis', NULL, 'Ann Black', 4687545),
(4, 'San-room', NULL, 'Jade Mathews', 1124693),
(5, 'Aqualink', NULL, 'Ronald Flynn', 3586521),
(6, 'Perfecto', NULL, 'Paul Houston', 9785520),
(7, 'HydroZone', NULL, 'Meghan Martin', 6445219),
(8, 'Miramix', NULL, 'Gordon Brooks', 5554141),
(9, 'Oasis', NULL, 'Oliver Shaw', 2587414),
(10, 'Trial Bussines Tehnologies', NULL,'Harvey Ramsey',  9856613)
;

INSERT INTO projects (p_id, p_title, p_depart, p_company_id, p_chief, p_begin, p_end, p_cost) VALUES
(3, 'E-commerce shop', 3, 6, 'Lindsay Ferguson', '2019-02-10', '2020-05-25', 2522140),
(3, 'On-line school', 3, 9, 'Bethanie Woods', '2019-05-26', '2020-01-30', 2500600),
(7, 'Accounting outsourcing', 7, 1, 'Jeffery Bradford', '2015-01-01', '2025-12-31', 1100780),
(7, 'Tax advice', 7, 5, 'Thomas Warren', '2018-10-13', '2021-12-31', 5000000),
(1, 'Contextual advertising', 1, 2, 'Augustine Bishop', '2019-05-02', '2019-11-11', 700000),
(1, 'Web analytics', 1, 3, 'Christopher Reed', '2020-04-01', '2020-06-30', 962500),
(5, 'Marketing research', 5, 10, 'Irma Evans', '2020-06-02', '2021-03-22', 778410),
(3, 'Site development', 3, 8, 'Oliver Powell', '2019-12-05', '2020-02-22', 1250000),
(2, 'Broker services', 2, 3, 'Samuel Walker', '2018-12-10', '2021-01-01', 845200),
(2, 'Trust management', 2, 4, 'Carol Bryant', '2019-06-12', '2022-01-10', 2125100)
;


INSERT INTO stages (s_pro_id, s_num, s_title, s_begin, s_finish, s_cost) VALUES
(1, 3, 'in the operation', '2019-12-20', '2020-04-30', 1255444),
(2, 4, 'finished', '2020-01-25', '2020-01-30',50000),
(3, 3, 'in the operation', '2015-08-30', '2025-12-10', 800000),
(4, 3, 'in the operation', '2019-01-01', '2021-12-01', 4890100),
(5, 4, 'finished', '2019-11-01', '2019-11-11', 10000),
(6, 2, 'payment', '2020-04-03', '2020-04-10', 100),
(7, 1, 'agreement', '2020-04-02', '2020-04-30', 120000),
(8, 4, 'finished', '2020-01-25', '2020-02-22', 54200),
(9, 3, 'in the operation', '2019-02-01', '2020-12-01', 790500),
(10, 1, 'agreement', '2019-06-12', '2020-05-01', 154000)
;

REPLACE INTO job (j_pro, j_emp_id, j_role) VALUES
('E-commerce shop', 10, 'исполнитель'),
('On-line school', 11, 'исполнитель'),
('Tax advice', 27, 'исполнитель'),
('Accounting outsourcing', 25, 'консультант'),
('Contextual advertising', 2, 'исполнитель'),
('Web analytics', 3, 'консультант'),
('Marketing research', 19, 'консультант'),
('E-commerce shop', 12, 'исполнитель'),
('Broker services', 6, 'консультант'),
('Trust management', 8, 'исполнитель')
;

-- Задание №6 Скрипты характерных выборок (вкл. группировки, Join'ы, вложенные таблицы)
SELECT avg(salary) AS avg_salary FROM posts;

SELECT e_id, firstname, lastname, substring(born, 1,3) FROM employees; 
SELECT * FROM employees WHERE sex ='м';
SELECT *FROM employees WHERE sex='ж';
SELECT * FROM employees ORDER BY born DESC;
SELECT count(*) FROM projects;

SELECT
  r_depart_id, room, phone
 FROM
  rooms r2 
WHERE
  r_depart_id = (SELECT d_id FROM departs WHERE d_name = 'finance department');
 
 
 SELECT *FROM departs JOIN rooms;


SELECT 
 	e_id,
 	e_room,
 	e_phone
 FROM 
 	employees AS e
 LEFT JOIN 
 	rooms AS r
 ON 
 	e_room = r.room;
 	
 
 SELECT 
 	p_id,
 	p_title,
 	p_depart,
 	p_company_id
 FROM 
 	projects  
 RIGHT JOIN 
 	 clients 
 ON 
 	p_depart = c_company;

 
 -- Задание 7. Представления (минимум 2).

CREATE VIEW info_view 
AS SELECT * FROM  posts 
ORDER BY salary DESC; 
SELECT * FROM info_view;
 

CREATE VIEW  info_view_1
AS SELECT *
FROM rooms, departs
WHERE rooms.r_depart_id = d_id
;
SELECT *FROM info_view_1;


-- Задание №8. Хранимые процедуры / триггеры.

DELIMITER //
DROP PROCEDURE IF EXISTS insert_clients;
CREATE PROCEDURE insert_clients (c_id bigint, c_company varchar(40), c_adr varchar(50), c_person varchar (50), c_phone bigint)
	BEGIN
		INSERT INTO clients (c_id, c_company, c_adr, c_person, c_phone)
		value (c_id, c_company, c_adr, c_person, c_phone);
	END //

delimiter ;

CALL insert_clients(11, 'MMM', NULL, 'James Bond', 1548945);
-- В Бивере ошибка, а в консоли работает.


