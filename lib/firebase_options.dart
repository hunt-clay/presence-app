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
    apiKey: 'AIzaSyAb-40HXzz8YfQ6_ZC2ZHMA6ZUUM9Xskbc',
    appId: '1:868179625748:web:85c5790365a73e05b96401',
    messagingSenderId: '868179625748',
    projectId: 'presenceapp-ebe6f',
    authDomain: 'presenceapp-ebe6f.firebaseapp.com',
    storageBucket: 'presenceapp-ebe6f.appspot.com',
    measurementId: 'G-2QRB49L8NS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGMBuv0vT9haAlvqEhIr95oJGfUbwDKK8',
    appId: '1:868179625748:android:3ed4a638e9fc0bf6b96401',
    messagingSenderId: '868179625748',
    projectId: 'presenceapp-ebe6f',
    storageBucket: 'presenceapp-ebe6f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4GZyt1RF_NzPHASPW4T5-zdJEdrZsyZw',
    appId: '1:868179625748:ios:1ae9d54ae3bd7b07b96401',
    messagingSenderId: '868179625748',
    projectId: 'presenceapp-ebe6f',
    storageBucket: 'presenceapp-ebe6f.appspot.com',
    iosClientId: '868179625748-f2jt1cl7l9sh5ifu70ic0m00auuc0t12.apps.googleusercontent.com',
    iosBundleId: 'com.presenceapp.presenceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC4GZyt1RF_NzPHASPW4T5-zdJEdrZsyZw',
    appId: '1:868179625748:ios:1ae9d54ae3bd7b07b96401',
    messagingSenderId: '868179625748',
    projectId: 'presenceapp-ebe6f',
    storageBucket: 'presenceapp-ebe6f.appspot.com',
    iosClientId: '868179625748-f2jt1cl7l9sh5ifu70ic0m00auuc0t12.apps.googleusercontent.com',
    iosBundleId: 'com.presenceapp.presenceApp',
  );
}
