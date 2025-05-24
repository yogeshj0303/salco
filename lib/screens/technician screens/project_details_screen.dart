import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../models/project.dart';
import '../../models/project_detail.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildDocumentTile(String title, String url, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryTeal,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.download,
            color: AppColors.primaryTeal,
            size: 20,
          ),
        ),
        onTap: () => _launchUrl(url),
      ),
    );
  }

  Widget _buildLiftDetails(ProjectDetail detail) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.elevator,
                    color: AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    detail.liftType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildDocumentTile('Site Plan', detail.sitePlan, Icons.map),
          _buildDocumentTile('Drawing', detail.drawing, Icons.architecture),
          _buildDocumentTile('Material Order', detail.materialOrder, Icons.inventory),
          _buildDocumentTile('Testing Report', detail.testingReport, Icons.assignment),
          _buildDocumentTile('Installation License', detail.installationLicense, Icons.verified_user),
          _buildDocumentTile('Permission Report', detail.permissionReport, Icons.security),
          _buildDocumentTile('Inspection Report', detail.inspectionReport, Icons.checklist),
          _buildDocumentTile('Third Party Report', detail.thirdPartyReport, Icons.people),
          _buildDocumentTile('Final Inspection', detail.finalInspection, Icons.task_alt),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          project.projectName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryTeal.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Project Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.flag, 'Status', project.status),
                  _buildInfoRow(Icons.numbers, 'Enquiry ID', project.enquiryId.toString()),
                  _buildInfoRow(Icons.receipt_long, 'Quotation ID', project.quotationId.toString()),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Created At',
                    project.createdAt.toString().split('.')[0],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.elevator,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Lift Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: project.details?.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildLiftDetails(project.details![index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryTeal.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
} 