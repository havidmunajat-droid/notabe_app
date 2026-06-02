import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  // Data dari API
  List<dynamic> _customers = [];
  List<dynamic> _services = [];

  // State form
  dynamic _selectedCustomer;
  List<Map<String, dynamic>> _selectedServices = [];
  String _selectedCategory = 'Semua';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final customers = await ApiService.getCustomers();
    final services = await ApiService.getServices();
    if (mounted) {
      setState(() {
        _customers = customers;
        _services = services;
        _isLoading = false;
      });
    }
  }

  double get _totalAmount {
    return _selectedServices.fold(
        0, (sum, item) => sum + (item['subtotal'] as double));
  }

  List<dynamic> get _filteredServices {
    if (_selectedCategory == 'Semua') return _services;
    return _services.where((s) => s['category'] == _selectedCategory).toList();
  }

  List<String> get _categories {
    final cats =
        _services.map((s) => s['category'].toString()).toSet().toList();
    return ['Semua', ...cats];
  }

  Future<void> _saveTransaction() async {
    if (_selectedCustomer == null) {
      _showSnackbar('Pilih pelanggan dulu!', Colors.red);
      return;
    }
    if (_selectedServices.isEmpty) {
      _showSnackbar('Pilih layanan dulu!', Colors.red);
      return;
    }

    final invoiceNumber =
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final result = await ApiService.createTransaction(
      customerId: _selectedCustomer['id'],
      invoiceNumber: invoiceNumber,
      totalAmount: _totalAmount,
    );

    if (mounted) {
      if (result['transaction'] != null) {
        _showSnackbar('Transaksi berhasil!', Colors.green);
        Navigator.pop(context, true);
      } else {
        _showSnackbar('Gagal menyimpan', Colors.red);
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Handle
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tambah Transaksi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pilih Pelanggan
                        const Text('Pilih Pelanggan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _customers.isEmpty
                            ? Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const Text('Belum ada pelanggan'),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _showAddCustomerDialog(),
                                        icon: const Icon(Icons.add, size: 18),
                                        label: const Text('Tambah Pelanggan'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DropdownButtonFormField<dynamic>(
                                value: _selectedCustomer,
                                items: _customers
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(
                                              '${c['name']} - ${c['phone']}'),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedCustomer = val),
                                decoration: const InputDecoration(
                                  hintText: 'Pilih pelanggan',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),

                        const SizedBox(height: 24),

                        // Pilih Kategori
                        const Text('Kategori Layanan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _categories
                                .map((cat) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        label: Text(cat),
                                        selected: _selectedCategory == cat,
                                        onSelected: (_) => setState(
                                            () => _selectedCategory = cat),
                                        selectedColor: const Color(0xFF2A9DFF),
                                        labelStyle: TextStyle(
                                            color: _selectedCategory == cat
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // List Layanan
                        ...(_filteredServices.map((service) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                    '${service['product_name']} (${service['service_name']})'),
                                subtitle: Text(
                                    'Rp ${service['price']} • ${service['duration_hours']} jam'),
                                trailing: ElevatedButton(
                                  onPressed: () => _addServiceToCart(service),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2A9DFF),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                  ),
                                  child: const Text('Pilih',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                ),
                              ),
                            ))),

                        const SizedBox(height: 24),

                        // Ringkasan Pesanan
                        if (_selectedServices.isNotEmpty) ...[
                          const Text('Pesanan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          ...(_selectedServices.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;
                            return Card(
                              child: ListTile(
                                title: Text(
                                    '${item['product_name']} (${item['service_name']})'),
                                subtitle: Text(
                                    '${item['quantity']} x Rp ${item['price']} = Rp ${item['subtotal']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => setState(
                                      () => _selectedServices.removeAt(i)),
                                ),
                              ),
                            );
                          })),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('Rp $_totalAmount',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2A9DFF))),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                // Tombol Simpan
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A9DFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Simpan Transaksi',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _addServiceToCart(dynamic service) {
    final qtyController = TextEditingController(text: '1');
    final price = double.tryParse(service['price'].toString()) ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${service['product_name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rp $price / ${service['service_name']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (kg/pcs)',
                  hintText: 'Masukkan jumlah',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(qtyController.text) ?? 1;
                setState(() {
                  _selectedServices.add({
                    'service_id': service['id'],
                    'product_name': service['product_name'],
                    'service_name': service['service_name'],
                    'price': price,
                    'quantity': qty,
                    'subtotal': price * qty,
                  });
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A9DFF),
              ),
              child:
                  const Text('Tambah', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddCustomerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Pelanggan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama')),
              const SizedBox(height: 8),
              TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'No. WA'),
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Alamat')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                final result = await ApiService.addCustomer(
                  name: nameController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  if (result['customer'] != null) {
                    _loadData();
                    _showSnackbar('Pelanggan berhasil ditambah!', Colors.green);
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
