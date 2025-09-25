// lib/screens/disciplinary/disciplinary_issue_screen.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:teacher_class_manager/models/disciplinary_model.dart';
import 'package:teacher_class_manager/models/student_model.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class DisciplinaryIssueScreen extends StatefulWidget {
  const DisciplinaryIssueScreen({super.key});

  @override
  State<DisciplinaryIssueScreen> createState() =>
      _DisciplinaryIssueScreenState();
}

class _DisciplinaryIssueScreenState extends State<DisciplinaryIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  Student? _selectedStudent;
  late Jalali _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = Jalali.now(); // تاریخ فعلی را به عنوان پیش‌فرض قرار می‌دهیم
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // --- Helper method to format date ---
  // یک متد کمکی برای جلوگیری از تکرار کد و خوانایی بیشتر
  String _formatSelectedDate() {
    final formatter = _selectedDate.formatter;
    return '${formatter.y}/${formatter.mm}/${formatter.dd}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // تبدیل تاریخ شمسی فعلی به میلادی برای مقدار اولیه DatePicker
    final initialDateTime = _selectedDate.toDateTime();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = Jalali.fromDateTime(pickedDate);
      });
    }
  }

  Future<void> _saveIssue() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _selectedStudent == null) return;

    final newIssue = DisciplinaryIssue(
      studentId: _selectedStudent!.id!,
      // **FIXED**: Using the correct formatting helper
      date: _formatSelectedDate(),
      description: _descriptionController.text,
    );

    await DatabaseService.instance.createDisciplinaryIssue(newIssue);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('مورد انضباطی ثبت شد.'),
            backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت مورد انضباطی')),
      body: FutureBuilder<List<Student>>(
        future: DatabaseService.instance.getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                    'هیچ دانش‌آموزی یافت نشد. لطفا ابتدا دانش‌آموز اضافه کنید.'));
          }
          final students = snapshot.data!;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<Student>(
                  value: _selectedStudent,
                  items: students.map((student) {
                    return DropdownMenuItem(
                        value: student, child: Text(student.fullName));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedStudent = value);
                  },
                  decoration:
                      const InputDecoration(labelText: 'انتخاب دانش‌آموز'),
                  validator: (value) =>
                      value == null ? 'لطفا یک دانش‌آموز انتخاب کنید' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'توضیحات مورد انضباطی'),
                  maxLines: 4,
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'توضیحات نمی‌تواند خالی باشد'
                      : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('تاریخ'),
                  // **FIXED**: Using the correct formatting helper
                  subtitle: Text(_formatSelectedDate()),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveIssue,
                  child: const Text('ثبت مورد انضباطی'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
