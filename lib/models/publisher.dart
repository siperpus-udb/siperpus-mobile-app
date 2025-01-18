class Penerbit {
  final int idpenerbit;
  final String nama;
  final String alamat;
  final String nohp;

  Penerbit({
    required this.idpenerbit,
    required this.nama,
    required this.alamat,
    required this.nohp,
  });

  factory Penerbit.fromJson(Map<String, dynamic> json) {
    return Penerbit(
      idpenerbit: json['idpenerbit'],
      nama: json['nama'],
      alamat: json['alamat'],
      nohp: json['nohp']
    );
  }
}