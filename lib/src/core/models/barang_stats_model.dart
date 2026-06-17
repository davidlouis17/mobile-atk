class BarangStats {
  final int totalBarang;
  final int totalStok;
  final int barangMenipis;
  final int barangHabis;

  BarangStats({
    required this.totalBarang,
    required this.totalStok,
    required this.barangMenipis,
    required this.barangHabis,
  });

  factory BarangStats.fromJson(Map<String, dynamic> json) {
    return BarangStats(
      totalBarang: json['total_barang'] as int,
      totalStok: json['total_stok'] as int,
      barangMenipis: json['barang_menipis'] as int,
      barangHabis: json['barang_habis'] as int,
    );
  }
}