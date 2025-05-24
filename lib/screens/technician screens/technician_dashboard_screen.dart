import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/project_service.dart';
import '../../models/project.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  const TechnicianDashboardScreen({super.key});

  @override
  State<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> {
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

  int _getProjectCountByStatus(String status) {
    return _projects.where((project) => project.status.toLowerCase() == status.toLowerCase()).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error: $_error',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadProjects,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 160,
                      pinned: true,
                      backgroundColor: AppColors.primaryTeal,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        expandedTitleScale: 1.0,
                        titlePadding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back,',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Technician Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColors.primaryTeal.withOpacity(0.8),
                                    AppColors.primaryTeal,
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: -40,
                              top: -40,
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatsGrid(),
                            const SizedBox(height: 26),
                            _buildSectionTitle('Recent Activities'),
                            const SizedBox(height: 8),
                            _buildActivityList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(
          'Total Projects',
          _projects.length.toString(),
          Icons.assignment,
          Colors.blue,
        ),
        _buildStatCard(
          'In Progress',
          _getProjectCountByStatus('in progress').toString(),
          Icons.engineering,
          Colors.orange,
        ),
        _buildStatCard(
          'Completed',
          _getProjectCountByStatus('completed').toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Pending',
          _getProjectCountByStatus('pending').toString(),
          Icons.schedule,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.history,
            color: AppColors.primaryTeal,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    if (_projects.isEmpty) {
      return Center(
        child: Column(
          spacing: 0,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 32,
              color: AppColors.primaryTeal.withOpacity(0.5),
            ),
            const SizedBox(height: 6),
            const Text(
              'No projects available',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTeal,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _projects.length > 5 ? 5 : _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return Container(
          margin: EdgeInsets.only(
            bottom: index == (_projects.length > 5 ? 4 : _projects.length - 1) ? 0 : 8,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.assignment,
                  color: AppColors.primaryTeal,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.projectName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Status: ${project.status}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 