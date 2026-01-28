// import 'package:flutter/material.dart';

// class AppTheme {
//   // WhatsApp Color Constants
//   static const Color whatsAppTeal = Color(0xFF075E54);
//   static const Color whatsAppTealDark = Color(0xFF054D42);
//   static const Color whatsAppTealLight = Color(0xFF128C7E);
//   static const Color whatsAppGreen = Color(0xFF25D366);
//   static const Color whatsAppGreenLight = Color(0xFFDCF8C6);
//   static const Color whatsAppBlue = Color(0xFF34B7F1);

//   // Light Theme Colors
//   static const Color lightPrimary = Color(0xFF008069);
//   static const Color lightBackground = Color(0xFFF0F2F5);
//   static const Color lightChatBackground = Color(0xFFEFE7DD);
//   static const Color lightMessageBubbleReceived = Colors.white;
//   static const Color lightMessageBubbleSent = Color(0xFFD9FDD3);

//   // Dark Theme Colors
//   static const Color darkPrimary = Color(0xFF00A884);
//   static const Color darkBackground = Color(0xFF111B21);
//   static const Color darkSurface = Color(0xFF202C33);
//   static const Color darkChatBackground = Color(0xFF0B141A);
//   static const Color darkMessageBubbleReceived = Color(0xFF202C33);
//   static const Color darkMessageBubbleSent = Color(0xFF005C4B);

//   static final lightTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.light,
//     primaryColor: lightPrimary,
//     primaryColorDark: whatsAppTealDark,
//     primaryColorLight: whatsAppTealLight,
//     hintColor: whatsAppGreen,
//     scaffoldBackgroundColor: lightBackground,

//     // Color Scheme
//     colorScheme: const ColorScheme.light(
//       primary: lightPrimary,
//       secondary: whatsAppGreen,
//       surface: Colors.white,
//       error: Color(0xFFE53935),
//       onPrimary: Colors.white,
//       onSecondary: Colors.white,
//       onSurface: Colors.black87,
//       onError: Colors.white,
//     ),

//     // AppBar Theme
//     appBarTheme: const AppBarTheme(
//       backgroundColor: lightPrimary,
//       elevation: 0,
//       centerTitle: false,
//       iconTheme: IconThemeData(color: Colors.white),
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         letterSpacing: 0.15,
//       ),
//     ),

//     // Icon Theme
//     iconTheme: const IconThemeData(
//       color: Color(0xFF667781),
//     ),

//     // Text Theme
//     textTheme: const TextTheme(
//       displayLarge: TextStyle(
//         color: Colors.black,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 0,
//       ),
//       displayMedium: TextStyle(
//         color: Colors.black,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         letterSpacing: 0.15,
//       ),
//       displaySmall: TextStyle(
//         color: Colors.black,
//         fontSize: 18,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0.15,
//       ),
//       bodyLarge: TextStyle(
//         color: Colors.black87,
//         fontSize: 16,
//         letterSpacing: 0.15,
//       ),
//       bodyMedium: TextStyle(
//         color: Color(0xFF667781),
//         fontSize: 14,
//         letterSpacing: 0.25,
//       ),
//       bodySmall: TextStyle(
//         color: Color(0xFF8696A0),
//         fontSize: 12,
//         letterSpacing: 0.4,
//       ),
//       labelLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         letterSpacing: 0.5,
//       ),
//       labelMedium: TextStyle(
//         color: Colors.black87,
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0.5,
//       ),
//     ),

//     // Button Themes
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: lightPrimary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//         textStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.5,
//         ),
//       ),
//     ),

//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: lightPrimary,
//         textStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.5,
//         ),
//       ),
//     ),

//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: whatsAppGreen,
//       foregroundColor: Colors.white,
//       elevation: 3,
//     ),

