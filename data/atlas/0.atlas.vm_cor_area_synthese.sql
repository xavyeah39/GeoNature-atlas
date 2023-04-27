CREATE MATERIALIZED VIEW atlas.vm_cor_area_synthese
TABLESPACE pg_default
AS SELECT sa.id_synthese,
    sa.id_area,
    a.centroid,
    st_transform(a.geom, 4326) AS geom,
    st_asgeojson(st_transform(a.geom, 4326)) AS geojson_4326,
    st_transform(a.centroid, 4326) AS centroid_4326,
    t.type_code,
    sensi.cd_nomenclature,
        CASE
            WHEN sensi.cd_nomenclature::text = '1'::text AND t.type_code::text = 'M1'::text THEN true
            WHEN sensi.cd_nomenclature::text = '2'::text AND t.type_code::text = 'M5'::text THEN true
            WHEN sensi.cd_nomenclature::text = '3'::text AND t.type_code::text = 'M10'::text THEN true
            WHEN (sensi.cd_nomenclature::text = '0'::TEXT OR sensi.cd_nomenclature::text IS NULL) AND t.type_code::text = :default_maille::text THEN true
            ELSE false
        END AS is_blurred_geom
   FROM synthese.synthese s
     JOIN synthese.cor_area_synthese sa ON sa.id_synthese = s.id_synthese
     JOIN ref_geo.l_areas a ON sa.id_area = a.id_area
     JOIN ref_geo.bib_areas_types t ON a.id_type = t.id_type
     LEFT JOIN synthese.t_nomenclatures sensi ON s.id_nomenclature_sensitivity = sensi.id_nomenclature
  WHERE (t.type_code::text = ANY (ARRAY['M1'::character varying, 'M5'::character varying, 'M10'::character varying]::text[]))
  AND (NOT sensi.cd_nomenclature::text = '4'::TEXT OR sensi.cd_nomenclature IS NULL )
WITH DATA;
CREATE UNIQUE INDEX i_vm_cor_area_synthese ON atlas.vm_cor_area_synthese USING btree (id_synthese, id_area );
