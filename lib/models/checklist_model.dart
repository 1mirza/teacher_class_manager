// lib/models/checklist_model.dart

class ChecklistItemFields {
  static const String tableName = 'checklist';
  static const String id = '_id';
  static const String date = 'date';
  static const String title = 'title';
  static const String isDone = 'isDone'; // 0 for false, 1 for true
}

class ChecklistItem {
  final int? id;
  final String date;
  final String title;
  final bool isDone;

  ChecklistItem({
    this.id,
    required this.date,
    required this.title,
    this.isDone = false,
  });

  ChecklistItem copyWith({
    int? id,
    String? date,
    String? title,
    bool? isDone,
  }) =>
      ChecklistItem(
        id: id ?? this.id,
        date: date ?? this.date,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );

  Map<String, dynamic> toMap() => {
        ChecklistItemFields.id: id,
        ChecklistItemFields.date: date,
        ChecklistItemFields.title: title,
        ChecklistItemFields.isDone: isDone ? 1 : 0,
      };

  static ChecklistItem fromMap(Map<String, dynamic> map) => ChecklistItem(
        id: map[ChecklistItemFields.id] as int?,
        date: map[ChecklistItemFields.date] as String,
        title: map[ChecklistItemFields.title] as String,
        isDone: map[ChecklistItemFields.isDone] == 1,
      );
}
