import 'package:atk_mobile/src/features/barang/barang_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atk_mobile/src/core/models/barang_model.dart';
import 'package:atk_mobile/src/l10n/app_localizations.dart';
import 'package:atk_mobile/src/features/riwayat/riwayat_page.dart';
import 'package:atk_mobile/src/features/stok/stok_input_page.dart';
import 'package:atk_mobile/src/features/scanner/scanner_page.dart';
import 'package:atk_mobile/src/features/barang/tambah_barang_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'habis':
        return Colors.redAccent;
      case 'menipis':
        return Colors.orangeAccent;
      default:
        return Colors.green;
    }
  }

  Widget _buildStatsCard(BuildContext context, String title, int value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 2),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barangsAsync = ref.watch(barangListProvider);
    final statsAsync = ref.watch(barangStatsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('dashboard')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SearchBar(
              hintText: t.translate('search'),
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          statsAsync.when(
            data: (stats) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  _buildStatsCard(context, t.translate('total_items'), stats.totalBarang, Icons.inventory, Colors.indigo),
                  _buildStatsCard(context, t.translate('total_stock'), stats.totalStok, Icons.stacked_bar_chart, Colors.blue),
                  _buildStatsCard(context, t.translate('low_stock'), stats.barangMenipis, Icons.warning, Colors.orange),
                  _buildStatsCard(context, t.translate('out_of_stock'), stats.barangHabis, Icons.error, Colors.red),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          Expanded(
            child: barangsAsync.when(
              data: (barangs) {
                final filtered = searchQuery.isEmpty
                    ? barangs
                    : barangs.where((b) =>
                        b.namaBarang.toLowerCase().contains(searchQuery.toLowerCase()) ||
                        b.kategori.toLowerCase().contains(searchQuery.toLowerCase()) ||
                        (b.barcode?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)).toList();
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(barangListProvider);
                    ref.invalidate(barangStatsProvider);
                  },
                  child: filtered.isEmpty
                      ? Center(child: Text(t.translate('no_items')))
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final Barang b = filtered[i];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _statusColor(b.status),
                                  child: Text(b.stok.toString()),
                                ),
                                title: Text(b.namaBarang),
                                subtitle: b.barcode != null
                                    ? Text('${b.kategori} • ${b.barcode}')
                                    : Text(b.kategori),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.history),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => RiwayatPage(barangId: b.id)));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => StokInputPage(barangId: b.id, namaBarang: b.namaBarang)));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TambahBarangPage()));
            },
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'scan',
            child: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ScannerPage()));
            },
          ),
        ],
      ),
    );
  }
}
