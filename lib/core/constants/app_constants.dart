class AppConstants {
  // App Info
  static const String appName = 'MediRelay AI';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Smart Healthcare Referral System';

  // API Configuration
  static const String anthropicApiKey = 'YOUR_ANTHROPIC_API_KEY';
  static const String anthropicApiUrl = 'https://api.anthropic.com/v1/messages';
  static const String claudeModel = 'claude-sonnet-4-20250514';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String patientsCollection = 'patients';
  static const String appointmentsCollection = 'appointments';
  static const String referralsCollection = 'referrals';
  static const String medicalRecordsCollection = 'medical_records';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String notificationsCollection = 'notifications';

  // Local Storage Keys
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserToken = 'user_token';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyEncryptionKey = 'encryption_key';
  static const String keyLastSync = 'last_sync';

  // Medical Specialties
  static const List<String> specialties = [
    'General Practice',
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'Neurology',
    'Oncology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Pulmonology',
    'Radiology',
    'Surgery',
    'Urology',
  ];

  // Urgency Levels
  static const String urgencyLow = 'low';
  static const String urgencyMedium = 'medium';
  static const String urgencyHigh = 'high';
  static const String urgencyEmergency = 'emergency';

  // Appointment Status
  static const String appointmentScheduled = 'scheduled';
  static const String appointmentCompleted = 'completed';
  static const String appointmentCancelled = 'cancelled';
  static const String appointmentNoShow = 'no_show';

  // Referral Status
  static const String referralPending = 'pending';
  static const String referralAccepted = 'accepted';
  static const String referralDeclined = 'declined';
  static const String referralCompleted = 'completed';

  // File Types
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Validation
  static const int minPasswordLength = 8;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^\+?[\d\s-]{10,}$';

  // Encryption
  static const int encryptionKeyLength = 32;
  static const String encryptionMode = 'AES-256';

  // Pagination
  static const int patientsPerPage = 20;
  static const int appointmentsPerPage = 50;
  static const int messagesPerPage = 30;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorAuth = 'Authentication failed. Please login again.';
  static const String errorPermission =
      'Permission denied. Please grant required permissions.';

  // Success Messages
  static const String successPatientAdded = 'Patient added successfully';
  static const String successAppointmentScheduled =
      'Appointment scheduled successfully';
  static const String successReferralSent = 'Referral sent successfully';
  static const String successFileUploaded = 'File uploaded successfully';
}
