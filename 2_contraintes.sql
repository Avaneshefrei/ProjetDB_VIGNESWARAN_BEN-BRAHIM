ALTER TABLE ingredient 
ADD CONSTRAINT chk_unite_valide CHECK (unite IN ('kg', 'L', 'unité', 'g', 'cl'));

ALTER TABLE ingredient 
ADD CONSTRAINT chk_stocks_coherents CHECK (qte_stock >= 0 AND seuil_min >= 0);

ALTER TABLE fournisseur 
ADD CONSTRAINT chk_format_email CHECK (id_fournisseur LIKE '%@%.%');

ALTER TABLE commande_fournisseur 
ADD CONSTRAINT chk_format_id_cmd CHECK (id_cmd LIKE 'CMD-%');

ALTER TABLE commande_fournisseur 
ADD CONSTRAINT chk_statut_valide CHECK (statut_cmd IN ('En cours', 'Reçu', 'Annulé'));

ALTER TABLE pizza 
ADD CONSTRAINT chk_prix_pizza CHECK (prix_vente BETWEEN 5 AND 40);

ALTER TABLE LOT 
ADD CONSTRAINT chk_dates_lot CHECK (dlc_LOT > date_recep);

ALTER TABLE composer 
ADD CONSTRAINT chk_quantite_recette CHECK (qte_recette > 0 AND qte_recette < 10);

ALTER TABLE approvisionner 
ADD CONSTRAINT chk_prix_achat_positif CHECK (prix_d_achat > 0);

ALTER TABLE approvisionner 
ADD CONSTRAINT chk_qte_livree_positive CHECK (qte_commandee > 0);