create table doctors (
	id serial primary key,
	first_name varchar(100) not null,
	last_name varchar(100) not null
);

create table diagnoses (
	code varchar(6) primary key,
	name varchar(200) not null,
	description text
);

create table departments (
	id serial primary key,
	name varchar(200) not null,
	bed_count integer not null default 0
);

create table measurement_types (
	id serial primary key,
	name varchar(200) not null,
	unit varchar(20)
);

create type sex_type as enum ('M', 'F');

create table patients (
	id serial primary key,
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	birthday date not null,
	sex sex_type not null
);

create table measurements (
	id serial primary key,
	measurement_type_id integer not null references measurement_types(id),
	value integer not null,
	created_at timestamp default current_timestamp,
	patient_id integer not null references patients(id)
);

create table examinations (
	id serial primary key,
	created_at timestamp default current_timestamp,
	patient_id integer not null references patients(id),
	department_id integer not null references departments(id),
	diagnose_id varchar(6) references diagnoses(code),
	doctor_id integer not null references doctors(id)
);

create table doctors_departments (
	doctor_id integer references doctors(id),
	department_id integer references departments(id),
	primary key (doctor_id, department_id)
);

commit;


-- spojit tabulky czechia_price a czechia_payroll
-- chceme za obdobi 2013-2018 spocitat prumerne ceny a prumerne platy
-- a spojit do jedne tabulky

----- rok | prumer_mezd | prumer_potravin

with price_average as (
	select extract(year from date_from) as price_year, round(avg(value)::numeric, 2) as price_value from czechia_price group by extract(year from date_from)
),
pay_average as (
	select round(avg(value), 2) payroll_value, payroll_year from czechia_payroll where value_type_code = 5958 group by payroll_year
)

select * from price_average pra join pay_average pa on pra.price_year = pa.payroll_year;
