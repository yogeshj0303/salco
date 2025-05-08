import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enquiry.dart';
import '../models/get_enquiry_response.dart';

class ApiService {
  static const String baseUrl = 'https://salco.acttconnect.com/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<EnquiryData>> getEnquiries(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get-enquiry?user_id=$userId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = GetEnquiryResponse.fromJson(jsonDecode(response.body));
        if (responseData.status == 'success') {
          return responseData.data;
        } else {
          throw Exception(responseData.message);
        }
      } else {
        throw Exception('Failed to fetch enquiries: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> createEnquiry(Enquiry enquiry, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/enquiries'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(enquiry.toJson()),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode != 200 || data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Failed to create enquiry');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
} 