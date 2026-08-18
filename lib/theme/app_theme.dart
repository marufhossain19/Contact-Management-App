import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Green Palette ───
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color greenPrimary = Color(0xFF2E7D32);
  static const Color greenMedium = Color(0xFF4CAF50);
  static const Color greenLight = Color(0xFF81C784);
  static const Color greenPale = Color(0xFFC8E6C9);

  // ─── Gold Palette ───
  static const Color goldDark = Color(0xFFFF8F00);
  static const Color goldPrimary = Color(0xFFFFC107);
  static const Color goldLight = Color(0xFFFFD54F);
  static const Color goldPale = Color(0xFFFFF8E1);

  // ─── Neutrals ───
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyMedium = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF424242);
  static const Color black = Color(0xFF212121);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [greenDark, greenMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [greenDark, greenPrimary, greenMedium],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldDark, goldPrimary, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF1F8E9), Color(0xFFE8F5E9), white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkAppBarGradient = LinearGradient(
    colors: [Color(0xFF1A3C1A), Color(0xFF2E5E2E)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ─── Avatar Colors ───
  static const List<Color> avatarColors = [
    Color(0xFF1B5E20),
    Color(0xFF2E7D32),
    Color(0xFF388E3C),
    Color(0xFF43A047),
    Color(0xFF4CAF50),
    Color(0xFFFF8F00),
    Color(0xFFFFA000),
    Color(0xFFFFB300),
    Color(0xFF00695C),
    Color(0xFF00796B),
  ];

  static Color getAvatarColor(String name) {
    final index = name.isEmpty ? 0 : name.codeUnitAt(0) % avatarColors.length;
    return avatarColors[index];
  }

  // ─── Light Theme ───
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: greenPrimary,
      primary: greenPrimary,
      secondary: goldPrimary,
      surface: white,
      onPrimary: white,
      onSecondary: black,
      onSurface: black,
    ),
    scaffoldBackgroundColor: offWhite,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: greenPrimary,
      foregroundColor: white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
      iconTheme: const IconThemeData(color: white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: goldPrimary,
      foregroundColor: black,
      elevation: 6,
      shape: CircleBorder(),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: white,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: greenPrimary, width: 2),
      ),
      prefixIconColor: greenMedium,
      labelStyle: GoogleFonts.poppins(color: greyMedium),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenPrimary,
        foregroundColor: white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerColor: greyLight,
    iconTheme: const IconThemeData(color: greenPrimary),
  );

  // ─── Dark Theme ───
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: greenPrimary,
      brightness: Brightness.dark,
      primary: greenMedium,
      secondary: goldPrimary,
      surface: const Color(0xFF1E1E1E),
      onPrimary: white,
      onSecondary: black,
      onSurface: white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: const Color(0xFF1A3C1A),
      foregroundColor: white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
      iconTheme: const IconThemeData(color: white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: goldPrimary,
      foregroundColor: black,
      elevation: 6,
      shape: CircleBorder(),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF2C2C2C),
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF444444)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF444444)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: greenMedium, width: 2),
      ),
      prefixIconColor: greenLight,
      labelStyle: GoogleFonts.poppins(color: greyMedium),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenMedium,
        foregroundColor: white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerColor: const Color(0xFF444444),
    iconTheme: const IconThemeData(color: greenLight),
  );
}
