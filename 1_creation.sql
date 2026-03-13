CREATE TABLE ingredient(
   id_ing VARCHAR(10),
   nom_ing VARCHAR(50),
   unite VARCHAR(10),
   seuil_min DOUBLE,
   qte_stock DOUBLE,
   PRIMARY KEY(id_ing)
);

CREATE TABLE fournisseur(
   id_fournisseur VARCHAR(50),
   nom_fourn VARCHAR(50),
   tel_fourn VARCHAR(15),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE commande_fournisseur(
   id_cmd VARCHAR(15),
   date_cmd DATE,
   statut_cmd VARCHAR(20),
   PRIMARY KEY(id_cmd)
);

CREATE TABLE pizza(
   id_pizza VARCHAR(10),
   nom_pizza VARCHAR(50),
   prix_vente DECIMAL(5,2),
   PRIMARY KEY(id_pizza)
);

CREATE TABLE LOT(
   id_LOT VARCHAR(20),
   dlc_LOT DATE,
   date_recep DATE,
   id_ing VARCHAR(10) NOT NULL,
   PRIMARY KEY(id_LOT, id_ing),
   FOREIGN KEY(id_ing) REFERENCES ingredient(id_ing) ON DELETE CASCADE
);

CREATE TABLE composer(
   id_ing VARCHAR(10),
   id_pizza VARCHAR(10),
   qte_recette DECIMAL(10,2),
   PRIMARY KEY(id_ing, id_pizza),
   FOREIGN KEY(id_ing) REFERENCES ingredient(id_ing) ON DELETE CASCADE,
   FOREIGN KEY(id_pizza) REFERENCES pizza(id_pizza) ON DELETE CASCADE
);

CREATE TABLE fournir(
   id_ing VARCHAR(10),
   id_fournisseur VARCHAR(50),
   PRIMARY KEY(id_ing, id_fournisseur),
   FOREIGN KEY(id_ing) REFERENCES ingredient(id_ing) ON DELETE CASCADE,
   FOREIGN KEY(id_fournisseur) REFERENCES fournisseur(id_fournisseur) ON DELETE CASCADE
);

CREATE TABLE approvisionner(
   id_ing VARCHAR(10),
   id_fournisseur VARCHAR(50),
   id_cmd VARCHAR(15),
   prix_d_achat DECIMAL(8,2),
   qte_commandee DECIMAL(10,2),
   PRIMARY KEY(id_ing, id_fournisseur, id_cmd),
   FOREIGN KEY(id_ing) REFERENCES ingredient(id_ing) ON DELETE CASCADE,
   FOREIGN KEY(id_fournisseur) REFERENCES fournisseur(id_fournisseur) ON DELETE CASCADE,
   FOREIGN KEY(id_cmd) REFERENCES commande_fournisseur(id_cmd) ON DELETE CASCADE
);