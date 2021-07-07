/*
Список сущьностей
1. Профиль
2. пост
3. друзья
4. сообщества
5. сообщения
6. медиа
*/


DROP DATABASE vk;
CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS users;
-- Таблица пользователей
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
	email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
    phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);

DROP TABLE IF EXISTS profiles;
-- Таблица профилей
CREATE TABLE profiles (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    user_id INT UNSIGNED UNIQUE NOT NULL COMMENT "Ссылка на пользователя", 
	first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
	last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
    birth_date DATE COMMENT "Дата рождения",    
    country VARCHAR(100) COMMENT "Страна проживания",
    city VARCHAR(100) COMMENT "Город проживания",
    `status` ENUM('ONLINE', 'OFFLINE', 'INACTIVE') COMMENT "Текущий статус",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    -- ,PRIMARY KEY (`id`) -- вариант объявления PK
);

-- ALTER TABLE profiles ADD CONSTRAINT PRIMARY KEY (id); -- вариант объявления PK

-- Связываем поле "user_id" таблицы "profiles" с полем "id" таблицы "users" c помощью внешнего ключа
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);

DROP TABLE IF EXISTS messages;
-- Таблица сообщений
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
	to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
    message_header VARCHAR(255) COMMENT "Заголовок сообщения",
    message_body TEXT NOT NULL COMMENT "Текст сообщения",
    is_delivered BOOLEAN NOT NULL COMMENT "Признак доставки",
    was_edited BOOLEAN NOT NULL COMMENT "Признак правки заголовка или тела сообщения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
--     ,FOREIGN KEY (from_user_id) REFERENCES users(id), -- вариант объявления внешни ключей
--     FOREIGN KEY (to_user_id) REFERENCES users(id)
);

ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);

DROP TABLE IF EXISTS friendship;
-- Таблица дружбы
CREATE TABLE friendship (
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
    friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
    friendship_status ENUM('FRIENDSHIP', 'FOLLOWING', 'BLOCKED') COMMENT "Cтатус (текущее состояние) отношений",
	requested_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время отправления приглашения дружить",
	confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
	PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ"
);

ALTER TABLE friendship ADD CONSTRAINT fk_friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

-- Таблица групп
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

ALTER TABLE communities_users ADD CONSTRAINT fk_cu_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

-- Таблица медиафайлов
CREATE TABLE medias (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название медиа",
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора",
    media_type ENUM('VIDEO', 'PICTURE', 'AUDIO') COMMENT "Тип медиа",
    media_url  VARCHAR(255) COMMENT 'Адрес расположения файла',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки"  
) COMMENT "Медиафайлы"; 

ALTER TABLE medias ADD CONSTRAINT fk_medias_user_id FOREIGN KEY (user_id) REFERENCES users(id);

 -- Таблица постов
CREATE TABLE posts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автора",
    post_text TEXT COMMENT "Текст поста",
    media_id INT DEFAULT 0 COMMENT "Вложенное медиа, если 0, то контента нет",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Посты";

ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_posts_media_id FOREIGN KEY (media_id) REFERENCES medias(id);

 -- Таблица лайков
CREATE TABLE likes (
    from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя лайкнувшего пост",
    post_id INT UNSIGNED COMMENT "Ссылка на пост",
    media_id INT UNSIGNED COMMENT "Ссылка на медиа",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    CONSTRAINT post_or_media_chk
	CHECK (post_id IS NOT NULL OR media_id IS NOT NULL),
     -- Проверяем к чему относится лайк, медиа или посту пользователя
	PRIMARY KEY (post_id, media_id) COMMENT "Составной первичный ключ"
);

ALTER TABLE likes ADD CONSTRAINT fk_likes_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE likes ADD CONSTRAINT fk_likes_post_id FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE likes ADD CONSTRAINT fk_likes_media_id FOREIGN KEY (media_id) REFERENCES medias(id);