import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/security/encryption_service.dart';
import 'core/theme/theme_controller.dart';
import 'features/appointments/appointment_controller.dart';
import 'features/patients/patient_controller.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize GetStorage BEFORE controllers
  await GetStorage.init();

  // Initialize Encryption Service
  await EncryptionService().initialize();

  // Initialize Controllers
  _initializeControllers();

  // Determine if we should use Device Preview
  bool useDevicePreview = !kReleaseMode && kIsWeb;

  runApp(
    useDevicePreview
        ? DevicePreview(
            enabled: true,
            defaultDevice: Devices.ios.iPhone13,
            builder: (context) => const MedRelayApp(),
          )
        : const MedRelayApp(),
  );
}

void _initializeControllers() {
  if (!Get.isRegistered<ThemeController>()) {
    Get.put(ThemeController(), permanent: true);
  }

  Get.put(PatientController(), permanent: true);
  Get.put(AppointmentController(), permanent: true);

  debugPrint('✅ All controllers initialized');
}
