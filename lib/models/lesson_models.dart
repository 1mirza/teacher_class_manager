// lib/models/lesson_models.dart

// --- Homework Model ---
class HomeworkFields {
  static const String tableName = 'homework';
  static const String id = '_id';
  static const String date = 'date';
  static const String description = 'description';
  static const String isGroupal = 'isGroupal'; // 0 for false, 1 for true
}

class Homework {
  final int? id;
  final String date;
  final String description;
  final bool isGroupal;

  Homework({
    this.id,
    required this.date,
    required this.description,
    required this.isGroupal,
  });

  Homework copyWith({
    int? id,
    String? date,
    String? description,
    bool? isGroupal,
  }) =>
      Homework(
        id: id ?? this.id,
        date: date ?? this.date,
        description: description ?? this.description,
        isGroupal: isGroupal ?? this.isGroupal,
      );

  Map<String, dynamic> toMap() => {
        HomeworkFields.id: id,
        HomeworkFields.date: date,
        HomeworkFields.description: description,
        HomeworkFields.isGroupal: isGroupal ? 1 : 0,
      };

  static Homework fromMap(Map<String, dynamic> map) => Homework(
        id: map[HomeworkFields.id] as int?,
        date: map[HomeworkFields.date] as String,
        description: map[HomeworkFields.description] as String,
        isGroupal: map[HomeworkFields.isGroupal] == 1,
      );
}

// --- Teacher Activity Model ---
class TeacherActivityFields {
  static const String tableName = 'teacher_activities';
  static const String id = '_id';
  static const String date = 'date';
  static const String activityLog =
      'activityLog'; // Log of activities for the day
}

class TeacherActivity {
  final int? id;
  final String date;
  final String activityLog;

  TeacherActivity({
    this.id,
    required this.date,
    required this.activityLog,
  });

  TeacherActivity copyWith({
    int? id,
    String? date,
    String? activityLog,
  }) =>
      TeacherActivity(
        id: id ?? this.id,
        date: date ?? this.date,
        activityLog: activityLog ?? this.activityLog,
      );

  Map<String, dynamic> toMap() => {
        TeacherActivityFields.id: id,
        TeacherActivityFields.date: date,
        TeacherActivityFields.activityLog: activityLog,
      };

  static TeacherActivity fromMap(Map<String, dynamic> map) => TeacherActivity(
        id: map[TeacherActivityFields.id] as int?,
        date: map[TeacherActivityFields.date] as String,
        activityLog: map[TeacherActivityFields.activityLog] as String,
      );
}
