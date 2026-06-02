import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/bottom_nav.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Semua',
    'Masuk',
    'Proses',
    'Selesai',
    'Diambil',
    'Batal'
  ];
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadOrders();
      }
    });
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final status = _tabs[_tabController.index];
    final data = await ApiService.getTransactions(
        status: status == 'Semua' ? null : status);
    if (mounted) {
      setState(() {
        _orders = data;
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Masuk':
        return Colors.blue;
      case 'Proses':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Diambil':
        return Colors.purple;
      case 'Batal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateStatus(dynamic order, String newStatus) async {
    await ApiService.updateStatus(order['id'], newStatus);
    _loadOrders();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Status diubah ke $newStatus'),
            backgroundColor: Colors.green),
      );
    }
  }

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
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.local_laundry_service,
                  size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('NotaBe',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A9DFF))),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF2A9DFF),
          labelColor: const Color(0xFF2A9DFF),
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('Tidak ada order',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[400])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) =>
                        _buildOrderCard(_orders[index]),
                  ),
                ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    final status = order['status'] ?? '';
    final color = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showOrderDetail(order),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.person, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['customer_name'] ?? 'N/A',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('INV: ${order['invoice_number'] ?? '-'}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text('${order['entry_date'] ?? '-'}',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[500])),
                        const SizedBox(width: 12),
                        Icon(Icons.timer, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text('${order['estimated_completion'] ?? '-'}',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rp ${order['total_amount'] ?? '0'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(status,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetail(dynamic order) {
    final status = order['status'] ?? '';
    final color = _getStatusColor(status);

    List<String> nextStatuses = [];
    if (status == 'Masuk') nextStatuses = ['Proses', 'Batal'];
    if (status == 'Proses') nextStatuses = ['Selesai', 'Batal'];
    if (status == 'Selesai') nextStatuses = ['Diambil'];
    if (status == 'Batal') nextStatuses = [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text(order['customer_name'] ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _detailRow('No. Invoice', order['invoice_number'] ?? '-'),
              _detailRow('Tanggal Masuk', '${order['entry_date'] ?? '-'}'),
              _detailRow('Estimasi Selesai',
                  '${order['estimated_completion'] ?? '-'}'),
              _detailRow('Total', 'Rp ${order['total_amount'] ?? '0'}'),
              _detailRow('Status', status),
              _detailRow('Catatan', order['notes'] ?? '-'),
              const SizedBox(height: 16),
              if (nextStatuses.isNotEmpty) ...[
                const Text('Ubah Status:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: nextStatuses
                      .map((s) => ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _updateStatus(order, s);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _getStatusColor(s)),
                            child: Text(s,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
