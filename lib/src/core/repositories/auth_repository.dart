import 'package:atk_mobile/src/config/app_config.dart';
import 'package:atk_mobile/src/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient(useMock: AppConfig.useMockApi);

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await apiClient.post('/api/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;

      if (token == null) {
        throw Exception('Token auth tidak ditemukan dari API.');
      }

      await apiClient.storage.write(key: AppConfig.authTokenKey, value: token);
    } on DioException catch (e) {
      // Print full error response to see validation messages
      print('Login DioException: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Error message: ${e.message}');

      // Get validation errors from Laravel response
      final errorData = e.response?.data;
      if (errorData is Map<String, dynamic>) {
        if (errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            throw Exception(firstError.first.toString());
          }
        }
      }
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
