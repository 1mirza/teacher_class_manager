// lib/models/attendance_model.dart

// An enum for clarity and type safety
enum AttendanceStatus { present, absent, justified }

class AttendanceFields {
  static const String tableName = 'attendance';
  static const String id = '_id';
  static const String studentId = 'studentId';
  static const String date = 'date'; // Format: 'yyyy/mm/dd'
  static const String status = 'status'; // 'present', 'absent', 'justified'
}

class AttendanceRecord {
  final int? id;
  final int studentId;
  final String date;
  final AttendanceStatus status;

  const AttendanceRecord({
    this.id,
    required this.studentId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        AttendanceFields.id: id,
        AttendanceFields.studentId: studentId,
        AttendanceFields.date: date,
        AttendanceFields.status: status.toString().split('.').last, // 'present'
      };

  static AttendanceRecord fromMap(Map<String, dynamic> map) => AttendanceRecord(
        id: map[AttendanceFields.id] as int?,
        studentId: map[AttendanceFields.studentId] as int,
        date: map[AttendanceFields.date] as String,
        status: AttendanceStatus.values.firstWhere(
          (e) =>
              e.toString() ==
              'AttendanceStatus.${map[AttendanceFields.status]}',
        ),
      );
}
