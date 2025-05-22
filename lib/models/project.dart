import 'project_detail.dart';

class Project {
  final int id;
  final int enquiryId;
  final int quotationId;
  final String projectName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProjectDetail>? details;

  Project({
    required this.id,
    required this.enquiryId,
    required this.quotationId,
    required this.projectName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.details,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      enquiryId: json['enquiry_id'],
      quotationId: json['quotation_id'],
      projectName: json['project_name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      details: json['details'] != null
          ? (json['details'] as List)
              .map((detail) => ProjectDetail.fromJson(detail))
              .toList()
          : null,
    );
  }
} 