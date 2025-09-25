// lib/screens/grades/grades_list_screen.dart
import 'package:flutter/material.dart';

class GradesListScreen extends StatelessWidget {
  const GradesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست آزمون‌ها و نمرات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // TODO: Load this list from database
          ListTile(
            title: const Text('آزمون میان‌ترم ریاضی'),
            subtitle: const Text('تاریخ: ۱۴۰۴/۰۸/۱۵'),
            leading: const Icon(Icons.assessment_outlined),
            onTap: () {
              // TODO: Navigate to enter grades screen for this exam
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show a dialog to add a new exam
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
