import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:interview/db/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  group('CourseSystemDb Tests', () {
    late CourseSystemDb courseSystem;
    late Database db;

    setUp(() async {
      courseSystem = CourseSystemDb();
      db = await courseSystem.initializeDb();
    });

    tearDown(() async {
      await db.close();
      String dbPath = await getDatabasesPath();
      String path = join(dbPath, 'course_system.db');
      await deleteDatabase(path);
    });

    test('Add Course', () async {
      User teacher =
          User(id: 1, name: 'oliver', password: 'password', role: 'teacher');
      await courseSystem.addTeacher(teacher);
      Course course =
          Course(id: 1, teacherId: 1, topic: 'Flutter', info: 'Flutter Course');
      await courseSystem.addCourse(course);

      List<Course> courses = await courseSystem.getCourses();
      expect(courses.length, 1);
      expect(courses.first.topic, 'Flutter');
    });

    test('Get Course List', () async {
      User teacher =
          User(id: 1, name: 'oliver', password: 'password', role: 'teacher');
      await courseSystem.addTeacher(teacher);
      Course course1 =
          Course(id: 1, teacherId: 1, topic: 'Flutter', info: 'Flutter Course');
      Course course2 =
          Course(id: 2, teacherId: 1, topic: 'Dart', info: 'Dart Course');
      await courseSystem.addCourse(course1);
      await courseSystem.addCourse(course2);

      List<Course> courses = await courseSystem.getCourses();
      expect(courses.length, 2);
    });

    test('Delete Course', () async {
      User teacher =
          User(id: 1, name: 'oliver', password: 'password', role: 'teacher');
      await courseSystem.addTeacher(teacher);
      Course course =
          Course(id: 1, teacherId: 1, topic: 'Flutter', info: 'Flutter Course');
      await courseSystem.addCourse(course);

      List<Course> coursesBeforeDeletion = await courseSystem.getCourses();
      expect(coursesBeforeDeletion.length, 1);

      await courseSystem.deleteCourse(1);
      List<Course> coursesAfterDeletion = await courseSystem.getCourses();
      expect(coursesAfterDeletion.length, 0);
    });
  });
}
