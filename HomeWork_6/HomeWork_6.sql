USE vk;

-- 1) Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
 
SELECT
  from_user_id,
  COUNT(*) AS send 
FROM 
  messages 
WHERE 
  to_user_id=1
GROUP BY from_user_id
ORDER BY send DESC;

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT 
  COUNT(*) AS 'Likes' 
FROM 
  profiles 
ORDER BY birth_date LIMIT 10;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT 
    gender, COUNT(*) AS 'Кол-во'
FROM
    profiles
GROUP BY gender;

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT 
  user_id, 
  COUNT(id) 
FROM
  entries 
GROUP BY user_id 
ORDER BY COUNT(id) DESC LIMIT 10 

