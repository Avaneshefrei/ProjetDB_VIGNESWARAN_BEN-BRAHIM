-- Requêtes d'interrogation - Pizzeria
-- Utilisateur : gérant de la pizzeria


-- ========================
-- 1. PROJECTIONS / SELECTIONS
-- ========================

-- Pizzas triées par prix
SELECT nom_pizza, prix_vente
FROM pizza
ORDER BY prix_vente ASC;

-- Pizzas entre 10 et 13 euros
SELECT nom_pizza, prix_vente
FROM pizza
WHERE prix_vente BETWEEN 10.00 AND 13.00;

-- Ingrédients en rupture de stock
SELECT nom_ing, unite, seuil_min, qte_stock
FROM ingredient
WHERE qte_stock < seuil_min
ORDER BY nom_ing;

-- Ingrédients en kg ou en L
SELECT nom_ing, unite, qte_stock
FROM ingredient
WHERE unite IN ('kg', 'L')
ORDER BY nom_ing;

-- Fournisseurs dont l'email commence par "contact"
SELECT id_fournisseur, nom_fourn, tel_fourn
FROM fournisseur
WHERE id_fournisseur LIKE 'contact@%';

-- Commandes passées entre janvier et avril 2024
SELECT id_cmd, date_cmd, statut_cmd
FROM commande_fournisseur
WHERE date_cmd BETWEEN '2024-01-01' AND '2024-04-30'
ORDER BY date_cmd;

-- Lots qui périment avant 2025
SELECT id_LOT, dlc_LOT, date_recep, id_ing
FROM LOT
WHERE dlc_LOT < '2025-01-01'
ORDER BY dlc_LOT ASC;

-- Commandes encore en cours
SELECT id_cmd, date_cmd, statut_cmd
FROM commande_fournisseur
WHERE statut_cmd = 'En cours'
ORDER BY date_cmd;


-- ========================
-- 2. AGREGATIONS / GROUP BY / HAVING
-- ========================

-- Répartition des pizzas par tranche de prix
SELECT
    CASE
        WHEN prix_vente < 10 THEN 'Moins de 10€'
        WHEN prix_vente BETWEEN 10 AND 12 THEN 'Entre 10€ et 12€'
        ELSE 'Plus de 12€'
    END AS tranche_prix,
    COUNT(*) AS nb_pizzas
FROM pizza
GROUP BY tranche_prix;

-- Prix moyen, min et max des pizzas
SELECT
    ROUND(AVG(prix_vente), 2) AS prix_moyen,
    MIN(prix_vente) AS prix_min,
    MAX(prix_vente) AS prix_max
FROM pizza;

-- Nb d'ingrédients par fournisseur
SELECT f.nom_fourn, COUNT(fr.id_ing) AS nb_ingredients
FROM fournisseur f
JOIN fournir fr ON f.id_fournisseur = fr.id_fournisseur
GROUP BY f.nom_fourn
ORDER BY nb_ingredients DESC;

-- Montant total commandé par fournisseur
SELECT f.nom_fourn,
    ROUND(SUM(a.prix_d_achat * a.qte_commandee), 2) AS montant_total
FROM approvisionner a
JOIN fournisseur f ON a.id_fournisseur = f.id_fournisseur
GROUP BY f.nom_fourn
ORDER BY montant_total DESC;

-- Fournisseurs avec plus de 3 ingrédients référencés
SELECT f.nom_fourn, COUNT(fr.id_ing) AS nb_ingredients
FROM fournisseur f
JOIN fournir fr ON f.id_fournisseur = fr.id_fournisseur
GROUP BY f.nom_fourn
HAVING nb_ingredients > 3;

-- Moyenne d'ingrédients par pizza
SELECT ROUND(AVG(nb_ing), 2) AS moyenne_ingredients_par_pizza
FROM (
    SELECT id_pizza, COUNT(id_ing) AS nb_ing
    FROM composer
    GROUP BY id_pizza
) AS sous_requete;

-- Quantités totales commandées par ingrédient (> 10)
SELECT i.nom_ing, SUM(a.qte_commandee) AS qte_totale_commandee
FROM approvisionner a
JOIN ingredient i ON a.id_ing = i.id_ing
GROUP BY i.nom_ing
HAVING qte_totale_commandee > 10
ORDER BY qte_totale_commandee DESC;


