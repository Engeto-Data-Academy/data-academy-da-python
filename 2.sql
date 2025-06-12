/*
 * COUNT
 */

-- Úkol 1: Spočítejte počet řádků v tabulce czechia_price.
SELECT count(*)
FROM czechia_price;

SELECT count(1)
FROM czechia_price;

-- Úkol 2: Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce count().
SELECT *
FROM czechia_payroll;

SELECT count(id)
FROM czechia_payroll;
SELECT count(1)
FROM czechia_payroll;

SELECT count(value)
FROM czechia_payroll;

-- Úkol 3: Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?
SELECT
	count(1)
FROM czechia_payroll
WHERE
	value_type_code = 316
	AND value IS NOT NULL;

-- Úkol 4: Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.
SELECT
	category_code,
	count(1)
FROM czechia_price
GROUP BY category_code;

SELECT
	category_code,
	count(value)
FROM czechia_price
GROUP BY category_code;

-- Úkol 5: Rozšiřte předchozí dotaz o dodatečné rozdělení dle let měření.
SELECT *
FROM czechia_price;

SELECT *
FROM czechia_price
WHERE date_part('year', date_from) <> date_part('year', date_to); 

SELECT
	category_code,
	date_part('year', date_from) year_of_entry,
	count(1)
FROM czechia_price
GROUP BY
	category_code,
	date_part('year', date_from)
ORDER BY
	year_of_entry,
	category_code;

/*
 * SUM
 */

-- Úkol 1: Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.
SELECT sum(value)
FROM czechia_payroll
WHERE value_type_code = 5958;

-- Úkol 2: Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.
SELECT
	category_code,
	sum(value)
FROM czechia_price
WHERE region_code = 'CZ064'
GROUP BY category_code;

-- Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie, u kterých měření probíhalo od (date_from) 15. 1. 2018.
SELECT
	sum(value)
FROM czechia_price
WHERE date_from::date >= '2018-01-15';


-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.
SELECT max(value)
FROM czechia_payroll
WHERE czechia_payroll.value_type_code = 5958;

-- Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin její minimum v letech 2015 až 2017.
-- date_part('year', date_from)
SELECT
	category_code,
	min(value)
FROM czechia_price cp
WHERE
	date_part('year', date_from) BETWEEN 2015 AND 2017
GROUP BY
	category_code;

-- Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.
SELECT *
FROM czechia_payroll_industry_branch
WHERE code = 
(
	SELECT industry_branch_code
	FROM czechia_payroll
	WHERE value = 
	(
		SELECT max(value)
		FROM czechia_payroll
		WHERE value_type_code = 5958
	)
);

-- Úkol 4: Pro každou kategorii potravin určete její minimum, maximum a vytvořte nový sloupec s názvem difference, ve kterém budou hodnoty
-- "rozdíl do 10 Kč", "rozdíl do 40 Kč" a "rozdíl nad 40 Kč" na základě rozdílu minima a maxima. Podle tohoto rozdílu data seřaďte.

SELECT 
	category_code,
	min(value),
	max(value),
	max(value) - min(value) diff,
	CASE
		WHEN max(value) - min(value) < 10 THEN 'rozdíl do 10 Kč'
		WHEN max(value) - min(value) < 40 THEN 'rozdíl do 40 Kč'
		ELSE 'rozdíl nad 40 Kč'
	END difference
FROM czechia_price 
GROUP BY category_code
ORDER BY diff;

/*
 * HAVING
 */

-- Úkol 1: Vypište z tabulky covid19_basic_differences země s více než 5 000 000 potvrzenými případy COVID-19 (data jsou za rok 2020 a část roku 2021).
-- nevalidni dotaz
SELECT
	country,
	sum(confirmed)
FROM covid19_basic_differences
WHERE sum(confirmed) > 5_000_000
GROUP BY country;

SELECT
	country,
	sum(confirmed)
FROM covid19_basic_differences
GROUP BY country
HAVING sum(confirmed) > 5_000_000;

-- Úkol 2: Vyberte z tabulky economies roky a oblasti s populací nad 4 miliardy.
SELECT
	country,
	year,
	sum(population) AS overall_population
FROM economies 
GROUP BY country, YEAR
HAVING sum(population) > 4*10^9
ORDER BY overall_population;

/*
 * Dalsi operace
 */

-- Úkol 1: Vyzkoušejte si následující dotazy. Co vypisují a proč?
SELECT SQRT(-16);
SELECT sqrt(16);
SELECT POWER(4, 3);
SELECT 10/0;

SELECT FLOOR(1.56);
SELECT FLOOR(-1.56);

SELECT CEIL(1.56);
SELECT CEIL(-1.56);

SELECT ROUND(1.56);
SELECT ROUND(-1.56);

-- Úkol 2: Vypočítejte průměrné ceny kategorií potravin bez použití funkce AVG() s přesností na dvě desetinná místa.
SELECT
    category_code,
    ROUND(AVG(value)::numeric, 2),
    ROUND((SUM(value) / COUNT(value))::numeric, 2) AS average_price
FROM czechia_price
GROUP BY category_code
ORDER BY average_price;

-- Úkol 3: Jaké datové typy budou mít hodnoty v následujících dotazech?
SELECT 1;
SELECT 1.0;
SELECT 1 + 1;
SELECT 1 + 1.0;
SELECT 1 + '1';
SELECT 1 + 'a';
SELECT 'a' + '1';
SELECT 1 + '12tatata';

-- Úkol 5: Vyzkoušejte si operátor modulo (zbytek po celočíselném dělení).
SELECT 5 % 2;
SELECT 14 % 5;
SELECT 15 % 5;

SELECT 123456789874 % 11;
SELECT 123456759874 % 11;
