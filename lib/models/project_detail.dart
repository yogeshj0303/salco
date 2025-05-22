class ProjectDetail {
  final int id;
  final int projectId;
  final String liftType;
  final String sitePlan;
  final String drawing;
  final String materialOrder;
  final String installation;
  final String testingReport;
  final String installationLicense;
  final String permissionReport;
  final String inspectionReport;
  final String thirdPartyReport;
  final String finalInspection;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectDetail({
    required this.id,
    required this.projectId,
    required this.liftType,
    required this.sitePlan,
    required this.drawing,
    required this.materialOrder,
    required this.installation,
    required this.testingReport,
    required this.installationLicense,
    required this.permissionReport,
    required this.inspectionReport,
    required this.thirdPartyReport,
    required this.finalInspection,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) {
    return ProjectDetail(
      id: json['id'],
      projectId: json['project_id'],
      liftType: json['lift_type'],
      sitePlan: json['site_plan'],
      drawing: json['drawing'],
      materialOrder: json['material_order'],
      installation: json['installation'],
      testingReport: json['testing_report'],
      installationLicense: json['installation_license'],
      permissionReport: json['permission_report'],
      inspectionReport: json['inspection_report'],
      thirdPartyReport: json['third_party_report'],
      finalInspection: json['final_inspection'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
} 