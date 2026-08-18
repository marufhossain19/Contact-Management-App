import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';
import '../theme/app_theme.dart';
import '../widgets/contact_tile.dart';
import '../widgets/app_drawer.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class ContactListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const ContactListScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with SingleTickerProviderStateMixin {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      _contacts = contacts;
      _filteredContacts = contacts;
      _isLoading = false;
    });
    _fabAnimController.forward();
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts
            .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _toggleFavorite(Contact contact) async {
    await DatabaseHelper.instance
        .toggleFavorite(contact.id!, !contact.isFavorite);
    await _loadContacts();
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

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredContacts = _contacts;
      }
    });
  }

  Future<void> _navigateToAddContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddContactScreen()),
    );
    if (result == true) _loadContacts();
  }

  Future<void> _navigateToDetail(Contact contact) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailScreen(contact: contact),
      ),
    );
    if (result == true) _loadContacts();
  }

  Future<void> _navigateToFavorites() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
    if (result == true) _loadContacts();
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: AppDrawer(
        currentIndex: 0,
        onContactsTap: () {},
        onFavoritesTap: _navigateToFavorites,
        onAddContactTap: _navigateToAddContact,
        onSettingsTap: _navigateToSettings,
      ),
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
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    onChanged: _filterContacts,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    cursorColor: AppTheme.goldPrimary,
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      hintStyle:
                          TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  )
                : Text(
                    'My Contacts',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close_rounded : Icons.search_rounded,
                ),
                onPressed: _toggleSearch,
              ),
              if (!_isSearching)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (value) {
                    if (value == 'favorites') _navigateToFavorites();
                    if (value == 'settings') _navigateToSettings();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'favorites',
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, size: 20),
                          SizedBox(width: 10),
                          Text('Favorites'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings_rounded, size: 20),
                          SizedBox(width: 10),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.greenPrimary))
          : _filteredContacts.isEmpty
              ? _buildEmptyState(isDark)
              : RefreshIndicator(
                  onRefresh: _loadContacts,
                  color: AppTheme.greenPrimary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 300 + (index * 50)),
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
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final isSearchEmpty = _searchController.text.isNotEmpty;
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
                    ? AppTheme.greenPrimary.withValues(alpha: 0.1)
                    : AppTheme.greenPale.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearchEmpty
                    ? Icons.search_off_rounded
                    : Icons.contacts_rounded,
                size: 64,
                color: isDark ? AppTheme.greenLight : AppTheme.greenMedium,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isSearchEmpty ? 'No results found' : 'No contacts yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearchEmpty
                  ? 'Try a different search term'
                  : 'Add your first contact by tapping\nthe + button below.',
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
