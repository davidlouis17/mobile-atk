import 'package:atk_mobile/src/config/app_config.dart';
import 'package:atk_mobile/src/core/network/api_client.dart';
import 'package:atk_mobile/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _kategoriCtrl = TextEditingController();
  final _stokCtrl = TextEditingController();
  final _batasCtrl = TextEditingController();
  bool _loading = false;
  String? _generatedBarcode;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final api = ApiClient(useMock: AppConfig.useMockApi);
      final response = await api.post('/api/barang', data: {
        'nama_barang': _namaCtrl.text,
        'kategori': _kategoriCtrl.text,
        'stok': int.tryParse(_stokCtrl.text) ?? 0,
        'batas_minimum': int.tryParse(_batasCtrl.text) ?? 0,
      });
      
      if (mounted) {
        final responseData = response.data as Map<String, dynamic>;
        final barangData = responseData['data'] as Map<String, dynamic>?;
        setState(() {
          _generatedBarcode = barangData?['barcode'];
        });
        final t = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.translate('item_added'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _kategoriCtrl.dispose();
    _stokCtrl.dispose();
    _batasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(t.translate('add_item'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: InputDecoration(labelText: t.translate('item_name')),
                validator: (v) => v == null || v.isEmpty ? t.translate('required') : null,
              ),
              TextFormField(
                controller: _kategoriCtrl,
                decoration: InputDecoration(labelText: t.translate('category')),
                validator: (v) => v == null || v.isEmpty ? t.translate('required') : null,
              ),
              TextFormField(
                controller: _stokCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t.translate('stock')),
                validator: (v) => v == null || v.isEmpty ? t.translate('required') : null,
              ),
              TextFormField(
                controller: _batasCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t.translate('min_stock')),
                validator: (v) => v == null || v.isEmpty ? t.translate('required') : null,
              ),
              const SizedBox(height: 20),
              if (_generatedBarcode != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Barcode: $_generatedBarcode', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : Text(t.translate('submit')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
