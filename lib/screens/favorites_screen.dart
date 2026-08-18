import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';
import '../theme/app_theme.dart';
import '../widgets/contact_tile.dart';
import 'contact_detail_screen.dart';
import 'add_contact_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  List<Contact> _favorites = [];
  bool _isLoading = true;
  bool _hasChanges = false;
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadFavorites();
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favorites = await DatabaseHelper.instance.getFavoriteContacts();
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
    _fabAnimController.forward();
  }
  Future<void> _toggleFavorite(Contact contact) async {
    await DatabaseHelper.instance
        .toggleFavorite(contact.id!, !contact.isFavorite);
    _hasChanges = true;
    await _loadFavorites();
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                !contact.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                !contact.isFavorite
                    ? 'Added to favorites'
                    : 'Removed from favorites',
              ),
            ],
          ),
          backgroundColor: !contact.isFavorite
              ? AppTheme.goldDark
              : AppTheme.greyDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _navigateToDetail(Contact contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailScreen(contact: contact),
      ),
    );
    if (result == true) {
      _hasChanges = true;
      _loadFavorites();
    }
  }

  Future<void> _navigateToAddContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddContactScreen()),
    );
    if (result == true) {
      _hasChanges = true;
      _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _hasChanges) {
          Navigator.of(context);
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
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: AppTheme.goldPrimary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Favorites',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppTheme.greenPrimary))
            : _favorites.isEmpty
                ? _buildEmptyState(isDark)
                : RefreshIndicator(
                    onRefresh: _loadFavorites,
                    color: AppTheme.goldPrimary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        final contact = _favorites[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration:
                              Duration(milliseconds: 300 + (index * 50)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: ContactTile(
                            contact: contact,
                            onTap: () => _navigateToDetail(contact),
                            onFavoriteToggle: () => _toggleFavorite(contact),
                          ),
                        );
                      },
                    ),
                  ),
        floatingActionButton: ScaleTransition(
          scale: CurvedAnimation(
            parent: _fabAnimController,
            curve: Curves.elasticOut,
          ),
          child: FloatingActionButton(
            onPressed: _navigateToAddContact,
            tooltip: 'Add Contact',
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.goldPrimary.withValues(alpha: 0.1)
                    : AppTheme.goldPale,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_border_rounded,
                size: 64,
                color: isDark ? AppTheme.goldLight : AppTheme.goldDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No favorites yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mark contacts as favorites\nby tapping the star icon.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : AppTheme.greyMedium,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
