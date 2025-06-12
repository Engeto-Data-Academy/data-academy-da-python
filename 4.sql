SELECT *
FROM czechia_price
INNER JOIN czechia_price_category ON czechia_price.category_code = czechia_price_category.code; 

SELECT 
	cp.id,
	cpc.name AS produkt,
	cp.value AS cena,
	cr.name AS nazev_kraje
FROM czechia_price AS cp 
RIGHT JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr ON cr.code = cp.region_code;

SELECT *
FROM czechia_payroll AS cp 
LEFT JOIN czechia_payroll_calculation AS cpc ON cpc.code = cp.calculation_code
LEFT JOIN czechia_payroll_industry_branch AS cpib ON cpib.code = cp.industry_branch_code 
LEFT JOIN czechia_payroll_unit AS cpu ON cpu.code = cp.unit_code 
LEFT JOIN czechia_payroll_value_type AS cpvt ON cpvt.code = cp.value_type_code;

-- Úkol 4: 
-- Vytvořte průnik cen z krajů Hl. město Praha a Jihomoravský kraj.
-- Stejný příklad jako o něco výše, jen INTERSECT místo UNION

SELECT 
	category_code, 
	value
FROM czechia_price
WHERE region_code = 'CZ064'
INTERSECT
SELECT 
	category_code, 
	value
FROM czechia_price
WHERE region_code = 'CZ010';

-- Úkol 6: 
-- Vyberte z tabulky czechia_price takové záznamy, které jsou v Jihomoravském kraji jiné na sloupcích 
-- category_code a value než v Praze.

SELECT 
	category_code, 
	value
FROM czechia_price
WHERE region_code = 'CZ064'
EXCEPT 
SELECT 
	category_code, 
	value
FROM czechia_price
WHERE region_code = 'CZ010';

-- CTE (Common Table Expression)
-- ---------------------------------------------

-- CTE tabulka pro průměrné ceny produktů pro každý kraj zvlášť

WITH prumerne_ceny AS (
	SELECT 
		region_code,
		avg (value) AS prumerna_cena
	FROM czechia_price AS cp 
	GROUP BY cp.region_code
)
SELECT *
FROM prumerne_ceny; 
