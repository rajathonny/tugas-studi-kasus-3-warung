import 'package:flutter/material.dart';
import 'menu_item.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;
  final int jumlahPorsi;
  final ValueChanged<int> onJumlahChanged;
  final String? imgPath;

  const MenuCard({
    super.key,
    required this.item,
    required this.jumlahPorsi,
    required this.onJumlahChanged,
    this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHabis = !item.tersedia || item.stokTersisa <= 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(0),
      color: isHabis ? Colors.grey.shade200 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isHabis ? Colors.red.shade200 : Colors.teal.shade100,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.asset(
                      (imgPath ?? item.imgPath).trim(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.fastfood_rounded,
                            color: Colors.teal,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.kategori,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.namaMenu,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isHabis ? Colors.grey : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isHabis)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'HABIS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Rp ${item.harga}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isHabis ? Colors.grey : Colors.teal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sisa: ${item.stokTersisa} porsi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: item.stokTersisa < 3 ? Colors.orange.shade800 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            JumlahPorsi(
              isHabis: isHabis,
              maxPorsi: item.stokTersisa,
              jumlah: jumlahPorsi,
              onChanged: onJumlahChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class JumlahPorsi extends StatefulWidget {
  final bool isHabis;
  final int maxPorsi;
  final int jumlah;
  final ValueChanged<int> onChanged;

  const JumlahPorsi({
    super.key,
    required this.isHabis,
    required this.maxPorsi,
    required this.jumlah,
    required this.onChanged,
  });

  @override
  State<JumlahPorsi> createState() => _JumlahPorsiState();
}

class _JumlahPorsiState extends State<JumlahPorsi> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: Text(
            'Jumlah:',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: widget.isHabis || widget.jumlah <= 0
                  ? null
                  : () {
                      setState(() {
                        widget.onChanged(widget.jumlah - 1);
                      });
                    },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                '${widget.jumlah}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add_circle_outline),
              onPressed: widget.isHabis || widget.jumlah >= widget.maxPorsi
                  ? null
                  : () {
                      setState(() {
                        widget.onChanged(widget.jumlah + 1);
                      });
                    },
            ),
          ],
        ),
      ],
    );
  }
}
