// lib/models/disciplinary_model.dart

class DisciplinaryFields {
  static const String tableName = 'disciplinary_issues';
  static const String id = 'id';
  static const String studentId = 'studentId';
  static const String date = 'date';
  static const String description = 'description';
}

class DisciplinaryIssue {
  final int? id;
  final int studentId;
  final String date;
  final String description;

  DisciplinaryIssue({
    this.id,
    required this.studentId,
    required this.date,
    required this.description,
  });

  // متد copyWith برای ساخت یک کپی از شیء با مقادیر جدید
  DisciplinaryIssue copyWith({
    int? id,
    int? studentId,
    String? date,
    String? description,
  }) {
    return DisciplinaryIssue(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DisciplinaryFields.id: id,
      DisciplinaryFields.studentId: studentId,
      DisciplinaryFields.date: date,
      DisciplinaryFields.description: description,
    };
  }

  factory DisciplinaryIssue.fromMap(Map<String, dynamic> map) {
    return DisciplinaryIssue(
      id: map[DisciplinaryFields.id] as int?,
      studentId: map[DisciplinaryFields.studentId] as int,
      date: map[DisciplinaryFields.date] as String,
      description: map[DisciplinaryFields.description] as String,
    );
  }
}
