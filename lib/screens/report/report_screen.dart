import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedFilter = 'Hari Ini';
  final List<String> _filters = [
    'Hari Ini',
    'Per Tanggal',
    'Per Bulan',
    'Semua'
  ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Filter Periode ===
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedFilter = filter);
                      },
                      selectedColor: const Color(0xFF2A9DFF),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // === Ringkasan Hari Ini ===
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Pendapatan',
                    amount: 'Rp 1.250.000',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Pengeluaran',
                    amount: 'Rp 350.000',
                    icon: Icons.trending_down,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // === Laporan Keuangan ===
            const Text(
              'Laporan Keuangan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFinanceRow('Omset', 'Rp 1.250.000', Colors.blue),
                    const Divider(),
                    _buildFinanceRow('Pendapatan', 'Rp 900.000', Colors.green),
                    const Divider(),
                    _buildFinanceRow('Pengeluaran', 'Rp 350.000', Colors.red),
                    const Divider(),
                    _buildFinanceRow('Piutang', 'Rp 150.000', Colors.orange),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // === Laporan Transaksi ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export Excel berhasil!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // List transaksi
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildTransactionItem(
                    name: 'Budi Santoso',
                    service: 'Cuci Setrika Kiloan',
                    amount: 'Rp 45.000',
                    status: 'Diambil',
                    date: '31 Mei 2026',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildTransactionItem(
                    name: 'Siti Nurhaliza',
                    service: 'Setrika Satuan',
                    amount: 'Rp 30.000',
                    status: 'Selesai',
                    date: '31 Mei 2026',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildTransactionItem(
                    name: 'Ahmad Dhani',
                    service: 'Cuci Lipat Kiloan',
                    amount: 'Rp 55.000',
                    status: 'Proses',
                    date: '30 Mei 2026',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // === Laporan Konsumen ===
            const Text(
              'Top Konsumen Bulan Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildCustomerItem('Budi Santoso', '12 order', 'Rp 540.000'),
                  const Divider(height: 1, indent: 60),
                  _buildCustomerItem('Siti Nurhaliza', '8 order', 'Rp 240.000'),
                  const Divider(height: 1, indent: 60),
                  _buildCustomerItem('Ahmad Dhani', '6 order', 'Rp 330.000'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  // === WIDGET BUILDER ===

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceRow(String label, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String name,
    required String service,
    required String amount,
    required String status,
    required String date,
  }) {
    Color statusColor;
    switch (status) {
      case 'Diambil':
        statusColor = Colors.green;
        break;
      case 'Selesai':
        statusColor = Colors.blue;
        break;
      case 'Proses':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(Icons.receipt, color: statusColor, size: 20),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$service • $date',
          style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(amount,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 2),
          Text(status, style: TextStyle(fontSize: 11, color: statusColor)),
        ],
      ),
    );
  }

  Widget _buildCustomerItem(String name, String orders, String total) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF2A9DFF).withOpacity(0.1),
        child: const Icon(Icons.person, color: Color(0xFF2A9DFF)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle:
          Text(orders, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      trailing: Text(total,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF2A9DFF))),
    );
  }
}
