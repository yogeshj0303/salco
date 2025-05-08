class GetEnquiryResponse {
  final String status;
  final String message;
  final List<EnquiryData> data;

  GetEnquiryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetEnquiryResponse.fromJson(Map<String, dynamic> json) {
    return GetEnquiryResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? 'Unknown error',
      data: (json['data'] as List?)
          ?.map((item) => EnquiryData.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class EnquiryData {
  final int id;
  final int userId;
  final String clientName;
  final String address;
  final String phoneNo;
  final String contactPerson;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  EnquiryData({
    required this.id,
    required this.userId,
    required this.clientName,
    required this.address,
    required this.phoneNo,
    required this.contactPerson,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnquiryData.fromJson(Map<String, dynamic> json) {
    return EnquiryData(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      clientName: json['client_name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phoneNo: json['phone_no']?.toString() ?? '',
      contactPerson: json['contact_person']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
} 