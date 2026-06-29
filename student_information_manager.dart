import 'dart:io';

// ========== ABSTRACT CLASS (Person) ==========
abstract class Person {
  String get name;
  int get age;
  void displayInfo();
}

// ========== STUDENT CLASS ==========
class Student extends Person {
  // Private fields (Encapsulation)
  String _name;
  int _age;
  String _id;
  String _grade;

  // Constructor
  Student({
    required String name,
    required int age,
    required String id,
    required String grade,
  })  : _name = name,
        _age = age,
        _id = id,
        _grade = grade;

  // Getters (Arrow functions)
  @override
  String get name => _name;

  @override
  int get age => _age;

  String get id => _id;
  String get grade => _grade;

  // Fixed displayInfo with proper box border
  @override
  void displayInfo() {
    const width = 27;
    String row(String label, String value) {
      final content = ' $label : $value';
      final padding = width - content.length - 1;
      return '│$content${' ' * (padding < 0 ? 0 : padding)}│';
    }

    print('┌${'─' * width}┐');
    print(row('ID   ', _id));
    print(row('Name ', _name));
    print(row('Age  ', _age.toString()));
    print(row('Grade', _grade));
    print('└${'─' * width}┘');
  }
}

// ========== STUDENT MANAGER CLASS ==========
class StudentManager {
  // Private list
  final List<Student> _students = [];

  // Add student
  void addStudent(Student student) {
    _students.add(student);
    print('\n✅ Student added successfully!\n');
  }

  // View all students (Anonymous function in forEach)
  void viewStudents() {
    if (_students.isEmpty) {
      print('\n⚠️  No students found.\n');
      return;
    }
    print('\n===== All Students =====');
    _students.forEach((student) {
      student.displayInfo();
    });
  }

  // Search student by name (Anonymous function in where)
  void searchStudent(String query) {
    final results = _students
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      print('\n⚠️  No student found with name: $query\n');
    } else {
      print('\n===== Search Results =====');
      results.forEach((s) => s.displayInfo());
    }
  }

  // Delete student by ID (Arrow function)
  void deleteStudent(String id) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index == -1) {
      print('\n⚠️  Student with ID "$id" not found.\n');
    } else {
      final removed = _students.removeAt(index);
      print('\n🗑️  Student "${removed.name}" deleted successfully.\n');
    }
  }
}

// ========== HELPER ==========
String readInput(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync() ?? '';
}

// ========== MAIN ==========
void main() {
  final manager = StudentManager();

  // Anonymous function for menu
  final showMenu = () {
    print('\n====== Student Information Manager ======');
    print('1. Add Student');
    print('2. View Students');
    print('3. Search Student');
    print('4. Delete Student');
    print('5. Exit');
    print('=========================================');
  };

  while (true) {
    showMenu();
    stdout.write('Choose: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('\n--- Add New Student ---');
        final id = readInput('Enter ID     : ');
        final name = readInput('Enter Name   : ');
        final ageStr = readInput('Enter Age    : ');
        final grade = readInput('Enter Grade  : ');
        final age = int.tryParse(ageStr) ?? 0;
        manager.addStudent(Student(
          name: name,
          age: age,
          id: id,
          grade: grade,
        ));
        break;

      case '2':
        manager.viewStudents();
        break;

      case '3':
        final query = readInput('\nEnter name to search: ');
        manager.searchStudent(query);
        break;

      case '4':
        final id = readInput('\nEnter student ID to delete: ');
        manager.deleteStudent(id);
        break;

      case '5':
        print('\n👋 Goodbye!\n');
        exit(0);

      default:
        print('\n❌ Invalid choice. Try again.\n');
    }
  }
}