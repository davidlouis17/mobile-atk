import 'dart:developer';

import 'package:atk_mobile/src/config/app_config.dart';
import 'package:atk_mobile/src/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permissions (web/mobile)
    await _messaging.requestPermission();

    // Get token (log for backend registration)
    final token = await _messaging.getToken();
    log('FCM token: $token');

    // Subscribe to topic
    try {
      await _messaging.subscribeToTopic(AppConfig.fcmTopic);
    } catch (e) {
      log('Subscribe topic failed: $e');
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Pemberitahuan';
      final body = message.notification?.body ?? '';
      LocalNotificationService.showNotification(title: title, body: body);
    });

    // Background/terminated handled by native/firebase setup
  }
}
