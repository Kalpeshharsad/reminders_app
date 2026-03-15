import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../providers/settings_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = settings.primaryColor;

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
              Icon(Symbols.arrow_back_ios, color: primary, size: 20),
              Text('Back', style: TextStyle(color: primary, fontSize: 16)),
            ],
          ),
        ),
        leadingWidth: 100,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildSection(context, 'REPETITION & SOUND', [
              _buildToggleItem('Daily Digest', Symbols.summarize, Colors.blue, settings.dailyDigest, isDark, primary, (val) => settings.toggleDailyDigest(val)),
              _buildToggleItem('Critical Alerts', Symbols.priority_high, Colors.red, settings.criticalAlerts, isDark, primary, (val) => settings.toggleCriticalAlerts(val)),
              _buildSoundSelection(context, primary, isDark),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'ALERTS', [
              _buildToggleItem('Show on Lock Screen', Symbols.lock, Colors.indigo, settings.showOnLockScreen, isDark, primary, (val) => settings.toggleShowOnLockScreen(val)),
              _buildToggleItem('Show in History', Symbols.history, Colors.orange, settings.showInHistory, isDark, primary, (val) => settings.toggleShowInHistory(val)),
              _buildToggleItem('Show as Banners', Symbols.ad_units, Colors.green, settings.showAsBanners, isDark, primary, (val) => settings.toggleShowAsBanners(val)),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'OPTIONS', [
              _buildNavigateItem('Show Previews', 'Always', isDark),
              _buildNavigateItem('Notification Grouping', 'Automatic', isDark),
            ]),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Customize how you receive your reminder notifications to stay on track.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ],
        ),
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
          child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
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

  Widget _buildToggleItem(String title, IconData icon, Color iconBg, bool value, bool isDark, Color primary, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
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

  Widget _buildSoundSelection(BuildContext context, Color primary, bool isDark) {
    return InkWell(
      onTap: () {
        // Show sound selection dialog or screen
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.volume_up, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Notification Sound', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Text('Default (Glass)', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(Symbols.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigateItem(String title, String subtitle, bool isDark) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12, width: 0.5)),
        ),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(Symbols.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
