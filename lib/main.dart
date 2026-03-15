import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'providers/reminder_provider.dart';
import 'screens/loading_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/settings_screen.dart'; // Will be created next

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ReminderProvider(),
      child: const RemindersApp(),
    ),
  );
}

class RemindersApp extends StatelessWidget {
  const RemindersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RemindMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/main': (context) => const DashboardScreen(),
        '/add': (context) => const AddEditScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