-- ========================
-- 3. JOINTURES
-- ========================

-- Ingrédients et leurs fournisseurs
SELECT i.nom_ing, f.nom_fourn, f.tel_fourn
FROM ingredient i
JOIN fournir fr ON i.id_ing = fr.id_ing
JOIN fournisseur f ON fr.id_fournisseur = f.id_fournisseur
ORDER BY i.nom_ing;

-- Composition de chaque pizza
SELECT p.nom_pizza, i.nom_ing, c.qte_recette, i.unite
FROM pizza p
JOIN composer c ON p.id_pizza = c.id_pizza
JOIN ingredient i ON c.id_ing = i.id_ing
ORDER BY p.nom_pizza, i.nom_ing;

-- Ingrédients jamais commandés
SELECT i.nom_ing
FROM ingredient i
LEFT JOIN approvisionner a ON i.id_ing = a.id_ing
WHERE a.id_ing IS NULL;

-- Détail complet des commandes fournisseurs
SELECT
    cmd.id_cmd,
    cmd.date_cmd,
    cmd.statut_cmd,
    f.nom_fourn,
    i.nom_ing,
    a.qte_commandee,
    a.prix_d_achat,
    ROUND(a.qte_commandee * a.prix_d_achat, 2) AS montant_ligne
FROM commande_fournisseur cmd
JOIN approvisionner a ON cmd.id_cmd = a.id_cmd
JOIN fournisseur f ON a.id_fournisseur = f.id_fournisseur
JOIN ingredient i ON a.id_ing = i.id_ing
ORDER BY cmd.date_cmd, f.nom_fourn;

-- Lots avec nom de l'ingrédient
SELECT l.id_LOT, i.nom_ing, l.date_recep, l.dlc_LOT
FROM LOT l
JOIN ingredient i ON l.id_ing = i.id_ing
ORDER BY l.dlc_LOT;

-- Fournisseurs sans aucune commande
SELECT f.nom_fourn
FROM fournisseur f
LEFT JOIN approvisionner a ON f.id_fournisseur = a.id_fournisseur
WHERE a.id_fournisseur IS NULL;


-- ========================
-- 4. REQUETES IMBRIQUEES
-- ========================

-- Pizzas avec de la mozzarella (IN)
SELECT nom_pizza
FROM pizza
WHERE id_pizza IN (
    SELECT id_pizza FROM composer WHERE id_ing = 'ING006'
);

-- Ingrédients non utilisés dans les recettes (NOT IN)
SELECT nom_ing
FROM ingredient
WHERE id_ing NOT IN (
    SELECT DISTINCT id_ing FROM composer
);

-- Fournisseurs avec au moins une commande en cours (EXISTS)
SELECT f.nom_fourn
FROM fournisseur f
WHERE EXISTS (
    SELECT 1
    FROM approvisionner a
    JOIN commande_fournisseur cmd ON a.id_cmd = cmd.id_cmd
    WHERE a.id_fournisseur = f.id_fournisseur
    AND cmd.statut_cmd = 'En cours'
);

-- Ingrédients jamais approvisionnés (NOT EXISTS)
SELECT i.nom_ing
FROM ingredient i
WHERE NOT EXISTS (
    SELECT 1 FROM approvisionner a WHERE a.id_ing = i.id_ing
);

-- Pizzas plus chères que toutes celles à moins de 10€ (ALL)
SELECT nom_pizza, prix_vente
FROM pizza
WHERE prix_vente > ALL (
    SELECT prix_vente FROM pizza WHERE prix_vente < 10
);

-- Ingrédients avec moins de stock qu'au moins un autre de même unité (ANY)
SELECT nom_ing, unite, qte_stock
FROM ingredient i1
WHERE qte_stock < ANY (
    SELECT qte_stock FROM ingredient i2
    WHERE i2.unite = i1.unite AND i2.id_ing != i1.id_ing
)
ORDER BY unite, qte_stock;

-- Ingrédients des commandes reçues en 2024 (IN imbriqué)
SELECT DISTINCT i.nom_ing
FROM ingredient i
WHERE i.id_ing IN (
    SELECT a.id_ing
    FROM approvisionner a
    WHERE a.id_cmd IN (
        SELECT id_cmd FROM commande_fournisseur
        WHERE statut_cmd = 'Reçu'
        AND YEAR(date_cmd) = 2024
    )
);