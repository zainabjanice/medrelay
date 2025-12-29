import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  // Database of Specialist Doctors
  final List<Map<String, dynamic>> _specialists = [
    {
      'id': 'D001',
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Cardiology',
      'hospital': 'City Heart Hospital',
      'experience': '15 years',
      'rating': 4.8,
      'available': true,
      'phone': '+1 555-0101',
      'email': 'sarah.johnson@hospital.com',
      'avatar': 'SJ',
      'color': AppColors.cardiology,
    },
    {
      'id': 'D002',
      'name': 'Dr. Michael Chen',
      'specialty': 'Neurology',
      'hospital': 'Brain & Spine Center',
      'experience': '12 years',
      'rating': 4.9,
      'available': true,
      'phone': '+1 555-0102',
      'email': 'michael.chen@hospital.com',
      'avatar': 'MC',
      'color': AppColors.neurology,
    },
    {
      'id': 'D003',
      'name': 'Dr. Emily Brown',
      'specialty': 'Pediatrics',
      'hospital': 'Children\'s Medical Center',
      'experience': '10 years',
      'rating': 4.7,
      'available': true,
      'phone': '+1 555-0103',
      'email': 'emily.brown@hospital.com',
      'avatar': 'EB',
      'color': AppColors.pediatrics,
    },
    {
      'id': 'D004',
      'name': 'Dr. James Wilson',
      'specialty': 'Orthopedics',
      'hospital': 'Bone & Joint Clinic',
      'experience': '18 years',
      'rating': 4.6,
      'available': false,
      'phone': '+1 555-0104',
      'email': 'james.wilson@hospital.com',
      'avatar': 'JW',
      'color': AppColors.orthopedics,
    },
    {
      'id': 'D005',
      'name': 'Dr. Lisa Martinez',
      'specialty': 'Dermatology',
      'hospital': 'Skin Care Institute',
      'experience': '8 years',
      'rating': 4.5,
      'available': true,
      'phone': '+1 555-0105',
      'email': 'lisa.martinez@hospital.com',
      'avatar': 'LM',
      'color': AppColors.dermatology,
    },
    {
      'id': 'D006',
      'name': 'Dr. David Lee',
      'specialty': 'Psychiatry',
      'hospital': 'Mental Health Center',
      'experience': '14 years',
      'rating': 4.9,
      'available': true,
      'phone': '+1 555-0106',
      'email': 'david.lee@hospital.com',
      'avatar': 'DL',
      'color': AppColors.psychiatry,
    },
  ];

  String _selectedSpecialty = 'All';
  final List<String> _specialties = [
    'All',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Dermatology',
    'Psychiatry',
  ];

  List<Map<String, dynamic>> get _filteredSpecialists {
    if (_selectedSpecialty == 'All') return _specialists;
    return _specialists
        .where((d) => d['specialty'] == _selectedSpecialty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        appBar: AppBar(title: const Text('Patient Transfers'), elevation: 0),
        body: Column(
          children: [
            // Specialty Filter
            Container(
              height: 60,
              color: isDark ? AppColors.darkSurface : Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _specialties.length,
                itemBuilder: (context, index) {
                  final specialty = _specialties[index];
                  final isSelected = specialty == _selectedSpecialty;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedSpecialty = specialty);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isDark
                            ? AppColors.darkBorder
                            : AppColors.veryLightBlue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          specialty,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isDark
                                ? Colors.white70
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Specialist List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredSpecialists.length,
                itemBuilder: (context, index) {
                  final doctor = _filteredSpecialists[index];
                  return _buildDoctorCard(doctor, isDark);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: isDark ? 0 : 2,
        child: InkWell(
          onTap: () => _showTransferDialog(doctor),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: AppColors.darkBorder) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          doctor['color'],
                          doctor['color'].withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        doctor['avatar'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doctor['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: doctor['available']
                                    ? AppColors.success.withOpacity(0.1)
                                    : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                doctor['available'] ? 'Available' : 'Busy',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: doctor['available']
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor['specialty'],
                          style: TextStyle(
                            fontSize: 14,
                            color: doctor['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor['hospital'],
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor['rating']}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.work,
                              size: 14,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor['experience'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark ? Colors.white54 : AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTransferDialog(Map<String, dynamic> doctor) {
    final reasonController = TextEditingController();
    final notesController = TextEditingController();
    final themeController = Get.find<ThemeController>();

    Get.dialog(
      Obx(() {
        final isDark = themeController.isDarkMode.value;

        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [doctor['color'], doctor['color'].withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    doctor['avatar'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                doctor['name'],
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Text(
                doctor['specialty'],
                style: TextStyle(fontSize: 14, color: doctor['color']),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer Patient',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Reason for Referral',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                    hintText: 'e.g., Chest pain, requires specialist',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : AppColors.textTertiary,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Additional Notes',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                    hintText: 'Medical history, test results...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : AppColors.textTertiary,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.isNotEmpty) {
                  Get.back();
                  Get.snackbar(
                    'Transfer Successful',
                    'Patient referred to ${doctor['name']} (${doctor['specialty']})',
                    backgroundColor: AppColors.success,
                    colorText: Colors.white,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    duration: const Duration(seconds: 3),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: doctor['color'],
                foregroundColor: Colors.white,
              ),
              child: const Text('Send Referral'),
            ),
          ],
        );
      }),
    );
  }
}
