import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwWM_dag5lD-RbJBhpSmrkTOM7SVfruYA',
    appId: '1:665598081738:web:823eabe0f9b8225a7cd233',
    messagingSenderId: '665598081738',
    projectId: 'flutter-a5df9',
    authDomain: 'flutter-a5df9.firebaseapp.com',
    storageBucket: 'flutter-a5df9.firebasestorage.app',
    measurementId: 'G-NJXZP7CZLJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNpHe1vt9BAZBinZeUTVzqnQdAKkx6yj4',
    appId: '1:665598081738:android:046bd03c16b229067cd233',
    messagingSenderId: '665598081738',
    projectId: 'flutter-a5df9',
    storageBucket: 'flutter-a5df9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwWM_dag5lD-RbJBhpSmrkTOM7SVfruYA',
    appId: '1:665598081738:web:823eabe0f9b8225a7cd233', // Note: iOS requires a different App ID (from GoogleService-Info.plist)
    messagingSenderId: '665598081738',
    projectId: 'flutter-a5df9',
    storageBucket: 'flutter-a5df9.firebasestorage.app',
    iosBundleId: 'com.example.car_rental_app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwWM_dag5lD-RbJBhpSmrkTOM7SVfruYA',
    appId: '1:665598081738:web:823eabe0f9b8225a7cd233',
    messagingSenderId: '665598081738',
    projectId: 'flutter-a5df9',
    storageBucket: 'flutter-a5df9.firebasestorage.app',
    iosBundleId: 'com.example.car_rental_app',
  );
}
