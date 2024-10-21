-- zad 3
CREATE EXTENSION postgis;

-- zad 4
CREATE TABLE buildings (id int, name varchar(50), geometry geometry);
CREATE TABLE roads (id int, name varchar(50), geometry geometry);
CREATE TABLE poi (id int, name varchar(50), geometry geometry);

-- zad 5
INSERT INTO roads (id, name, geometry) values (1, 'RoadX', 'LINESTRING(0 4.5, 12 4.5)');
INSERT INTO roads (id, name, geometry) values (2, 'RoadY', 'LINESTRING(7.5 10.5, 7.5 0)');

INSERT INTO poi (id, name, geometry) values (1, 'G', 'POINT(1 3.5)');
INSERT INTO poi (id, name, geometry) values (2, 'H', 'POINT(5.5 1.5)');
INSERT INTO poi (id, name, geometry) values (3, 'I', 'POINT(9.5 6)');
INSERT INTO poi (id, name, geometry) values (4, 'J', 'POINT(6.5 6)');
INSERT INTO poi (id, name, geometry) values (5, 'K', 'POINT(6 9.5)');

INSERT INTO buildings (id, name, geometry) values (1, 'BuildingA', 'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))');
INSERT INTO buildings (id, name, geometry) values (2, 'BuildingB', 'POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))');
INSERT INTO buildings (id, name, geometry) values (3, 'BuildingC', 'POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))');
INSERT INTO buildings (id, name, geometry) values (4, 'BuildingD', 'POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))');
INSERT INTO buildings (id, name, geometry) values (5, 'BuildingF', 'POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))');

-- zad 6
-- a
SELECT SUM(st_length(geometry)) FROM roads;

-- b
SELECT  st_astext(geometry), st_area(geometry), st_perimeter(geometry) 
FROM buildings WHERE name = 'BuildingA';

-- c
SELECT  name, st_area(geometry) FROM buildings ORDER BY name;

-- d
SELECT  name, st_perimeter(geometry) FROM buildings 
ORDER BY st_area(geometry) DESC LIMIT 2;

-- e
SELECT  st_distance((SELECT geometry FROM buildings WHERE name = 'BuildingC'), 
					(SELECT geometry FROM poi WHERE name = 'K'));

-- f
SELECT st_area(st_difference(b1.geometry, st_buffer(b2.geometry, 0.5)))
FROM buildings b1, buildings b2 WHERE b1.name = 'BuildingC'AND b2.name = 'BuildingB';

-- g
SELECT name FROM buildings 
WHERE st_y(st_centroid(geometry)) > (SELECT st_y(st_centroid(geometry)) 
FROM roads WHERE name = 'RoadX');

-- h
SELECT st_area(geometry) + st_area(st_geomfromtext('POLYGON((4 7,6 7, 6 8, 4 8, 4 7))')) - st_area(st_intersection(geometry, st_geomfromtext('POLYGON((4 7,6 7, 6 8, 4 8, 4 7))'))) 
FROM buildings WHERE name = 'BuildingC'


