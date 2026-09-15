import 'package:flutter/material.dart';
import 'menu_item.dart';
import 'menu_card.dart';

void main() {
  runApp(const AplikasiWarungApp());
}

class AplikasiWarungApp extends StatelessWidget {
  const AplikasiWarungApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Makan Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
      ),
      home: const HalamanMenuWarung(),
    );
  }
}

class HalamanMenuWarung extends StatefulWidget {
  const HalamanMenuWarung({super.key});

  @override
  State<HalamanMenuWarung> createState() => _HalamanMenuWarungState();
}

class _HalamanMenuWarungState extends State<HalamanMenuWarung> {
  late List<MenuItem> _semuaMenu;
  late TextEditingController _searchController;

  String _pencarian = '';
  String _kategoriDipilih = 'Semua'; // Untuk Fitur F2 (Saring Kategori)
  bool _urutkanHargaTermurah = true; // Untuk Fitur F1 (Urutkan)

  // Map untuk menyimpan jumlah porsi yang dipesan tiap index menu
  final Map<int, int> _jumlahPesanan = {};

  @override
  void initState() {
    super.initState();
    _semuaMenu = getDaftarMenuAwal();
    // Controller dibuat di initState
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _pencarian = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    // Controller dibuang di dispose
    _searchController.dispose();
    super.dispose();
  }

  // Menghitung Total Biaya Seluruh Pesanan (Khas 1 & Aturan Usaha 1)
  double _hitungTotalKeseluruhan() {
    double total = 0;
    for (int i = 0; i < _semuaMenu.length; i++) {
      int porsi = _jumlahPesanan[i] ?? 0;
      if (porsi > 0) {
        total += _semuaMenu[i].hitungTotalHarga(porsi);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Saring data berdasarkan pencarian (Khas 2) dan kategori (F2)
    List<MenuItem> listFilter = _semuaMenu.where((item) {
      bool cocokPencarian = item.namaMenu.toLowerCase().contains(_pencarian.toLowerCase());
      bool cocokKategori = _kategoriDipilih == 'Semua' || item.kategori == _kategoriDipilih;
      return cocokPencarian && cocokKategori;
    }).toList();

    // Fitur F1: Urutkan Berdasarkan Harga (Termurah ke Termahal atau Sebaliknya)
    listFilter.sort((a, b) {
      return _urutkanHargaTermurah
          ? a.harga.compareTo(b.harga)
          : b.harga.compareTo(a.harga);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go-Warung', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Kotak Pencarian (Khas 2)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama menu...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _pencarian.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // 2. Bagian Fitur Pilihan F1 & F2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                // F2: Deretan Tombol Kategori
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Makanan', 'Minuman', 'Cemilan'].map((kat) {
                      bool isSelected = _kategoriDipilih == kat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(kat),
                          selected: isSelected,
                          selectedColor: Colors.teal,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (val) {
                            setState(() {
                              _kategoriDipilih = kat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // F1: Tombol Urutkan Harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menampilkan: ${listFilter.length} menu',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      icon: Icon(
                        _urutkanHargaTermurah ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                      ),
                      label: Text(
                        _urutkanHargaTermurah ? 'Harga: Murah > Mahal' : 'Harga: Mahal > Murah',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          _urutkanHargaTermurah = !_urutkanHargaTermurah;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 3. Grid Responsif Menggunakan LayoutBuilder & GridView.builder
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Aturan Ketentuan Responsif
                int crossAxisCount = 1;
                if (constraints.maxWidth >= 900) {
                  crossAxisCount = 3; // 900 ke atas: 3 kolom
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 2; // 600 - 899: 2 kolom
                } else {
                  crossAxisCount = 1; // < 600: 1 kolom
                }

                if (listFilter.isEmpty) {
                  return const Center(
                    child: Text('Menu tidak ditemukan.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: constraints.maxWidth < 600 ? 1.8 : 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: listFilter.length,
                  itemBuilder: (context, index) {
                    final item = listFilter[index];
                    int meIndex = _semuaMenu.indexOf(item);

                    return MenuCard(
                      item: item,
                      jumlahPorsi: _jumlahPesanan[meIndex] ?? 0,
                      onJumlahChanged: (baru) {
                        setState(() {
                          _jumlahPesanan[meIndex] = baru;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),

          // 4. Bagian Bottom Bar untuk Total Pesanan (Khas 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total Pesanan:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'Rp ${_hitungTotalKeseluruhan().toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _hitungTotalKeseluruhan() == 0
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pesanan berhasil dibuat!'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        },
                  child: const Text('Pesan Sekarang'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}