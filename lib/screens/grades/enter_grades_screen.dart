// lib/screens/grades/enter_grades_screen.dart
import 'package:flutter/material.dart';
import 'package:teacher_class_manager/models/grade_models.dart';
import 'package:teacher_class_manager/models/student_model.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class EnterGradesScreen extends StatefulWidget {
  final Exam exam;
  const EnterGradesScreen({super.key, required this.exam});

  @override
  State<EnterGradesScreen> createState() => _EnterGradesScreenState();
}

class _EnterGradesScreenState extends State<EnterGradesScreen> {
  // Map<studentId, controller>
  final Map<int, TextEditingController> _gradeControllers = {};
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = DatabaseService.instance.getAllStudents();
    _loadExistingGrades();
  }

  void _loadExistingGrades() async {
    final existingGrades =
        await DatabaseService.instance.getGradesForExam(widget.exam.id!);
    for (var grade in existingGrades) {
      if (_gradeControllers.containsKey(grade.studentId)) {
        _gradeControllers[grade.studentId]!.text = grade.score;
      }
    }
    // Refresh UI after loading grades
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _gradeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveGrades() async {
    final List<Grade> gradesToSave = [];
    _gradeControllers.forEach((studentId, controller) {
      if (controller.text.isNotEmpty) {
        gradesToSave.add(Grade(
          studentId: studentId,
          examId: widget.exam.id!,
          score: controller.text,
        ));
      }
    });

    await DatabaseService.instance.saveGradesForExam(gradesToSave);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('نمرات با موفقیت ذخیره شد'),
            backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت نمرات: ${widget.exam.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveGrades,
            tooltip: 'ذخیره نمرات',
          )
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final students = snapshot.data!;
          // Initialize controllers for all students
          for (var student in students) {
            if (!_gradeControllers.containsKey(student.id!)) {
              _gradeControllers[student.id!] = TextEditingController();
            }
          }
          // Reload grades after controllers are initialized
          _loadExistingGrades();

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(student.fullName),
                trailing: SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _gradeControllers[student.id!],
                    textAlign: TextAlign.center,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        hintText: 'نمره',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
