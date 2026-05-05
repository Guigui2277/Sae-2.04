drop schema if exists "parcoursup" cascade;

create schema "parcoursup";

set schema 'parcoursup';

-- Création des tables dépendantes de formation

drop table if exists _academie;
create table _academie (

  academie_nom varchar(30),
  
  constraint _academie_pk primary key(academie_nom)
);


drop table if exists _filiere;
create table _filiere(
  
  filiere_id int,
  filiere_libele varchar(30),
  filiere_libele_tres_abrege varchar(30),
  filiere_libele_abrege varchar(30),
  filiere_libele_detaille_bis varchar(30),
  
  constraint _filiere_pk primary key(filiere_id)
);

drop table if exists _etablissement;
create table _etablissement (

  etablissement_code_uai char(8),
  etablissement_nom varchar(30),
  etablissement_statut varchar(30),
  
  constraint _etablissement_pk primary key(etablissement_code_uai)
);

drop table if exists _region;
create table _region(
  region_nom varchar(40),
  
  constraint _region_pk primary key(region_nom)
); 

drop table if exists _departement;
create table _departement(
  departement_code varchar(40),
  departement_nom varchar(40),
  region_nom varchar(40),

  constraint _departement_pk primary key(departement_code),
  
  constraint _departement_fk_region foreign key (region_nom) references _region(region_nom)
); 

drop table if exists _commune;
create table _commune(
  id_commune serial,
  commune_nom varchar(40),
  departement_code varchar(40),

  constraint _commune_pk primary key(id_commune),
  
  constraint _commune_fk_departement foreign key (departement_code) references _departement(departement_code)
);

drop table if exists _formation;
create table _formation (

  cod_aff_form varchar(30),
  filliere_libele_detaille varchar(30),
  coordonnees_gps varchar(30),
  list_com varchar(30),
  concours_communs_banque_epreuve varchar(30),
  url_formation varchar(30),
  tri varchar(30),
  academie_nom varchar(30),
  filiere_id int,
  etablissement_code_uai char(8),
  id_commune int,
  
  
  constraint _formation_pk primary key(cod_aff_form),
  
  constraint _formation_fk_academie 
  foreign key (academie_nom) references _academie(academie_nom),
      
  constraint _formation_fk_filiere 
  foreign key (filiere_id) references _filiere(filiere_id),
 
  constraint _formation_fk_etablissement 
  foreign key (etablissement_code_uai) references _etablissement(etablissement_code_uai),
  
  constraint _formation_fk_commune
  foreign key (id_commune) references _commune(id_commune)
);

-------------------------------------

drop table if exists _regroupement;
create table _regroupement(
  libele_regroupement varchar(40),
  
  constraint _formation_pk primary key(cod_aff_form)
);

drop table if exists _session;
create table _session(
  session_annee int,
  
  constraint _session_pk primary key(session_annee)
);

--table association

drop table if exists _rang_dernier_appele_selon_regroupement;
create table _rang_dernier_appele_selon_regroupement(
  session_annee int,
  cod_aff_form varchar(30),
  libele_regroupement varchar(40),
  session_annee int,
  
  constraint _rang_dernier_appele_selon_regroupement_fk_formation
  foreign key (cod_aff_form) references _rang_dernier_appele_selon_regroupement(cod_aff_form),
  
  constraint _rang_dernier_appele_selon_regroupement_fk_regroupement
  foreign key (libele_regroupement) references _rang_dernier_appele_selon_regroupement(libele_regroupement),

  constraint _rang_dernier_appele_selon_regroupement_fk_session
  foreign key (session_annee) references _rang_dernier_appele_selon_regroupement(session_annee)
);
   
drop table if exists _admissions_generalite;
create table _admissions_generalites(
  selectivite varchar(100),
  capacite int,
  effectif_total_candidats int,
  effectif_total_candidates int,
  cod_aff_form varchar(30),
  session_annee int,
  
  constraint _admissions_generalites_fk_formation
  foreign key (cod_aff_form) references _admissions_generalites(cod_aff_form),

  constraint _admissions_generalites_fk_session
  foreign key (session_annee) references _admissions_generalites(session_annee)
);

---------------------------------

drop table if exists _type_bac;
create table _type_bac(
  type_bac varchar(30),
  
  constraint _type_bac_pk primary key(type_bac)
);

drop table if exists _admissions_selon_type_neo_bac;
create table _admissions_selon_type_neo_bac(
  effectif_admis_neo_bac_selon_mention int,
  type_bac varchar(30),
  cod_aff_form varchar(30),
  session_annee int,
  
  constraint _admissions_selon_type_neo_bac_fk_formation
  foreign key (cod_aff_form) references _admissions_selon_type_neo_bac(cod_aff_form),

  constraint _admissions_selon_type_neo_bac_fk_session
  foreign key (session_annee) references _admissions_selon_type_neo_bac(session_annee),

  constraint _admissions_selon_type_neo_bac_fk_type_bac
  foreign key (type_bac) references _admissions_selon_type_neo_bac(type_bac)
);

--------

drop table if exists _mention_bac;
create table _mention_bac(
  libelle_mention varchar(30),
  
  constraint _mention_bac_pk primary key(libelle_mention)
);

drop table if exists _effectif_selon_mention;
create table _effectif_selon_mention(
  effectif_admis_neo_bac_selon_mention int,
  libelle_mention varchar(40),
  cod_aff_form varchar(30),
  session_annee int,
  
  constraint _effectif_selon_mention_fk_formation
  foreign key (cod_aff_form) references _effectif_selon_mention(cod_aff_form),

  constraint _effectif_selon_mention_fk_session
  foreign key (session_annee) references _effectif_selon_mention(session_annee),

  constraint _effectif_selon_mention_fk_mention_bac
  foreign key (libelle_mention) references _effectif_selon_mention(libelle_mention)
);

