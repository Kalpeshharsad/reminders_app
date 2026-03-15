import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          children: [
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Symbols.arrow_back_ios, color: AppTheme.primary, size: 20),
            ),
            const Text('Back', style: TextStyle(color: AppTheme.primary, fontSize: 16)),
          ],
        ),
        leadingWidth: 100,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileSection(isDark),
            const SizedBox(height: 24),
            _buildSection(context, 'Appearance', [
              _buildToggleItem('Dark Mode', Symbols.dark_mode, Colors.indigo, true, isDark),
              _buildToggleItem('Automatic', Symbols.brightness_medium, Colors.orange, false, isDark),
            ]),
            const SizedBox(height: 24),
            _buildThemeColorSection(isDark),
            const SizedBox(height: 24),
            _buildSection(context, 'Notifications', [
              _buildToggleItem('Allow Notifications', Symbols.notifications_active, Colors.red, true, isDark),
              _buildNavigateItem('Scheduled Summary', Symbols.schedule, Colors.blue, 'Off', isDark),
              _buildNavigateItem('Sounds & Haptics', Symbols.vibration, Colors.grey, null, isDark),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'General', [
              _buildNavigateItem('Cloud Sync', Symbols.sync, Colors.lightBlue, 'iCloud', isDark),
              _buildNavigateItem('Help & Feedback', Symbols.help, Colors.teal, null, isDark),
              _buildNavigateItem('Rate App', Symbols.star, Colors.pink, null, isDark),
            ]),
            const SizedBox(height: 32),
            const Text(
              'Reminders version 2.4.0 (829)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Symbols.account_circle, color: AppTheme.primary, size: 36),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alex Johnson', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Apple ID, iCloud, Media & Purchases', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Symbols.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(String title, IconData icon, Color iconBg, bool value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05), width: 0.5)),
      ),
      child: Row(
        children: [
          _buildIcon(icon, iconBg),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: (val) {},
            activeThumbColor: Colors.white,
            activeTrackColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigateItem(String title, IconData icon, Color iconBg, String? subtitle, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05), width: 0.5)),
      ),
      child: Row(
        children: [
          _buildIcon(icon, iconBg),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          if (subtitle != null)
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Symbols.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color bg) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildThemeColorSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text('THEME COLOR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColorSwatch(AppTheme.primary, true),
              _buildColorSwatch(Colors.purple, false),
              _buildColorSwatch(Colors.pink, false),
              _buildColorSwatch(Colors.green, false),
              _buildColorSwatch(Colors.yellow, false),
              _buildColorSwatch(Colors.blueGrey, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(Color color, bool isSelected) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 4) : null,
      ),
      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
    );
  }
}
