import 'package:flutter/material.dart';

void main() {
  runApp(const BukuApp());
}

class BukuApp extends StatelessWidget {
  const BukuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Buku Perpustakaan Mini',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const CatalogPage(),
    );
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  // 1. Koleksi List<Map<String, dynamic>> minimal 6 buku (Kriteria Data & Map)
  final List<Map<String, dynamic>> _daftarBuku = [
    {
      'judul': 'Pemrograman Dart dan Flutter',
      'pengarang': 'Eko Kurniawan',
      'tahunTerbit': 2023,
      'rating': 4.8,
      'tersedia': true,
      'genre': 'Teknologi',
    },
    {
      'judul': 'Algoritma & Struktur Data',
      'pengarang': 'Rian Hidayat',
      'tahunTerbit': 2021,
      'rating': 4.2,
      'tersedia': false,
      'genre': 'Teknologi',
    },
    {
      'judul': 'Belajar Basis Data SQL',
      'pengarang': 'Siti Aminah',
      'tahunTerbit': 2020,
      'rating': 3.8,
      'tersedia': true,
      'genre': 'Teknologi',
    },
    {
      'judul': 'Laskar Pelangi',
      'pengarang': 'Andrea Hirata',
      'tahunTerbit': 2005,
      'rating': 4.7,
      'tersedia': true,
      'genre': 'Novel',
    },
    {
      'judul': 'Filosofi Teras',
      'pengarang': 'Henry Manampiring',
      'tahunTerbit': 2018,
      'rating': 4.6,
      'tersedia': false,
      'genre': 'Self Improvement',
    },
    {
      'judul': 'Sejarah Dunia yang Disembunyikan',
      'pengarang': 'Jonathan Black',
      'tahunTerbit': 2007,
      'rating': 3.2,
      'tersedia': true,
      'genre': 'Sejarah',
    },
  ];

  String _searchQuery = '';

  // 2. Fungsi kategoriRating dengan if/else
  String kategoriRating(double rating) {
    if (rating >= 4.5) {
      return 'Sangat Baik';
    } else if (rating >= 3.5) {
      return 'Baik';
    } else {
      return 'Cukup';
    }
  }

  // Fungsi tambahan untuk memenuhi kriteria fungsi 20%
  Set<String> _getUniqueGenres() {
    return _daftarBuku.map((buku) => buku['genre'] as String).toSet();
  }

  @override
  Widget build(BuildContext context) {
    // Penggunaan Set<String> untuk genre unik
    final Set<String> daftarGenre = _getUniqueGenres();

    // Filter buku berdasarkan judul menggunakan .where()
    final bukuFiltered = _daftarBuku.where((buku) {
      final judul = buku['judul'].toString().toLowerCase();
      return judul.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku Perpustakaan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter TextField pencarian
            TextField(
              decoration: InputDecoration(
                labelText: 'Cari Judul Buku',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // Menampilkan Genre Unik menggunakan Set, Wrap, dan Chip
            const Text(
              'Genre Tersedia:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8.0,
              children: daftarGenre.map((genre) {
                return Chip(
                  label: Text(genre),
                  backgroundColor: const Color.fromARGB(255, 198, 201, 221),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Tampilkan daftar buku dengan ListView.builder
            Expanded(
              child: bukuFiltered.isEmpty
                  ? const Center(child: Text('Buku tidak ditemukan'))
                  : ListView.builder(
                      itemCount: bukuFiltered.length,
                      itemBuilder: (context, index) {
                        final buku = bukuFiltered[index];
                        final isTersedia = buku['tersedia'] as bool;

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              buku['judul'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Pengarang: ${buku['pengarang']}'),
                                Text('Tahun Terbit: ${buku['tahunTerbit']}'),
                                Text(
                                  'Rating: ${buku['rating']} (${kategoriRating(buku['rating'])})',
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Kontrol Alur (ternary) untuk Badge Status
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isTersedia
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isTersedia ? 'Tersedia' : 'Dipinjam',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 24, 24, 24),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigasi ke Halaman Detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailBukuPage(buku: buku),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Detail (StatefulWidget)
class DetailBukuPage extends StatefulWidget {
  final Map<String, dynamic> buku;

  const DetailBukuPage({super.key, required this.buku});

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  // Field String? catatanPeminjam yang NULLABLE
  String? catatanPeminjam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.buku['judul'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.buku['judul'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Pengarang: ${widget.buku['pengarang']}'),
            Text('Tahun Terbit: ${widget.buku['tahunTerbit']}'),
            Text('Genre: ${widget.buku['genre']}'),
            Text('Rating: ${widget.buku['rating']}'),
            const Divider(height: 30),
            const Text(
              'Catatan Peminjam:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Penerapan Operator ?? untuk Null Safety
            Text(
              catatanPeminjam ?? '(Tidak ada catatan)',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: catatanPeminjam == null
                    ? const Color.fromARGB(255, 211, 203, 203)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
