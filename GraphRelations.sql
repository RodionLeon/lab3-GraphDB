-- �������� ���� ������ GraphRelations
USE master;
DROP DATABASE IF EXISTS GraphRelations;
CREATE DATABASE GraphRelations;
USE GraphRelations;

-- �������� �����
CREATE TABLE Country
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE;

INSERT INTO Country (id, name)
VALUES (1, N'������'),
	   (2, N'���'),
	   (3, N'������'),
	   (4, N'��������'),
	   (5, N'�������'),
	   (6, N'�������'),
	   (7, N'��������'),
	   (8, N'��������'),
	   (9, N'��������'),
	   (10, N'���������');

CREATE TABLE City
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE;

INSERT INTO City (id, name)
VALUES (1, N'������'),
	   (2, N'�����-���������'),
	   (3, N'���-����'),
	   (4, N'���-��������'),
	   (5, N'�������'),
	   (6, N'������'),
	   (7, N'�����'),
	   (8, N'������'),
	   (9, N'�����'),
	   (10, N'��������'),
	   (11, N'���-��-�������'),
	   (12, N'���-�����'),
	   (13, N'������-�����')
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


-- �������� �����
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

-- ����� ������
SELECT * FROM Country;
SELECT * FROM City;
SELECT * FROM Person;
SELECT * FROM LivesIn;
SELECT * FROM BelongsTo;
SELECT * FROM Relative;


--5 �������
--��� ��������� � �������
SELECT Person.name, City.name
FROM Person,
	 LivesIN,
	 City
WHERE MATCH(Person-(LivesIN)->City)
AND City.name = N'������'

--� ����� ������� ��������� ���� � ������ ����
SELECT Country.name AS Country, City.name AS City, Person.name AS Person
FROM Person,
	 City,
	 Country,
	 BelongsTo,
	 LivesIN
WHERE MATCH(Person-(LivesIn)->City-(BelongsTo)->Country)
AND Person.name = N'Ivan'

 --������, ��� �������� � ����������� ����� � �������
SELECT person2.name AS person
FROM Person AS person1
	 , Relative
	 , Person AS person2
WHERE MATCH(person1-(Relative)->person2)
			AND person1.name = N'Kevin';

--������, � ����� ������� ����� ������������ ������
SELECT person2.name AS person, City.name AS city
FROM Person AS person1
	 , Relative
	 , Person AS person2
	 , LivesIn
	 , City
WHERE MATCH(person1-(Relative)->person2-(LivesIn)->City)
	        AND person1.name = N'Alex';

--������, ��� ���� � �������, ������� ����������� � ������
SELECT Country.name AS country, City.name AS city, person.name AS person 
FROM City
	 , BelongsTo
	 , Country
	 , LivesIn
	 , Person
WHERE MATCH(Person-(LivesIn)->City-(BelongsTo)->Country)
			AND Country.name = N'������';

--6 ������� 

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



