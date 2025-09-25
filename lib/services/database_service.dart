// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teacher_class_manager/models/checklist_model.dart';
import 'package:teacher_class_manager/models/disciplinary_model.dart';
import 'package:teacher_class_manager/models/grade_models.dart';
import 'package:teacher_class_manager/models/lesson_models.dart';
import 'package:teacher_class_manager/models/student_model.dart';
import 'package:teacher_class_manager/models/teacher_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('teacher_app_v2.db'); // نسخه جدید برای جداول جدید
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textUnique = 'TEXT NOT NULL UNIQUE';

    // 1. جدول معلم
    await db.execute('''
    CREATE TABLE ${TeacherFields.tableName} (
      ${TeacherFields.id} $idType,
      ${TeacherFields.fullName} $textType,
      ${TeacherFields.schoolLevel} $textType,
      ${TeacherFields.schoolName} $textType,
      ${TeacherFields.className} $textType,
      ${TeacherFields.username} $textUnique,
      ${TeacherFields.password} $textType
    )''');

    // 2. جدول دانش‌آموزان
    await db.execute('''
    CREATE TABLE ${StudentFields.tableName} (
      ${StudentFields.id} $idType, ${StudentFields.fullName} $textType,
      ${StudentFields.fatherName} $textType, ${StudentFields.contactInfo} TEXT,
      ${StudentFields.avatarPath} TEXT, ${StudentFields.absences} $integerType DEFAULT 0,
      ${StudentFields.disciplinaryIssues} $integerType DEFAULT 0
    )''');

    // ... سایر جداول ...
    await db.execute(
        'CREATE TABLE ${DisciplinaryFields.tableName} ( ${DisciplinaryFields.id} $idType, ${DisciplinaryFields.studentId} $integerType, ${DisciplinaryFields.date} $textType, ${DisciplinaryFields.description} $textType, FOREIGN KEY (${DisciplinaryFields.studentId}) REFERENCES ${StudentFields.tableName} (${StudentFields.id}) ON DELETE CASCADE )');
    await db.execute(
        'CREATE TABLE ${ExamFields.tableName} ( ${ExamFields.id} $idType, ${ExamFields.title} $textType, ${ExamFields.date} $textType, ${ExamFields.courseName} $textType )');
    await db.execute(
        'CREATE TABLE ${GradeFields.tableName} ( ${GradeFields.id} $idType, ${GradeFields.studentId} $integerType, ${GradeFields.examId} $integerType, ${GradeFields.score} $textType, FOREIGN KEY (${GradeFields.studentId}) REFERENCES ${StudentFields.tableName} (${StudentFields.id}) ON DELETE CASCADE, FOREIGN KEY (${GradeFields.examId}) REFERENCES ${ExamFields.tableName} (${ExamFields.id}) ON DELETE CASCADE )');
    await db.execute(
        'CREATE TABLE ${HomeworkFields.tableName} ( ${HomeworkFields.id} $idType, ${HomeworkFields.date} $textType, ${HomeworkFields.description} $textType, ${HomeworkFields.isGroupal} $integerType )');
    await db.execute(
        'CREATE TABLE ${TeacherActivityFields.tableName} ( ${TeacherActivityFields.id} $idType, ${TeacherActivityFields.date} $textType UNIQUE, ${TeacherActivityFields.activityLog} $textType )');

    // آخرین جدول: چک‌لیست
    await db.execute('''
    CREATE TABLE ${ChecklistItemFields.tableName} (
      ${ChecklistItemFields.id} $idType,
      ${ChecklistItemFields.date} $textType,
      ${ChecklistItemFields.title} $textType,
      ${ChecklistItemFields.isDone} $integerType
    )''');
  }

  // --- Teacher Methods ---
  Future<Teacher> createTeacher(Teacher teacher) async {
    final db = await instance.database;
    await db.insert(TeacherFields.tableName, teacher.toMap());
    return teacher;
  }

  Future<Teacher?> getTeacher(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      TeacherFields.tableName,
      where: '${TeacherFields.username} = ? AND ${TeacherFields.password} = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return Teacher.fromMap(maps.first);
    }
    return null;
  }

  // --- Checklist Methods ---
  Future<ChecklistItem> createChecklistItem(ChecklistItem item) async {
    final db = await instance.database;
    final id = await db.insert(ChecklistItemFields.tableName, item.toMap());
    return item.copyWith(id: id);
  }

  Future<List<ChecklistItem>> getChecklistForDate(String date) async {
    final db = await instance.database;
    final result = await db.query(ChecklistItemFields.tableName,
        where: '${ChecklistItemFields.date} = ?', whereArgs: [date]);
    return result.map((json) => ChecklistItem.fromMap(json)).toList();
  }

  Future<int> updateChecklistItem(ChecklistItem item) async {
    final db = await instance.database;
    return db.update(ChecklistItemFields.tableName, item.toMap(),
        where: '${ChecklistItemFields.id} = ?', whereArgs: [item.id]);
  }

  // --- Student Methods ---
  Future<Student> createStudent(Student student) async {
    final db = await instance.database;
    final id = await db.insert(StudentFields.tableName, student.toMap());
    return student.copyWith(id: id);
  }

  Future<List<Student>> getAllStudents() async {
    final db = await instance.database;
    final result = await db.query(StudentFields.tableName,
        orderBy: '${StudentFields.fullName} ASC');
    return result.map((json) => Student.fromMap(json)).toList();
  }

  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return db.update(StudentFields.tableName, student.toMap(),
        where: '${StudentFields.id} = ?', whereArgs: [student.id]);
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete(StudentFields.tableName,
        where: '${StudentFields.id} = ?', whereArgs: [id]);
  }

  // --- Disciplinary Methods ---
  Future<DisciplinaryIssue> createDisciplinaryIssue(
      DisciplinaryIssue issue) async {
    final db = await instance.database;
    final id = await db.insert(DisciplinaryFields.tableName, issue.toMap());
    return issue.copyWith(id: id);
  }

  // --- Exam & Grade Methods ---
  Future<Exam> createExam(Exam exam) async {
    final db = await instance.database;
    final id = await db.insert(ExamFields.tableName, exam.toMap());
    return exam.copyWith(id: id);
  }

  Future<List<Exam>> getAllExams() async {
    final db = await instance.database;
    final result = await db.query(ExamFields.tableName,
        orderBy: '${ExamFields.date} DESC');
    return result.map((json) => Exam.fromMap(json)).toList();
  }

  Future<int> deleteExam(int id) async {
    final db = await instance.database;
    return db.delete(ExamFields.tableName,
        where: '${ExamFields.id} = ?', whereArgs: [id]);
  }

  Future<void> saveGradesForExam(List<Grade> grades) async {
    final db = await instance.database;
    final batch = db.batch();
    if (grades.isNotEmpty) {
      batch.delete(GradeFields.tableName,
          where: '${GradeFields.examId} = ?', whereArgs: [grades.first.examId]);
    }
    for (var grade in grades) {
      batch.insert(GradeFields.tableName, grade.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Grade>> getGradesForExam(int examId) async {
    final db = await instance.database;
    final result = await db.query(GradeFields.tableName,
        where: '${GradeFields.examId} = ?', whereArgs: [examId]);
    return result.map((json) => Grade.fromMap(json)).toList();
  }

  // --- Homework Methods ---
  Future<Homework> createHomework(Homework homework) async {
    final db = await instance.database;
    final id = await db.insert(HomeworkFields.tableName, homework.toMap());
    return homework.copyWith(id: id);
  }

  Future<List<Homework>> getAllHomework() async {
    final db = await instance.database;
    final result = await db.query(HomeworkFields.tableName,
        orderBy: '${HomeworkFields.date} DESC');
    return result.map((json) => Homework.fromMap(json)).toList();
  }

  // --- Teacher Activity Methods ---
  Future<void> saveActivity(TeacherActivity activity) async {
    final db = await instance.database;
    await db.insert(TeacherActivityFields.tableName, activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<TeacherActivity?> getActivityForDate(String date) async {
    final db = await instance.database;
    final maps = await db.query(TeacherActivityFields.tableName,
        where: '${TeacherActivityFields.date} = ?', whereArgs: [date]);
    if (maps.isNotEmpty) {
      return TeacherActivity.fromMap(maps.first);
    }
    return null;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
