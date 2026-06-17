import 'package:atk_mobile/src/core/models/barang_model.dart';
import 'package:atk_mobile/src/core/models/barang_stats_model.dart';
import 'package:atk_mobile/src/core/network/api_client.dart';
import 'package:atk_mobile/src/config/app_config.dart';
import 'package:dio/dio.dart';

class BarangRepository {
  final ApiClient apiClient;

  BarangRepository({ApiClient? client}) 
      : apiClient = client ?? ApiClient(useMock: AppConfig.useMockApi);

  Future<List<Barang>> fetchBarangs() async {
    try {
      final resp = await apiClient.get('/api/barang');
      final data = resp.data;
      if (data is List) {
        return data.map((e) => Barang.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => Barang.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw Exception('Unexpected API response for /api/barang: ${resp.data}');
    } on DioException catch (e) {
      print('fetchBarangs error: ${e.response?.statusCode} ${e.response?.data}');
      throw Exception('Failed to fetch barang: ${e.message}');
    }
  }

  Future<BarangStats> fetchStats() async {
    try {
      final resp = await apiClient.get('/api/barang/stats');
      final data = resp.data;
      if (data is Map<String, dynamic>) {
        return BarangStats.fromJson(data);
      }
      throw Exception('Unexpected API response for /api/barang/stats');
    } on DioException catch (e) {
      print('fetchStats error: ${e.response?.statusCode} ${e.response?.data}');
      throw Exception('Failed to fetch stats: ${e.message}');
    }
  }

  Future<List<Barang>> searchByQuery(String q) async {
    try {
      print('searchByQuery: $q');
      final resp = await apiClient.get('/api/barang', queryParameters: {'q': q});
      print('searchByQuery response: ${resp.statusCode}');
      final data = resp.data;
      print('searchByQuery data: $data');
      if (data is List) {
        return data.map((e) => Barang.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => Barang.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('searchByQuery DioException: ${e.response?.statusCode} ${e.response?.data}');
      return [];
    } catch (e) {
      print('searchByQuery error: $e');
      return [];
    }
  }
}
