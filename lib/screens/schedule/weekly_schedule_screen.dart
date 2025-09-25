// lib/screens/schedule/weekly_schedule_screen.dart
import 'package:flutter/material.dart';

class WeeklyScheduleScreen extends StatelessWidget {
  const WeeklyScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه'];
    final periods = ['زنگ اول', 'زنگ دوم', 'زنگ سوم', 'زنگ چهارم'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامه هفتگی'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          headingRowColor: MaterialStateProperty.all(Colors.indigo.shade50),
          columns: [
            const DataColumn(label: Text(' ')),
            for (var day in days)
              DataColumn(
                  label: Text(day,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: periods.map((period) {
            return DataRow(cells: [
              DataCell(Text(period,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              // TODO: اطلاعات هر سلول باید از پایگاه داده خوانده شود
              DataCell(_buildScheduleCell('ریاضی')),
              DataCell(_buildScheduleCell('علوم')),
              DataCell(_buildScheduleCell('')), // روز خالی
              DataCell(_buildScheduleCell('فارسی')),
              DataCell(_buildScheduleCell('ریاضی')),
            ]);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: صفحه‌ای برای ویرایش برنامه هفتگی باز شود
        },
        child: const Icon(Icons.edit_calendar_outlined),
      ),
    );
  }

  Widget _buildScheduleCell(String courseName) {
    if (courseName.isEmpty) {
      return const Center(child: Text('-'));
    }
    return Center(
      child: Chip(
        label: Text(courseName),
        backgroundColor: Colors.indigo.shade100,
      ),
    );
  }
}
