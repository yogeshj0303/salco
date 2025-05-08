import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  Future<Map<String, dynamic>> submitQuotation({
    required int enquiryId,
    required String amount,
    required String quotation,
    File? attachment,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/store-enquiry-quotation'),
      );

      request.fields['enquiry_id'] = enquiryId.toString();
      request.fields['amount'] = amount;
      request.fields['quotation_text'] = quotation;

      if (attachment != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachment',
            attachment.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Failed to submit quotation');
      }

      return data;
    } catch (e) {
      throw Exception('Failed to submit quotation: $e');
    }
  }
} 