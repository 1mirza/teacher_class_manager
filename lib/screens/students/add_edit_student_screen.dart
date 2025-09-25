// lib/screens/students/add_edit_student_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teacher_class_manager/models/student_model.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class AddEditStudentScreen extends StatefulWidget {
  // برای حالت ویرایش، مدل دانش‌آموز را به عنوان ورودی می‌گیریم
  final Student? student;
  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _contactInfoController;
  String? _avatarPath;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.student?.fullName ?? '');
    _fatherNameController =
        TextEditingController(text: widget.student?.fatherName ?? '');
    _contactInfoController =
        TextEditingController(text: widget.student?.contactInfo ?? '');
    _avatarPath = widget.student?.avatarPath;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _contactInfoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
      });
    }
  }

  Future<void> _saveStudent() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final student = Student(
      id: widget.student?.id,
      fullName: _fullNameController.text,
      fatherName: _fatherNameController.text,
      contactInfo: _contactInfoController.text,
      avatarPath: _avatarPath,
    );

    if (_isEditing) {
      await DatabaseService.instance.updateStudent(student);
    } else {
      await DatabaseService.instance.createStudent(student);
    }

    // بعد از ذخیره، به صفحه قبل برمی‌گردیم و یک مقدار true را پاس می‌دهیم تا لیست رفرش شود
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'ویرایش دانش‌آموز' : 'افزودن دانش‌آموز'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatarPicker(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _fullNameController,
                decoration:
                    const InputDecoration(labelText: 'نام و نام خانوادگی'),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'این فیلد الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fatherNameController,
                decoration: const InputDecoration(labelText: 'نام پدر'),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'این فیلد الزامی است' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactInfoController,
                decoration: const InputDecoration(
                    labelText: 'شماره تماس ولی دانش‌آموز'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _saveStudent,
                icon: const Icon(Icons.save_alt_outlined),
                label: const Text('ذخیره اطلاعات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                _avatarPath != null ? FileImage(File(_avatarPath!)) : null,
            child: _avatarPath == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.indigo,
              child: IconButton(
                icon:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
