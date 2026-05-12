drop schema if exists "parcoursup" cascade;

create schema "parcoursup";

set schema 'parcoursup';

-- Création des tables dépendantes de formation

drop table if exists _academie;
create table _academie (

  academie_nom varchar(50),
  
  constraint _academie_pk primary key(academie_nom)
);


drop table if exists _filiere;
create table _filiere(
  
  filiere_id int,
  filiere_libele varchar(180),
  filiere_libele_tres_abrege varchar(30),
  filiere_libele_abrege varchar(80),
  filiere_libele_detaille_bis varchar(130),
  filiere_libelle_tres_detaille varchar(230),
  
  constraint _filiere_pk primary key(filiere_id)
);

drop table if exists _etablissement;
create table _etablissement (

  etablissement_code_uai char(8),
  etablissement_nom varchar(180),
  etablissement_statut varchar(40),
  
  constraint _etablissement_pk primary key(etablissement_code_uai)
);

drop table if exists _region;
create table _region(
  region_nom varchar(30),
  
  constraint _region_pk primary key(region_nom)
); 

drop table if exists _departement;
create table _departement(
  departement_code char(2),
  region_nom varchar(30) not null,
  departement_nom varchar(40),

  constraint _departement_pk primary key(departement_code),
  
  constraint _departement_fk_region foreign key (region_nom) references _region(region_nom)
); 

drop table if exists _commune;
create table _commune(
  id_commune serial,
  departement_code char(2) not null,
  commune_nom varchar(130),

  constraint _commune_pk primary key(id_commune),
  
  constraint _commune_fk_departement foreign key (departement_code) references _departement(departement_code)
);

drop table if exists _formation;
create table _formation (

  cod_aff_form varchar(10),
  academie_nom varchar(50),
  filiere_id int,
  etablissement_code_uai char(8),
  id_commune int not null, --A PRECISER AU PROF
  filiere_libele_detaille varchar(220),
  coordonnees_gps varchar(30),
  list_com varchar(50),
  concours_communs_banque_epreuve varchar(50),
  url_formation varchar(100),
  tri varchar(30),

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
  libelle_regroupement varchar(100),
  
  constraint _regroupement_pk primary key(libelle_regroupement)
);

drop table if exists _session;
create table _session(
  session_annee int,
  
  constraint _session_pk primary key(session_annee)
);

--table association

drop table if exists _rang_dernier_appele_selon_regroupement;
create table _rang_dernier_appele_selon_regroupement(
  cod_aff_form varchar(10),
  libelle_regroupement varchar(100),
  session_annee int,
  regroupement_1 int,
  rang_dernier_appele_groupe1 int,
  regroupement_2 int,
  rang_dernier_appele_groupe2 int,
  regroupement_3 int,
  rang_dernier_appele_groupe3 int,

  
  constraint _rang_dernier_appele_selon_regroupement_fk_formation
  foreign key (cod_aff_form) references _formation(cod_aff_form),
  
  constraint _rang_dernier_appele_selon_regroupement_fk_regroupement
  foreign key (libelle_regroupement) references _regroupement(libelle_regroupement),

  constraint _rang_dernier_appele_selon_regroupement_fk_session
  foreign key (session_annee) references _session(session_annee)
);
   
drop table if exists _admissions_generalites;
create table _admissions_generalites(
  cod_aff_form varchar(10),
  session_annee int,
  selectivite varchar(100),
  capacite int,
  effectif_total_candidats int,
  effectif_total_candidates int,
  effectif_total_proposition_admission int,
  effectif_total_admis int,
  effectif_total_admises int,
  effectif_admis_meme_etablissement int,
  effectif_admises_meme_etablissement int,
  effectif_admis_meme_academie int,
  effectif_admis_meme_academie_pcv int,

  constraint _admissions_generalites_fk_formation
  foreign key (cod_aff_form) references _formation(cod_aff_form),

  constraint _admissions_generalites_fk_session
  foreign key (session_annee) references _session(session_annee)
);

---------------------------------

drop table if exists _type_bac;
create table _type_bac(
  type_bac varchar(100),
  
  constraint _type_bac_pk primary key(type_bac)
);

drop table if exists _admissions_selon_type_neo_bac;
create table _admissions_selon_type_neo_bac(
  cod_aff_form varchar(10),
  session_annee int,
  type_bac varchar(100),
  effectif_candidats_neo_bac_classes_type_general int,
  effectif_candidats_neo_bac_boursiers_classes_type_general int,
  effectif_candidats_neo_bac_classes_type_techno int,
  effectif_candidats_neo_bac_boursiers_classes_type_techno int,
  effectif_candidats_neo_bac_classes_type_pro int,
  effectif_candidats_neo_bac_boursiers_classes_type_pro int,
  effectif_candidats_classes_type_autres int,
  effectif_total_admis_boursiers_neo_bac int,
  effectif_total_admis_neo_bac int,
  effectif_admis_neo_bac_type_general int,
  effectif_admis_neo_bac_type_techno int,
  effectif_admis_neo_bac_type_pro int,
  effectif_admis_neo_bac_type_autres int,


  
  constraint _admissions_selon_type_neo_bac_fk_formation
  foreign key (cod_aff_form) references _formation(cod_aff_form),

  constraint _admissions_selon_type_neo_bac_fk_session
  foreign key (session_annee) references _session(session_annee),

  constraint _admissions_selon_type_neo_bac_fk_type_bac
  foreign key (type_bac) references _type_bac(type_bac)
);

--------

drop table if exists _mention_bac;
create table _mention_bac(
  libelle_mention varchar(50),
  
  constraint _mention_bac_pk primary key(libelle_mention)
);

drop table if exists _effectif_selon_mention;
create table _effectif_selon_mention(
  cod_aff_form varchar(10),
  session_annee int,
  libelle_mention varchar(50),
  effectif_admis_neo_bac_selon_mention int,
  effectif_candidats_neo_bac_classes_type_general int,
  effectif_admis_neo_bac_selon_mention_type_mention_sans_info int,
  effectif_admis_neo_bac_selon_mention_type_mention_sans_mention int,
  effectif_admis_neo_bac_selon_mention_type_mention_assez_bien int,
  effectif_admis_neo_bac_selon_mention_type_mention_bien int,
  effectif_admis_neo_bac_selon_mention_type_mention_tres_bien int,
  effectif_admis_neo_bac_selon_mention_type_mention_tres_bien_fel int,
  effectif_admis_neo_bac_avec_mention_type_bac_general int,
  effectif_admis_neo_bac_avec_mention_type_bac_techno int,
  effectif_admis_neo_bac_avec_mention_type_bac_pro int,

  constraint _effectif_selon_mention_fk_formation
  foreign key (cod_aff_form) references _formation(cod_aff_form),

  constraint _effectif_selon_mention_fk_session
  foreign key (session_annee) references _session(session_annee),

  constraint _effectif_selon_mention_fk_mention_bac
  foreign key (libelle_mention) references _mention_bac(libelle_mention)
);

insert into _type_bac values
  ('Bac général'),
  ('Bac technologique'),
  ('Bac professionnel'),
  ('Autres');
  
insert into _mention_bac values
  ('Sans information'),
  ('Sans mention'),
  ('Assez bien'),
  ('Bien'),
  ('Très bien'),
  ('Très bien avec les félicitations du jury');

