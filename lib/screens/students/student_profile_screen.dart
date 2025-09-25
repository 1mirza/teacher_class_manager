// lib/screens/students/student_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:teacher_class_manager/models/student_model.dart';

class StudentProfileScreen extends StatelessWidget {
  final Student student;
  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.fullName),
        actions: [
          IconButton(
              onPressed: () {
                // TODO: به صفحه ویرایش دانش‌آموز برود
              },
              icon: const Icon(Icons.edit_outlined))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildInfoCard(
            title: 'اطلاعات کلی',
            icon: Icons.person_outline,
            children: [
              _InfoRow(label: 'نام پدر', value: student.fatherName),
              _InfoRow(
                  label: 'تماس با ولی',
                  value: student.contactInfo ?? 'ثبت نشده'),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'وضعیت تحصیلی و انضباطی',
            icon: Icons.school_outlined,
            children: [
              _InfoRow(
                  label: 'تعداد غیبت‌ها', value: '${student.absences} جلسه'),
              _InfoRow(
                  label: 'موارد انضباطی',
                  value: '${student.disciplinaryIssues} مورد'),
              _InfoRow(
                  label: 'وضعیت کلی درسی',
                  value: 'خوب'), // TODO: این بخش باید داینامیک باشد
            ],
          ),
          const SizedBox(height: 16),
          // TODO: بخشی برای نمایش نمرات آزمون‌ها اضافه شود
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.indigo.shade100,
          // TODO: اگر تصویر آواتار وجود داشت، آن را نمایش بده
          // backgroundImage: student.avatarPath != null ? FileImage(...) : null,
          child: const Icon(Icons.person, size: 60, color: Colors.indigo),
        ),
        const SizedBox(height: 12),
        Text(
          student.fullName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'کلاس هفتم - ب', // TODO: نام کلاس باید داینامیک باشد
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
