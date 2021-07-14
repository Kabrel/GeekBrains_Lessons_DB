USE vk;

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
UPDATE users
    SET created_at = NULL;

UPDATE users
    SET updated_at = NULL;

UPDATE users
    SET created_at = NOW() WHERE created_at is NULL;

UPDATE users
    SET updated_at = NOW() WHERE updated_at is NULL;
    
-- 2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения
-- в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
-- 
-- Предположим, что тип столбцов created_at и updated_at - VARCHAR(256), хотя в предыдущем уроке тип был указан верно - DATETIME,
-- c использованием DEFAULT CURRENT_TIMESTAMP и DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP.
-- Поэтому сначала приводим тип столбцов в соотвествии с требованием дз.
ALTER TABLE users 
    CHANGE COLUMN `created_at` `created_at` VARCHAR(256) NULL,
    CHANGE COLUMN `updated_at` `updated_at` VARCHAR(256) NULL;

describe users;
SELECT created_at from users;

ALTER TABLE users 
    CHANGE COLUMN `created_at` `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHANGE COLUMN `updated_at` `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

describe users;
SELECT created_at from users;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
-- если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
-- чтобы они выводились в порядке увеличения значения value. Нулевые запасы должны выводиться в конце, после всех записей.
create table storehouses_products (
	id SERIAL PRIMARY KEY,
    storehouse_id INT unsigned,
    product_id INT unsigned,
    `value` INT unsigned COMMENT 'Запас товарный позиции на складке',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
    storehouses_products (storehouse_id, product_id, value)
VALUES
    (1, 1, 15),
    (1, 3, 0),
    (1, 5, 10),
    (1, 7, 5),
    (1, 8, 0);

SELECT 
    value
FROM
    storehouses_products ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;
    