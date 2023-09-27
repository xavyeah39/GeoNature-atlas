-- CREATE MATERIALIZED VIEW atlas.vm_observations_mailles AS
--     SELECT 
--       obs.id_observation,
--       obs.cd_ref,
--       cor.id_area as id_maille,
--       cor.geojson_4326 as geojson_maille,
--       cor.geom as the_geom,
--       cor.type_code as type_code,
-- date_part('year', dateobs) as annee,
-- obs.dateobs
-- FROM atlas.vm_observations obs
-- JOIN atlas.vm_cor_area_synthese cor ON cor.id_synthese = obs.id_observation AND cor.is_blurred_geom IS TRUE
-- WITH DATA;

-- create unique index on atlas.vm_observations_mailles (id_observation, id_maille);
-- create index on atlas.vm_observations_mailles (id_maille);
-- create index on atlas.vm_observations_mailles (cd_ref);
-- create index on atlas.vm_observations_mailles (geojson_maille);

CREATE MATERIALIZED VIEW atlas.vm_observations_mailles AS
    SELECT 
      obs.id_observation,
      obs.cd_ref,
      cor.id_area as id_maille,
      cor.geojson_4326 as geojson_maille,
      cor.geom as the_geom,
      cor.type_code as type_code,
date_part('year', dateobs) as annee,
obs.dateobs
FROM atlas.vm_observations obs
JOIN atlas.vm_cor_area_synthese cor ON cor.id_synthese = obs.id_observation AND cor.is_blurred_geom IS TRUE
WITH DATA;

create unique index on atlas.vm_observations_mailles (id_observation, id_maille);
create index on atlas.vm_observations_mailles (id_maille);
create index on atlas.vm_observations_mailles (cd_ref);
create index on atlas.vm_observations_mailles (geojson_maille);