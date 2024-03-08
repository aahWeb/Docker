# TP API MongoDB

### Étape 1: Prérequis

Assurez-vous d'avoir installé les dépendances nécessaires :

🏗️

- PHP
- Composer
- MongoDB
- Docker

:rocket: Le but de ce cours est d'expliquer comment créer et déployer un conteneur Docker qui utilise PHP 8.2 avec Apache et intègre le pilote MongoDB pour les applications web.

Une fois que vous avez votre environnement de travail Docker est en place, vous implémenterez l'API avec PHP et MongoDB.

#### Étapes Docker

##### 1. **Création du Dockerfile :**

```Dockerfile
# Utilisez une image PHP officielle avec Apache et PHP 8.2
FROM php:8.2-apache

# Installez le pilote MongoDB pour PHP
RUN apt-get -y update \
    && apt-get install -y libssl-dev pkg-config libzip-dev unzip git

RUN pecl install zlib zip mongodb \
    && docker-php-ext-enable zip \
    && docker-php-ext-enable mongodb

# Install composer (updated via entry point)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Activer le module Apache pour PHP
RUN a2enmod rewrite
RUN a2enmod headers

# Redémarrez Apache pour prendre en compte les modifications
RUN service apache2 restart

# Copiez vos fichiers PHP dans le répertoire du serveur web
COPY . /var/www/html

# Exposez le port 80 (par défaut pour Apache)
EXPOSE 80

# Démarrez Apache au lancement du conteneur
CMD ["apache2-foreground"]
```

##### 2. **Création du docker-compose.yml :**

```yaml
version: '3.8'

services:
  php-mongodb-app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: docker_php_mongodb
    ports:
      - "8080:80"  # Expose le port 8080 de votre machine hôte vers le port 80 du conteneur
    volumes:
      - ./app:/var/www/html
    depends_on:
      - mongo

  mongo:
    container_name: docker_mongo
    image: mongo
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example
    ports:
      - "27017:27017"
    volumes:
      - $PWD/data:/data/db
```

##### 3. **Explication des Étapes :**

- **Dockerfile :**
  - Utilisation de l'image officielle PHP 8.2 avec Apache.
  - Installation du pilote MongoDB pour PHP.
  - Activation des modules Apache pour PHP.
  - Redémarrage d'Apache pour prendre en compte les modifications.
  - Copie des fichiers PHP dans le répertoire du serveur web.
  - Exposition du port 80 pour Apache.

- **docker-compose.yml :**
    - Configuration du service `php-mongodb-app`.
    - Spécification du Dockerfile et du contexte de construction.
    - Exposition du port 8080 de la machine hôte vers le port 80 du conteneur.
    - Montage du répertoire local `./app` dans le répertoire du serveur web.
    - Dépendance du service `mongo`.

  - Configuration du service `mongo`.
    -  Configuration de MongoDB avec le nom d'utilisateur et le mot de passe.

##### 4. **Exécution du Conteneur :**

- Ouvrez un terminal dans le répertoire où se trouvent vos fichiers Docker et exécutez la commande suivante :

  ```bash
  docker-compose up --build
  ```

- Attendez que la construction du conteneur soit terminée.

