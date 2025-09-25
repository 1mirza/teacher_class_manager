// lib/screens/attendance/attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:teacher_class_manager/models/student_model.dart'; // مسیر فایل را اصلاح کنید

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // TODO: این لیست باید از پایگاه داده خوانده شود
  final List<Student> _students = [
    Student(fullName: 'علی رضایی', fatherName: 'محمد'),
    Student(fullName: 'زهرا احمدی', fatherName: 'حسین'),
    Student(fullName: 'محمد حسینی', fatherName: 'رضا'),
    Student(fullName: 'فاطمه کریمی', fatherName: 'علی'),
  ];

  late final Map<String, bool> _attendanceStatus;
  late Jalali _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = Jalali.now();
    _attendanceStatus = {
      for (var student in _students)
        student.fullName: true, // همه به صورت پیش‌فرض حاضر هستند
    };
  }

  String _getShamsiDate() {
    final f = _currentDate.formatter;
    return '${f.wN} ${f.d} ${f.mN} ${f.yyyy}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت حضور و غیاب')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  _getShamsiDate(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _students.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  title: Text(student.fullName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _attendanceStatus[student.fullName]! ? 'حاضر' : 'غایب',
                        style: TextStyle(
                          color: _attendanceStatus[student.fullName]!
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: _attendanceStatus[student.fullName]!,
                        onChanged: (value) {
                          setState(() {
                            _attendanceStatus[student.fullName] = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: اطلاعات حضور و غیاب را برای تاریخ انتخاب شده در پایگاه داده ذخیره کنید
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('لیست حضور و غیاب ذخیره شد.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('ذخیره لیست'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
