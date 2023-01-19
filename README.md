# README

## SETUP

Voici les informations pour initialiser le projet sur votre machine.
Il s'agit d'une API Rails servant une application Frontend que [vous trouverez ici](https://github.com/benoitbarges/react-pokedex). La version 6 de Rails est utilisée, avec Ruby `2.7.5`

Les différentes étapes sont les suivantes :
1. Cloner le repository
2. Fetcher et basculer sur la branche `kinoba-technical-test`
3. Lancer en console `bundle install`
4. Lancer en console `rails db:create db:migrate db:seed` pour seeder votre DB (cela prendra quelques minutes)
5. Lancer en console `rails s` pour faire tourner un serveur local

## Contexte

Cette API a été conçue pour un test technique dont voici les principales fonctionnalités demandées :
1. Mettre en place une API REST Rails
2. Ajouter la possibilité de créer un compte, de se connecter et se déconnecter
3. En tant qu’utilisateur connecté, je veux pouvoir ajouter/supprimer un pokémon à la liste
de mes Pokémons capturés
4. En tant qu’utilisateur connecté, je veux pouvoir filtrer la liste des pokémons par pokémons capturés / non-capturés / date de capture
5. En tant que visiteur, je veux pouvoir voir la liste complète des pokémons de toutes les
générations avec une pagination de 10 par 10 pokémons (scroll infini)
6. En tant qu’utilisateur connecté, je veux pouvoir partager un lien public vers mon Pokédex
pour consultation

## Login

J'ai utilisé les gem `devise` et `devise-jwt` pour authentifier les requêtes. L'implémentation est rapide sans trop de configuration.

Comment fonctionne l'authentification par jeton ? 

L'utilisateur saisit ses coordonnées et envoie la requête au serveur. Si les informations sont correctes, le serveur crée un jeton unique codé HMACSHA256, également connu sous le nom de jeton web JSON (JWT). Le client conserve ce token et exécute toutes les demandes suivantes sur le serveur avec celui-ci. Le serveur vérifie l'utilisateur en comparant le token envoyé avec la demande à celui qu'il a stocké dans la base de données, dans le cas présent il s'agit de la colonne `jti` sur le modèle `Trainer`.

Le reste de la configuration est opéré sur l'app Frontend avec la gestion de ce JWT dans le `localStorage` du browser.

## Base de donnée et Modèles

J'ai utilisé PosgreSQL.

Nous avons ici 3 modèles principaux: `Trainer`, `Pokemon` et `CatchedPokemon`.
Les tables `trainers` et `pokemons` ont une relation many-to-many via la table de jointure `catched_pokemons`.  En suivant les conventions elle s'appelerait `trainers_pokemons` mais cela me semblait plus pertinant de la rénommer de la sorte.

J'ai décidé de seeder l'[API pokemon](https://pokeapi.co/) officielle pour recréer de toute pièce ma popre API et mieux gérer les relations entre les différents modèles. De plus on enlève une dépendance si l'API est modifiée, notre application frontend continuera de fonctionner.

On peut marquer des pokémons comme attraper ou non via les actions `#create` et `#destroy` du `CatchedPokemonsController`.

Concernant les actions du `PokemonsController`, elles nous permettent de :
1. Lister et paginer les pokemons par générations via l'action `#index`. J'ai utilisé la gem `kaminari` pour gérer la pagination.
2. Récupérer les informations d'un pokémon en particulier via l'action `#show`.
3. Filter, ordonner et paginer les pokémons selon plusieurs critères via l'action `#filter`.
4. Voir les pokémons attrappés d'un utilisateur en particulier via l'action `#pokedex`.

Dans tous les cas j'ai utitlisé la gem `fast_jsonapi` pour sérializer la donnée, pour une configuration et utilisation simple et efficace.

Avec du temps supplémentaire, j'implémenterais un système d'autorisation des différentes actions (quel utilisateur peut faire quelle action) avec la gem `pundit`.
En l'état je peux créer créer des `catched_pokemons` pour n'importe quel utilisateur via une requête `POST`. On aimerait plutôt que l'utilisateur connecté ne puisse en créer que pour lui-même.

## Tests

Des tests sont écrits dans le dossier `spec`, avec l'utilisation la gem `rspec`. Il faut utiliser la commande `rspec` en console pour lancer la suite de tests.

