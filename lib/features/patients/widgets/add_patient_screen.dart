import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/theme_controller.dart';
import '/features/patients/patient_controller.dart';

class AddPatientScreen extends StatefulWidget {
  final Map<String, dynamic>? existingPatient; // For editing

  const AddPatientScreen({Key? key, this.existingPatient}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final PatientController _patientController = Get.find<PatientController>();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _conditionController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodType = 'O+';
  String _selectedStatus = 'stable';
  bool _isLoading = false;
  bool _isEditMode = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final List<String> _statuses = ['stable', 'monitoring', 'critical'];

  @override
  void initState() {
    super.initState();
    if (widget.existingPatient != null) {
      _isEditMode = true;
      _loadExistingPatient();
    }
  }

  void _loadExistingPatient() {
    final patient = widget.existingPatient!;
    final nameParts = patient['name'].split(' ');
    _firstNameController.text = nameParts.first;
    _lastNameController.text = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';
    _ageController.text = patient['age'].toString();
    _phoneController.text = patient['phone'];
    _emailController.text = patient['email'] ?? '';
    _addressController.text = patient['address'];
    _conditionController.text = patient['condition'];
    _selectedGender = patient['gender'];
    _selectedBloodType = patient['bloodType'];
    _selectedStatus = patient['status'];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate saving to database
    await Future.delayed(const Duration(seconds: 1));

    final patientData = {
      'name': '${_firstNameController.text} ${_lastNameController.text}',
      'age': int.parse(_ageController.text),
      'gender': _selectedGender,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'bloodType': _selectedBloodType,
      'condition': _conditionController.text,
      'status': _selectedStatus,
    };

    if (_isEditMode) {
      // Update existing patient
      _patientController.updatePatient(
        widget.existingPatient!['id'],
        patientData,
      );
    } else {
      // Add new patient
      _patientController.addPatient(patientData);
    }

    setState(() => _isLoading = false);

    // Show success message
    Get.snackbar(
      'Success',
      _isEditMode
          ? 'Patient ${_firstNameController.text} ${_lastNameController.text} updated successfully!'
          : 'Patient ${_firstNameController.text} ${_lastNameController.text} added successfully!',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    // Go back
    Get.back(result: true);
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
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Patient' : 'Add New Patient'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Personal Information
                _buildSectionHeader(
                  'Personal Information',
                  Icons.person,
                  isDark,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.person_outline,
                        isDark: isDark,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.person_outline,
                        isDark: isDark,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _ageController,
                        label: 'Age',
                        icon: Icons.cake,
                        isDark: isDark,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        value: _selectedGender,
                        label: 'Gender',
                        icon: Icons.wc,
                        items: _genders,
                        isDark: isDark,
                        onChanged: (value) {
                          setState(() => _selectedGender = value!);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  isDark: isDark,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email (Optional)',
                  icon: Icons.email,
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Icons.location_on,
                  isDark: isDark,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Section: Medical Information
                _buildSectionHeader(
                  'Medical Information',
                  Icons.medical_information,
                  isDark,
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  value: _selectedBloodType,
                  label: 'Blood Type',
                  icon: Icons.bloodtype,
                  items: _bloodTypes,
                  isDark: isDark,
                  onChanged: (value) {
                    setState(() => _selectedBloodType = value!);
                  },
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _conditionController,
                  label: 'Primary Condition',
                  icon: Icons.healing,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Primary condition is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Current Status',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.monitor_heart,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  items: _statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: _getStatusColor(status),
                          ),
                          const SizedBox(width: 8),
                          Text(status.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedStatus = value!);
                  },
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePatient,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save),
                              SizedBox(width: 8),
                              Text(
                                'Save Patient',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required bool isDark,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.white70 : AppColors.textSecondary,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
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
}
