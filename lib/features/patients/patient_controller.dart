import 'package:get/get.dart';

class PatientController extends GetxController {
  // Observable list of patients
  var patients = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'John Doe',
      'age': 45,
      'gender': 'Male',
      'phone': '+1 234-567-8900',
      'email': 'john.doe@email.com',
      'address': '123 Main St, New York, NY',
      'bloodType': 'O+',
      'lastVisit': '2024-01-15',
      'condition': 'Hypertension',
      'status': 'stable',
      'avatar': 'JD',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'age': 32,
      'gender': 'Female',
      'phone': '+1 234-567-8901',
      'email': 'jane.smith@email.com',
      'address': '456 Oak Ave, Boston, MA',
      'bloodType': 'A+',
      'lastVisit': '2024-01-10',
      'condition': 'Diabetes Type 2',
      'status': 'monitoring',
      'avatar': 'JS',
    },
    {
      'id': '3',
      'name': 'Robert Johnson',
      'age': 58,
      'gender': 'Male',
      'phone': '+1 234-567-8902',
      'email': 'robert.j@email.com',
      'address': '789 Pine Rd, Chicago, IL',
      'bloodType': 'B-',
      'lastVisit': '2024-01-12',
      'condition': 'Cardiac Issues',
      'status': 'critical',
      'avatar': 'RJ',
    },
    {
      'id': '4',
      'name': 'Emily Davis',
      'age': 28,
      'gender': 'Female',
      'phone': '+1 234-567-8903',
      'email': 'emily.d@email.com',
      'address': '321 Elm St, Los Angeles, CA',
      'bloodType': 'AB+',
      'lastVisit': '2024-01-18',
      'condition': 'Asthma',
      'status': 'stable',
      'avatar': 'ED',
    },
    {
      'id': '5',
      'name': 'Michael Brown',
      'age': 65,
      'gender': 'Male',
      'phone': '+1 234-567-8904',
      'email': 'michael.b@email.com',
      'address': '654 Maple Dr, Miami, FL',
      'bloodType': 'O-',
      'lastVisit': '2024-01-08',
      'condition': 'Arthritis',
      'status': 'monitoring',
      'avatar': 'MB',
    },
  ].obs;

  // Add a new patient
  void addPatient(Map<String, dynamic> patient) {
    // Generate new ID
    final newId = (patients.length + 1).toString();

    // Create avatar from name
    final nameParts = patient['name'].split(' ');
    final avatar = nameParts.length > 1
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : nameParts[0].substring(0, 2).toUpperCase();

    final newPatient = {
      'id': newId,
      'name': patient['name'],
      'age': patient['age'],
      'gender': patient['gender'],
      'phone': patient['phone'],
      'email': patient['email'] ?? '',
      'address': patient['address'],
      'bloodType': patient['bloodType'],
      'lastVisit': DateTime.now().toString().substring(0, 10),
      'condition': patient['condition'],
      'status': patient['status'],
      'avatar': avatar,
    };

    patients.add(newPatient);
  }

  // Update existing patient
  void updatePatient(String id, Map<String, dynamic> updatedData) {
    final index = patients.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      patients[index] = {...patients[index], ...updatedData};
      patients.refresh();
    }
  }

  // Delete patient
  void deletePatient(String id) {
    patients.removeWhere((p) => p['id'] == id);
  }

  // Get patient by ID
  Map<String, dynamic>? getPatientById(String id) {
    try {
      return patients.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
