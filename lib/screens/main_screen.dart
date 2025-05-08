import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selco_app/screens/dashboard_screen.dart';
import 'package:selco_app/screens/enquiry.dart';
import 'package:selco_app/screens/profile_screen.dart';
import 'package:selco_app/screens/quotation_list_screen.dart';
import '../constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Enquiries(),
    const QuotationListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        // Changed from Container to SizedBox
        height: 58, // Reduced height further
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
            selectedFontSize: 11, // Reduced font size
            unselectedFontSize: 11,
            iconSize: 22, // Reduced icon size
            elevation: 8,
            items: [
              _buildNavItem(Icons.dashboard_rounded, 'Dashboard'),
              _buildNavItem(Icons.add_circle_rounded, 'Enquiries'),
              _buildNavItem(Icons.description_rounded, 'Quotations'),
              _buildNavItem(Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon), // Simplified icon
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 6,
        ), // Reduced padding
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryTeal.withOpacity(0.2),
              AppColors.primaryTeal.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryTeal),
      ),
      label: label,
    );
  }
}
