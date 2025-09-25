// lib/models/student_model.dart

// نام جدول و ستون‌ها را به صورت ثابت تعریف می‌کنیم تا از خطا جلوگیری شود
class StudentFields {
  static const String tableName = 'students';
  static const String id = 'id';
  static const String fullName = 'fullName';
  static const String fatherName = 'fatherName';
  static const String contactInfo = 'contactInfo';
  static const String avatarPath = 'avatarPath';
  static const String absences = 'absences';
  static const String disciplinaryIssues = 'disciplinaryIssues';

  static final List<String> values = [
    id,
    fullName,
    fatherName,
    contactInfo,
    avatarPath,
    absences,
    disciplinaryIssues
  ];
}

class Student {
  final int? id;
  final String fullName;
  final String fatherName;
  final String? contactInfo;
  final String? avatarPath;
  final int absences;
  final int disciplinaryIssues;

  const Student({
    this.id,
    required this.fullName,
    required this.fatherName,
    this.contactInfo,
    this.avatarPath,
    this.absences = 0,
    this.disciplinaryIssues = 0,
  });

  Student copyWith({
    int? id,
    String? fullName,
    String? fatherName,
    String? contactInfo,
    String? avatarPath,
    int? absences,
    int? disciplinaryIssues,
  }) =>
      Student(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        fatherName: fatherName ?? this.fatherName,
        contactInfo: contactInfo ?? this.contactInfo,
        avatarPath: avatarPath ?? this.avatarPath,
        absences: absences ?? this.absences,
        disciplinaryIssues: disciplinaryIssues ?? this.disciplinaryIssues,
      );

  // متد کلیدی: تبدیل مدل به Map برای ذخیره در پایگاه داده
  Map<String, dynamic> toMap() {
    return {
      StudentFields.id: id,
      StudentFields.fullName: fullName,
      StudentFields.fatherName: fatherName,
      StudentFields.contactInfo: contactInfo,
      StudentFields.avatarPath: avatarPath,
      StudentFields.absences: absences,
      StudentFields.disciplinaryIssues: disciplinaryIssues,
    };
  }

  // متد کلیدی: ساختن یک نمونه از مدل از روی Map خوانده شده از پایگاه داده
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map[StudentFields.id] as int?,
      fullName: map[StudentFields.fullName] as String,
      fatherName: map[StudentFields.fatherName] as String,
      contactInfo: map[StudentFields.contactInfo] as String?,
      avatarPath: map[StudentFields.avatarPath] as String?,
      absences: map[StudentFields.absences] as int,
      disciplinaryIssues: map[StudentFields.disciplinaryIssues] as int,
    );
  }
}
