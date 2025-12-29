import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'patient_controller.dart';
import '/features/patients/widgets/add_patient_screen.dart';

class PatientDetailScreen extends StatelessWidget {
  final Map<String, dynamic> patient;
  final PatientController _patientController = Get.find<PatientController>();

  PatientDetailScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Hero(
                      tag: 'patient_${patient['id']}',
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            patient['avatar'],
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      patient['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient ID: ${patient['id']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Get.to(
                    () => AddPatientScreen(existingPatient: patient),
                  );
                  if (result == true) {
                    // Refresh by going back and reopening
                    Get.back();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showMoreOptions(context),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.phone,
                          label: 'Call',
                          color: AppColors.success,
                          onTap: () {
                            _makePhoneCall(patient['phone']);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.message,
                          label: 'Message',
                          color: AppColors.info,
                          onTap: () {
                            _sendMessage(patient['name']);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.swap_horiz,
                          label: 'Transfer',
                          color: AppColors.warning,
                          onTap: () => _showTransferDialog(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Personal Information
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow('Age', '${patient['age']} years'),
                    _buildInfoRow('Gender', patient['gender']),
                    _buildInfoRow('Blood Type', patient['bloodType']),
                    _buildInfoRow('Phone', patient['phone']),
                  ]),

                  const SizedBox(height: 20),

                  // Medical Information
                  _buildSectionTitle('Medical Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow('Primary Condition', patient['condition']),
                    _buildInfoRow(
                      'Status',
                      patient['status'].toUpperCase(),
                      valueColor: _getStatusColor(patient['status']),
                    ),
                    _buildInfoRow('Last Visit', patient['lastVisit']),
                    _buildInfoRow('Next Appointment', '2024-01-25'),
                  ]),

                  const SizedBox(height: 20),

                  // Medical History
                  _buildSectionTitle('Medical History'),
                  const SizedBox(height: 12),
                  _buildHistoryItem(
                    date: '2024-01-15',
                    title: 'Regular Checkup',
                    description: 'Blood pressure normal, prescribed medication',
                    icon: Icons.favorite,
                    color: AppColors.success,
                  ),
                  _buildHistoryItem(
                    date: '2023-12-10',
                    title: 'Lab Results',
                    description: 'All parameters within normal range',
                    icon: Icons.science,
                    color: AppColors.info,
                  ),
                  _buildHistoryItem(
                    date: '2023-11-05',
                    title: 'Consultation',
                    description:
                        'Discussed treatment plan and lifestyle changes',
                    icon: Icons.medical_information,
                    color: AppColors.warning,
                  ),

                  const SizedBox(height: 20),

                  // Documents
                  _buildSectionTitle('Medical Documents'),
                  const SizedBox(height: 12),
                  _buildDocumentCard('Lab Report - Jan 2024', 'PDF • 2.3 MB'),
                  _buildDocumentCard('X-Ray Results', 'PDF • 1.8 MB'),
                  _buildDocumentCard('Prescription History', 'PDF • 856 KB'),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAIAnalysisDialog(context),
        icon: const Icon(Icons.psychology),
        label: const Text('AI Analysis'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            _downloadDocument(title);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'stable':
        return AppColors.success;
      case 'monitoring':
        return AppColors.warning;
      case 'critical':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showMoreOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.primary),
              title: const Text('Share Patient File'),
              onTap: () {
                Get.back();
                _sharePatientFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: AppColors.info),
              title: const Text('Print Records'),
              onTap: () {
                Get.back();
                _printRecords();
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: AppColors.warning),
              title: const Text('Archive Patient'),
              onTap: () {
                Get.back();
                _archivePatient();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete Patient'),
              onTap: () {
                Get.back();
                _deletePatient();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferDialog(BuildContext context) {
    final TextEditingController specialtyController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.swap_horiz, color: AppColors.warning),
            ),
            const SizedBox(width: 12),
            const Text('Transfer Patient'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transfer ${patient['name']} to a specialist'),
              const SizedBox(height: 16),
              TextField(
                controller: specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Specialist Type',
                  hintText: 'e.g., Cardiologist',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Transfer Notes',
                  hintText: 'Reason for referral...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (specialtyController.text.isNotEmpty) {
                Get.back();
                Get.snackbar(
                  'Transfer Initiated',
                  'Referral to ${specialtyController.text} created successfully',
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  duration: const Duration(seconds: 3),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  void _showAIAnalysisDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            const Text('AI Analysis'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analyzing ${patient['name']}\'s medical history...'),
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'AI Recommendations:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Consider cardiology consultation'),
            const Text('• Schedule follow-up in 2 weeks'),
            const Text('• Review current medications'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: const Text('View Full Report'),
          ),
        ],
      ),
    );
  }

  // Working helper functions
  void _makePhoneCall(String phone) {
    Get.defaultDialog(
      title: 'Call Patient',
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          const Icon(Icons.phone, size: 48, color: AppColors.success),
          const SizedBox(height: 16),
          Text('Call $phone?', style: const TextStyle(fontSize: 16)),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Call',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.success,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Calling',
          'Dialing $phone...',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          icon: const Icon(Icons.phone, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      },
    );
  }

  void _sendMessage(String patientName) {
    final messageController = TextEditingController();

    Get.defaultDialog(
      title: 'Send Message',
      content: Column(
        children: [
          Text('To: $patientName'),
          const SizedBox(height: 16),
          TextField(
            controller: messageController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Send',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.info,
      onConfirm: () {
        if (messageController.text.isNotEmpty) {
          Get.back();
          Get.snackbar(
            'Message Sent',
            'Your message has been sent to $patientName',
            backgroundColor: AppColors.success,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        }
      },
    );
  }

  void _downloadDocument(String title) {
    Get.snackbar(
      'Downloading',
      title,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      icon: const Icon(Icons.download, color: Colors.white),
      showProgressIndicator: true,
      duration: const Duration(seconds: 3),
    );

    // Simulate download completion
    Future.delayed(const Duration(seconds: 3), () {
      Get.snackbar(
        'Download Complete',
        '$title has been saved to your device',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    });
  }

  void _sharePatientFile() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Share Patient File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email, color: AppColors.primary),
              title: const Text('Email'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Sharing via Email',
                  'Patient file sent to registered email',
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, color: AppColors.info),
              title: const Text('Copy Link'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Link Copied',
                  'Shareable link copied to clipboard',
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _printRecords() {
    Get.snackbar(
      'Printing',
      'Preparing patient records for printing...',
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      icon: const Icon(Icons.print, color: Colors.white),
      showProgressIndicator: true,
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Get.snackbar(
        'Ready to Print',
        'Records sent to printer',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    });
  }

  void _archivePatient() {
    Get.defaultDialog(
      title: 'Archive Patient',
      middleText: 'Are you sure you want to archive ${patient['name']}?',
      textCancel: 'Cancel',
      textConfirm: 'Archive',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.warning,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Patient Archived',
          '${patient['name']} has been archived',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      },
    );
  }

  void _deletePatient() {
    Get.defaultDialog(
      title: 'Delete Patient',
      middleText:
          'Are you sure you want to permanently delete ${patient['name']}? This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        _patientController.deletePatient(patient['id']);
        Get.back(); // Close dialog
        Get.back(); // Go back to patient list
        Get.snackbar(
          'Patient Deleted',
          '${patient['name']} has been removed',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      },
    );
  }
}
