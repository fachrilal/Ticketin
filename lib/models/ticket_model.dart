class Ticket {
  final String id;
  final String namaTicket;
  final int harga;
  final String kategori;
  final DateTime tanggal;

  Ticket({
    required this.id,
    required this.namaTicket,
    required this.harga,
    required this.kategori,
    required this.tanggal,
  });

  factory Ticket.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Ticket(
      id: documentId,
      namaTicket: data['nama_tiket'] ?? '',
      harga: data['harga'] ?? 0,
      kategori: data['kategori'] ?? '',
      tanggal: data['tanggal']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nama_tiket': namaTicket,
      'harga': harga,
      'kategori': kategori,
      'tanggal': tanggal,
    };
  }

  String get formattedPrice {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}



