class MenuItem {
  final String namaMenu;
  final String kategori;
  final int harga;
  bool tersedia;
  int stokTersisa;
  final String imgPath;

  MenuItem({
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    required this.stokTersisa,
    required this.imgPath,
  });
  
  double hitungTotalHarga(int porsi) {
    double total = (harga * porsi).toDouble();
    if (porsi >= 5) {
      total *= 0.90; // Diskon 10%
    }
    return total;
  }

  bool stokTersedia(int porsi) {
    if (!tersedia || stokTersisa <= 0) return false;
    if (porsi > stokTersisa) return false;
    return true;
  }
}

List<MenuItem> menuItems = [
  MenuItem(
    namaMenu: 'Nasi Goreng Spesial',
    kategori: 'Makanan',
    harga: 18000,
    tersedia: true,
    stokTersisa: 12,
    imgPath: 'assets/images/nasgor.webp',
  ),
  MenuItem(
    namaMenu: 'Mie Ayam Bakso',
    kategori: 'Makanan',
    harga: 14000,
    tersedia: true,
    stokTersisa: 999,
    imgPath: 'assets/images/mie ayam.webp',
  ),
  MenuItem(
    namaMenu: 'Gado-Gado',
    kategori: 'Makanan',
    harga: 13000,
    tersedia: true,
    stokTersisa: 6,
    imgPath: 'assets/images/Gado_gado.jpg',
  ),
  MenuItem(
    namaMenu: 'Ayam Bakar Taliwang',
    kategori: 'Makanan',
    harga: 25000,
    tersedia: true,
    stokTersisa: 0,
    imgPath: 'assets/images/images.jpg',
  ),
  MenuItem(
    namaMenu: 'Es Teh jumbo',
    kategori: 'Minuman',
    harga: 6000,
    tersedia: true,
    stokTersisa: 20,
    imgPath: 'assets/images/esteh.webp',
  ),
  MenuItem(
    namaMenu: 'Pisang Goreng Coklat',
    kategori: 'Cemilan',
    harga: 8000,
    tersedia: true,
    stokTersisa: 15,
    imgPath: 'assets/images/pisang goreng.jpg',
  ),
];

List<MenuItem> getDaftarMenuAwal() {
  return menuItems;
}

