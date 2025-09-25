// lib/models/teacher_model.dart

class TeacherFields {
  static const String tableName = 'teacher';
  static const String id = '_id';
  static const String fullName = 'fullName';
  static const String schoolLevel = 'schoolLevel';
  static const String schoolName = 'schoolName';
  static const String className = 'className';
  static const String username = 'username';
  static const String password =
      'password'; // Note: In a real app, hash the password!
}

class Teacher {
  final int? id;
  final String fullName;
  final String schoolLevel;
  final String schoolName;
  final String className;
  final String username;
  final String password;

  const Teacher({
    this.id,
    required this.fullName,
    required this.schoolLevel,
    required this.schoolName,
    required this.className,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        TeacherFields.id: id,
        TeacherFields.fullName: fullName,
        TeacherFields.schoolLevel: schoolLevel,
        TeacherFields.schoolName: schoolName,
        TeacherFields.className: className,
        TeacherFields.username: username,
        TeacherFields.password: password,
      };

  static Teacher fromMap(Map<String, dynamic> map) => Teacher(
        id: map[TeacherFields.id] as int?,
        fullName: map[TeacherFields.fullName] as String,
        schoolLevel: map[TeacherFields.schoolLevel] as String,
        schoolName: map[TeacherFields.schoolName] as String,
        className: map[TeacherFields.className] as String,
        username: map[TeacherFields.username] as String,
        password: map[TeacherFields.password] as String,
      );
}
