import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.8:3000/api';

  // ========== AUTH ==========

  // REGISTER
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
          'phone': phone ?? '',
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // ========== DASHBOARD ==========

  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard'));
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'omzet': '0',
        'masuk': 0,
        'harusSelesai': 0,
        'terlambat': 0,
        'orders': []
      };
    }
  }

  // ========== TRANSACTIONS ==========

  static Future<List<dynamic>> getTransactions(
      {String? status, String? date}) async {
    try {
      String url = '$baseUrl/transactions';
      final params = <String, String>{};
      if (status != null && status != 'Semua') params['status'] = status;
      if (date != null) params['date'] = date;

      if (params.isNotEmpty) {
        url += '?${Uri(queryParameters: params).query}';
      }

      final response = await http.get(Uri.parse(url));
      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateStatus(
      int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/transactions/$id/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal: $e'};
    }
  }

  // ========== CUSTOMERS ==========

  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers'));
      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> addCustomer({
    required String name,
    required String phone,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'address': address ?? '',
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal: $e'};
    }
  }
  // ========== SERVICES ==========

  static Future<List<dynamic>> getServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));
      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  // ========== CREATE TRANSACTION ==========

  static Future<Map<String, dynamic>> createTransaction({
    required int customerId,
    required String invoiceNumber,
    required double totalAmount,
    String? notes,
    String? estimatedCompletion,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer_id': customerId,
          'invoice_number': invoiceNumber,
          'total_amount': totalAmount,
          'notes': notes ?? '',
          'estimated_completion': estimatedCompletion ?? '',
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal: $e'};
    }
  }
  // ========== UPGRADE AKUN ==========

  static Future<Map<String, dynamic>> upgradeAccount({
    required int userId,
    required String packageName,
    required int price,
    required int durationDays,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payment/upgrade'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'package_name': packageName,
          'price': price,
          'duration_days': durationDays,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal: $e'};
    }
  }
}
