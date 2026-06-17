import 'package:atk_mobile/src/core/models/barang_stats_model.dart';
import 'package:atk_mobile/src/features/barang/barang_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atk_mobile/src/core/models/barang_model.dart';

final barangListProvider = FutureProvider.autoDispose<List<Barang>>((ref) async {
  final repo = BarangRepository();
  return repo.fetchBarangs();
});

final barangStatsProvider = FutureProvider.autoDispose<BarangStats>((ref) async {
  final repo = BarangRepository();
  return repo.fetchStats();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
