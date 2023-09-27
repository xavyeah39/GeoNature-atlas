-- Rafraichissement des vues contenant les données de l'atlas
--USAGE : SELECT atlas.refresh_materialized_view_data();
CREATE OR REPLACE FUNCTION atlas.refresh_materialized_view_data()
RETURNS VOID AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.t_layer_territoire;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.l_communes;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_areas;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_synthese;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_cor_area_synthese;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_observations;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_observations_mailles;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_mois;

  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_altitudes;

  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_taxons;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_cor_taxon_organism;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_cor_taxon_attribut;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_search_taxon;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_medias;
  REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_taxons_plus_observes;

END
$$ LANGUAGE plpgsql;