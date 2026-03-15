import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum Frequency { hourly, threeHours, sixHours, twelveHours, daily, weekly, monthly, yearly }

class Reminder {
  final String id;
  final String title;
  final Frequency frequency;
  final TimeOfDay startTime;
  final DateTime startDate;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.frequency,
    required this.startTime,
    required this.startDate,
    this.isCompleted = false,
  });

  String get frequencyText {
    switch (frequency) {
      case Frequency.hourly: return 'Hourly';
      case Frequency.threeHours: return '3 Hours';
      case Frequency.sixHours: return '6 Hours';
      case Frequency.twelveHours: return '12 Hours';
      case Frequency.daily: return 'Daily';
      case Frequency.weekly: return 'Weekly';
      case Frequency.monthly: return 'Monthly';
      case Frequency.yearly: return 'Yearly';
    }
  }

  Color get categoryColor {
    if (title.contains('Water')) return Colors.blue;
    if (title.contains('Vitamins')) return Colors.orange;
    if (title.contains('Gym')) return Colors.green;
    if (title.contains('Grocery')) return Colors.purple;
    return Colors.blue;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'frequency': frequency.index,
    'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
    'startDate': startDate.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    title: json['title'],
    frequency: Frequency.values[json['frequency']],
    startTime: TimeOfDay(
      hour: json['startTime']['hour'],
      minute: json['startTime']['minute'],
    ),
    startDate: DateTime.parse(json['startDate']),
    isCompleted: json['isCompleted'],
  );
}

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  final NotificationService _notificationService = NotificationService();

  ReminderProvider() {
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersJson = prefs.getString('reminders');
    
    if (remindersJson != null) {
      final List<dynamic> decoded = jsonDecode(remindersJson);
      _reminders = decoded.map((item) => Reminder.fromJson(item)).toList();
    } else {
      // Default reminders if none exist
      _reminders = [
        Reminder(
          id: '1',
          title: 'Drink Water',
          frequency: Frequency.hourly,
          startTime: const TimeOfDay(hour: 8, minute: 0),
          startDate: DateTime.now(),
        ),
        Reminder(
          id: '2',
          title: 'Take Vitamins',
          frequency: Frequency.daily,
          startTime: const TimeOfDay(hour: 9, minute: 0),
          startDate: DateTime.now(),
        ),
      ];
      _saveToPrefs();
    }
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_reminders.map((r) => r.toJson()).toList());
    await prefs.setString('reminders', encoded);
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _saveToPrefs();
    _scheduleReminderNotification(reminder);
    notifyListeners();
  }

  void toggleReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].isCompleted = !_reminders[index].isCompleted;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void removeReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      final reminder = _reminders[index];
      // Cancel all possible instances (up to 24 for hourly)
      int baseId = reminder.id.hashCode.abs() % 100000;
      for (int i = 0; i < 24; i++) {
        _notificationService.cancelNotification(baseId * 100 + i);
      }
      _reminders.removeAt(index);
      _saveToPrefs();
      notifyListeners();
    }
  }

  void _scheduleReminderNotification(Reminder reminder) async {
    final prefs = await SharedPreferences.getInstance();
    final sound = prefs.getString('notificationSound') ?? 'Default';

    DateTime scheduledDate = DateTime(
      reminder.startDate.year,
      reminder.startDate.month,
      reminder.startDate.day,
      reminder.startTime.hour,
      reminder.startTime.minute,
    );

    int count = 1;
    int intervalHours = 0;
    bool isSubDaily = false;

    switch (reminder.frequency) {
      case Frequency.hourly:
        count = 24;
        intervalHours = 1;
        isSubDaily = true;
        break;
      case Frequency.threeHours:
        count = 8;
        intervalHours = 3;
        isSubDaily = true;
        break;
      case Frequency.sixHours:
        count = 4;
        intervalHours = 6;
        isSubDaily = true;
        break;
      case Frequency.twelveHours:
        count = 2;
        intervalHours = 12;
        isSubDaily = true;
        break;
      default:
        isSubDaily = false;
        break;
    }

    int baseId = reminder.id.hashCode.abs() % 100000;

    if (isSubDaily) {
      for (int i = 0; i < count; i++) {
        DateTime instanceDate = scheduledDate.add(Duration(hours: i * intervalHours));
        _notificationService.scheduleNotification(
          id: baseId * 100 + i,
          title: 'Reminder: ${reminder.title}',
          body: 'It\'s time for your ${reminder.frequencyText.toLowerCase()} task!',
          scheduledDate: instanceDate,
          matchDateTimeComponents: DateTimeComponents.time,
          sound: sound,
        );
      }
    } else {
      DateTimeComponents? matchComponents;
      switch (reminder.frequency) {
        case Frequency.daily:
          matchComponents = DateTimeComponents.time;
          break;
        case Frequency.weekly:
          matchComponents = DateTimeComponents.dayOfWeekAndTime;
          break;
        case Frequency.monthly:
          matchComponents = DateTimeComponents.dayOfMonthAndTime;
          break;
        case Frequency.yearly:
          matchComponents = DateTimeComponents.dateAndTime;
          break;
        default:
          matchComponents = null;
      }

      _notificationService.scheduleNotification(
        id: baseId * 100,
        title: 'Reminder: ${reminder.title}',
        body: 'It\'s time for your ${reminder.frequencyText.toLowerCase()} task!',
        scheduledDate: scheduledDate,
        matchDateTimeComponents: matchComponents,
        sound: sound,
      );
    }
  }
}
