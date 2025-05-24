import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Project Assignment',
      'message': 'You have been assigned to a new residential project.',
      'time': '2 hours ago',
      'isRead': false,
    },
    {
      'title': 'Project Update',
      'message': 'The commercial project status has been updated to "In Progress".',
      'time': '5 hours ago',
      'isRead': true,
    },
    {
      'title': 'New Enquiry',
      'message': 'A new enquiry has been received for a renovation project.',
      'time': '1 day ago',
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
              ),
            )
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 48,
                        color: AppColors.primaryTeal.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No notifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: AppColors.primaryTeal,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                            color: notification['isRead'] ? Colors.grey[600] : Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              notification['message'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification['time'],
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (!notification['isRead']) {
                            setState(() {
                              notification['isRead'] = true;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
} 