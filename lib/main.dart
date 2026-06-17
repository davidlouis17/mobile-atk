import 'package:atk_mobile/src/config/firebase_options.dart';
import 'package:atk_mobile/src/features/auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:atk_mobile/src/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atk_mobile/src/services/local_notification_service.dart';
import 'package:atk_mobile/src/services/fcm_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var _firebaseInitialized = false;
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _firebaseInitialized = true;
  } else {
    try {
      await Firebase.initializeApp();
      _firebaseInitialized = true;
    } catch (_) {
      // native Firebase not configured (missing google-services.json / plist)
      // continue without native Firebase to allow local debugging
    }
  }
  // Crashlytics not required for local/native-debug runs without Firebase

  // Run the app first, then initialize platform services asynchronously
  runApp(const ProviderScope(child: AtkMobileApp()));

  Future.microtask(() async {
    try {
      await LocalNotificationService.init();
    } catch (_) {}
    if (_firebaseInitialized) {
      try {
        final fcm = FcmService();
        await fcm.initialize();
      } catch (_) {}
    }
  });
}

class AtkMobileApp extends StatelessWidget {
  const AtkMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pengingat Stok Gudang ATK',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id'), Locale('en')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
