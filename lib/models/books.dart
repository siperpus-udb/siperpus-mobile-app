class Buku {
  final int idbuku;
  final String nama;
  final int harga;
  final int stok;

  Buku({required this.idbuku, required this.nama, required this.harga, required this.stok});

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      idbuku: json['idbuku'],
      nama: json['nama'],
      harga: json['harga'],
      stok: json['stok'],
    );
  }
}