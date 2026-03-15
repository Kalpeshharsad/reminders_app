import 'package:flutter/material.dart';

enum Frequency { hourly, threeHours, sixHours, twelveHours, daily, weekly, monthly, yearly }

class Reminder {
  final String id;
  final String title;
  final Frequency frequency;
  final TimeOfDay startTime;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.frequency,
    required this.startTime,
    this.isCompleted = false,
  });

  String get frequencyText {
    switch (frequency) {
      case Frequency.hourly: return 'Every Hour';
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
    // Just a placeholder for category colors based on title or index
    if (title.contains('Water')) return Colors.blue;
    if (title.contains('Vitamins')) return Colors.orange;
    if (title.contains('Gym')) return Colors.purple;
    if (title.contains('Grocery')) return Colors.green;
    return Colors.blue;
  }
}

class ReminderProvider extends ChangeNotifier {
  final List<Reminder> _reminders = [
    Reminder(id: '1', title: 'Water Plants', frequency: Frequency.daily, startTime: const TimeOfDay(hour: 10, minute: 0)),
    Reminder(id: '2', title: 'Take Vitamins', frequency: Frequency.daily, startTime: const TimeOfDay(hour: 8, minute: 30)),
    Reminder(id: '3', title: 'Gym Session', frequency: Frequency.weekly, startTime: const TimeOfDay(hour: 18, minute: 0)),
    Reminder(id: '4', title: 'Grocery Shopping', frequency: Frequency.weekly, startTime: const TimeOfDay(hour: 11, minute: 0)),
  ];

  List<Reminder> get reminders => _reminders;

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void toggleReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].isCompleted = !_reminders[index].isCompleted;
      notifyListeners();
    }
  }
}
