import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return loc ?? AppLocalizations(const Locale('en'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'dashboard': 'Dashboard',
      'scan': 'Scan',
      'not_found': 'Item not found',
      'stok_updated': 'Stock updated successfully',
      'login_failed': 'Login failed',
      'submit': 'Submit',
      'close': 'Close',
      'stock_input': 'Stock input',
      'history': 'History',
      'no_history': 'No history available',
      'masuk': 'In',
      'keluar': 'Out',
      'total_items': 'Total Items',
      'total_stock': 'Total Stock',
      'low_stock': 'Low Stock',
      'out_of_stock': 'Out of Stock',
      'search': 'Search',
      'add_item': 'Add Item',
      'item_name': 'Item Name',
      'category': 'Category',
      'stock': 'Stock',
      'min_stock': 'Min Stock',
      'required': 'Required',
      'item_added': 'Item added successfully',
      'no_items': 'No items found',
      'jumlah': 'Quantity',
      'keterangan': 'Description',
    },
    'id': {
      'login': 'Masuk',
      'email': 'Email',
      'password': 'Kata sandi',
      'dashboard': 'Dashboard Stok',
      'scan': 'Pindai',
      'not_found': 'Barang tidak ditemukan',
      'stok_updated': 'Stok berhasil diperbarui',
      'login_failed': 'Gagal masuk',
      'submit': 'Kirim',
      'close': 'Tutup',
      'stock_input': 'Input Stok',
      'history': 'Riwayat',
      'no_history': 'Tidak ada riwayat',
      'masuk': 'Masuk',
      'keluar': 'Keluar',
      'total_items': 'Total Barang',
      'total_stock': 'Total Stok',
      'low_stock': 'Stok Menipis',
      'out_of_stock': 'Stok Habis',
      'search': 'Cari',
      'add_item': 'Tambah Barang',
      'item_name': 'Nama Barang',
      'category': 'Kategori',
      'stock': 'Stok',
      'min_stock': 'Batas Minimum',
      'required': 'Wajib diisi',
      'item_added': 'Barang berhasil ditambah',
      'no_items': 'Tidak ada barang',
      'jumlah': 'Jumlah',
      'keterangan': 'Keterangan',
    }
  };

  String translate(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
