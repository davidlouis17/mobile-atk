import 'package:atk_mobile/src/features/riwayat/riwayat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:atk_mobile/src/l10n/app_localizations.dart';

class RiwayatPage extends ConsumerWidget {
  final int barangId;

  const RiwayatPage({super.key, required this.barangId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riwayatAsync = ref.watch(riwayatProvider(barangId));

    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.translate('history'))),
      body: riwayatAsync.when(
        data: (items) {
          if (items.isEmpty) return Center(child: Text(t.translate('no_history')));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final r = items[i];
              return ListTile(
                leading: CircleAvatar(child: Text(r.tipe[0].toUpperCase())),
                title: Text('${r.tipe.toUpperCase()} • ${r.jumlah}'),
                subtitle: Text(r.keterangan),
                trailing: Text(DateFormat.yMd().add_Hm().format(r.createdAt)),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }
}
