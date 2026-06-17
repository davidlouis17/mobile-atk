import 'package:atk_mobile/src/features/riwayat/riwayat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atk_mobile/src/core/models/riwayat_model.dart';

final riwayatProvider = FutureProvider.family<List<Riwayat>, int>((ref, barangId) async {
  final repo = RiwayatRepository();
  return repo.fetchByBarang(barangId);
});
