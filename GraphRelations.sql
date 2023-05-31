-- Создание базы данных GraphRelations
USE master;
DROP DATABASE IF EXISTS GraphRelations;
CREATE DATABASE GraphRelations;
USE GraphRelations;

-- Создание графа
CREATE TABLE Country
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE;

INSERT INTO Country (id, name)
VALUES (1, N'Россия'),
	   (2, N'США'),
	   (3, N'Канада'),
	   (4, N'Германия'),
	   (5, N'Франция'),
	   (6, N'Испания'),
	   (7, N'Беларусь'),
	   (8, N'Исландия'),
	   (9, N'Бразилия'),
	   (10, N'Аргентина');

CREATE TABLE City
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE;

INSERT INTO City (id, name)
VALUES (1, N'Москва'),
	   (2, N'Санкт-Петербург'),
	   (3, N'Нью-Йорк'),
	   (4, N'Лос-Анджелес'),
	   (5, N'Торонто'),
	   (6, N'Берлин'),
	   (7, N'Париж'),
	   (8, N'Мадрид'),
	   (9, N'Минск'),
	   (10, N'Рекъявик'),
	   (11, N'Рио-де-Жанейру'),
	   (12, N'Сан-Паулу'),
	   (13, N'Буэнос-Айрес')
;

CREATE TABLE Person
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE;

INSERT INTO Person (id, name)
VALUES (1, N'Ivan'),
	   (2, N'Alex'),
	   (3, N'Marie'),
	   (4, N'Katherina'),
	   (5, N'John'),
	   (6, N'Sarah'),
	   (7, N'Michael'),
	   (8, N'Emily'),
	   (9, N'Kevin'),
	   (10, N'Sam'),
	   (11, N'Kataleya');


-- Создание ребер
CREATE TABLE LivesIn AS EDGE;
ALTER TABLE LivesIn
ADD CONSTRAINT EC_LivesIn CONNECTION (Person TO City);

INSERT INTO LivesIn ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Person WHERE ID = 1), (SELECT $node_id FROM City WHERE ID = 1)),
((SELECT $node_id FROM Person WHERE ID = 2), (SELECT $node_id FROM City WHERE ID = 2)),
((SELECT $node_id FROM Person WHERE ID = 3), (SELECT $node_id FROM City WHERE ID = 9)),
((SELECT $node_id FROM Person WHERE ID = 4), (SELECT $node_id FROM City WHERE ID = 6)),
((SELECT $node_id FROM Person WHERE ID = 5), (SELECT $node_id FROM City WHERE ID = 3)),
((SELECT $node_id FROM Person WHERE ID = 6), (SELECT $node_id FROM City WHERE ID = 10)),
((SELECT $node_id FROM Person WHERE ID = 7), (SELECT $node_id FROM City WHERE ID = 6)),
((SELECT $node_id FROM Person WHERE ID = 8), (SELECT $node_id FROM City WHERE ID = 2)),
((SELECT $node_id FROM Person WHERE ID = 9), (SELECT $node_id FROM City WHERE ID = 11)),
((SELECT $node_id FROM Person WHERE ID = 10), (SELECT $node_id FROM City WHERE ID = 8));


CREATE TABLE BelongsTo AS EDGE;
ALTER TABLE BelongsTo
ADD CONSTRAINT EC_BelongsTo CONNECTION (City TO Country);

INSERT INTO BelongsTo ($from_id, $to_id)
VALUES
((SELECT $node_id FROM City WHERE ID = 1), (SELECT $node_id FROM Country WHERE ID = 1)),
((SELECT $node_id FROM City WHERE ID = 2), (SELECT $node_id FROM Country WHERE ID = 1)),
((SELECT $node_id FROM City WHERE ID = 3), (SELECT $node_id FROM Country WHERE ID = 2)),
((SELECT $node_id FROM City WHERE ID = 4), (SELECT $node_id FROM Country WHERE ID = 2)),
((SELECT $node_id FROM City WHERE ID = 5), (SELECT $node_id FROM Country WHERE ID = 3)),
((SELECT $node_id FROM City WHERE ID = 6), (SELECT $node_id FROM Country WHERE ID = 4)),
((SELECT $node_id FROM City WHERE ID = 7), (SELECT $node_id FROM Country WHERE ID = 5)),
((SELECT $node_id FROM City WHERE ID = 8), (SELECT $node_id FROM Country WHERE ID = 6)),
((SELECT $node_id FROM City WHERE ID = 9), (SELECT $node_id FROM Country WHERE ID = 7)),
((SELECT $node_id FROM City WHERE ID = 10), (SELECT $node_id FROM Country WHERE ID = 8)),
((SELECT $node_id FROM City WHERE ID = 11), (SELECT $node_id FROM Country WHERE ID = 9)),
((SELECT $node_id FROM City WHERE ID = 12), (SELECT $node_id FROM Country WHERE ID = 9)),
((SELECT $node_id FROM City WHERE ID = 13), (SELECT $node_id FROM Country WHERE ID = 10));