//     // Input Decoration Theme
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: lightPrimary, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE53935)),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       hintStyle: const TextStyle(
//         color: Color(0xFF8696A0),
//         fontSize: 16,
//       ),
//     ),

//     // Card Theme
//     cardTheme: CardThemeData(
//       color: Colors.white,
//       elevation: 1,
//       shadowColor: Colors.black.withOpacity(0.1),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),

//     // Dialog Theme
//     dialogTheme: DialogThemeData(
//       backgroundColor: Colors.white,
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),

//     // Divider Theme
//     dividerTheme: const DividerThemeData(
//       color: Color(0xFFE0E0E0),
//       thickness: 0.5,
//       space: 1,
//     ),

//     // Bottom Sheet Theme
//     bottomSheetTheme: const BottomSheetThemeData(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     ),

//     // List Tile Theme
//     listTileTheme: const ListTileThemeData(
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),
//   );

//   static final darkTheme = ThemeData(
//     useMaterial3: true,
//     brightness: Brightness.dark,
//     primaryColor: darkPrimary,
//     primaryColorDark: whatsAppTealDark,
//     primaryColorLight: whatsAppTealLight,
//     hintColor: whatsAppGreen,
//     scaffoldBackgroundColor: darkBackground,

//     // Color Scheme
//     colorScheme: const ColorScheme.dark(
//       primary: darkPrimary,
//       secondary: whatsAppGreen,
//       surface: darkSurface,
//       error: Color(0xFFEF5350),
//       onPrimary: Colors.white,
//       onSecondary: Colors.white,
//       onSurface: Colors.white,
//       onError: Colors.white,
//     ),

//     // AppBar Theme
//     appBarTheme: const AppBarTheme(
//       backgroundColor: darkSurface,
//       elevation: 0,
//       centerTitle: false,
//       iconTheme: IconThemeData(color: Colors.white),
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         letterSpacing: 0.15,
//       ),
//     ),

//     // Icon Theme
//     iconTheme: const IconThemeData(
//       color: Color(0xFF8696A0),
//     ),

//     // Text Theme
//     textTheme: const TextTheme(
//       displayLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 0,
//       ),
//       displayMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         letterSpacing: 0.15,
//       ),
//       displaySmall: TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0.15,
//       ),
//       bodyLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         letterSpacing: 0.15,
//       ),
//       bodyMedium: TextStyle(
//         color: Color(0xFF8696A0),
//         fontSize: 14,
//         letterSpacing: 0.25,
//       ),
//       bodySmall: TextStyle(
//         color: Color(0xFF667781),
//         fontSize: 12,
//         letterSpacing: 0.4,
//       ),
//       labelLarge: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         letterSpacing: 0.5,
//       ),
//       labelMedium: TextStyle(
//         color: Colors.white,
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0.5,
//       ),
//     ),

//     // Button Themes
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: darkPrimary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//         textStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.5,
//         ),
//       ),
//     ),

//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: darkPrimary,
//         textStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.5,
//         ),
//       ),
//     ),

//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: whatsAppGreen,
//       foregroundColor: Colors.white,
//       elevation: 3,
//     ),

//     // Input Decoration Theme
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF2A3942)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF2A3942)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: darkPrimary, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFEF5350)),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFFEF5350), width: 2),
//       ),
//       filled: true,
//       fillColor: darkSurface,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       hintStyle: const TextStyle(
//         color: Color(0xFF667781),
//         fontSize: 16,
//       ),
//     ),

//     // Card Theme
//     cardTheme: CardThemeData(
//       color: darkSurface,
//       elevation: 1,
//       shadowColor: Colors.black.withOpacity(0.3),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),

//     // Dialog Theme
//     dialogTheme: DialogThemeData(
//       backgroundColor: darkSurface,
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),

//     // Divider Theme
//     dividerTheme: const DividerThemeData(
//       color: Color(0xFF2A3942),
//       thickness: 0.5,
//       space: 1,
//     ),

//     // Bottom Sheet Theme
//     bottomSheetTheme: const BottomSheetThemeData(
//       backgroundColor: darkSurface,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     ),

//     // List Tile Theme
//     listTileTheme: const ListTileThemeData(
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),
//   );
// }

