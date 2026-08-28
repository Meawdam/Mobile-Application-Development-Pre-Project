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
        await editExpenses(connector);
        break;
      case '4':
        break;
      case '5':
        break;
      case '6':
        await filterExpenses(connector);
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
  print('1. Show expenses');
  print('2. Add new expenses');
  print('3. Edit expenses');
  print('4. Delete expenses');
  print('5. Search expense');
  print('6. Filter expense by category');
  print('7. Today expenses');
  print('8. Total expenses');
  print('9. Your own menu');
  print('10. Exit');
}

Future<void> showExpense(Connector connector) async {
  try {
    final List<Expense> todos = await connector.getTasks();
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

// editTask
Future<void> editExpenses(Connector api) async {
  try {
    List<Expense> todos = await api.getTasks();
    if (todos.isEmpty) {
      print('\nNo tasks to edit.');
      return;
    }

    print('\n--- Select Expense to Edit ---');
    for (var (index, todo) in todos.indexed) {
      print('${index + 1}. $todo');
    }

    stdout.write('Enter the index number: ');
    String? input = stdin.readLineSync();
    int? itemIndex = int.tryParse(input ?? '');
    if (itemIndex == null || itemIndex < 1 || itemIndex > todos.length) {
      print('Invalid task number.');
      return;
    }

    final selectedTask = todos[itemIndex - 1];

    stdout.write('Enter New Title (leave blank to keep current): ');
    String? newTitleInput = stdin.readLineSync();
    String? newTitle =
        (newTitleInput != null && newTitleInput.trim().isNotEmpty)
        ? newTitleInput.trim()
        : null;

    stdout.write('Enter New Amount (leave blank to keep current): ');
    String? newAmountInput = stdin.readLineSync();
    double? newAmount =
        (newAmountInput != null && newAmountInput.trim().isNotEmpty)
        ? double.tryParse(newAmountInput.trim())
        : null;

    stdout.write(
      'Select Category (1:food, 2:transportation, 3:shopping, 4:others, blank:current): ',
    );
    String? categoryInput = stdin.readLineSync();
    ExpenseCategory? newCategory;
    if (categoryInput != null && categoryInput.trim().isNotEmpty) {
      int? catChoice = int.tryParse(categoryInput.trim());
      if (catChoice != null) {
        newCategory = ExpenseCategory.fromMenuChoice(catChoice);
      }
    }

    stdout.write('Enter New Date (YYYY-MM-DD) or press Enter for today: ');
    String? dateInput = stdin.readLineSync();
    DateTime? newDate;
    if (dateInput != null && dateInput.trim().isNotEmpty) {
      newDate = DateTime.tryParse(dateInput.trim());
    }

    await api.editTask(
      selectedTask.id,
      newTitle: newTitle,
      newAmount: newAmount,
      newCategory: newCategory,
      newDate: newDate,
    );
    print('Expense updated successfully!');
  } on Exception catch (e) {
    print('Error: $e');
  }
}

// filter
Future<void> filterExpenses(Connector connector) async {
  stdout.write(
    'Select Category (1:food, 2:transportation, 3:shopping, 4:others): ',
  );
  final input = stdin.readLineSync()?.trim() ?? '';
  final choice = int.tryParse(input);

  if (choice == null) {
    print('Invalid input.');
    return;
  }

  final category = ExpenseCategory.fromMenuChoice(choice);
  if (category == null) {
    print('Invalid category choice.');
    return;
  }

  final results = await connector.filterExpenses(category);

  print('\n--- Filtered Results ---');
  if (results.isEmpty) {
    print('No expenses found for this category.');
  } else {
    for (final item in results) {
      print(item);
    }
  }
}
