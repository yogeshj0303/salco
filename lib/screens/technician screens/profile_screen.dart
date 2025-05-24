import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/shared_prefs_service.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _sharedPrefsService = SharedPrefsService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _sharedPrefsService.getUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: AppBar(
      //   elevation: 0,
      //   title: const Text(
      //     'Profile',
      //     style: TextStyle(
      //       fontWeight: FontWeight.w500,
      //       fontSize: 18,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: AppColors.primaryTeal,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.edit, color: Colors.white),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: 16),
                      _buildSettingsSection(),
                      const SizedBox(height: 24),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 42, 0, 24),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: _userData?['avatar'] != null && _userData!['avatar'].toString().isNotEmpty
                ? NetworkImage(_userData!['avatar'])
                : null,
            child: _userData?['avatar'] == null || _userData!['avatar'].toString().isEmpty
                ? const Icon(Icons.person, size: 40, color: AppColors.primaryTeal)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            _userData?['name'] ?? 'User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _userData?['email'] ?? 'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildListTile(Icons.person_outline, 'Name', _userData?['name'] ?? 'N/A'),
          _buildDivider(),
          _buildListTile(Icons.email_outlined, 'Email', _userData?['email'] ?? 'N/A'),
          _buildDivider(),
          _buildListTile(Icons.calendar_today_outlined, 'Member Since', 
            _userData?['created_at'] != null 
              ? DateTime.parse(_userData!['created_at'].toString().split('T')[0]).toString().split(' ')[0].split('-').reversed.join('/')
              : 'N/A'
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryTeal,
            ),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          ListTile(
            leading: const Icon(
              Icons.lock_outline,
              color: AppColors.primaryTeal,
            ),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryTeal, size: 20),
      title: Text(
        label,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3E50),
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade200);

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await _sharedPrefsService.clearUserData();
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
