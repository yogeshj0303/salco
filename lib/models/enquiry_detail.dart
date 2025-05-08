class EnquiryDetail {
  final int id;
  final int enquiryId;
  final String quotation;
  final String amount;
  final String? attachment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String workOrderStatus;

  EnquiryDetail({
    required this.id,
    required this.enquiryId,
    required this.quotation,
    required this.amount,
    this.attachment,
    required this.createdAt,
    required this.updatedAt,
    this.workOrderStatus = '',
  });

  factory EnquiryDetail.fromJson(Map<String, dynamic> json) {
    return EnquiryDetail(
      id: json['id'] as int? ?? 0,
      enquiryId: json['enquiry_id'] as int? ?? 0,
      quotation: json['quotation']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      attachment: json['attachment']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      workOrderStatus: json['work_order_status']?.toString() ?? '',
    );
  }
} 