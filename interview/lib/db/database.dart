import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class User {
  final int id;
  final String name;
  final String password;
  final String role;

  User(
      {required this.id,
      required this.name,
      required this.password,
      required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'role': role,
    };
  }
}

class Course {
  final int id;
  final int teacherId;
  final String topic;
  final String? info;

  Course(
      {required this.id,
      required this.teacherId,
      required this.topic,
      this.info});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacherId': teacherId,
      'topic': topic,
      'info': info,
    };
  }
}

class CourseUser {
  final int courseId;
  final int studentId;

  CourseUser({
    required this.courseId,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'studentId': studentId,
    };
  }
}

class CourseSystemDb {
  Future<Database> initializeDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'course_system.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          password TEXT,
          role TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE courses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          teacherId INTEGER,
          topic TEXT,
          info TEXT,
          FOREIGN KEY (teacherId) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');

        await db.execute('''
        CREATE TABLE courseUser (
          courseId INTEGER,
          studentId INTEGER,
          PRIMARY KEY (courseId, studentId),
          FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,
          FOREIGN KEY (studentId) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
      },
    );
  }

  Future<List<Course>> getCourses() async {
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> maps = await db.query('courses');
    return List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          teacherId: maps[i]['teacherId'],
          topic: maps[i]['topic'],
          info: maps[i]['info']);
    });
  }

  Future<List<User>> getTeacher(String role) async {
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: ["teacher"],
    );
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        password: maps[i]['password'],
        role: maps[i]['role'],
      );
    });
  }

  Future<List<Course>> getCourseByTeacher(int teacherId) async {
    final Database db = await initializeDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'courses',
      where: 'teacherId = ?',
      whereArgs: [teacherId],
    );
    return List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          teacherId: maps[i]['teacherId'],
          topic: maps[i]['topic'],
          info: maps[i]['info']);
    });
  }

  Future<void> addTeacher(User teacher) async {
    final Database db = await initializeDb();
    await db.insert(
      'users',
      teacher.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addCourse(Course course) async {
    final Database db = await initializeDb();
    await db.insert(
      'courses',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCourse(Course course) async {
    final Database db = await initializeDb();
    await db.update(
      'courses',
      course.toMap(),
      where: "id = ?",
      whereArgs: [course.id],
    );
  }

  Future<void> deleteCourse(int courseId) async {
    final Database db = await initializeDb();
    await db.delete(
      'courses',
      where: "id = ?",
      whereArgs: [courseId],
    );
  }
}
