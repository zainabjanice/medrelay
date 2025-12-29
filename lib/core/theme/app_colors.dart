import 'package:flutter/material.dart';

class AppColors {
  // ==================== PROFESSIONAL MEDICAL PALETTE ====================

  // Primary Blues - From the palette you showed
  static const Color lightestBlue = Color(
    0xFFF0F3FA,
  ); // #F0F3FA - Very light (backgrounds)
  static const Color veryLightBlue = Color(
    0xFFD5DEEF,
  ); // #D5DEEF - Light (cards in light mode)
  static const Color lightBlue = Color(0xFFB1C9EF); // #B1C9EF - Medium light
  static const Color mediumBlue = Color(
    0xFF8AAEE0,
  ); // #8AAEE0 - Medium (accents)
  static const Color primary = Color(
    0xFF638ECB,
  ); // #638ECB - Main primary color
  static const Color primaryDark = Color(
    0xFF395886,
  ); // #395886 - Dark blue (headers, emphasis)

  // These will be our MAIN colors throughout the app
  static const Color background = lightestBlue; // Main background
  static const Color surface = Color(0xFFFFFFFF); // Cards surface (white)
  static const Color cardBackground = veryLightBlue; // Alternative card bg
  static const Color primaryAccent = primary; // Buttons, links
  static const Color appBarColor = primaryDark; // App bars

  // Secondary Medical Colors - Complementary
  static const Color secondary = Color(0xFF4ECDC4); // Teal (medical green-blue)
  static const Color secondaryLight = Color(0xFF95E1D3); // Light teal

  // Text Colors - Adjusted for the blue theme
  static const Color textPrimary = Color(0xFF1A2332); // Very dark blue-gray
  static const Color textSecondary = Color(0xFF4A5567); // Medium blue-gray
  static const Color textTertiary = Color(0xFF6B7280); // Light gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White for buttons
  static const Color textWhite = Color(0xFFFFFFFF); // White text

  // Status Colors - Softer medical tones
  static const Color success = Color(0xFF48BB78); // Soft green
  static const Color warning = Color(0xFFED8936); // Soft orange
  static const Color error = Color(0xFFE53E3E); // Soft red
  static const Color info = Color(0xFF4299E1); // Info blue

  // Medical Specialty Colors - Based on our palette
  static const Color cardiology = Color(0xFFE53E3E); // Red
  static const Color neurology = Color(0xFF9F7AEA); // Purple
  static const Color pediatrics = Color(0xFF63B3ED); // Sky blue
  static const Color orthopedics = Color(0xFF48BB78); // Green
  static const Color dermatology = Color(0xFFFBD38D); // Beige
  static const Color psychiatry = Color(0xFFB794F4); // Lavender

  // Gradients - Using our palette
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightestBlue, veryLightBlue],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), veryLightBlue],
  );

  // Border Colors
  static const Color border = Color(0xFFD1D9E6); // Soft blue-gray border
  static const Color borderLight = Color(0xFFE5EAF3); // Very light border

  // Shadow Colors
  static const Color shadow = Color(0x1A395886); // Soft blue shadow
  static const Color shadowDark = Color(0x33395886); // Darker shadow

  // ==================== DARK MODE COLORS ====================

  static const Color darkBackground = Color(0xFF1A2332); // Very dark blue
  static const Color darkSurface = Color(0xFF2D3748); // Dark blue-gray
  static const Color darkSurfaceElevated = Color(0xFF3A4556); // Elevated dark
  static const Color darkBorder = Color(0xFF4A5568); // Dark border
  static const Color darkTextPrimary = Color(0xFFF7FAFC); // Almost white
  static const Color darkTextSecondary = Color(0xFFCBD5E0); // Light gray

  // Dark mode adjusted colors
  static const Color darkPrimary = mediumBlue; // Lighter primary for dark mode
  static const Color darkSecondary = secondaryLight; // Lighter secondary

  // Hover and Active States
  static const Color hoverBlue = Color(0xFF7CA1D7); // Hover state
  static const Color activeBlue = primaryDark; // Active/pressed state

  // Special UI Elements
  static const Color divider = Color(0xFFE2E8F0);
  static const Color overlay = Color(0x66000000); // Modal overlay
  static const Color shimmer = Color(0xFFEDF2F7); // Loading shimmer

  // Badge Colors
  static const Color badgeBlue = primary;
  static const Color badgeGreen = success;
  static const Color badgeOrange = warning;
  static const Color badgeRed = error;

  // Chart Colors - Various blues from palette
  static final List<Color> chartColors = [
    primary,
    mediumBlue,
    lightBlue,
    secondary,
    primaryDark,
    Color(0xFF7CA1D7),
  ];

  // ==================== HELPER METHODS ====================

  /// Get color with opacity
  static Color withAlpha(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get appropriate text color for background
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textOnPrimary;
  }

  /// Get status color by name
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'stable':
      case 'success':
      case 'active':
        return success;
      case 'monitoring':
      case 'warning':
      case 'pending':
        return warning;
      case 'critical':
      case 'error':
      case 'failed':
        return error;
      case 'info':
      case 'scheduled':
        return info;
      default:
        return textSecondary;
    }
  }
}
