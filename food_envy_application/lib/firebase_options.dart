// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAyLjzoU7oFz8-37YlT1rgK3KB3bs-Q1c4',
    appId: '1:956648166081:web:dd41a4dc8d4269646eba40',
    messagingSenderId: '956648166081',
    projectId: 'foodenvy-9e8d2',
    authDomain: 'foodenvy-9e8d2.firebaseapp.com',
    storageBucket: 'foodenvy-9e8d2.appspot.com',
    measurementId: 'G-MBSQ5LY3TX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCd0iAw1iFZiTOEBl-SyU7mfcAfn1ovyiM',
    appId: '1:956648166081:android:ec65aabf515790166eba40',
    messagingSenderId: '956648166081',
    projectId: 'foodenvy-9e8d2',
    storageBucket: 'foodenvy-9e8d2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8dGQA3s024JKwOfKSeIaSbBv1zmIBicY',
    appId: '1:956648166081:ios:69b3c1b46373f32f6eba40',
    messagingSenderId: '956648166081',
    projectId: 'foodenvy-9e8d2',
    storageBucket: 'foodenvy-9e8d2.appspot.com',
    iosBundleId: 'com.example.foodEnvyApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8dGQA3s024JKwOfKSeIaSbBv1zmIBicY',
    appId: '1:956648166081:ios:0925a853ae6628716eba40',
    messagingSenderId: '956648166081',
    projectId: 'foodenvy-9e8d2',
    storageBucket: 'foodenvy-9e8d2.appspot.com',
    iosBundleId: 'com.example.foodEnvyApplication.RunnerTests',
  );
}
