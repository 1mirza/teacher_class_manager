// lib/screens/activities/teacher_activities_screen.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:teacher_class_manager/models/lesson_models.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class TeacherActivitiesScreen extends StatefulWidget {
  const TeacherActivitiesScreen({super.key});

  @override
  State<TeacherActivitiesScreen> createState() =>
      _TeacherActivitiesScreenState();
}

class _TeacherActivitiesScreenState extends State<TeacherActivitiesScreen> {
  final _controller = TextEditingController();
  Jalali _selectedDate = Jalali.now();
  TeacherActivity? _currentActivity;

  @override
  void initState() {
    super.initState();
    _loadActivityForSelectedDate();
  }

  Future<void> _loadActivityForSelectedDate() async {
    final activity = await DatabaseService.instance
        .getActivityForDate(_formatDate(_selectedDate));
    setState(() {
      _currentActivity = activity;
      _controller.text = _currentActivity?.activityLog ?? '';
    });
  }

  String _formatDate(Jalali date) {
    final formatter = date.formatter;
    return '${formatter.y}/${formatter.mm}/${formatter.dd}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.toDateTime(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale("fa", "IR"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = Jalali.fromDateTime(picked);
      });
      _loadActivityForSelectedDate();
    }
  }

  Future<void> _saveActivity() async {
    final log = _controller.text;
    if (log.isEmpty) return;

    final activity = TeacherActivity(
      id: _currentActivity?.id,
      date: _formatDate(_selectedDate),
      activityLog: log,
    );

    await DatabaseService.instance.saveActivity(activity);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('فعالیت با موفقیت ذخیره شد.'),
            backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ثبت فعالیت‌های روزانه معلم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('انتخاب روز'),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.edit_calendar),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null, // Allows multiline input
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText:
                      'فعالیت‌های انجام شده یا برنامه‌ریزی شده برای این روز...',
                  hintText:
                      'مثال: زنگ اول: تدریس فصل ۳ علوم\nزنگ دوم: حل تمرین ریاضی...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('ذخیره فعالیت'),
              onPressed: _saveActivity,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
