import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Konfigurasi Firebase untuk platform web.
/// Untuk Android/iOS, tambahkan file google-services.json / GoogleService-Info.plist.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not configured for this platform.\n'
      'Please add native Firebase config files for Android and iOS.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA34X0Fw1qptrTMFMfZsCytYHTwR_TubHQ',
    authDomain: 'web-porto-c57a4.firebaseapp.com',
    projectId: 'web-porto-c57a4',
    storageBucket: 'web-porto-c57a4.firebasestorage.app',
    messagingSenderId: '149407504324',
    appId: '1:149407504324:web:782d3e84a67f34b75f3691',
    measurementId: 'G-69ZRESVSVF',
  );
}
