DROP DATABASE IF EXISTS coursework;
CREATE DATABASE coursework;
USE coursework;

CREATE TABLE departs(
	d_id SERIAL, 
	d_name varchar(100) NOT NULL, 
	PRIMARY KEY (d_id, d_name)
);
ALTER TABLE departs ADD INDEX d_name_idx(d_name);

CREATE TABLE rooms(
	r_depart_id SERIAL, 
	room  numeric(4) not null,
	phone bigint, 
	unique(room, phone),
	FOREIGN KEY (r_depart_id) REFERENCES departs(d_id),
	PRIMARY KEY(room, phone)
);

create table posts ( 
	id SERIAL,			/*таблица должности, post - должность, salary - оклад*/
	name varchar(100), 
	salary numeric(6,2)  not null check(salary>=4500),
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
	post_name varchar(30), /*должность*/
	e_room INT not null, 
	e_phone bigint not null, 
	FOREIGN KEY(e_room,e_phone) REFERENCES rooms(room, phone),
	FOREIGN KEY (depart_name) REFERENCES departs(d_name),
	FOREIGN KEY (e_id) REFERENCES posts(id),
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
	a_phone  varchar(30),
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

create table projects ( 
	p_id  SERIAL PRIMARY KEY, 
	p_title  varchar(100)  not null, 
	p_depart varchar (50),              /*  отдел  */
	p_company_id BIGINT UNSIGNED NOT NULL UNIQUE,   /*  заказчик */
	p_chief  numeric(4)  references employees, 
	p_begin  date not null, 
	p_end  date not null, 
	p_finish  date, 
	p_cost  numeric(10) not null check(p_cost>0), 
	check (p_end>p_begin), 
	check (p_finish is null or p_finish>p_begin),
	FOREIGN KEY (p_id) REFERENCES departs(d_id),
	FOREIGN KEY (p_company_id) REFERENCES clients(c_id),
	INDEX p_id_p_company_idx(p_id, p_company_id)
); 

create table stages (              /*  Этапы проекта */
	s_pro_id  SERIAL PRIMARY KEY, 
	s_num  numeric(2)  not null,    /* Номер этапа */
	s_title  varchar(200)  not null, /* Название этапа */
	s_begin  date   not null, /* дата начала  */
	s_finish  date   not null,  /*  Дата окончания  */
	s_cost  numeric(10)  not null,  /*  стоимость этапа */
	check (s_cost>0), 
	check (s_finish>s_begin), 
	FOREIGN KEY (s_pro_id) REFERENCES projects(p_id)
);

create table job ( 
	j_pro_id SERIAL PRIMARY KEY,  /*  Проект  */
	j_emp_id BIGINT UNSIGNED NOT NULL UNIQUE, /*  Сотрудник  */
	j_role  ENUM ('исполнитель', 'консультант') not null,  
	check(j_role in ('исполнитель', 'консультант')),
	FOREIGN KEY (j_pro_id) REFERENCES projects (p_id),
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
(22, 'accuntant', 60000.00),
(23, 'accountant', 60000.00)
;

INSERT INTO employees (e_id, firstname, lastname, born, sex, depart_name, post_name, e_room, e_phone) VALUES
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
(12,  'Oliver', 'Powell', '1987-03-15', 'м', 'IT', 'web programmer', '2002', '257895'),
(13, 'Jared', 'Gordon', '1990-01-20', 'м', 'IT', 'web programmer', '2002', '257895'),
(14, 'Lenard','Curtis', '1984-08-20', 'м', 'IT', '2002', 'web designer', '2002', '257895'),
(15, 'Jeffrey', 'Harmon', '1970-12-02', 'м', 'IT', 'web developer', '2002', '257895'),
(16, 'Rosa', 'Thompson', '1978-03-12', 'ж' 'legal department', 'head of legal department', '3002', '395874'),
(17, 'Emma','Bennett', '1983-07-31', 'ж' 'legal department', 'lawyer', '3002', '395874'),
(18,  'Christine', 'Murphy', '1988-05-12', 'ж', 'marketing department', 'head of marketing department', '3025', '357831'),
(19, 'Irma', 'Evans', '1990-03-15', 'ж', 'marketing department', 'senior internet marketer', '3025', '357831'),
(20, 'Irene','Martin', '1989-04-01', 'ж', 'marketing department', 'marketer', '3025', '357831'),
(21, 'Adele', 'Lynch', '1993-05-07', 'ж', 'orders', '1125', 'specialist of orders', '135554'),
(22, 'Marianna', 'Garrett', '1986-05-15', 'ж', 'orders', 'specialist of orders', '1125', '135554'),
(23, 'Betty', 'Davis', '1970-02-22', 'ж', 'orders', '1125', 'head of orders', '135554'),
(24, 'Hicks', '1985-11-11', 'м', 'accounting department', '5217', '502145'),
(25, 'Thomas', 'Warren', 'Toby', '1974-04-21', 'м', 'accounting department', '5217', '502145'),
(26, 'Nicholas', 'Elliott', '1981-08-18', 'accounting department', 'chief accauntant', '5217', '502145'),
(27, 'Jeffery', 'Bradford', '1986-09-29', 'accounting department', 'accuntant', '5217', '502145'),
(28, 'Nicholas', 'Miller', '1990-10-24', 'accounting department', 'accuntant', '5217', '502145')
;





























