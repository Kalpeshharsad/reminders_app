import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8),
              Icon(Symbols.arrow_back_ios, color: settings.primaryColor, size: 20),
              Text('Back', style: TextStyle(color: settings.primaryColor, fontSize: 16)),
            ],
          ),
        ),
        leadingWidth: 100,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProfileSection(isDark, settings.primaryColor),
            const SizedBox(height: 24),
            _buildSection(context, 'Appearance', [
              _buildToggleItem(
                'Dark Mode', 
                Symbols.dark_mode, 
                Colors.indigo, 
                settings.themeMode == ThemeMode.dark, 
                isDark,
                (val) => settings.setThemeMode(val ? ThemeMode.dark : ThemeMode.light),
                settings.primaryColor,
              ),
              _buildToggleItem(
                'Automatic', 
                Symbols.brightness_medium, 
                Colors.orange, 
                settings.themeMode == ThemeMode.system, 
                isDark,
                (val) => settings.setThemeMode(val ? ThemeMode.system : (isDark ? ThemeMode.dark : ThemeMode.light)),
                settings.primaryColor,
              ),
            ]),
            const SizedBox(height: 24),
            _buildThemeColorSection(isDark, settings),
            const SizedBox(height: 24),
            _buildSection(context, 'Notifications', [
              _buildToggleItem(
                'Allow Notifications', 
                Symbols.notifications_active, 
                Colors.red, 
                settings.notificationsEnabled, 
                isDark,
                (val) => settings.toggleNotifications(val),
                settings.primaryColor,
              ),
              _buildNavigateItem(
                context,
                'Notification Settings', 
                Symbols.schedule, 
                Colors.blue, 
                'Details', 
                isDark,
                '/settings/notifications',
              ),
            ]),
            const SizedBox(height: 32),
            const Text(
              'Reminders version 2.4.0 (829)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {},
              child: Text(
                'Sign Out',
                style: TextStyle(color: settings.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isDark, Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Symbols.account_circle, color: primary, size: 36),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kalpesh Harsad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(String title, IconData icon, Color iconBg, bool value, bool isDark, ValueChanged<bool> onChanged, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildIcon(icon, iconBg),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigateItem(BuildContext context, String title, IconData icon, Color iconBg, String? subtitle, bool isDark, String? route) {
    return InkWell(
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12, width: 0.5)),
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

  Widget _buildThemeColorSection(bool isDark, SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text('THEME COLOR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColorSwatch(const Color(0xFF0D7FF2), settings.primaryColor == const Color(0xFF0D7FF2), settings),
              _buildColorSwatch(Colors.purple, settings.primaryColor == Colors.purple, settings),
              _buildColorSwatch(Colors.pink, settings.primaryColor == Colors.pink, settings),
              _buildColorSwatch(Colors.green, settings.primaryColor == Colors.green, settings),
              _buildColorSwatch(Colors.orange, settings.primaryColor == Colors.orange, settings),
              _buildColorSwatch(Colors.blueGrey, settings.primaryColor == Colors.blueGrey, settings),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(Color color, bool isSelected, SettingsProvider settings) {
    return InkWell(
      onTap: () => settings.setPrimaryColor(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: color.withOpacity(0.3), width: 4) : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }
}
