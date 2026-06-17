import 'package:dio/dio.dart';

class MockApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;

    if (path.contains('/api/login')) {
      return handler.resolve(Response(
        data: {'token': 'mock-token-jwt-12345-abcde'},
        statusCode: 200,
        requestOptions: options,
      ));
    }

    if (path.contains('/api/barang/stats') && options.method == 'GET') {
      return handler.resolve(Response(
        data: {
          'total_barang': 5,
          'total_stok': 255,
          'barang_menipis': 2,
          'barang_habis': 1,
        },
        statusCode: 200,
        requestOptions: options,
      ));
    }

    // Handle search by barcode (q=) or name/category/id
    if (options.queryParameters.containsKey('q')) {
      final q = options.queryParameters['q'].toString().toLowerCase();
      final allBarangs = _getAllBarangs();
      
      // Try to match by ID (if q is numeric) or barcode or name/category
      Map<String, dynamic>? found;
      if (int.tryParse(q) != null) {
        found = allBarangs.where((b) => b['id'].toString() == q).firstOrNull;
      } else {
        found = allBarangs.where((b) => 
          b['nama_barang']!.toString().toLowerCase().contains(q) ||
          b['kategori']!.toString().toLowerCase().contains(q) ||
          (b['barcode'] != null && b['barcode']!.toString().toLowerCase().contains(q))
        ).firstOrNull;
      }
      
      if (found != null) {
        return handler.resolve(Response(
          data: [found],
          statusCode: 200,
          requestOptions: options,
        ));
      }
      
      return handler.resolve(Response(
        data: [],
        statusCode: 200,
        requestOptions: options,
      ));
    }

    // Mock barang list
    if ((path == '/api/barang' || path == '/api/barang/') && options.method == 'GET') {
      return handler.resolve(Response(
        data: _getAllBarangs(),
        statusCode: 200,
        requestOptions: options,
      ));
    }

    // Generate auto barcode
    String _generateBarcode(String kategori, String namaBarang) {
      final katCode = kategori.isNotEmpty ? kategori.substring(0, kategori.length < 3 ? kategori.length : 3).toUpperCase() : 'X';
      final namaCode = namaBarang.isNotEmpty ? namaBarang.substring(0, namaBarang.length < 3 ? namaBarang.length : 3).toUpperCase() : 'Y';
      final random = (100 + DateTime.now().millisecond) % 900;
      return '$katCode-$namaCode-$random';
    }

    // Mock create barang
    if (path == '/api/barang' && options.method == 'POST') {
      final barcode = options.data?['barcode'] as String? ?? _generateBarcode(
        options.data?['kategori'] ?? '',
        options.data?['nama_barang'] ?? 'New Item',
      );
      return handler.resolve(Response(
        data: {
          'id': 999,
          'nama_barang': options.data?['nama_barang'] ?? 'New Item',
          'kategori': options.data?['kategori'] ?? '',
          'stok': options.data?['stok'] ?? 0,
          'batas_minimum': options.data?['batas_minimum'] ?? 0,
          'barcode': barcode,
          'status': 'aman',
        },
        statusCode: 201,
        requestOptions: options,
      ));
    }

    // Mock riwayat stok per barang
    if (path.contains('/api/riwayat') && options.method == 'GET') {
      final barangIdParam = options.queryParameters['barang_id'];
      final allRiwayats = [
        {
          'id': 1,
          'barang_id': 1,
          'tipe': 'masuk',
          'jumlah': 50,
          'keterangan': 'Pembelian awal',
          'created_at': '2026-06-10T10:00:00Z',
        },
        {
          'id': 2,
          'barang_id': 1,
          'tipe': 'keluar',
          'jumlah': 5,
          'keterangan': 'Penggunaan kantor',
          'created_at': '2026-06-11T14:30:00Z',
        },
      ];
      final results = barangIdParam != null
          ? allRiwayats.where((r) => r['barang_id'] == barangIdParam).toList()
          : allRiwayats;
      return handler.resolve(Response(
        data: results,
        statusCode: 200,
        requestOptions: options,
      ));
    }

    // Mock create riwayat (input stok)
    if (path.contains('/api/riwayat') && options.method == 'POST') {
      return handler.resolve(Response(
        data: {
          'success': true,
          'message': 'Stok berhasil diperbarui',
          'id': 999,
        },
        statusCode: 201,
        requestOptions: options,
      ));
    }

    return handler.next(options);
  }
}

List<Map<String, dynamic>> _getAllBarangs() => [
  {
    'id': 1,
    'nama_barang': 'Kertas A4',
    'kategori': 'Kertas',
    'stok': 50,
    'batas_minimum': 10,
    'barcode': 'BRG001',
    'status': 'aman',
  },
  {
    'id': 2,
    'nama_barang': 'Tinta Ballpoint Biru',
    'kategori': 'Tinta',
    'stok': 3,
    'batas_minimum': 5,
    'barcode': 'BRG002',
    'status': 'menipis',
  },
  {
    'id': 3,
    'nama_barang': 'Stapler',
    'kategori': 'Alat Tulis',
    'stok': 0,
    'batas_minimum': 2,
    'barcode': 'BRG003',
    'status': 'habis',
  },
  {
    'id': 4,
    'nama_barang': 'Klip Kertas',
    'kategori': 'Alat Tulis',
    'stok': 200,
    'batas_minimum': 50,
    'barcode': 'BRG004',
    'status': 'aman',
  },
  {
    'id': 5,
    'nama_barang': 'Penggaris Besi',
    'kategori': 'Alat Tulis',
    'stok': 2,
    'batas_minimum': 3,
    'barcode': 'BRG005',
    'status': 'menipis',
  },
];
