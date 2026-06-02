import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2A9DFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_laundry_service,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'NotaBe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A9DFF),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Laundry Bersih',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Cabang Utama',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[100],
                  child: const Icon(
                    Icons.store,
                    size: 18,
                    color: Color(0xFF2A9DFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // === INFO AKUN ===
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF2A9DFF),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipe Akun',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Basic',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Masa Aktif: 30 Hari',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showUpgradeDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2A9DFF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'UPGRADE AKUN',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // === MENU SETTING ===
            _buildMenuSection(
              title: 'Akun & Toko',
              items: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Profil',
                  subtitle: 'Edit nama, email, password',
                  onTap: () => _showSnackbar('Profil'),
                ),
                _buildMenuItem(
                  icon: Icons.store_outlined,
                  title: 'Toko',
                  subtitle: 'Profil toko & metode pembayaran',
                  onTap: () => _showSnackbar('Toko'),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'Konfigurasi',
              items: [
                _buildMenuItem(
                  icon: Icons.local_laundry_service_outlined,
                  title: 'Layanan',
                  subtitle: 'Kategori, jenis, harga, durasi',
                  onTap: () => _showSnackbar('Layanan'),
                ),
                _buildMenuItem(
                  icon: Icons.spa_outlined,
                  title: 'Parfum',
                  subtitle: 'Kelola pilihan parfum',
                  onTap: () => _showSnackbar('Parfum'),
                ),
                _buildMenuItem(
                  icon: Icons.discount_outlined,
                  title: 'Diskon',
                  subtitle: 'Event promo & potongan harga',
                  onTap: () => _showSnackbar('Diskon'),
                ),
                _buildMenuItem(
                  icon: Icons.person_add_outlined,
                  title: 'Kasir',
                  subtitle: 'Tambah & atur akses kasir',
                  onTap: () => _showSnackbar('Kasir'),
                ),
                _buildMenuItem(
                  icon: Icons.people_outline,
                  title: 'Konsumen',
                  subtitle: 'Kelola data konsumen',
                  onTap: () => _showSnackbar('Konsumen'),
                ),
                _buildMenuItem(
                  icon: Icons.print_outlined,
                  title: 'Printer',
                  subtitle: 'Konfigurasi nota & struk',
                  onTap: () => _showSnackbar('Printer'),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'Lainnya',
              items: [
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'Tentang Developer',
                  subtitle: 'Kontak & bantuan',
                  onTap: () => _showSnackbar('Developer'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === LOGOUT ===
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Konfirmasi Logout'),
                      content: const Text('Anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSnackbar('Logout berhasil');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Logout',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  // === HELPER WIDGETS ===

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A9DFF).withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF2A9DFF), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upgrade Akun',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Paket Basic
              _buildPackageCard(
                title: 'Basic',
                price: 'Rp 18.000',
                period: '30 Hari',
                color: Colors.blue,
                features: ['Fitur dasar', '1 cabang', '1 kasir'],
              ),
              const SizedBox(height: 12),

              // Paket Premium
              _buildPackageCard(
                title: 'Premium',
                price: 'Rp 49.000',
                period: '90 Hari',
                color: const Color(0xFF2A9DFF),
                features: ['Semua fitur', '3 cabang', '3 kasir', 'Export data'],
                isPopular: true,
              ),
              const SizedBox(height: 12),

              // Paket Exclusive
              _buildPackageCard(
                title: 'Exclusive',
                price: 'Rp 175.000',
                period: '1 Tahun',
                color: Colors.purple,
                features: [
                  'Semua fitur',
                  'Unlimited cabang',
                  'Unlimited kasir',
                  'Priority support'
                ],
              ),

              const SizedBox(height: 20),
              Text(
                'Pembayaran via Midtrans',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPackageCard({
    required String title,
    required String price,
    required String period,
    required Color color,
    required List<String> features,
    bool isPopular = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? color : Colors.grey[200]!,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                    if (isPopular) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'POPULER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(price,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: color)),
                Text(period,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const SizedBox(height: 8),
                ...features.map((f) => Text('• $f',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              int durationDays = title == 'Basic'
                  ? 30
                  : title == 'Premium'
                      ? 90
                      : 365;
              int price = title == 'Basic'
                  ? 18000
                  : title == 'Premium'
                      ? 49000
                      : 175000;

              final result = await ApiService.upgradeAccount(
                userId: 1,
                packageName: title,
                price: price,
                durationDays: durationDays,
              );

              if (mounted) {
                _showSnackbar(result['message'] ?? 'Upgrade berhasil!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Pilih'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF2A9DFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
