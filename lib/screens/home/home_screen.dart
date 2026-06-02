import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/add_transaction_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _dashboardData = {
    'omzet': '0',
    'masuk': 0,
    'harusSelesai': 0,
    'terlambat': 0,
    'orders': []
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final data = await ApiService.getDashboard();
    if (mounted) {
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final omzet = _dashboardData['omzet'] ?? '0';
    final masuk = _dashboardData['masuk'] ?? 0;
    final harusSelesai = _dashboardData['harusSelesai'] ?? 0;
    final terlambat = _dashboardData['terlambat'] ?? 0;
    final orders = _dashboardData['orders'] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFF2A9DFF),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.local_laundry_service,
                  size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NotaBe',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A9DFF))),
                Text('Nota Rapih, Bisnis Lancar',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
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
                    Text('Laundry Bersih',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    Text('Cabang Utama',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[100],
                    child: const Icon(Icons.store,
                        size: 18, color: Color(0xFF2A9DFF))),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2A9DFF)))
          : RefreshIndicator(
              onRefresh: _loadDashboard,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu Omzet
                    Card(
                      color: const Color(0xFF2A9DFF),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet,
                                        color: Colors.white70, size: 20),
                                    SizedBox(width: 8),
                                    Text('Total Omzet Hari Ini',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70)),
                                  ],
                                ),
                                Text('Rp $omzet',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                            const Divider(color: Colors.white24, height: 30),
                            Row(
                              children: [
                                _buildStatItem(
                                    icon: Icons.download,
                                    label: 'Masuk',
                                    value: '$masuk',
                                    color: Colors.lightBlueAccent,
                                    onTap: () =>
                                        _showSnackbar('Orderan Masuk')),
                                _buildDivider(),
                                _buildStatItem(
                                    icon: Icons.access_time,
                                    label: 'Harus Selesai',
                                    value: '$harusSelesai',
                                    color: Colors.orangeAccent,
                                    onTap: () =>
                                        _showSnackbar('Harus Selesai')),
                                _buildDivider(),
                                _buildStatItem(
                                    icon: Icons.warning_amber,
                                    label: 'Terlambat',
                                    value: '$terlambat',
                                    color: Colors.redAccent,
                                    onTap: () => _showSnackbar('Terlambat')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4 Menu Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _buildMenuCard(
                          icon: Icons.add_circle_outline,
                          label: 'Tambah Transaksi',
                          color: const Color(0xFF2A9DFF),
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const AddTransactionSheet(),
                            );
                            if (result == true) {
                              _loadDashboard();
                            }
                          },
                        ),
                        _buildMenuCard(
                            icon: Icons.receipt_long_outlined,
                            label: 'Lihat Order',
                            color: const Color(0xFF1565C0),
                            onTap: () => _showSnackbar('Lihat Order')),
                        _buildMenuCard(
                            icon: Icons.money_off,
                            label: 'Input Pengeluaran',
                            color: Colors.red[700]!,
                            onTap: () => _showSnackbar('Input Pengeluaran')),
                        _buildMenuCard(
                            icon: Icons.bar_chart_outlined,
                            label: 'Laporan Hari Ini',
                            color: const Color(0xFFE65100),
                            onTap: () => _showSnackbar('Laporan Hari Ini')),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Order Terbaru
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order Terbaru',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        TextButton(
                            onPressed: () => _showSnackbar('Lihat Semua'),
                            child: const Text('Lihat Semua')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (orders.isEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                              child: Text('Belum ada order hari ini',
                                  style: TextStyle(color: Colors.grey))),
                        ),
                      )
                    else
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                            children: List.generate(orders.length,
                                (i) => _buildOrderItem(orders[i]))),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildStatItem(
      {required IconData icon,
      required String label,
      required String value,
      required Color color,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(value,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 2),
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() =>
      Container(width: 1, height: 50, color: Colors.white24);

  Widget _buildMenuCard(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 28)),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: color, fontSize: 13),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(dynamic order) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(Icons.person, color: Colors.blue)),
      title: Text(order['customer_name'] ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text('${order['status'] ?? ''} • ${order['entry_date'] ?? ''}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Text('Rp ${order['total_amount'] ?? '0'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF2A9DFF),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }
}
