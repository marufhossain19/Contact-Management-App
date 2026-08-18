import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient:
                isDark ? AppTheme.darkAppBarGradient : AppTheme.appBarGradient,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          // Theme Section
          _SectionHeader(title: 'Appearance', isDark: isDark),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.greenPrimary.withValues(alpha: 0.15)
                          : AppTheme.greenPale.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.palette_rounded,
                      color:
                          isDark ? AppTheme.greenLight : AppTheme.greenPrimary,
                    ),
                  ),
                  title: Text(
                    'Theme',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                    ),
                  ),
                  subtitle: Text(
                    isDarkMode ? 'Dark' : 'Light',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: isDark ? const Color(0xFF444444) : AppTheme.greyLight,
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.goldPrimary.withValues(alpha: 0.15)
                          : AppTheme.goldPale,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: isDark ? AppTheme.goldLight : AppTheme.goldDark,
                    ),
                  ),
                  title: Text(
                    'Change Theme',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                    ),
                  ),
                  subtitle: Text(
                    'Light / Dark',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                    ),
                  ),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (_) => onToggleTheme(),
                    activeThumbColor: AppTheme.greenMedium,
                    activeTrackColor:
                        AppTheme.greenPrimary.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _SectionHeader(title: 'Information', isDark: isDark),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.greenPrimary.withValues(alpha: 0.15)
                          : AppTheme.greenPale.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.info_rounded,
                      color:
                          isDark ? AppTheme.greenLight : AppTheme.greenPrimary,
                    ),
                  ),
                  title: Text(
                    'About App',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.grey[600] : AppTheme.greyLight,
                  ),
                  onTap: () => _showAboutDialog(context, isDark),
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: isDark ? const Color(0xFF444444) : AppTheme.greyLight,
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.goldPrimary.withValues(alpha: 0.15)
                          : AppTheme.goldPale,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.verified_rounded,
                      color: isDark ? AppTheme.goldLight : AppTheme.goldDark,
                    ),
                  ),
                  title: Text(
                    'Version',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
                    ),
                  ),
                  trailing: Text(
                    '1.0.0',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : AppTheme.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.contacts_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact Management',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A clean and beautiful contact management app built with Flutter and SQLite. Manage your contacts with ease!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : AppTheme.greyMedium,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: AppTheme.greenPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? AppTheme.greenLight : AppTheme.greenPrimary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
