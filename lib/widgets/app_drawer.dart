import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onContactsTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onAddContactTap;
  final VoidCallback onSettingsTap;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onContactsTap,
    required this.onFavoritesTap,
    required this.onAddContactTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppTheme.white,
      child: Column(
        children: [
          // Drawer Header with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppTheme.darkAppBarGradient
                  : AppTheme.appBarGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.contacts_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'My Contacts',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your friends easily',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Menu items
          _DrawerItem(
            icon: Icons.people_rounded,
            label: 'My Contacts',
            isSelected: currentIndex == 0,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
              onContactsTap();
            },
          ),
          _DrawerItem(
            icon: Icons.star_rounded,
            label: 'Favorites',
            isSelected: currentIndex == 1,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
              onFavoritesTap();
            },
          ),
          _DrawerItem(
            icon: Icons.person_add_rounded,
            label: 'Add Contact',
            isSelected: currentIndex == 2,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
              onAddContactTap();
            },
          ),

          const Spacer(),

          Divider(color: isDark ? const Color(0xFF444444) : AppTheme.greyLight),

          _DrawerItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            isSelected: currentIndex == 3,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
              onSettingsTap();
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? AppTheme.greenPrimary
              : (isDark ? Colors.grey[400] : AppTheme.greyMedium),
          size: 24,
        ),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14.5,
            color: isSelected
                ? AppTheme.greenPrimary
                : (isDark ? Colors.white : AppTheme.black),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? Colors.grey[600] : AppTheme.greyLight,
          size: 22,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selectedTileColor: isDark
            ? AppTheme.greenPrimary.withValues(alpha: 0.15)
            : AppTheme.greenPale.withValues(alpha: 0.5),
        selected: isSelected,
        onTap: onTap,
      ),
    );
  }
}
