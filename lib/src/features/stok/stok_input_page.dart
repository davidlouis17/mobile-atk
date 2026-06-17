import 'package:atk_mobile/src/config/app_config.dart';
import 'package:atk_mobile/src/core/network/api_client.dart';
import 'package:atk_mobile/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class StokInputPage extends StatefulWidget {
  final int barangId;
  final String namaBarang;

  const StokInputPage({super.key, required this.barangId, required this.namaBarang});

  @override
  State<StokInputPage> createState() => _StokInputPageState();
}

class _StokInputPageState extends State<StokInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahCtrl = TextEditingController();
  final _keteranganCtrl = TextEditingController();
  String _tipe = 'masuk';
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final jumlah = int.tryParse(_jumlahCtrl.text) ?? 0;
    final keterangan = _keteranganCtrl.text.trim();
    try {
      final api = ApiClient(useMock: AppConfig.useMockApi);
      await api.post('/api/riwayat', data: {
        'barang_id': widget.barangId,
        'tipe': _tipe,
        'jumlah': jumlah,
        'keterangan': keterangan,
      });
      if (mounted) {
        final t = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.translate('stok_updated'))));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    _keteranganCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('${t.translate('stock_input')} - ${widget.namaBarang}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(t.translate('masuk')),
                      value: 'masuk',
                      groupValue: _tipe,
                      onChanged: (v) => setState(() => _tipe = v!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(t.translate('keluar')),
                      value: 'keluar',
                      groupValue: _tipe,
                      onChanged: (v) => setState(() => _tipe = v!),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _jumlahCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t.translate('jumlah')),
                validator: (v) => v == null || v.isEmpty ? t.translate('required') : null,
              ),
              TextFormField(
                controller: _keteranganCtrl,
                decoration: InputDecoration(labelText: t.translate('keterangan')),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : Text(t.translate('submit')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
