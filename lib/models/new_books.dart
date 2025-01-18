class BukuMasuk {
  final int idtrans;
  final String idbuku;
  final String idpenerbit;
  final int jumlah;

  BukuMasuk({
    required this.idtrans,
    required this.idbuku,
    required this.idpenerbit,
    required this.jumlah,
  });

  factory BukuMasuk.fromJson(Map<String, dynamic> json) {
    return BukuMasuk(
      idtrans: json['idtrans'],
      idbuku: json['idbuku'],
      idpenerbit: json['idpenerbit'],
      jumlah: json['jumlah'],
    );
  }
}
