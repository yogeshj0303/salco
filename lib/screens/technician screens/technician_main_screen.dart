import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';
import 'technician_dashboard_screen.dart';
import 'projects.dart';
import 'technician_enquiry_screen.dart';
import 'profile_screen.dart';

class TechnicianMainScreen extends StatefulWidget {
  const TechnicianMainScreen({super.key});

  @override
  State<TechnicianMainScreen> createState() => _TechnicianMainScreenState();
}

class _TechnicianMainScreenState extends State<TechnicianMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TechnicianDashboardScreen(),
    const ProjectsScreen(),
    const TechnicianEnquiryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              HapticFeedback.lightImpact();
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryTeal,
            unselectedItemColor: Colors.grey.shade400,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            iconSize: 20,
            elevation: 0,
            items: [
              _buildNavItem(Icons.dashboard_rounded, 'Dashboard'),
              _buildNavItem(Icons.assignment_rounded, 'Projects'),
              _buildNavItem(Icons.add_circle_rounded, 'Enquiry'),
              _buildNavItem(Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _selectedIndex == _screens.indexOf(_screens[_selectedIndex])
              ? AppColors.primaryTeal.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
} 