import 'package:flutter/material.dart';

class AppTheme {
  // New Color Palette
  static const Color primaryDark = Color(0xFF1A3263); // Deep navy blue
  static const Color primaryBlue = Color(0xFF547792); // Muted blue-gray
  static const Color accentYellow = Color(0xFFFAB95B); // Warm yellow
  static const Color neutralLight = Color(0xFFE8E2DB); // Creamy off-white
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralBlack = Color(0xFF000000);

  // Derived colors
  static const Color primaryDarkVariant = Color(0xFF142654);
  static const Color primaryLightVariant = Color(0xFF5C859F);
  static const Color accentYellowLight = Color(0xFFFDE5B9);
  static const Color accentYellowDark = Color(0xFFE8A737);

  // Message bubble colors
  static const Color lightMessageBubbleReceived = Color(0xFFFFFFFF);
  static const Color lightMessageBubbleSent = Color(0xFFE1F5FE);
  static const Color darkMessageBubbleReceived = Color(0xFF2A3A4A);
  static const Color darkMessageBubbleSent = Color(0xFF1A3D5C);

  // Light Theme Colors
  static const Color lightPrimary = primaryDark;
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = neutralWhite;
  static const Color lightChatBackground = Color(0xFFF5F5F5);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightOnPrimary = neutralWhite;
  static const Color lightOnSurface = Color(0xFF212121);

