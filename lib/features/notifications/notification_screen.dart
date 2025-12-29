import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> notifications = const [
    {
      'id': '1',
      'title': 'New Patient Referral',
      'message': 'Dr. Sarah Johnson referred a cardiac patient to you',
      'time': '5 minutes ago',
      'type': 'referral',
      'read': false,
      'icon': Icons.swap_horiz,
      'color': AppColors.warning,
    },
    {
      'id': '2',
      'title': 'Appointment Reminder',
      'message': 'You have an appointment with John Doe at 2:00 PM',
      'time': '1 hour ago',
      'type': 'appointment',
      'read': false,
      'icon': Icons.calendar_today,
      'color': AppColors.info,
    },
    {
      'id': '3',
      'title': 'Lab Results Ready',
      'message': 'Blood test results for Jane Smith are now available',
      'time': '3 hours ago',
      'type': 'lab',
      'read': false,
      'icon': Icons.science,
      'color': AppColors.success,
    },
    {
      'id': '4',
      'title': 'Critical Alert',
      'message': 'Patient Robert Johnson showing abnormal vitals',
      'time': '5 hours ago',
      'type': 'alert',
      'read': true,
      'icon': Icons.warning,
      'color': AppColors.error,
    },
    {
      'id': '5',
      'title': 'Message Received',
      'message': 'New message from Emily Davis regarding medication',
      'time': 'Yesterday',
      'type': 'message',
      'read': true,
      'icon': Icons.message,
      'color': AppColors.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['read']).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                Get.snackbar(
                  'Marked as Read',
                  'All notifications marked as read',
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                );
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Stats Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  '${notifications.length}',
                  Icons.notifications,
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                _buildStatItem('Unread', '$unreadCount', Icons.circle),
                Container(width: 1, height: 40, color: Colors.white30),
                _buildStatItem('Today', '3', Icons.today),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: notification['read']
            ? Colors.white
            : AppColors.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        elevation: notification['read'] ? 1 : 3,
        child: InkWell(
          onTap: () {
            Get.snackbar(
              notification['title'],
              notification['message'],
              backgroundColor: notification['color'],
              colorText: Colors.white,
              icon: Icon(notification['icon'], color: Colors.white),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification['read']
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!notification['read'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification['time'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
