class MenuItem {
  final String namaMenu;
  final String kategori;
  final int harga;
  bool tersedia;
  int stokTersisa;

  MenuItem({
    required this.namaMenu,
    required this.kategori,
    required this.harga,
    required this.tersedia,
    required this.stokTersisa,
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
  ),
  MenuItem(
    namaMenu: 'Mie Ayam Bakso',
    kategori: 'Makanan',
    harga: 14000,
    tersedia: true,
    stokTersisa: 8,
  ),
  MenuItem(
    namaMenu: 'Gado-Gado',
    kategori: 'Vegetarian',
    harga: 13000,
    tersedia: true,
    stokTersisa: 6,
  ),
  MenuItem(
    namaMenu: 'Ayam Bakar Taliwang',
    kategori: 'Makanan',
    harga: 25000,
    tersedia: true,
    stokTersisa: 4,
  ),
  MenuItem(
    namaMenu: 'Es Teh Manis',
    kategori: 'Minuman',
    harga: 6000,
    tersedia: true,
    stokTersisa: 20,
  ),
  MenuItem(
    namaMenu: 'Pisang Goreng Coklat',
    kategori: 'Dessert',
    harga: 8000,
    tersedia: true,
    stokTersisa: 15,
  ),
  MenuItem(
    namaMenu: 'Es Teh Manis',
    kategori: 'Minuman',
    harga: 5000,
    tersedia: true,
    stokTersisa: 20,),
  MenuItem(
    namaMenu: 'Es Teh Manis',
    kategori: 'Minuman',
    harga: 5000,
    tersedia: true,
    stokTersisa: 20,),
  MenuItem(
    namaMenu: 'Es Teh Manis',
    kategori: 'Minuman',
    harga: 5000,
    tersedia: true,
    stokTersisa: 20,)
  

];