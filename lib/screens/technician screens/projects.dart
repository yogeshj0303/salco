import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/project_service.dart';
import '../../models/project.dart';
import 'project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _projectService = ProjectService();
  List<Project> _projects = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final projects = await _projectService.getProjects();
      
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _navigateToProjectDetails(Project project) async {
    try {
      final projectWithDetails = await _projectService.getProjectDetails(project.id);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsScreen(project: projectWithDetails),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading project details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Projects',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                ),
              )
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Error: $_error',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _loadProjects,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _projects.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 48,
                              color: AppColors.primaryTeal.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No projects available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProjects,
                        color: AppColors.primaryTeal,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: _projects.length,
                          itemBuilder: (context, index) {
                            final project = _projects[index];
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () => _navigateToProjectDetails(project),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              project.projectName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryTeal,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(project.status).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              project.status,
                                              style: TextStyle(
                                                color: _getStatusColor(project.status),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildInfoRow(Icons.numbers, 'Enquiry ID', project.enquiryId.toString()),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildInfoRow(Icons.receipt_long, 'Quotation ID', project.quotationId.toString()),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      _buildInfoRow(
                                        Icons.calendar_today,
                                        'Created At',
                                        project.createdAt.toString().split('.')[0],
                                      ),
                                      const SizedBox(height: 8),
                                      const Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.primaryTeal.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
} 