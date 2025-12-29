import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Sample patients list - you should fetch this from your patients widget/database
  final List<Map<String, dynamic>> _patients = [
    {'id': '1', 'name': 'John Doe', 'phone': '+1234567890'},
    {'id': '2', 'name': 'Jane Smith', 'phone': '+1234567891'},
    {'id': '3', 'name': 'Robert Johnson', 'phone': '+1234567892'},
    {'id': '4', 'name': 'Sarah Williams', 'phone': '+1234567893'},
    {'id': '5', 'name': 'Allessandra', 'phone': '+1234567894'},
    {'id': '6', 'name': 'Hurum', 'phone': '+1234567895'},
  ];

  final List<String> _appointmentTypes = [
    'Checkup',
    'Follow-up',
    'Consultation',
    'Treatment',
    'Emergency',
    'Routine Exam',
  ];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  // Sample appointments data
  final Map<DateTime, List<Map<String, dynamic>>> _appointments = {
    DateTime.utc(2024, 12, 28): [
      {
        'id': '1',
        'time': '09:00 AM',
        'patient': 'John Doe',
        'patientId': '1',
        'type': 'Checkup',
        'status': 'confirmed',
        'duration': 30,
      },
      {
        'id': '2',
        'time': '02:00 PM',
        'patient': 'Jane Smith',
        'patientId': '2',
        'type': 'Follow-up',
        'status': 'confirmed',
        'duration': 45,
      },
    ],
    DateTime.utc(2024, 12, 29): [
      {
        'id': '3',
        'time': '10:30 AM',
        'patient': 'Robert Johnson',
        'patientId': '3',
        'type': 'Consultation',
        'status': 'pending',
        'duration': 60,
      },
    ],
  };

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    final appointments =
        _appointments[DateTime.utc(day.year, day.month, day.day)] ?? [];
    // Filter out cancelled appointments from display
    return appointments.where((apt) => apt['status'] != 'cancelled').toList();
  }

  // Convert time string to minutes
  int _timeToMinutes(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    var hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return hour * 60 + minute;
  }

  // Check if a time slot is available with duration consideration
  bool _isTimeSlotAvailable(
    DateTime date,
    TimeOfDay time,
    int duration, {
    String? excludeAppointmentId,
  }) {
    final allAppointments =
        _appointments[DateTime.utc(date.year, date.month, date.day)] ?? [];
    final selectedStartMinutes = time.hour * 60 + time.minute;
    final selectedEndMinutes = selectedStartMinutes + duration;

    for (var appointment in allAppointments) {
      // Skip cancelled appointments and the appointment being edited
      if (appointment['status'] == 'cancelled') continue;
      if (excludeAppointmentId != null &&
          appointment['id'] == excludeAppointmentId)
        continue;

      final appointmentStartMinutes = _timeToMinutes(appointment['time']);
      final appointmentDuration = appointment['duration'] as int;
      final appointmentEndMinutes =
          appointmentStartMinutes + appointmentDuration;

      // Check for overlap
      if ((selectedStartMinutes >= appointmentStartMinutes &&
              selectedStartMinutes < appointmentEndMinutes) ||
          (selectedEndMinutes > appointmentStartMinutes &&
              selectedEndMinutes <= appointmentEndMinutes) ||
          (selectedStartMinutes <= appointmentStartMinutes &&
              selectedEndMinutes >= appointmentEndMinutes)) {
        return false;
      }
    }
    return true;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
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

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        appBar: AppBar(
          title: const Text('Appointments'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: () {
                _showSmartRecommendations(isDark);
              },
              tooltip: 'Smart Recommendations',
            ),
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
            // Calendar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: _getAppointmentsForDay,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  weekendTextStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  disabledTextStyle: TextStyle(
                    color: isDark ? Colors.white24 : Colors.grey,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  weekendStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),

            // Appointments for selected day
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDay != null
                        ? 'Appointments for ${_selectedDay!.day}/${_selectedDay!.month}'
                        : 'Select a day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  if (_selectedDay != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_getAppointmentsForDay(_selectedDay!).length} appointments',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Appointment list
            Expanded(
              child: _selectedDay == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 64,
                            color:
                                (isDark
                                        ? Colors.white54
                                        : AppColors.textTertiary)
                                    .withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select a day to view appointments',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _getAppointmentsForDay(_selectedDay!).isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color:
                                (isDark
                                        ? Colors.white54
                                        : AppColors.textTertiary)
                                    .withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No appointments for this day',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _getAppointmentsForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final appointment = _getAppointmentsForDay(
                          _selectedDay!,
                        )[index];
                        return _buildAppointmentCard(appointment, isDark);
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showAddAppointmentDialog(isDark);
          },
          icon: const Icon(Icons.add),
          label: const Text('New Appointment'),
          backgroundColor: AppColors.primary,
        ),
      );
    });
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showAppointmentDetails(appointment, isDark);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Time
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appointment['time'].split(' ')[0],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            appointment['time'].split(' ')[1],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment['patient'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment['type'],
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${appointment['duration']} min',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white60
                                  : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          appointment['status'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appointment['status'].toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(appointment['status']),
                        ),
                      ),
                    ),
                  ],
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _cancelAppointment(appointment, isDark);
                          },
                          icon: const Icon(Icons.cancel, size: 18),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _sendAppointmentNotification(appointment, isDark);
                          },
                          icon: const Icon(Icons.send, size: 18),
                          label: const Text('Notify'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
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

  void _cancelAppointment(Map<String, dynamic> appointment, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cancel Appointment',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel the appointment for ${appointment['patient']}?',
          style: TextStyle(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'No',
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Find the appointment in the original map and update it
                final dateKey = DateTime.utc(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                );
                final appointments = _appointments[dateKey];
                if (appointments != null) {
                  final index = appointments.indexWhere(
                    (apt) => apt['id'] == appointment['id'],
                  );
                  if (index != -1) {
                    appointments[index]['status'] = 'cancelled';
                  }
                }
              });
              Get.back();
              Get.snackbar(
                'Cancelled',
                'Appointment cancelled successfully',
                backgroundColor: AppColors.error,
                colorText: Colors.white,
                icon: const Icon(Icons.cancel, color: Colors.white),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _sendAppointmentNotification(
    Map<String, dynamic> appointment,
    bool isDark,
  ) {
    final patient = _patients.firstWhere(
      (p) => p['id'] == appointment['patientId'],
      orElse: () => {'name': 'Unknown', 'phone': 'N/A'},
    );

    Get.snackbar(
      'Notification Sent',
      'Appointment reminder sent to ${patient['name']} at ${patient['phone']}',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showFilterDialog(bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Filter Appointments',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: AppColors.success),
              title: Text(
                'Confirmed',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.pending, color: AppColors.warning),
              title: Text(
                'Pending',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: AppColors.error),
              title: Text(
                'Cancelled',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAppointmentDialog(
    bool isDark, {
    Map<String, dynamic>? existingAppointment,
  }) {
    String? selectedPatientId = existingAppointment?['patientId'];
    String? selectedType = existingAppointment?['type'];
    int selectedDuration = existingAppointment?['duration'] ?? 30;

    TimeOfDay selectedTime = TimeOfDay.now();
    if (existingAppointment != null) {
      final timeMinutes = _timeToMinutes(existingAppointment['time']);
      selectedTime = TimeOfDay(
        hour: timeMinutes ~/ 60,
        minute: timeMinutes % 60,
      );
    }

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              existingAppointment == null
                  ? 'New Appointment'
                  : 'Reschedule Appointment',
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Patient Selection
                  DropdownButtonFormField<String>(
                    value: selectedPatientId,
                    dropdownColor: isDark
                        ? AppColors.darkSurface
                        : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Select Patient',
                      labelStyle: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    items: _patients.map((patient) {
                      return DropdownMenuItem<String>(
                        value: patient['id'],
                        child: Text(
                          patient['name'],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPatientId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Appointment Type Selection
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    dropdownColor: isDark
                        ? AppColors.darkSurface
                        : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Appointment Type',
                      labelStyle: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.medical_services,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    items: _appointmentTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Duration Selection
                  DropdownButtonFormField<int>(
                    value: selectedDuration,
                    dropdownColor: isDark
                        ? AppColors.darkSurface
                        : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Duration',
                      labelStyle: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.timer,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    items: [15, 30, 45, 60, 90, 120].map((duration) {
                      return DropdownMenuItem<int>(
                        value: duration,
                        child: Text(
                          '$duration min',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedDuration = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    title: Text(
                      'Time: ${selectedTime.format(context)}',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    leading: Icon(
                      Icons.access_time,
                      color: isDark ? Colors.white70 : AppColors.primary,
                    ),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedTime = picked;
                        });
                      }
                    },
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
                  if (selectedPatientId != null && selectedType != null) {
                    final dateToUse = _selectedDay ?? DateTime.now();

                    // Check if time slot is available
                    if (!_isTimeSlotAvailable(
                      dateToUse,
                      selectedTime,
                      selectedDuration,
                      excludeAppointmentId: existingAppointment?['id'],
                    )) {
                      Get.snackbar(
                        'Time Slot Unavailable',
                        'This time slot conflicts with another appointment. Please choose a different time.',
                        backgroundColor: AppColors.error,
                        colorText: Colors.white,
                        icon: const Icon(Icons.error, color: Colors.white),
                        duration: const Duration(seconds: 4),
                      );
                      return;
                    }

                    final patient = _patients.firstWhere(
                      (p) => p['id'] == selectedPatientId,
                    );
                    final hour = selectedTime.hourOfPeriod == 0
                        ? 12
                        : selectedTime.hourOfPeriod;
                    final minute = selectedTime.minute.toString().padLeft(
                      2,
                      '0',
                    );
                    final period = selectedTime.period == DayPeriod.am
                        ? 'AM'
                        : 'PM';
                    final formattedTime = '$hour:$minute $period';

                    final dateKey = DateTime.utc(
                      dateToUse.year,
                      dateToUse.month,
                      dateToUse.day,
                    );

                    setState(() {
                      if (existingAppointment != null) {
                        // Update existing appointment
                        final appointments = _appointments[dateKey];
                        if (appointments != null) {
                          final index = appointments.indexWhere(
                            (apt) => apt['id'] == existingAppointment['id'],
                          );
                          if (index != -1) {
                            appointments[index] = {
                              'id': existingAppointment['id'],
                              'time': formattedTime,
                              'patient': patient['name'],
                              'patientId': selectedPatientId,
                              'type': selectedType,
                              'status': 'confirmed',
                              'duration': selectedDuration,
                            };
                          }
                        }
                      } else {
                        // Create new appointment
                        final newAppointment = {
                          'id': DateTime.now().millisecondsSinceEpoch
                              .toString(),
                          'time': formattedTime,
                          'patient': patient['name'],
                          'patientId': selectedPatientId,
                          'type': selectedType,
                          'status': 'confirmed',
                          'duration': selectedDuration,
                        };

                        if (_appointments[dateKey] == null) {
                          _appointments[dateKey] = [];
                        }
                        _appointments[dateKey]!.add(newAppointment);
                      }

                      if (_selectedDay == null) {
                        _selectedDay = dateToUse;
                      }
                    });

                    Get.back();
                    Get.snackbar(
                      'Success',
                      existingAppointment == null
                          ? 'Appointment scheduled for ${patient['name']}'
                          : 'Appointment rescheduled successfully',
                      backgroundColor: AppColors.success,
                      colorText: Colors.white,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please select patient and appointment type',
                      backgroundColor: AppColors.error,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  existingAppointment == null ? 'Schedule' : 'Update',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSmartRecommendations(bool isDark) {
    // Get patients with multiple appointments
    final patientAppointmentCount = <String, int>{};
    final patientLastAppointment = <String, DateTime>{};

    _appointments.forEach((date, appointments) {
      for (var apt in appointments.where((a) => a['status'] != 'cancelled')) {
        final patientId = apt['patientId'];
        patientAppointmentCount[patientId] =
            (patientAppointmentCount[patientId] ?? 0) + 1;

        if (patientLastAppointment[patientId] == null ||
            date.isAfter(patientLastAppointment[patientId]!)) {
          patientLastAppointment[patientId] = date;
        }
      }
    });

    // Generate recommendations
    final recommendations = <Map<String, dynamic>>[];

    patientAppointmentCount.forEach((patientId, count) {
      if (count >= 2) {
        final patient = _patients.firstWhere(
          (p) => p['id'] == patientId,
          orElse: () => {'id': '', 'name': 'Unknown', 'phone': 'N/A'},
        );

        if (patient['id'].isEmpty) return;

        final lastDate = patientLastAppointment[patientId]!;
        final recommendedDate = lastDate.add(const Duration(days: 30));

        recommendations.add({
          'patient': patient,
          'recommendedDate': recommendedDate,
          'reason': 'Follow-up recommended ($count previous appointments)',
          'count': count,
        });
      }
    });

    if (recommendations.isEmpty) {
      Get.snackbar(
        'No Recommendations',
        'No smart recommendations available at this time',
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Smart Recommendations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 400,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = recommendations[index];
                    final patient = rec['patient'];
                    final date = rec['recommendedDate'] as DateTime;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBackground
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.2,
                                ),
                                child: Text(
                                  patient['name'][0],
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      rec['reason'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.white70
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Suggested: ${date.day}/${date.month}/${date.year}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.snackbar(
                                  'Recommendation Sent',
                                  'Appointment suggestion sent to ${patient['name']} at ${patient['phone']}',
                                  backgroundColor: AppColors.success,
                                  colorText: Colors.white,
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  duration: const Duration(seconds: 3),
                                );
                              },
                              icon: const Icon(Icons.send, size: 18),
                              label: const Text('Send to Patient'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          appointment['patient'],
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Time', appointment['time'], isDark),
            _buildDetailRow('Type', appointment['type'], isDark),
            _buildDetailRow(
              'Duration',
              '${appointment['duration']} min',
              isDark,
            ),
            _buildDetailRow('Status', appointment['status'], isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showAddAppointmentDialog(
                isDark,
                existingAppointment: appointment,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
