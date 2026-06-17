class Barang {
  final int id;
  final String namaBarang;
  final String kategori;
  final int stok;
  final int batasMinimum;
  final String status;
  final String? barcode;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.kategori,
    required this.stok,
    required this.batasMinimum,
    required this.status,
    this.barcode,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'] as int,
      namaBarang: json['nama_barang'] as String,
      kategori: json['kategori'] as String,
      stok: json['stok'] as int,
      batasMinimum: json['batas_minimum'] as int,
      status: json['status'] as String? ?? 'aman',
      barcode: json['barcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori': kategori,
      'stok': stok,
      'batas_minimum': batasMinimum,
      'status': status,
      'barcode': barcode,
    };
  }
}
