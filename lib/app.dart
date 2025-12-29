import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/theme_controller.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/patients/patient_list_screen.dart';
import 'features/patients/patient_controller.dart';
import 'features/transfers/transfer_screen.dart';
import 'features/notifications/notification_screen.dart';
import '/./features/appointments/appoinment_screen.dart';
import 'features/ai/ai_analysis_screen.dart';
import 'features/appointments/appointment_controller.dart';

class MedRelayApp extends StatelessWidget {
  const MedRelayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final themeController = Get.put(ThemeController());
    Get.put(PatientController());
    Get.put(AppointmentController());

    return Obx(
      () => GetMaterialApp(
        title: 'MediRelay AI',
        debugShowCheckedModeBanner: false,
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,

        // Initial route
        initialRoute: '/splash',

        // Routes
        getPages: [
          GetPage(
            name: '/splash',
            page: () => const SplashScreen(),
            transition: Transition.fade,
          ),
          GetPage(
            name: '/login',
            page: () => const LoginScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/register',
            page: () => const RegisterScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/dashboard',
            page: () => const DashboardScreen(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/patients',
            page: () => const PatientListScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/transfers',
            page: () => const TransferScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/notifications',
            page: () => const NotificationScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/appointments',
            page: () => const AppointmentsScreen(),
            transition: Transition.rightToLeft,
          ),
          GetPage(
            name: '/ai-analysis',
            page: () => const AIAnalysisScreen(),
            transition: Transition.rightToLeft,
          ),
        ],
      ),
    );
  }
}
