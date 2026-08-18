import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';
import '../theme/app_theme.dart';
import 'edit_contact_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late Contact _contact;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _toggleFavorite() async {
    await DatabaseHelper.instance
        .toggleFavorite(_contact.id!, !_contact.isFavorite);
    setState(() {
      _contact = _contact.copyWith(isFavorite: !_contact.isFavorite);
      _hasChanges = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _contact.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                _contact.isFavorite
                    ? 'Added to favorites'
                    : 'Removed from favorites',
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          backgroundColor:
              _contact.isFavorite ? AppTheme.goldDark : AppTheme.greyDark,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditContactScreen(contact: _contact),
      ),
    );
    if (result == true) {
      // Reload contact from DB
      final updatedContact =
          await DatabaseHelper.instance.getContact(_contact.id!);
      if (updatedContact != null && mounted) {
        setState(() {
          _contact = updatedContact;
          _hasChanges = true;
        });
      }
    }
  }

  Future<void> _deleteContact() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? const Color(0xFF2C2C2C) : AppTheme.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Contact',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete\n${_contact.name}?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isDark ? Colors.grey[600]! : AppTheme.greyLight,
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.grey[400] : AppTheme.greyDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteContact(_contact.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.delete_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text('Contact deleted', style: GoogleFonts.poppins()),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarColor = AppTheme.getAvatarColor(_contact.name);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _hasChanges) {
          // Changes will be picked up by the result
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppTheme.darkAppBarGradient
                  : AppTheme.appBarGradient,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Contact Details',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: _navigateToEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded),
                  onPressed: _deleteContact,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient and avatar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppTheme.darkAppBarGradient
                      : AppTheme.primaryGradient,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Hero(
                      tag: 'avatar_${_contact.id}',
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.2),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: avatarColor,
                          child: Text(
                            _contact.initials,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _contact.name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Favorite toggle button
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: _contact.isFavorite
                              ? AppTheme.goldPrimary.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _contact.isFavorite
                                ? AppTheme.goldPrimary
                                : Colors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _contact.isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: _contact.isFavorite
                                  ? AppTheme.goldPrimary
                                  : Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _contact.isFavorite ? 'Favorited' : 'Add to Favorites',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _contact.isFavorite
                                    ? AppTheme.goldPrimary
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Contact info cards
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _InfoCard(
                      icon: Icons.phone_rounded,
                      label: 'Mobile',
                      value: _contact.phone,
                      iconColor: AppTheme.greenPrimary,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.email_rounded,
                      label: 'Email',
                      value: _contact.email,
                      iconColor: AppTheme.goldDark,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.location_on_rounded,
                      label: 'Address',
                      value: _contact.address,
                      iconColor: AppTheme.greenMedium,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool isDark;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
