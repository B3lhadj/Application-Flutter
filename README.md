# Car Rental App

Application Flutter de location de voitures avec authentification Firebase, gestion des réservations et favoris, et un chatbot alimenté par Gemini.

## Fonctionnalités
- Authentification Firebase (inscription, connexion, persistance de session)
- Parcourir les véhicules, voir les détails, ajouter aux favoris
- Réserver un véhicule et suivre ses réservations
- Profil utilisateur (édition des informations, photo stockée sur Firebase Storage)
- Notifications, écran de paiement, et chatbot d’assistance (Gemini)
- Thème moderne basé sur Material 3 + Google Fonts

## Pile technique
- Flutter 3 (Dart 3), MaterialApp + Provider pour l’état
- Firebase Core/Auth/Firestore/Storage
- Intégration Gemini pour le chatbot
- CI locale : `flutter analyze` et `flutter test`

## Prérequis
- Flutter SDK 3.x installé (`flutter --version`)
- Compte Firebase et projet configuré
- Node 18+ non requis, mais utile pour certains outils CLI

## Configuration Firebase
1) Crée ou sélectionne un projet Firebase.
2) Télécharge les fichiers de configuration et place-les :
   - Android : `android/app/google-services.json`
   - iOS/macOS : `ios/Runner/GoogleService-Info.plist` et `macos/Runner/GoogleService-Info.plist`
3) Si besoin, regénère `lib/firebase_options.dart` avec :
   ```
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

## Démarrage rapide
```bash
flutter pub get
flutter run
```

Pour cibler une plateforme précise :
```bash
flutter run -d chrome          # Web
flutter run -d emulator-5554   # Android
flutter run -d iphone          # iOS (simulateur)
```

## Structure du projet (extraits)
- `lib/main.dart` : point d’entrée, routes, providers
- `lib/screens/` : écrans (auth, accueil, détails, réservations, favoris, profil, chatbot, paiement, notifications)
- `lib/providers/` : gestion d’état (auth, voitures, réservations, favoris)
- `lib/services/` : services métier (Firebase, Gemini, etc.)
- `assets/` : icônes et images
- `android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/` : projets plateforme

## Commandes utiles
- Analyse statique : `flutter analyze`
- Tests unitaires : `flutter test`
- Nettoyer les artefacts : `flutter clean`

## Livraison / bonnes pratiques
- Ne commite pas les dossiers générés (`build/`, `.dart_tool/`, `.gradle/`, `android/app/build/`, `**/ephemeral/`).
- Vérifie que `google-services.json` / `GoogleService-Info.plist` existent localement mais restent ignorés si tu ne souhaites pas les publier.
- Active les chemins longs Git sur Windows si nécessaire :
  ```bash
  git config --global core.longpaths true
  ```

## Licence
Projet académique/démonstration. Ajoute une licence si besoin (MIT, Apache 2.0, etc.).

