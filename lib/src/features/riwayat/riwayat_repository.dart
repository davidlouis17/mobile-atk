import 'package:atk_mobile/src/core/models/riwayat_model.dart';
import 'package:atk_mobile/src/core/network/api_client.dart';

class RiwayatRepository {
  final ApiClient apiClient;

  RiwayatRepository({ApiClient? client}) : apiClient = client ?? ApiClient();

  Future<List<Riwayat>> fetchByBarang(int barangId) async {
    final resp = await apiClient.get('/api/riwayat', queryParameters: {'barang_id': barangId});
    final data = resp.data;
    if (data is List) {
      return data.map((e) => Riwayat.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).map((e) => Riwayat.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}
