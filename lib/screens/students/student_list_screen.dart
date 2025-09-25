// lib/screens/students/student_list_screen.dart
import 'package:flutter/material.dart';
import 'package:teacher_class_manager/models/student_model.dart'; // مسیر فایل را اصلاح کنید
import 'package:teacher_class_manager/screens/students/add_edit_student_screen.dart'; // مسیر فایل را اصلاح کنید

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // TODO: این لیست باید از پایگاه داده خوانده شود
  final List<Student> _students = [
    Student(
      fullName: 'علی رضایی',
      fatherName: 'محمد',
      absences: 2,
      disciplinaryIssues: 1,
    ),
    Student(
      fullName: 'زهرا احمدی',
      fatherName: 'حسین',
      absences: 0,
      disciplinaryIssues: 0,
    ),
    Student(
      fullName: 'محمد حسینی',
      fatherName: 'رضا',
      absences: 5,
      disciplinaryIssues: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لیست دانش‌آموزان')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                // TODO: به صفحه پروفایل دانش‌آموز برود
              },
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: Text(student.fullName.substring(0, 1)),
              ),
              title: Text(
                student.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('نام پدر: ${student.fatherName}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoChip(
                    label: 'غیبت',
                    value: student.absences.toString(),
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    label: 'انضباط',
                    value: student.disciplinaryIssues.toString(),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
          );
        },
        label: const Text('افزودن دانش‌آموز'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        label: Text(label),
        backgroundColor: color.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