CREATE TABLE Relative AS EDGE;
ALTER TABLE Relative
ADD CONSTRAINT EC_Relative CONNECTION (Person TO Person);

INSERT INTO Relative ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Person WHERE ID = 1), (SELECT $node_id FROM Person WHERE ID = 2)),
((SELECT $node_id FROM Person WHERE ID = 1), (SELECT $node_id FROM Person WHERE ID = 3)),
((SELECT $node_id FROM Person WHERE ID = 2), (SELECT $node_id FROM Person WHERE ID = 4)),
((SELECT $node_id FROM Person WHERE ID = 3), (SELECT $node_id FROM Person WHERE ID = 9)),
((SELECT $node_id FROM Person WHERE ID = 5), (SELECT $node_id FROM Person WHERE ID = 6)),
((SELECT $node_id FROM Person WHERE ID = 6), (SELECT $node_id FROM Person WHERE ID = 7)),
((SELECT $node_id FROM Person WHERE ID = 7), (SELECT $node_id FROM Person WHERE ID = 2)),
((SELECT $node_id FROM Person WHERE ID = 8), (SELECT $node_id FROM Person WHERE ID = 3)),
((SELECT $node_id FROM Person WHERE ID = 9), (SELECT $node_id FROM Person WHERE ID = 4)),
((SELECT $node_id FROM Person WHERE ID = 10), (SELECT $node_id FROM Person WHERE ID = 8)),
((SELECT $node_id FROM Person WHERE ID = 11), (SELECT $node_id FROM Person WHERE ID = 6)),
((SELECT $node_id FROM Person WHERE ID = 3), (SELECT $node_id FROM Person WHERE ID = 7));

-- Вывод данных
SELECT * FROM Country;
SELECT * FROM City;
SELECT * FROM Person;
SELECT * FROM LivesIn;
SELECT * FROM BelongsTo;
SELECT * FROM Relative;


--5 задание
--Кто проживает в Берлине
SELECT Person.name, City.name
FROM Person,
	 LivesIN,
	 City
WHERE MATCH(Person-(LivesIN)->City)
AND City.name = N'Берлин'

--В каких странах проживают люди с именем Иван
SELECT Country.name AS Country, City.name AS City, Person.name AS Person
FROM Person,
	 City,
	 Country,
	 BelongsTo,
	 LivesIN
WHERE MATCH(Person-(LivesIn)->City-(BelongsTo)->Country)
AND Person.name = N'Ivan'

 --Узнаем, кто является в родственное связи с Кевинои
SELECT person2.name AS person
FROM Person AS person1
	 , Relative
	 , Person AS person2
WHERE MATCH(person1-(Relative)->person2)
			AND person1.name = N'Kevin';

--Узнаем, в каких городах живут родственники Алекса
SELECT person2.name AS person, City.name AS city
FROM Person AS person1
	 , Relative
	 , Person AS person2
	 , LivesIn
	 , City
WHERE MATCH(person1-(Relative)->person2-(LivesIn)->City)
	        AND person1.name = N'Alex';

--Узнаем, кто живёт в городах, которые расположены в России
SELECT Country.name AS country, City.name AS city, person.name AS person 
FROM City
	 , BelongsTo
	 , Country
	 , LivesIn
	 , Person
WHERE MATCH(Person-(LivesIn)->City-(BelongsTo)->Country)
			AND Country.name = N'Россия';

--6 задание 

SELECT Person1.name AS person 
 , STRING_AGG(Person2.name, '->') WITHIN GROUP (GRAPH PATH) AS
Relatives
FROM Person AS Person1
 , Relative FOR PATH AS r
 , Person FOR PATH AS Person2
WHERE MATCH(SHORTEST_PATH(Person1(-(r)->Person2)+))
 AND Person1.id = 1;



 SELECT Person1.name AS person 
 , STRING_AGG(Person2.name, '->') WITHIN GROUP (GRAPH PATH) AS Relatives
FROM Person AS Person1
 , Relative FOR PATH AS r
 , Person FOR PATH AS Person2
WHERE MATCH(SHORTEST_PATH(Person1(-(r)->Person2){1,2}))
 AND Person1.id = 1;



