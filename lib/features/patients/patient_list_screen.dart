import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import 'patient_detail_screen.dart';
import './../patients/widgets/add_patient_screen.dart';
import 'patient_controller.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final PatientController _patientController = Get.find<PatientController>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, stable, monitoring, critical

  List<Map<String, dynamic>> _getFilteredPatients() {
    var filtered = _patientController.patients.toList();

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((p) => p['status'] == _selectedFilter).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((patient) {
        return patient['name'].toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            patient['condition'].toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
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

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      // This will trigger rebuild when patients list changes
      final filteredPatients = _getFilteredPatients();

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        appBar: AppBar(
          title: const Text('My Patients'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showFilterDialog(isDark);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              color: isDark ? AppColors.darkSurface : Colors.white,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search patients...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : AppColors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkBorder.withOpacity(0.3)
                      : AppColors.veryLightBlue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Patient Stats
            Container(
              color: isDark ? AppColors.darkSurface : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip(
                    'Total',
                    _patientController.patients.length.toString(),
                    AppColors.primary,
                    isDark,
                  ),
                  _buildStatChip(
                    'Active',
                    '${_patientController.patients.where((p) => p['status'] == 'stable').length}',
                    AppColors.success,
                    isDark,
                  ),
                  _buildStatChip(
                    'Critical',
                    '${_patientController.patients.where((p) => p['status'] == 'critical').length}',
                    AppColors.error,
                    isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Patient List
            Expanded(
              child: filteredPatients.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return _buildPatientCard(patient, isDark);
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showAddPatientDialog();
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Patient'),
          backgroundColor: AppColors.primary,
        ),
      );
    });
  }

  Widget _buildStatChip(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: isDark ? 0 : 2,
        child: InkWell(
          onTap: () {
            Get.to(() => PatientDetailScreen(patient: patient));
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'patient_${patient['id']}',
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        patient['avatar'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Patient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              patient['name'],
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
                              color: _getStatusColor(
                                patient['status'],
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              patient['status'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(patient['status']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient['age']} years • ${patient['gender']} • ${patient['bloodType']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patient['condition'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white54
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: isDark
                                ? Colors.white54
                                : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Last visit: ${patient['lastVisit']}',
                            style: TextStyle(
                              fontSize: 11,
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

                const SizedBox(width: 8),

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
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: (isDark ? Colors.white54 : AppColors.textTertiary)
                .withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No patients found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Filter Patients',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All Patients', 'all', null, isDark),
            _buildFilterOption('Stable', 'stable', AppColors.success, isDark),
            _buildFilterOption(
              'Monitoring',
              'monitoring',
              AppColors.warning,
              isDark,
            ),
            _buildFilterOption('Critical', 'critical', AppColors.error, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    String title,
    String value,
    Color? color,
    bool isDark,
  ) {
    return RadioListTile<String>(
      title: Row(
        children: [
          if (color != null) ...[
            Icon(Icons.circle, size: 12, color: color),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      value: value,
      groupValue: _selectedFilter,
      onChanged: (val) {
        setState(() => _selectedFilter = val!);
        Get.back();
      },
    );
  }

  void _showAddPatientDialog() async {
    final result = await Get.to(() => const AddPatientScreen());

    if (result == true) {
      // No need to call setState() - Obx will handle the refresh
      // since we're observing _patientController.patients
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
