import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppointmentController extends GetxController {
  final box = GetStorage();

  // Observable map of appointments
  var appointments = <DateTime, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
    debugPrint('✅ AppointmentController initialized');
  }

  // Load appointments from storage or initialize with defaults
  void loadAppointments() {
    try {
      final data = box.read('appointments');

      if (data != null) {
        // Load from storage
        appointments.clear();
        final Map<String, dynamic> decoded = Map.from(data);
        decoded.forEach((dateStr, aptList) {
          try {
            final date = DateTime.parse(dateStr);
            appointments[date] = List<Map<String, dynamic>>.from(aptList);
          } catch (e) {
            debugPrint('⚠️ Error parsing date: $e');
          }
        });
        debugPrint('✅ Loaded ${appointments.length} dates from storage');
      } else {
        // Initialize with default data
        initializeDefaultAppointments();
      }
    } catch (e) {
      debugPrint('⚠️ Error loading appointments: $e');
      initializeDefaultAppointments();
    }
  }

  // Initialize with default appointments
  void initializeDefaultAppointments() {
    appointments.assignAll({
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
    });
    saveAppointments();
    debugPrint('✅ Initialized with default appointments');
  }

  // Save appointments to storage
  void saveAppointments() {
    try {
      final Map<String, dynamic> dataToSave = {};
      appointments.forEach((date, aptList) {
        dataToSave[date.toIso8601String()] = aptList;
      });
      box.write('appointments', dataToSave);
      debugPrint('✅ Appointments saved to storage');
    } catch (e) {
      debugPrint('⚠️ Error saving appointments: $e');
    }
  }

  // Add new appointment - FIXED TYPE
  void addAppointment(DateTime date, Map<String, dynamic> appointment) {
    final dateKey = DateTime.utc(date.year, date.month, date.day);
    if (appointments[dateKey] == null) {
      appointments[dateKey] = [];
    }
    appointments[dateKey]!.add(appointment);
    appointments.refresh();
    saveAppointments();
    debugPrint('✅ Appointment added for $dateKey');
  }

  // Update existing appointment - FIXED TYPE
  void updateAppointment(
    DateTime date,
    String appointmentId,
    Map<String, dynamic> updatedData,
  ) {
    final dateKey = DateTime.utc(date.year, date.month, date.day);
    final appointmentList = appointments[dateKey];
    if (appointmentList != null) {
      final index = appointmentList.indexWhere(
        (apt) => apt['id'] == appointmentId,
      );
      if (index != -1) {
        appointmentList[index] = updatedData;
        appointments.refresh();
        saveAppointments();
        debugPrint('✅ Appointment $appointmentId updated');
      }
    }
  }

  // Cancel appointment
  void cancelAppointment(DateTime date, String appointmentId) {
    final dateKey = DateTime.utc(date.year, date.month, date.day);
    final appointmentList = appointments[dateKey];
    if (appointmentList != null) {
      final index = appointmentList.indexWhere(
        (apt) => apt['id'] == appointmentId,
      );
      if (index != -1) {
        appointmentList[index]['status'] = 'cancelled';
        appointments.refresh();
        saveAppointments();
        debugPrint('✅ Appointment $appointmentId cancelled');
      }
    }
  }

  // Get appointments for a specific date
  List<Map<String, dynamic>> getAppointmentsForDay(DateTime day) {
    final dateKey = DateTime.utc(day.year, day.month, day.day);
    final appointmentList = appointments[dateKey] ?? [];
    // Filter out cancelled appointments
    return appointmentList
        .where((apt) => apt['status'] != 'cancelled')
        .toList();
  }

  // Get all appointments count
  int getTotalAppointmentsCount() {
    int count = 0;
    appointments.forEach((date, aptList) {
      count += aptList.where((apt) => apt['status'] != 'cancelled').length;
    });
    return count;
  }

  // Get pending appointments count
  int getPendingAppointmentsCount() {
    int count = 0;
    appointments.forEach((date, aptList) {
      count += aptList.where((apt) => apt['status'] == 'pending').length;
    });
    return count;
  }

  // Clear all appointments (optional - for testing)
  void clearAllAppointments() {
    appointments.clear();
    box.remove('appointments');
    debugPrint('✅ All appointments cleared');
  }
}