- Ouvrez un navigateur web et accédez à l'application à l'adresse [http://localhost:8080](http://localhost:8080).

##### 5. **Arrêt du Conteneur :**

- Pour arrêter les conteneurs, ouvrez un terminal dans le répertoire et exécutez la commande suivante :

  ```bash
  docker-compose down
  ```

## Mise en place des données dans la base de données MongoDB

🥟 Les données se trouvent dans le dossier **data/restaurants.json**

```bash
# Connectez-vous au conteneur 
docker exec -it docker_mongo bash

# Déplacez vous dans le dossier contenant les données
cd data/db

# (Ces données sont partagées de votre machine hôte vers 
#  le conteneur Docker, grâce au volume déclaré dans
#  le fichier stack.yml)

# Importez les données JSON dans une base MongoDB 'ny'
mongoimport --db ny \
            --collection restaurants \
            --authenticationDatabase admin \
            --username root \
            --password example \
            --drop \
            --file ./restaurants.json
```

Dans le conteneur PHP 

```bash
docker exec -it docker_php_mongodb bash
```

### Étape 2: Création du projet

:rocket: Les deux dépendances **mongodb** et **http-foundation** sont nécessaires pour transmettre nos requêtes à MongoDB et pour gérer les requêtes HTTP ainsi que les réponses en JSON.

```bash
# Créez un nouveau projet
composer init

# Installez les dépendances 
composer require mongodb/mongodb symfony/http-foundation
```

### Étape 3: 🍆 Structure du projet

```
- index.php
- bootstrap.php
- vendor/
  (répertoire généré par Composer)
- composer.json
```

### Étape 4: 🍆 Configuration de MongoDB

Créez un fichier `bootstrap.php` pour gérer la configuration de MongoDB :

```php
// bootstrap.php

require_once __DIR__ . '/vendor/autoload.php' ;

use MongoDB\Client;

# Attention mettre mongo à la place de  localhost 
$client = new Client('mongodb://root:example@mongo:27017');
$collection = $client->ny->restaurants;
```

### Étape 5: API avec Symfony HTTP Foundation

Créez un fichier `index.php` pour définir votre API :

```php
// api.php
require_once __DIR__ . '/bootstrap.php';

// utilisation d'une dépandance Symfony pour gérer les requêtes
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

$request = Request::createFromGlobals();
$action = $request->query->get('action');

$response = new Response();

// traitement des actions de l'API
if ($action == 'all') {
    $cursor = $collection->find(
        [
          'cuisine' => 'Italian',
        ],
        [
          'limit' => 5,
          'projection' => [
              'name' => 1,
              '_id' => 0
          ],
        ]
    );

    $response->setContent(json_encode([
        'data' => $cursor->toArray();
    ]));
}
// la réponse est un JSON à préciser pour l'envoi des données au navigateur
$response->headers->set('Content-Type', 'application/json');
// on envoit les données 
$response->send();
```

### :rocket: Étape 6: Tester l'API

- Exécutez votre serveur PHP local.
- Testez les différentes actions de l'API avec un outil comme Postman.
- Consultez la documentation de l'API pour comprendre comment utiliser chaque endpoint.

Adaptez ce tutoriel en fonction de vos besoins spécifiques et de votre structure de base de données. N'oubliez pas de sécuriser votre API, notamment en implémentant des mécanismes d'authentification si nécessaire.

## Étape 7: Les requêtes en fonction des routes

Toutes les requêtes seront limitées à 10 par défaut, paramètre à préciser dans l'action.

### Lire tous les restaurants

#### Endpoint
GET /index.php?action=all&limit=10

#### Réponse
Retourne la liste de tous les restaurants au format JSON.

### Lire un restaurant par ID

#### Endpoint
GET /index.php?action=cusine&name=(name)limit=10

#### Paramètres
- {name}: type de restaurant à récupérer (obligatoire)

#### Réponse
Retourne les détails du restaurant spécifié au format JSON.

## Restaurants par quartier

### Endpoint
GET /index.php?action=restaurantsByBorough

### Réponse
Retourne le nombre total de restaurants par quartier au format JSON.

## Restaurants par quartier

### Endpoint
GET /index.php?action=restaurantsByBorough

### Réponse
Retourne le nombre total de restaurants par quartier au format JSON.

## Nombre de restaurants dans le dataset 

### Endpoint
GET /index.php?action=count

### Réponse
Retourne le nombre total de restaurants au format JSON.

## Moyenne des scores par quartier

### Endpoint
GET /index.php?action=averageByBorough

### Réponse
Retourne le nombre total de restaurants au format JSON.

## Coffee restaurants

### Endpoint
GET /index.php?action=regex&name=coffee

### Réponse
Retourne les restaurants qui ont dans leur nom coffee