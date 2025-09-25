// lib/models/grade_models.dart

// کلاس برای نگهداری نام ستون‌های جدول آزمون‌ها
class ExamFields {
  static const String tableName = 'exams';
  static const String id = '_id';
  static const String title = 'title';
  static const String date = 'date';
  static const String courseName = 'courseName';
}

// مدل داده برای یک آزمون
class Exam {
  final int? id;
  final String title;
  final String date;
  final String courseName;

  Exam({
    this.id,
    required this.title,
    required this.date,
    required this.courseName,
  });

  // **FIXED**: متد copyWith برای بروزرسانی شیء پس از ذخیره در دیتابیس اضافه شد
  Exam copyWith({
    int? id,
    String? title,
    String? date,
    String? courseName,
  }) =>
      Exam(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        courseName: courseName ?? this.courseName,
      );

  Map<String, dynamic> toMap() => {
        ExamFields.id: id,
        ExamFields.title: title,
        ExamFields.date: date,
        ExamFields.courseName: courseName,
      };

  static Exam fromMap(Map<String, dynamic> map) => Exam(
        id: map[ExamFields.id] as int?,
        title: map[ExamFields.title] as String,
        date: map[ExamFields.date] as String,
        courseName: map[ExamFields.courseName] as String,
      );
}

// کلاس برای نگهداری نام ستون‌های جدول نمرات
class GradeFields {
  static const String tableName = 'grades';
  static const String id = '_id';
  static const String studentId = 'studentId';
  static const String examId = 'examId';
  static const String score = 'score';
}

// مدل داده برای یک نمره
class Grade {
  final int? id;
  final int studentId;
  final int examId;
  final String score; // به صورت رشته برای انعطاف‌پذیری (مثلاً عالی، خوب، ۱۹.۵)

  Grade({
    this.id,
    required this.studentId,
    required this.examId,
    required this.score,
  });

  Grade copyWith({
    int? id,
    int? studentId,
    int? examId,
    String? score,
  }) =>
      Grade(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        examId: examId ?? this.examId,
        score: score ?? this.score,
      );

  Map<String, dynamic> toMap() => {
        GradeFields.id: id,
        GradeFields.studentId: studentId,
        GradeFields.examId: examId,
        GradeFields.score: score,
      };

  static Grade fromMap(Map<String, dynamic> map) => Grade(
        id: map[GradeFields.id] as int?,
        studentId: map[GradeFields.studentId] as int,
        examId: map[GradeFields.examId] as int,
        score: map[GradeFields.score] as String,
      );
}
