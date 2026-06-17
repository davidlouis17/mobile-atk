import 'package:atk_mobile/src/config/app_config.dart';
import 'package:atk_mobile/src/features/barang/barang_repository.dart';
import 'package:atk_mobile/src/services/analytics_service.dart';
import 'package:atk_mobile/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _scanned = false;
  MobileScannerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    debugPrint('Scanner detected: ${capture.barcodes.length} barcodes');
    if (_scanned) {
      debugPrint('Scanner busy, ignoring...');
      return;
    }
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      debugPrint('No barcodes found');
      return;
    }
    
    final code = barcodes.first.rawValue ?? '';
    if (code.isEmpty) {
      debugPrint('Barcode value is empty');
      return;
    }
    
    debugPrint('Barcode raw value: $code');
    setState(() => _scanned = true);

    try {
      await AnalyticsService.logScannerUsed();
    } catch (e) {
      debugPrint('Analytics error (ignored): $e');
    }

    try {
      final repo = BarangRepository();
      debugPrint('Searching for: $code with useMock=${AppConfig.useMockApi}');
      final results = await repo.searchByQuery(code);
      debugPrint('Search results: ${results.length} items');
      
      if (!mounted) return;
      if (results.isNotEmpty) {
        final b = results.first;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(b.namaBarang),
            content: Text('Stok: ${b.stok}\nStatus: ${b.status}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang tidak ditemukan'), backgroundColor: Colors.orange),
        );
      }
    } catch (e) {
      debugPrint('Search error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _scanned = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('scan')),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on),
            onPressed: () => _controller?.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
