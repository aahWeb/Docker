# Docker Introduction 

## Getting Started

**Préambule:**
Avant de plonger dans les détails, jetons un coup d'œil à l'environnement passionnant de la virtualisation et de la conteneurisation.

**Docker? C’est quoi ?**

Docker est une plateforme open-source permettant de créer, déployer et exécuter des applications dans des conteneurs. Mais qu'est-ce qu'un conteneur exactement et pourquoi Docker est-il devenu si populaire ?

**Pourquoi Docker et les conteneurs ?**
Explorons les avantages de l'utilisation de Docker et des conteneurs dans le développement logiciel. De la portabilité à l'efficacité, découvrons comment Docker simplifie la gestion des applications.

**Des environnements de développement et de production identiques:**
Maintenir des environnements cohérents entre le développement et la production peut être un défi. Découvrons comment Docker résout ce problème en garantissant une uniformité dans tous les stades du cycle de vie d'une application.

### Exemple: une application NodeJs
Illustrons les concepts précédents avec un exemple concret d'une application NodeJs déployée à l'aide de Docker.

*Exemple: une application Node.js avec Docker:*
Imaginons que nous ayons une application Node.js simple avec la structure suivante :

```plaintext
my-node-app/
|-- app.js
|-- package.json
|-- package-lock.json
|-- Dockerfile
```

Voici le contenu de chaque fichier :

**app.js** - Fichier principal de l'application Node.js.

```javascript
const http = require('http');
const server = http.createServer((req, res) => {
  res.end('Hello, Docker!');
});

const port = 3000;
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

**package.json** - Fichier de configuration Node.js pour les dépendances.

```json
{
  "name": "my-node-app",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.17.1"
  }
}
```

**Dockerfile** - Fichier Docker pour la construction de l'image.

```Dockerfile
# Utilise une image de base Node.js LTS 14
FROM node:14

# Définit le répertoire de travail dans le conteneur
WORKDIR /usr/src/app

# Copie le package.json et le package-lock.json pour installer les dépendances
COPY package*.json ./

# Installe les dépendances
RUN npm install

# Copie le reste des fichiers de l'application
COPY . .

# Expose le port 3000
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]
```

Avec ces fichiers en place, nous pouvons maintenant construire une image Docker pour notre application Node.js.

```bash
# Se placer dans le répertoire de l'application Node.js
cd my-node-app

# Construction de l'image Docker
docker build -t my-node-app:latest .
```

Ensuite, nous pouvons exécuter un conteneur à partir de l'image que nous avons construite.

```bash
# Exécution du conteneur
docker run -d -p 3000:3000 --name my-node-container my-node-app:latest
```

Notre application Node.js est maintenant accessible à l'adresse http://localhost:3000. Cette illustration montre comment Docker simplifie le processus de déploiement d'une application, en encapsulant toutes les dépendances et en assurant la portabilité.

**Des environnements de développement identiques au sein d’une équipe ou d’une organisation:**
L'uniformité ne doit pas seulement s'appliquer au niveau individuel, mais également à l'échelle de l'équipe et de l'organisation. Découvrons comment Docker facilite la collaboration.

**Des environnements conflictuels entre différents projets:**
Les conflits d'environnement peuvent surgir lorsque plusieurs projets coexistent. Comment Docker résout-il ce problème et facilite-t-il la gestion de multiples applications ?

**Machines Virtuelles vs Conteneurs Docker:**
Comparons les machines virtuelles traditionnelles aux conteneurs Docker. Comprendre les différences fondamentales est crucial pour apprécier l'efficacité des conteneurs.

**Un ordinateur dans l’ordinateur:**
Découvrons le concept de virtualisation et comment les machines virtuelles encapsulent un système d'exploitation complet.

**Les machines virtuelles sont lourdes:**
Les machines virtuelles peuvent être gourmandes en ressources. Examinons les implications et les limites de cette approche.

### Calcul des ressources restantes
Analysons comment calculer les ressources disponibles dans un environnement de machine virtuelle.

#### Calcul des ressources restantes
Explorons le processus de calcul des ressources disponibles dans le contexte des machines virtuelles.

#### Réflexion


Réfléchissons aux défis potentiels liés à la gestion des ressources dans un environnement de machine virtuelle.

**Les conteneurs sont légers:**
Découvrons comment les conteneurs Docker résolvent le problème de lourdeur des machines virtuelles en offrant une alternative légère et efficace.

**Docker vs. Machines Virtuelles : Une Approche Légère:**
Découvrons comment les conteneurs Docker résolvent le problème de lourdeur des machines virtuelles en offrant une alternative légère et efficace.

- **Isolation Mono-processus:**
  - **Machines Virtuelles:**
    - Chaque application s'exécute dans sa propre machine virtuelle avec son propre système d'exploitation complet.
    - Les machines virtuelles sont autonomes et peuvent avoir des systèmes d'exploitation différents.
  - **Conteneurs Docker:**
    - Chaque conteneur Docker est mono-processus et partage le même noyau du système hôte.
    - Les conteneurs sont légers, car ils partagent les ressources du système hôte sans la surcharge d'un système d'exploitation complet.

- **Légèreté et Performance:**
  - **Machines Virtuelles:**
    - Les machines virtuelles peuvent être lourdes en termes de ressources nécessaires.
    - La virtualisation complète inclut un système d'exploitation complet pour chaque application.
  - **Conteneurs Docker:**
    - Les conteneurs sont légers car ils n'incluent que les dépendances spécifiques à l'application.
    - Ils partagent le noyau du système hôte, ce qui réduit la surcharge et améliore les performances.

- **Portabilité et Facilité d'Utilisation:**
  - **Machines Virtuelles:**
    - Les VMs sont souvent plus complexes à déployer en raison de la nécessité d'installer et de configurer un système d'exploitation complet.
  - **Conteneurs Docker:**
    - Les conteneurs sont portables et peuvent être exécutés sur n'importe quel système prenant en charge Docker.
    - La configuration et les dépendances sont encapsulées, simplifiant le déploiement.

- **Gestion des Dépendances:**
  - **Machines Virtuelles:**
    - Chaque VM peut avoir ses propres dépendances, entraînant une gestion plus complexe.
  - **Conteneurs Docker:**
    - Les dépendances sont gérées de manière isolée dans chaque conteneur, facilitant la gestion des environnements.

En résumé, Docker offre une alternative légère et efficace aux machines virtuelles en isolant les applications dans des conteneurs mono-processus. Cette approche légère, combinée à la portabilité et à la facilité de gestion des dépendances, fait des conteneurs Docker un choix attrayant pour le déploiement d'applications.

**Pour s’entraîner:**
Passons à la pratique avec un ensemble de questions à choix multiples (QCM) pour renforcer les concepts introduits.

### QCM - Introduction à Docker
Testons vos connaissances avec ce questionnaire sur les bases de Docker.

#### Questionnaire de fin de chapitre
Évaluons la compréhension globale du chapitre avec ce questionnaire.

Ce cours fournira une base solide pour comprendre les concepts essentiels de Docker et des conteneurs, ainsi que les avantages qu'ils offrent dans le développement logiciel moderne. Bon apprentissage !