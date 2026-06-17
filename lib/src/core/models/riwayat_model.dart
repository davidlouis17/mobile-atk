class Riwayat {
  final int id;
  final int barangId;
  final String tipe; // masuk/keluar
  final int jumlah;
  final String keterangan;
  final DateTime createdAt;

  Riwayat({required this.id, required this.barangId, required this.tipe, required this.jumlah, required this.keterangan, required this.createdAt});

  factory Riwayat.fromJson(Map<String, dynamic> json) {
    return Riwayat(
      id: json['id'] as int,
      barangId: json['barang_id'] as int,
      tipe: json['tipe'] as String,
      jumlah: json['jumlah'] as int,
      keterangan: json['keterangan'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
