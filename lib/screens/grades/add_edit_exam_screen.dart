// lib/screens/grades/add_edit_exam_screen.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:teacher_class_manager/models/grade_models.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class AddEditExamScreen extends StatefulWidget {
  final Exam? exam; // برای حالت ویرایش
  const AddEditExamScreen({super.key, this.exam});

  @override
  State<AddEditExamScreen> createState() => _AddEditExamScreenState();
}

class _AddEditExamScreenState extends State<AddEditExamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _courseNameController;
  late Jalali _selectedDate;

  bool get _isEditing => widget.exam != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.exam?.title ?? '');
    _courseNameController =
        TextEditingController(text: widget.exam?.courseName ?? '');

    // **FIXED**: جایگزینی روش تبدیل تاریخ با یک روش امن و بدون خطا
    if (_isEditing && widget.exam!.date.isNotEmpty) {
      _parseDateString(widget.exam!.date);
    } else {
      _selectedDate = Jalali.now();
    }
  }

  // متد کمکی برای تبدیل امن رشته تاریخ به شیء جلالی
  void _parseDateString(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        _selectedDate = Jalali(year, month, day);
      } else {
        _selectedDate = Jalali.now(); // اگر فرمت اشتباه بود
      }
    } catch (e) {
      _selectedDate = Jalali.now(); // اگر در تبدیل عدد خطا رخ داد
    }
  }

  String _formatSelectedDate() {
    final formatter = _selectedDate.formatter;
    return '${formatter.y}/${formatter.mm}/${formatter.dd}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.toDateTime(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      // برای فارسی کردن انتخابگر تاریخ
      locale: const Locale("fa", "IR"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = Jalali.fromDateTime(picked);
      });
    }
  }

  Future<void> _saveExam() async {
    if (_formKey.currentState!.validate()) {
      final newExamData = Exam(
        id: widget.exam?.id,
        title: _titleController.text,
        courseName: _courseNameController.text,
        date: _formatSelectedDate(),
      );

      if (_isEditing) {
        // TODO: متد ویرایش را در دیتابیس پیاده‌سازی کنید
      } else {
        await DatabaseService.instance.createExam(newExamData);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'ویرایش آزمون' : 'افزودن آزمون جدید'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'عنوان آزمون', icon: Icon(Icons.title)),
              validator: (value) =>
                  value!.isEmpty ? 'عنوان نمی‌تواند خالی باشد' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseNameController,
              decoration: const InputDecoration(
                  labelText: 'نام درس', icon: Icon(Icons.book_outlined)),
              validator: (value) =>
                  value!.isEmpty ? 'نام درس نمی‌تواند خالی باشد' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('تاریخ آزمون'),
              subtitle: Text(_formatSelectedDate()),
              onTap: _pickDate,
              trailing: const Icon(Icons.edit_calendar),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _saveExam,
              label: const Text('ذخیره آزمون'),
            ),
          ],
        ),
      ),
    );
  }
}
