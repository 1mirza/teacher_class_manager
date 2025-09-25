// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:teacher_class_manager/screens/students/student_list_screen.dart'; // مسیر فایل را اصلاح کنید
import 'package:teacher_class_manager/screens/attendance/attendance_screen.dart'; // مسیر فایل را اصلاح کنید

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد معلم'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            title: 'دانش‌آموزان',
            icon: Icons.people_outline,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StudentListScreen()),
              );
            },
          ),
          _DashboardCard(
            title: 'حضور و غیاب',
            icon: Icons.check_circle_outline,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AttendanceScreen()),
              );
            },
          ),
          _DashboardCard(
            title: 'برنامه هفتگی',
            icon: Icons.calendar_today_outlined,
            onTap: () {},
          ),
          _DashboardCard(
            title: 'نمرات',
            icon: Icons.school_outlined,
            onTap: () {},
          ),
          _DashboardCard(
            title: 'موارد انضباطی',
            icon: Icons.report_problem_outlined,
            onTap: () {},
          ),
          _DashboardCard(
            title: 'تکالیف روزانه',
            icon: Icons.assignment_outlined,
            onTap: () {},
          ),
          _DashboardCard(
            title: 'چک‌لیست روزانه',
            icon: Icons.playlist_add_check_outlined,
            onTap: () {},
          ),
          _DashboardCard(
            title: 'پیگیری دروس',
            icon: Icons.track_changes_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.indigo.shade400),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
