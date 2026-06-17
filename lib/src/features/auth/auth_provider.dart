import 'package:atk_mobile/src/core/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AsyncValue.data(false));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = AuthRepository();
      await repo.login(email: email, password: password);
      // Log analytics event for login
      try {
        // avoid adding direct dependency cycle; import locally
        // use package import
        // AnalyticsService is lightweight and safe to call
        // ignore: unused_import
      } catch (_) {}
      // We'll call analytics from UI layer after success where email is available
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
