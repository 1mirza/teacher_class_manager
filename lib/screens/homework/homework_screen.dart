// lib/screens/homework/homework_screen.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:teacher_class_manager/models/lesson_models.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  late Future<List<Homework>> _homeworkList;

  @override
  void initState() {
    super.initState();
    _refreshHomeworkList();
  }

  void _refreshHomeworkList() {
    setState(() {
      _homeworkList = DatabaseService.instance.getAllHomework();
    });
  }

  void _showAddEditHomeworkDialog({Homework? homework}) {
    final formKey = GlobalKey<FormState>();
    final descriptionController =
        TextEditingController(text: homework?.description ?? '');
    Jalali selectedDate =
        homework != null ? _parseDateString(homework.date) : Jalali.now();
    bool isGroupal = homework?.isGroupal ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  Text(homework == null ? 'افزودن تکلیف جدید' : 'ویرایش تکلیف'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('تاریخ تکلیف'),
                        subtitle: Text(_formatDate(selectedDate)),
                        onTap: () async {
                          final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate.toDateTime(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              locale: const Locale("fa", "IR"));
                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = Jalali.fromDateTime(picked);
                            });
                          }
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'توضیحات تکلیف'),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty
                            ? 'توضیحات نمی‌تواند خالی باشد'
                            : null,
                      ),
                      SwitchListTile(
                        title: const Text('تکلیف گروهی است؟'),
                        value: isGroupal,
                        onChanged: (value) {
                          setDialogState(() {
                            isGroupal = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('لغو'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newHomework = Homework(
                        id: homework?.id,
                        date: _formatDate(selectedDate),
                        description: descriptionController.text,
                        isGroupal: isGroupal,
                      );
                      if (homework == null) {
                        await DatabaseService.instance
                            .createHomework(newHomework);
                      } else {
                        // TODO: Implement updateHomework in DatabaseService
                      }
                      Navigator.of(context).pop();
                      _refreshHomeworkList();
                    }
                  },
                  child: const Text('ذخیره'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Jalali _parseDateString(String dateStr) {
    final parts = dateStr.split('/');
    return Jalali(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  String _formatDate(Jalali date) {
    final formatter = date.formatter;
    return '${formatter.y}/${formatter.mm}/${formatter.dd}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت تکالیف روزانه')),
      body: FutureBuilder<List<Homework>>(
        future: _homeworkList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('هیچ تکلیفی ثبت نشده است.'));
          }
          final homeworks = snapshot.data!;
          return ListView.builder(
            itemCount: homeworks.length,
            itemBuilder: (context, index) {
              final homework = homeworks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child:
                        Icon(homework.isGroupal ? Icons.group : Icons.person),
                  ),
                  title: Text('تکلیف تاریخ: ${homework.date}'),
                  subtitle: Text(homework.description,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => _showAddEditHomeworkDialog(homework: homework),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditHomeworkDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
