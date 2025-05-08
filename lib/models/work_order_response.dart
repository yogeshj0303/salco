class WorkOrderResponse {
  final String status;
  final String message;
  final WorkOrderData data;

  WorkOrderResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: WorkOrderData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class WorkOrderData {
  final int id;
  final String workOrderStatus;
  final int enquiryId;
  final String quotation;
  final String amount;
  final String? attachment;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkOrderData({
    required this.id,
    required this.workOrderStatus,
    required this.enquiryId,
    required this.quotation,
    required this.amount,
    this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkOrderData.fromJson(Map<String, dynamic> json) {
    return WorkOrderData(
      id: json['id'] as int? ?? 0,
      workOrderStatus: json['work_order_status'] as String? ?? '',
      enquiryId: json['enquiry_id'] as int? ?? 0,
      quotation: json['quotation'] as String? ?? '',
      amount: json['amount'] as String? ?? '0.00',
      attachment: json['attachment'] as String?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
} 