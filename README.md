# ProjetDB_VIGNESWARAN_BEN-BRAHIM
Tu travailles dans le domaine de la restauration spécialisée (Pizzeria). Ton entreprise a comme activité de gérer une pizzeria optimisée par une gestion de stock prédictive pour limiter le gaspillage des produits frais et automatiser les commandes auprès des fournisseurs locaux.
C’est une entreprise comme Big Mamma ou une franchise innovante de type "Pizza Cosy". Les données sont collectées sur les niveaux de stocks en temps réel (poids de farine, litres de sauce), les dates de péremption (DLC), les livraisons des fournisseurs, et les quantités d'ingrédients consommées par chaque recette de pizza.
Inspire-toi du site web / de l’article suivant : "ZestVantage" (pour l'optimisation des stocks en restauration) ou des solutions de gestion type "L'Addition".
Ton entreprise veut appliquer MERISE pour concevoir un système d'information. Tu es chargé de la partie analyse, c’est-à-dire de collecter les besoins auprès de l’entreprise. Elle a fait appel à un étudiant en ingénierie informatique pour réaliser ce projet, tu dois lui fournir les informations nécessaires pour qu’il applique ensuite lui-même les étapes suivantes de conception et développement de la base de données.
D’abord, établis les règles de gestions des données de ton entreprise, sous la forme d'une liste à puce. Elle doit correspondre aux informations que fournit quelqu’un qui connaît le fonctionnement de l’entreprise, mais pas comment se construit un système d’information.
Ensuite, à partir de ces règles, fournis un dictionnaire de données brutes avec les colonnes suivantes, regroupées dans un tableau : signification de la donnée, type, taille en nombre de caractères ou de chiffres. Il doit y avoir entre 25 et 35 données. Il sert à fournir des informations supplémentaires sur chaque donnée (taille et type) mais sans a priori sur comment les données vont être modélisées ensuite.
Fournis donc les règles de gestion et le dictionnaire de données.


Règles de Gestion (Règles Métier)D'après le fonctionnement de notre pizzeria "Smart Stock" :Chaque ingrédient (farine, mozzarella, etc.) appartient à une catégorie précise (Frais, Sec, Liquide) pour faciliter le rangement.Un ingrédient peut être fourni par un ou plusieurs fournisseurs locaux.Nous devons suivre la Date Limite de Consommation (DLC) pour chaque lot d'ingrédient reçu afin de respecter la règle du "Premier Entré, Premier Sorti" (FIFO).Chaque recette de pizza consomme une quantité précise d'un ou plusieurs ingrédients.Un seuil d'alerte (stock minimum) est défini pour chaque ingrédient afin de déclencher une commande automatique.Les commandes auprès des fournisseurs regroupent plusieurs ingrédients et possèdent une date d'émission et une date de réception prévue.Un système de pesée connectée met à jour le poids réel en stock après chaque service.Dictionnaire de Données (28 données)Ce dictionnaire respecte la contrainte de 25 à 35 données demandée dans les consignes.Nom de la donnéeSignificationTypeTaille (caract.)ID_INGIdentifiant unique de l'ingrédientAlphanumérique10NOM_INGNom de l'ingrédient (ex: Farine Bio)Texte50CAT_INGCatégorie de l'ingrédientTexte30QTE_STOCKQuantité totale actuellement en stockRéel10UNITE_MESUnité de mesure (kg, litre, unité)Texte10SEUIL_ALERTENiveau de stock critique pour commandeRéel10PRIX_ACHAT_UPrix d'achat unitaire moyenDécimal8ID_LOTNuméro du lot reçuAlphanumérique20DLC_LOTDate limite de consommation du lotDate10DATE_RECEPDate de réception du lot en cuisineDate10ID_FOURNIdentifiant du fournisseurAlphanumérique10NOM_FOURNNom de l'entreprise fournisseurTexte50TEL_FOURNTéléphone du fournisseurNumérique15ADR_FOURNAdresse postale du fournisseurTexte100EMAIL_FOURNEmail de contact pour les commandesTexte50ID_PIZZAIdentifiant de la pizza à la carteAlphanumérique10NOM_PIZZANom commercial de la pizzaTexte50PRIX_VENTEPrix de vente de la pizzaDécimal6QTE_RECETTEQuantité d'ingrédient par pizzaRéel10ID_CMD_FNuméro de commande fournisseurAlphanumérique15DATE_CMD_FDate de passage de la commandeDate10STATUT_CMDÉtat (En cours, Reçu, Annulé)Texte20QTE_COMMANDEEQuantité demandée au fournisseurRéel10ID_EMPIdentifiant de l'employé (gestionnaire)Alphanumérique10NOM_EMPNom du responsable de stockTexte50POIDS_BALANCEPoids relevé par la balance connectéeRéel10TEMP_STOCKTempérature de conservation relevéeDécimal5OBSERVATIONNote sur l'état des produits (ex: abîmé)Texte200




Pour lier ces tables, on utilise des associations:

Composer (N-aire) : Lie PIZZA et INGREDIENT. L'attribut QTE_RECETTE se place ici (car la quantité dépend à la fois de la pizza ET de l'ingrédient).

Fournir : Lie FOURNISSEUR et INGREDIENT.

Contenir : Lie COMMANDE_FOURNISSEUR et INGREDIENT pour savoir quel produit est dans quelle commande.




(étape 5) : 


Scénario d'utilisation 
Rôle : Le gérant de la pizzeria
Le gérant est la personne responsable de la gestion quotidienne de la pizzeria. Il supervise les stocks d'ingrédients, passe les commandes auprès des fournisseurs, gère la carte des pizzas et s'assure que la production peut se faire sans rupture de stock.
Contexte d'utilisation
Chaque semaine, le gérant consulte la base de données pour :

Surveiller les stocks : il vérifie quels ingrédients sont en dessous du seuil minimum pour anticiper les ruptures et passer des commandes à temps.
Gérer les fournisseurs : il analyse les dépenses par fournisseur, vérifie quels fournisseurs ont des commandes en cours, et identifie les fournisseurs les plus sollicités.
Suivre les commandes : il consulte l'état des commandes passées (reçues, en cours) et vérifie les lots réceptionnés ainsi que leurs dates de péremption.
Analyser la carte : il consulte la composition des pizzas, compare les prix, et identifie les pizzas les plus ou moins chères pour ajuster sa carte si nécessaire.
Optimiser les achats : il calcule les montants totaux commandés par fournisseur pour négocier de meilleurs tarifs et identifier les ingrédients jamais commandés ou jamais utilisés.
