// lib/screens/checklist/checklist_screen.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:teacher_class_manager/models/checklist_model.dart';
import 'package:teacher_class_manager/services/database_service.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  Jalali _selectedDate = Jalali.now();
  late Future<List<ChecklistItem>> _checklistItems;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshChecklist();
  }

  void _refreshChecklist() {
    setState(() {
      _checklistItems = DatabaseService.instance
          .getChecklistForDate(_formatDate(_selectedDate));
    });
  }

  String _formatDate(Jalali date) {
    final formatter = date.formatter;
    return '${formatter.y}/${formatter.mm}/${formatter.dd}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.toDateTime(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale("fa", "IR"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = Jalali.fromDateTime(picked);
      });
      _refreshChecklist();
    }
  }

  Future<void> _addItem() async {
    if (_textController.text.isEmpty) return;
    final newItem = ChecklistItem(
      date: _formatDate(_selectedDate),
      title: _textController.text,
    );
    await DatabaseService.instance.createChecklistItem(newItem);
    _textController.clear();
    _refreshChecklist();
  }

  Future<void> _toggleItemStatus(ChecklistItem item) async {
    final updatedItem = item.copyWith(isDone: !item.isDone);
    await DatabaseService.instance.updateChecklistItem(updatedItem);
    _refreshChecklist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('چک لیست کارهای روزانه'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('نمایش کارها برای تاریخ'),
            subtitle: Text(_formatDate(_selectedDate)),
            trailing: const Icon(Icons.edit_calendar),
            onTap: _pickDate,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'کار جدید...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
              onSubmitted: (_) => _addItem(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ChecklistItem>>(
              future: _checklistItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('هیچ کاری برای این روز ثبت نشده است.'));
                }
                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CheckboxListTile(
                      title: Text(
                        item.title,
                        style: TextStyle(
                          decoration:
                              item.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      value: item.isDone,
                      onChanged: (value) => _toggleItemStatus(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
