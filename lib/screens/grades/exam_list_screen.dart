// lib/screens/grades/exam_list_screen.dart
import 'package:flutter/material.dart';
import 'package:teacher_class_manager/models/grade_models.dart';
import 'package:teacher_class_manager/screens/grades/add_edit_exam_screen.dart';
import 'package:teacher_class_manager/screens/grades/enter_grades_screen.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  // این متغیر وضعیت لیست آزمون‌ها را نگه می‌دارد
  late Future<List<Exam>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _refreshExams();
  }

  // متدی برای بازخوانی لیست آزمون‌ها از دیتابیس
  void _refreshExams() {
    setState(() {
      // **FIXED**: فراخوانی صحیح متد از سینگلتون دیتابیس
      _examsFuture = DatabaseService.instance.getAllExams();
    });
  }

  // ناوبری به صفحه افزودن آزمون و بازخوانی لیست پس از بازگشت
  void _navigateToAddExam() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEditExamScreen()),
    );
    _refreshExams();
  }

  // ناوبری به صفحه ثبت نمرات برای یک آزمون خاص
  void _navigateToEnterGrades(Exam exam) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EnterGradesScreen(exam: exam)),
    );
    _refreshExams(); // بازخوانی در صورت نیاز به آپدیت اطلاعات
  }

  // متد برای حذف آزمون
  Future<void> _deleteExam(int id) async {
    await DatabaseService.instance.deleteExam(id);
    _refreshExams();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('آزمون با موفقیت حذف شد.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست آزمون‌ها'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _navigateToAddExam,
            tooltip: 'افزودن آزمون جدید',
          ),
        ],
      ),
      body: FutureBuilder<List<Exam>>(
        future: _examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('خطا در بارگذاری اطلاعات: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'هیچ آزمونی ثبت نشده است.\nبرای افزودن، روی آیکون + در بالا کلیک کنید.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final exams = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(exam.courseName.isNotEmpty
                        ? exam.courseName.substring(0, 1)
                        : '?'),
                  ),
                  title: Text(exam.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle:
                      Text('درس: ${exam.courseName} - تاریخ: ${exam.date}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteExam(exam.id!),
                  ),
                  onTap: () => _navigateToEnterGrades(exam),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
