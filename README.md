# trkn-gsmH

> **trhacknonLAB - GSM Blackhat Fake BTS Spammer**

Projet offensif d'expérimentation en cybersécurité utilisant un **HackRF** pour envoyer des **cell broadcast notifications** massives aux smartphones à proximité via une fausse station GSM.

---

### 📚 Matériel nécessaire

Pour plus de détails sur le matériel requis pour ce projet, consultez la [page des matériels nécessaires](https://github.com/trh4ckn0n/trkn-gsmH/blob/main/matos.md).

---

## Fonctionnalités

- **Broadcast Blackhat** : spam automatique de messages d'alertes diverses (COVID, MAJ SIM, urgence nationale, etc.).
- **Rotation Automatique** des messages toutes les 10 secondes.
- **Multi-canaux** : envoie les notifications sur plusieurs canaux GSM simultanément.
- **Puissance personnalisable** : jusqu'à 22 dBm.
- **MCC/MNC configurables** : simulation d'opérateurs réels.
- **Mode furtif** : logs discrets, spam massif sans saturation locale.
- **Arrêt propre** : CTRL+C stoppe la station de manière safe.

---

## Prérequis

- **HackRF One** ou tout SDR supportant l'émission GSM.
- **Linux** (Debian, Ubuntu, Kali recommandé).
- **Accès root** (`sudo`) pour l'interface radio.
- Outils nécessaires :
  - `yate`
  - `yate-bts`
  - `hackrf-tools`
  - `telnet`

---

## Installation

```bash
git clone https://github.com/trh4ckn0n/trkn-gsmH.git
cd trkn-gsmH
chmod +x start_blackhat_bts.sh
sudo ./start_blackhat_bts.sh
```

Le script installera automatiquement les dépendances nécessaires si elles ne sont pas présentes.

---

## Usage

- Démarre une fausse BTS GSM sur bande 900 MHz.
- Diffuse automatiquement des messages cell broadcast.
- Spam ciblé sur les mobiles GSM compatibles autour.
- Tous les paramètres principaux peuvent être modifiés dans le script.

---

## Exemples de messages envoyés

- **MISE A JOUR RESEAU** : Redémarrage obligatoire.
- **COVID-19 Alerte** : Mesures urgentes.
- **5G Active** : Nouvelle configuration requise.
- **Votre numéro est suspendu** : Assistance requise.
- **Message système** : Merci de contacter l'assistance immédiatement.

---

## Versions

### V2 - Standard Pentest Mode

- Usage démonstratif et légal en environnement maîtrisé (lab, pentest autorisé).
- Emission sur une seule bande GSM sécurisée.
- Simulation de messages semi-automatisée.
- Limitations d'émission pour ne pas saturer les fréquences publiques.

### V3 - Blackhat Mode

- Mode offensif non limité : spams en boucle sur bandes multiples.
- Changements aléatoires des messages pour un impact maximal.
- Puissance configurable et ajustable jusqu'à 22 dBm.
- Teste la résistance des appareils mobiles aux faux messages systèmes.

### V4-fzf - Fake GSM Cell Blackhat Edition Interactive avec fzf

[v4-fzf.sh](https://github.com/trh4ckn0n/trkn-gsmH/raw/refs/heads/main/v4-fzf.sh).

- **Sélection interactive des messages** : Intégration de `fzf` pour permettre à l'utilisateur de choisir rapidement un message à envoyer parmi une liste prédéfinie ou d'entrer un message personnalisé.
- **Configuration simplifiée de la station de base (BTS)** : Paramètres de la station de base (BTS) comme la bande, la puissance d'émission, le MCC/MNC, et le nom du réseau sont configurés de manière centralisée et peuvent être ajustés.
- **Fréquence configurable de l'attaque** : La fréquence d'envoi des messages est ajustable par l'utilisateur, permettant un contrôle précis de la vitesse du spam.
- **Envoi de messages de diffusion (cell broadcast)** : Le script envoie des messages sur des canaux GSM spécifiques, testant ainsi la résistance des appareils mobiles aux faux messages systèmes.
- **Interface améliorée avec `fzf`** : Grâce à l'outil `fzf`, la sélection des messages et l'entrée des paramètres deviennent plus interactives et fluides pour l'utilisateur.
- **Sécurité et stabilité** : Vérifications préalables pour s'assurer que le script est exécuté en tant qu'utilisateur root et que le matériel HackRF est correctement détecté avant de procéder.

---

## Avertissements

- Ce projet est destiné à des fins de recherche et d'éducation uniquement.
- L'utilisation de cette technologie pour interférer avec des réseaux GSM réels sans autorisation est **illégale** et **pénalement répréhensible**.
- Ne l'utilisez que dans un environnement contrôlé et autorisé (par exemple, un lab ou un pentest avec permission).
- L'auteur décline toute responsabilité en cas d'utilisation malveillante de ce projet.

---

## Contribution

Les contributions sont les bienvenues ! Si vous avez des suggestions ou souhaitez améliorer ce projet, n'hésitez pas à créer une **pull request** ou à signaler un problème via les **issues**.

---

## License

Ce projet est sous la licence **MIT**. Vous pouvez consulter les détails de la licence dans le fichier `LICENSE`.
