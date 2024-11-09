--1
SELECT DISTINCT b18.polygon_id FROM t2018_kar_buildings b18 JOIN t2019_kar_buildings b19 ON b18.polygon_id = b19.polygon_id WHERE NOT st_equals(b18.geom, b19.geom)
UNION
SELECT DISTINCT polygon_id FROM t2019_kar_buildings WHERE polygon_id NOT IN (SELECT polygon_id FROM t2018_kar_buildings);

--2
WITH new_buildings AS (
SELECT DISTINCT b18.polygon_id, b18.geom FROM t2018_kar_buildings b18 JOIN t2019_kar_buildings b19 ON b18.polygon_id = b19.polygon_id WHERE NOT st_equals(b18.geom, b19.geom)
UNION
SELECT DISTINCT polygon_id, geom FROM t2019_kar_buildings WHERE polygon_id NOT IN (SELECT polygon_id FROM t2018_kar_buildings)
)

SELECT poi.type, COUNT(gid) FROM (SELECT * FROM t2019_kar_poi_table WHERE poi_id NOT IN (SELECT poi_id FROM t2018_kar_poi_table)) poi JOIN new_buildings ON st_intersects(poi.geom, st_buffer(new_buildings.geom, 0.005)) GROUP BY poi.type;

--3
CREATE TABLE streets_reprojected AS SELECT * FROM t2019_kar_streets;

UPDATE streets_reprojected SET geom = ST_SetSRID(geom, 3068);

--4
CREATE TABLE input_points (id int, geom geometry);

INSERT INTO input_points VALUES (1, 'POINT(8.36093 49.0374)'), (2, 'POINT(8.39876 49.00644)');

--5
UPDATE input_points SET geom = ST_SetSRID(geom, 3068);

--6 
UPDATE t2019_kar_street_node SET geom = ST_SetSRID(geom, 3068);

SELECT * FROM t2019_kar_street_node node JOIN input_points ON st_intersects(node.geom, st_buffer(input_points.geom, 0.002))

--7
SELECT * FROM t2019_kar_poi_table poi JOIN t2019_kar_land_use_a ON st_intersects(poi.geom, st_buffer(t2019_kar_land_use_a.geom, 0.003))

--8
CREATE TABLE t2019_kar_bridges AS SELECT rail.geom FROM t2019_kar_railways rail JOIN t2019_kar_water_lines water ON st_intersects(rail.geom, water.geom);