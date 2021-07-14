
-- Используем индетификатор схемы при обращении к таблице
SELECT * FROM vk.communities;

-- Вывести список таблиц в текущей схеме
SHOW TABLES;

-- Вынести поля таблицы и её свойства
DESCRIBE profiles;

-- Внутренняя схема с метаданными. Предусмотрена стандартом SQL. Ссылка на руководство: https://dev.mysql.com/doc/refman/8.0/en/information-schema.html
USE INFORMATION_SCHEMA;
SHOW TABLES;
DESCRIBE TABLES;

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'INFORMATION_SCHEMA'; -- INFORMATION_SCHEMA содержит описание себя собой
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'vk';
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'INFORMATION_SCHEMA' AND TABLE_NAME LIKE '%CONSTR%'; -- % - любое количество любых знаков, _ - один любой знак
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'vk';
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'vk' AND TABLE_NAME = 'profiles'; 
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'vk' AND TABLE_NAME = 'profiles'; 
DESCRIBE profiles;

/*C - CREATE
R - READ
U - UPDATE
D - DELETE*/

SELECT * FROM vk.users LIMIT 100;

SELECT email FROM users WHERE email LIKE '%org';
SELECT email FROM users WHERE REGEXP_LIKE(email, '^[A-Za-z_0-9]{6}@example\.org$');
SELECT phone FROM users WHERE REGEXP_LIKE(phone, '^\+7[0-9]{10}$');
SELECT REGEXP_LIKE('+79991234567', '^\\+7[0-9]{10}$');

-- Создаем собственное правило
ALTER TABLE users ADD CONSTRAINT phone_check CHECK (REGEXP_LIKE(phone, '^\\+7[0-9]{10}$'));

UPDATE users SET phone = CONCAT('+7', 9000000000 + FLOOR(RAND() * 999999999));
SELECT CONCAT('+7', 9000000000 + FLOOR(RAND() * 999999999));

SELECT * FROM vk.profiles LIMIT 100;
ALTER TABLE profiles DROP COLUMN gernder;
ALTER TABLE profiles ADD COLUMN gender ENUM('M', 'F');


-- Варианты заполнения атрибута 'gender'


SELECT 
	CASE
		WHEN RAND() > 0.5 THEN 'M'
        ELSE 'F'
	END gender;
   
-- 1
UPDATE profiles SET gender = (
SELECT CASE WHEN RAND() > 0.5 THEN 'M' ELSE 'F' END 
);

-- 2
CREATE TEMPORARY TABLE temp_gender (
	`value` CHAR(1)
);

INSERT INTO temp_gender (`value`) VALUE ('M');
INSERT INTO temp_gender (`value`) VALUE ('F');
SELECT * FROM temp_gender;

SELECT `value` FROM temp_gender ORDER BY RAND() LIMIT 1;


