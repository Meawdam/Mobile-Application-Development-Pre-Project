import 'dart:io';

import 'package:frontend/logic.dart';
import 'package:frontend/model.dart';

void main() async {
  final connector = Connector();
  print('--- Welcome to the Dart Expense Console ---');
  String? input;

  while (input != '7') {
    showMenu();
    stdout.write('Select an option : ');
    input = stdin.readLineSync();

    switch (input) {
      case '1':
        break;
      case '2':
        break;
      case '3':
        break;
      case '4':
        break;
      case '5':
        break;
      case '6':
        break;
      case '7':
        break;
      case '8':
        break;
      case '9':
        break;
      case '10':
        print('Good bye!');
        break;
      default:
        print('Invalid selection, please select only 1-10!');
    }
  }
}

void showMenu() {
  print('\n======== Menu ========');
  print('1. View Tasks');
  print('2. Add New Task');
  print('3. Delete Task');
  print('4. Toggle Task Status');
  print('5. Edit Task');
  print('6. Search Task');
  print('7. Exit');
}

Future<void> showExpense(Connector connector) async {
  try {
    final List<Expense> todos = await connector.getExpense();
    if (todos.isEmpty) {
      print('\nNo expense found.');
      return;
    }

    print('-------------------');
    for (var (index, todo) in todos.indexed) {
      print('${index + 1}. $todo');
    }
  } on Exception catch (e) {
    print('Error: $e');
  }
}