  // Dark Theme Colors
  static const Color darkPrimary = primaryBlue;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkChatBackground = Color(0xFF0D1117);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = neutralWhite;
  static const Color darkOnSurface = Color(0xFFE0E0E0);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    primaryColorDark: primaryDarkVariant,
    primaryColorLight: primaryLightVariant,
    scaffoldBackgroundColor: lightBackground,
    canvasColor: lightSurface,
    cardColor: lightSurface,
    dialogBackgroundColor: lightSurface,
    indicatorColor: accentYellow,
    hintColor: accentYellow,
    dividerColor: Color(0xFFE0E0E0).withOpacity(0.5),
    shadowColor: Color(0xFF000000).withOpacity(0.1),

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      primaryContainer: primaryDarkVariant,
      secondary: accentYellow,
      secondaryContainer: accentYellowLight,
      surface: lightSurface,
      background: lightBackground,
      error: lightError,
      onPrimary: lightOnPrimary,
      onSecondary: neutralBlack,
      onSurface: lightOnSurface,
      onBackground: lightOnSurface,
      onError: neutralWhite,
      outline: Color(0xFFBDBDBD),
      outlineVariant: Color(0xFFEEEEEE),
    ).copyWith(
      tertiary: primaryBlue,
      tertiaryContainer: primaryBlue.withOpacity(0.2),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: lightOnPrimary,
      elevation: 1,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      shadowColor: lightPrimary.withOpacity(0.3),
      iconTheme: const IconThemeData(color: lightOnPrimary),
      actionsIconTheme: const IconThemeData(color: lightOnPrimary),
      titleTextStyle: const TextStyle(
        color: lightOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: Color(0xFF666666),
      size: 24,
    ),

    // Text Theme
    textTheme: TextTheme(
      // Headlines
      displayLarge: const TextStyle(
        color: lightOnSurface,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        fontFamily: 'Roboto',
      ),
      displayMedium: const TextStyle(
        color: lightOnSurface,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: 'Roboto',
      ),
      displaySmall: const TextStyle(
        color: lightOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
      titleLarge: const TextStyle(
        color: lightOnSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
      titleMedium: const TextStyle(
        color: lightOnSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
      titleSmall: TextStyle(
        color: lightOnSurface.withOpacity(0.7),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        fontFamily: 'Roboto',
      ),

      // Body
      bodyLarge: TextStyle(
        color: lightOnSurface.withOpacity(0.87),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        color: lightOnSurface.withOpacity(0.87),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        fontFamily: 'Roboto',
      ),
      bodySmall: TextStyle(
        color: lightOnSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        fontFamily: 'Roboto',
      ),

      // Labels
      labelLarge: const TextStyle(
        color: lightOnPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
      labelMedium: const TextStyle(
        color: lightPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
      labelSmall: TextStyle(
        color: lightOnSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: lightOnPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: lightPrimary.withOpacity(0.3),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accentYellow,
        foregroundColor: neutralBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimary,
        side: BorderSide(color: lightPrimary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentYellow,
      foregroundColor: neutralBlack,
      elevation: 3,
      // shape: CircleBorder(),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: neutralLight.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightError, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightError, width: 2),
      ),
      hintStyle: TextStyle(
        color: lightOnSurface.withOpacity(0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      labelStyle: TextStyle(
        color: lightOnSurface.withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      floatingLabelStyle: TextStyle(
        color: lightPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      errorStyle: const TextStyle(
        color: lightError,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 2,
      shadowColor: Color(0xFF000000).withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: lightSurface,
      elevation: 8,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        color: lightOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
      contentTextStyle: TextStyle(
        color: lightOnSurface.withOpacity(0.87),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: lightOnSurface.withOpacity(0.12),
      thickness: 1,
      space: 1,
      indent: 16,
      endIndent: 16,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      modalElevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBackgroundColor: lightSurface,
      dragHandleColor: lightOnSurface.withOpacity(0.4),
      dragHandleSize: const Size(40, 4),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      iconColor: primaryBlue,
      titleTextStyle: TextStyle(
        color: lightOnSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      subtitleTextStyle: TextStyle(
        color: lightOnSurface.withOpacity(0.6),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      leadingAndTrailingTextStyle: TextStyle(
        color: lightOnSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: neutralLight.withOpacity(0.5),
      selectedColor: lightPrimary,
      disabledColor: Color(0xFFE0E0E0),
      labelStyle: TextStyle(
        color: lightOnSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      secondaryLabelStyle: const TextStyle(
        color: lightOnPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      brightness: Brightness.light,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide.none,
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightSurface,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      indicatorColor: lightPrimary.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: lightPrimary,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: lightOnPrimary,
      unselectedLabelColor: lightOnSurface.withOpacity(0.6),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      overlayColor: MaterialStateProperty.all(lightPrimary.withOpacity(0.1)),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    primaryColorDark: primaryDarkVariant,
    primaryColorLight: primaryLightVariant,
    scaffoldBackgroundColor: darkBackground,
    canvasColor: darkSurface,
    cardColor: darkSurface,
    dialogBackgroundColor: darkSurface,
    indicatorColor: accentYellow,
    hintColor: accentYellow,
    dividerColor: Color(0xFF404040).withOpacity(0.5),
    shadowColor: Color(0xFF000000).withOpacity(0.3),

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      primaryContainer: primaryDarkVariant,
      secondary: accentYellow,
      secondaryContainer: accentYellowDark,
      surface: darkSurface,
      background: darkBackground,
      error: darkError,
      onPrimary: darkOnPrimary,
      onSecondary: neutralBlack,
      onSurface: darkOnSurface,
      onBackground: darkOnSurface,
      onError: neutralWhite,
      outline: Color(0xFF404040),
      outlineVariant: Color(0xFF2A2A2A),
    ).copyWith(
      tertiary: accentYellow,
      tertiaryContainer: accentYellow.withOpacity(0.2),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkOnSurface,
      elevation: 1,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      shadowColor: Color(0xFF000000).withOpacity(0.5),
      iconTheme: const IconThemeData(color: darkOnSurface),
      actionsIconTheme: const IconThemeData(color: darkOnSurface),
      titleTextStyle: const TextStyle(
        color: darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: Color(0xFFAAAAAA),
      size: 24,
    ),

    // Text Theme
    textTheme: TextTheme(
      // Headlines
      displayLarge: const TextStyle(
        color: darkOnSurface,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        fontFamily: 'Roboto',
      ),
      displayMedium: const TextStyle(
        color: darkOnSurface,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: 'Roboto',
      ),
      displaySmall: const TextStyle(
        color: darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
      titleLarge: const TextStyle(
        color: darkOnSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
      titleMedium: const TextStyle(
        color: darkOnSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        fontFamily: 'Roboto',
      ),
      titleSmall: TextStyle(
        color: darkOnSurface.withOpacity(0.7),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        fontFamily: 'Roboto',
      ),

      // Body
      bodyLarge: TextStyle(
        color: darkOnSurface.withOpacity(0.87),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        color: darkOnSurface.withOpacity(0.87),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        fontFamily: 'Roboto',
      ),
      bodySmall: TextStyle(
        color: darkOnSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        fontFamily: 'Roboto',
      ),

      // Labels
      labelLarge: const TextStyle(
        color: darkOnPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
      labelMedium: const TextStyle(
        color: darkPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
      labelSmall: TextStyle(
        color: darkOnSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontFamily: 'Roboto',
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkOnPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: Color(0xFF000000).withOpacity(0.5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accentYellow,
        foregroundColor: neutralBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimary,
        side: BorderSide(color: darkPrimary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentYellow,
      foregroundColor: neutralBlack,
      elevation: 3,
      // shape: CircleBorder(),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkError, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkError, width: 2),
      ),
      hintStyle: TextStyle(
        color: darkOnSurface.withOpacity(0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      labelStyle: TextStyle(
        color: darkOnSurface.withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      floatingLabelStyle: const TextStyle(
        color: darkPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      errorStyle: const TextStyle(
        color: darkError,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 2,
      shadowColor: Color(0xFF000000).withOpacity(0.5),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: darkSurface,
      elevation: 8,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        color: darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
      contentTextStyle: TextStyle(
        color: darkOnSurface.withOpacity(0.87),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: darkOnSurface.withOpacity(0.12),
      thickness: 1,
      space: 1,
      indent: 16,
      endIndent: 16,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      modalElevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBackgroundColor: darkSurface,
      dragHandleColor: darkOnSurface.withOpacity(0.4),
      dragHandleSize: const Size(40, 4),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      iconColor: primaryBlue,
      titleTextStyle: TextStyle(
        color: darkOnSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      subtitleTextStyle: TextStyle(
        color: darkOnSurface.withOpacity(0.6),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      leadingAndTrailingTextStyle: TextStyle(
        color: darkOnSurface.withOpacity(0.6),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      selectedColor: darkPrimary,
      disabledColor: Color(0xFF404040),
      labelStyle: TextStyle(
        color: darkOnSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      secondaryLabelStyle: const TextStyle(
        color: darkOnPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      brightness: Brightness.dark,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide.none,
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkSurface,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      indicatorColor: darkPrimary.withOpacity(0.3),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: darkPrimary,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: darkOnPrimary,
      unselectedLabelColor: darkOnSurface.withOpacity(0.6),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
      overlayColor: MaterialStateProperty.all(darkPrimary.withOpacity(0.1)),
    ),
  );

  // Helper methods for custom widgets
  static BoxDecoration messageBubbleDecoration(bool isSent, bool isDarkMode) {
    return BoxDecoration(
      color: isSent
          ? (isDarkMode ? darkMessageBubbleSent : lightMessageBubbleSent)
          : (isDarkMode
              ? darkMessageBubbleReceived
              : lightMessageBubbleReceived),
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(16),
        bottomLeft:
            isSent ? const Radius.circular(16) : const Radius.circular(4),
        bottomRight:
            isSent ? const Radius.circular(4) : const Radius.circular(16),
      ),
      boxShadow: [
        if (!isDarkMode)
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
      ],
    );
  }

  static BoxDecoration statusDecoration(bool isDarkMode) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [primaryDark, primaryBlue]
            : [lightPrimary, primaryBlue],
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }

  static Color getChatBackground(bool isDarkMode) {
    return isDarkMode ? darkChatBackground : lightChatBackground;
  }
}
