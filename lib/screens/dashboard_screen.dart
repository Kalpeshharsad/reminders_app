import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';
import '../providers/reminder_provider.dart';
import '../providers/settings_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Reminders',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settings'),
                        icon: Icon(
                          Symbols.settings,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Symbols.search,
                          size: 20,
                          color: Colors.grey,
                        ),
                        hintText: 'Search reminders...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    itemCount:
                        reminderProvider.reminders.length +
                        1, // +1 for the promotion card
                    itemBuilder: (context, index) {
                      if (index < reminderProvider.reminders.length) {
                        final reminder = reminderProvider.reminders[index];
                        return _buildReminderCard(
                          context,
                          reminder,
                          isDark,
                          settings.primaryColor,
                          reminderProvider,
                        );
                      } else {
                        return _buildPromotionCard(settings.primaryColor);
                      }
                    },
                  ),
                ),
              ],
            ),
            // FAB
            Positioned(
              right: 24,
              bottom: 40,
              child: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, '/add_edit'),
                backgroundColor: settings.primaryColor,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Symbols.add, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(
    BuildContext context,
    Reminder reminder,
    bool isDark,
    Color primary,
    ReminderProvider provider,
  ) {
    String dateStr = DateFormat('MMM d').format(reminder.startDate);
    String timeStr = reminder.startTime.format(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // Delete Button
            IconButton(
              onPressed: () => provider.removeReminder(reminder.id),
              icon: const Icon(
                Symbols.delete,
                color: Colors.redAccent,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: reminder.categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForReminder(reminder.title),
                color: reminder.categoryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reminder.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: reminder.categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          reminder.frequencyText,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: reminder.categoryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Next: $dateStr at $timeStr',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                provider.toggleReminder(reminder.id);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: reminder.isCompleted
                        ? primary
                        : (isDark ? Colors.white24 : Colors.black12),
                    width: 2,
                  ),
                  color: reminder.isCompleted ? primary : Colors.transparent,
                ),
                child: reminder.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionCard(Color primary) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 100),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withBlue(255).withGreen(100)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New! Smart Groups',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Organize your reminders automatically based on location and time.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.2,
              child: Transform.rotate(
                angle: 0.2,
                child: const Icon(
                  Symbols.auto_awesome,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForReminder(String title) {
    if (title.contains('Water')) return Symbols.water_drop;
    if (title.contains('Vitamins')) return Symbols.medication;
    if (title.contains('Gym')) return Symbols.fitness_center;
    if (title.contains('Grocery')) return Symbols.shopping_cart;
    return Symbols.task;
  }
}
