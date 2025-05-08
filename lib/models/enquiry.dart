class Enquiry {
  final int? id;
  final int userId;
  final String clientName;
  final String address;
  final String phoneNo;
  final String contactPerson;
  final String note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Enquiry({
    this.id,
    required this.userId,
    required this.clientName,
    required this.address,
    required this.phoneNo,
    required this.contactPerson,
    required this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      clientName: json['client_name'] as String,
      address: json['address'] as String,
      phoneNo: json['phone_no'] as String,
      contactPerson: json['contact_person'] as String,
      note: json['note'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'client_name': clientName,
      'address': address,
      'phone_no': phoneNo,
      'contact_person': contactPerson,
      'note': note,
    };
  }
} 