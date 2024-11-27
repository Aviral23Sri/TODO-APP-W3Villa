// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB5wwJd-HcuBkf-_Fb9RPNSQRB4gYElwFU',
    appId: '1:765088895247:web:a01b89489cace364a7ee7a',
    messagingSenderId: '765088895247',
    projectId: 'todo-app-e9f78',
    authDomain: 'todo-app-e9f78.firebaseapp.com',
    storageBucket: 'todo-app-e9f78.firebasestorage.app',
    measurementId: 'G-2L8PSBQGBP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZgmNob8DUH-njvZAleGUKdX_ITc2xYdg',
    appId: '1:765088895247:android:5e782938e6a71f0ba7ee7a',
    messagingSenderId: '765088895247',
    projectId: 'todo-app-e9f78',
    storageBucket: 'todo-app-e9f78.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB5wwJd-HcuBkf-_Fb9RPNSQRB4gYElwFU',
    appId: '1:765088895247:web:ebb6270f0da05daaa7ee7a',
    messagingSenderId: '765088895247',
    projectId: 'todo-app-e9f78',
    authDomain: 'todo-app-e9f78.firebaseapp.com',
    storageBucket: 'todo-app-e9f78.firebasestorage.app',
    measurementId: 'G-CZ4P56CMFG',
  );
}