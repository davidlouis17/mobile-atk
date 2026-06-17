import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logScannerUsed() async {
    await _analytics.logEvent(name: 'scanner_used');
  }

  static Future<void> logLogin(String userEmail) async {
    await _analytics.logLogin(loginMethod: 'email');
    await _analytics.setUserId(id: userEmail);
  }
}
