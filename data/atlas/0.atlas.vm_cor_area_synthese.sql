-- CREATE MATERIALIZED VIEW atlas.vm_cor_area_synthese
-- TABLESPACE pg_default
-- AS SELECT sa.id_synthese,
--     sa.id_area,
--     a.centroid,
--     st_transform(a.geom, 4326) AS geom,
--     st_asgeojson(st_transform(a.geom, 4326)) AS geojson_4326,
--     st_transform(a.centroid, 4326) AS centroid_4326,
--     t.type_code,
--     sensi.cd_nomenclature,
--         CASE
--             WHEN sensi.cd_nomenclature::text = '1'::text AND t.type_code::text = 'M1'::text THEN true
--             WHEN sensi.cd_nomenclature::text = '2'::text AND t.type_code::text = 'M5'::text THEN true
--             WHEN sensi.cd_nomenclature::text = '3'::text AND t.type_code::text = 'M10'::text THEN true
--             WHEN (sensi.cd_nomenclature::text = '0'::TEXT OR sensi.cd_nomenclature::text IS NULL) AND t.type_code::text = :default_maille::text THEN true
--             ELSE false
--         END AS is_blurred_geom
--    FROM synthese.synthese s
--      JOIN synthese.cor_area_synthese sa ON sa.id_synthese = s.id_synthese
--      JOIN ref_geo.l_areas a ON sa.id_area = a.id_area
--      JOIN ref_geo.bib_areas_types t ON a.id_type = t.id_type
--      LEFT JOIN synthese.t_nomenclatures sensi ON s.id_nomenclature_sensitivity = sensi.id_nomenclature
--   WHERE (t.type_code::text = ANY (ARRAY['M1'::character varying, 'M5'::character varying, 'M10'::character varying]::text[]))
--   AND (NOT sensi.cd_nomenclature::text = '4'::TEXT OR sensi.cd_nomenclature IS NULL )
-- WITH DATA;
-- CREATE UNIQUE INDEX i_vm_cor_area_synthese ON atlas.vm_cor_area_synthese USING btree (id_synthese, id_area );

CREATE MATERIALIZED VIEW atlas.vm_synthese AS 
SELECT 
	s.*,
    sensi.cd_nomenclature::integer
FROM synthese.synthese s  
LEFT JOIN synthese.t_nomenclatures sensi ON s.id_nomenclature_sensitivity = sensi.id_nomenclature
WHERE (NOT sensi.cd_nomenclature::text = '4'::TEXT OR sensi.cd_nomenclature IS NULL )
;
CREATE UNIQUE INDEX ON atlas.vm_synthese USING btree(id_synthese);
CREATE INDEX ON atlas.vm_synthese USING gist(the_geom_local);
CREATE INDEX ON atlas.vm_synthese USING gist(the_geom_point);

--DROP MATERIALIZED VIEW IF EXISTS atlas.vm_areas;
CREATE MATERIALIZED VIEW atlas.vm_areas AS 
SELECT 
	a.id_area, 
	t.type_code,
    a.centroid,
    st_transform(a.geom, 4326) AS geom,
    st_asgeojson(st_transform(a.geom, 4326)) AS geojson_4326,
    st_transform(a.centroid, 4326) AS centroid_4326
FROM ref_geo.l_areas a 
JOIN ref_geo.bib_areas_types t ON a.id_type = t.id_type
WHERE (t.type_code::text = ANY (ARRAY['M1'::character varying, 'M5'::character varying, 'M10'::character varying]::text[]))
AND a.enable IS TRUE
;
CREATE UNIQUE INDEX ON atlas.vm_areas USING btree(id_area);
CREATE INDEX ON atlas.vm_areas USING gist(geom);

--DROP MATERIALIZED VIEW IF EXISTS atlas.vm_cor_area_synthese;
CREATE MATERIALIZED VIEW atlas.vm_cor_area_synthese AS 
SELECT 
	s.id_synthese,
	a.id_area,
    a.centroid,
    a.geom,
    a.geojson_4326,
    a.centroid_4326,
    a.type_code,
    s.cd_nomenclature,
        CASE
            WHEN s.cd_nomenclature::integer = 1 AND a.type_code::text = 'M5'::text THEN true
            WHEN s.cd_nomenclature::integer = 2 AND a.type_code::text = 'M10'::text THEN true
            WHEN s.cd_nomenclature::integer = 3 AND a.type_code::text = 'M10'::text THEN true
            WHEN (s.cd_nomenclature::integer = 0 OR s.cd_nomenclature IS NULL) AND a.type_code::text = :default_maille::text THEN true
            ELSE false
        END AS is_blurred_geom
FROM atlas.vm_synthese s 
JOIN atlas.vm_areas a ON ST_INTERSECTS(s.the_geom_point, a.geom)
--JOIN ref_geo.bib_areas_types t ON a.id_type = t.id_type
--LEFT JOIN synthese.t_nomenclatures sensi ON s.id_nomenclature_sensitivity = sensi.id_nomenclature
--WHERE (a.type_code::text = ANY (ARRAY['M1'::character varying, 'M5'::character varying, 'M10'::character varying]::text[]))
WHERE (NOT s.cd_nomenclature::integer = 4 OR s.cd_nomenclature IS NULL )
--AND a.enable IS TRUE
--AND (ST_GeometryType(s.the_geom_local) = 'ST_Point' 
--OR NOT ST_TOUCHES(st_buffer(s.the_geom_local,-1),a.geom))
--AND s.id_synthese = 865238
--)
;
CREATE UNIQUE INDEX ON atlas.vm_cor_area_synthese USING btree (id_synthese, id_area);
CREATE INDEX ON atlas.vm_cor_area_synthese USING btree (id_synthese);
CREATE INDEX ON atlas.vm_cor_area_synthese USING btree (id_area);
CREATE INDEX ON atlas.vm_cor_area_synthese USING gist (geom);
