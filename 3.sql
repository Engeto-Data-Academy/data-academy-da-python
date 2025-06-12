select name, district_code 
from healthcare_provider
where district_code in ('CZ0201', 'CZ0202')
order by district_code;

select *
from czechia_district
-- where name = 'Beroun' or name = 'Benešov'
where name in ('Beroun', 'Benešov');


-- Úkol: K tabulce t_{jméno}_{příjmení}_resume přidejte dva sloupce: 
-- institution a role, které budou typu VARCHAR(255)
alter table t_dominik_smida_resume add column institution varchar(255);
alter table t_dominik_smida_resume alter column job type varchar(1000);
alter table t_dominik_smida_resume rename column job to prace;

-- Úkol: Pomocí vnořeného SELECT vypište kódy krajů pro Jihomoravský a Středočeský kraj z tabulky czechia_region. 
-- Ty použijte pro vypsání ID, jména a kraje jen těch vyhovujících poskytovatelů z tabulky healthcare_provider
select provider_id, name, region_code
from healthcare_provider
where region_code in (
	select code
	from czechia_region
	where name in ('Jihomoravský kraj', 'Středočeský kraj')
);

-- Úkol: Vypište název a typ poskytovatele a v novém sloupci odlište, 
-- zda jeho typ je Lékárna nebo Výdejna zdravotnických prostředků.
select 
	name, 
	provider_type,
	case
		when provider_type = 'Lékárna' then 'lékárna'
		when provider_type = 'Výdejna zdravotnických prostředků' then 'VZP'
		else 'Něco jinýho'
	end as typ_poskytovatele
from healthcare_provider hp
limit 20;


-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.

select max(value) as maximalni_prumerna_mzda
from czechia_payroll
where value_type_code = 5958;

select 
	avg(value) as prumerna_cenu
from czechia_price
where category_code = 112704
and date_part('year', date_from) = 2015;


SELECT SQRT(-16);

SELECT 10/0;

SELECT FLOOR(1.56);
SELECT FLOOR(-1.56);

SELECT CEIL(1.56);
SELECT CEIL(-1.56);

SELECT ROUND(1.56, 2);
SELECT ROUND(-1.56);

create table zamestnanec (
	id int,
	krestni_jmeno varchar(20),
	prijmeni varchar(20)
)

insert into zamestnanec values (1, 'Dominik', 'Šmída'), (2, 'Dominik', 'Osička')
