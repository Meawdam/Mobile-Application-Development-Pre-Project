import 'dart:io';

import 'package:frontend/logic.dart';
import 'package:frontend/model.dart';

void main() async {
  final connector = Connector();
  print('--- Welcome to the Dart Expense Console ---');
  String? input;

  while (input != '10') {
    showMenu();
    stdout.write('Select an option : ');
    input = stdin.readLineSync();

    switch (input) {
      case '1':
        await showExpense(connector);
        break;
      case '2':
        await addExpense(connector);
        break;
      case '3':
        await editExpenses(connector);
        break;
      case '4':
        await deleteExpense(connector);
        break;
      case '5':
        await searchExpense(connector);
        break;
      case '6':
        await filterExpenses(connector);
        break;
      case '7':
        try {
          final List<Expense> expenses = await connector.getTodayExpenses();

          print('\n--- Today Expenses ---');

          if (expenses.isEmpty) {
            print('No expenses today.');
          } else {
            for (var (index, expense) in expenses.indexed) {
              print('${index + 1}. $expense');
            }
          }
        } catch (e) {
          print('Error: $e');
        }
        break;
      case '8':
        await showTotalExpenses(connector);
        break;
      case '9':
        try {
          stdout.write('Enter date (YYYY-MM-DD): ');
          final String? dateInput = stdin.readLineSync();

          if (dateInput == null || dateInput.isEmpty) {
            print('Invalid date.');
            break;
          }

          final DateTime selectedDate = DateTime.parse(dateInput);

          final List<Expense> expenses = await connector.getExpensesByDate(
            selectedDate,
          );

          print('\n--- Expenses on ${dateInput} ---');

          if (expenses.isEmpty) {
            print('No expenses found on this date.');
          } else {
            double total = 0;

            for (var (index, expense) in expenses.indexed) {
              print('${index + 1}. $expense');
              total += expense.amount;
            }

            print('-------------------');
            print('Total: $total');
          }
        } catch (e) {
          print('Invalid date. Please use YYYY-MM-DD.');
        }
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
  print('2. Add new expense');
  print('3. Edit expense');
  print('4. Delete expense');
  print('5. Search expense');
  print('6. Filter expense by category');
  print('7. Today expenses');
  print('8. Total expenses');
  print('9. Your own menu');
  print('10. Exit');
}

Future<void> addExpense(Connector connector) async {
  stdout.write('Enter Title: ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Enter Amount: ');
  final amount = double.tryParse(stdin.readLineSync() ?? '');
  if (amount == null) {
    print('Error: Invalid amount');
    return;
  }

  stdout.write(
    'Select Category (1:food, 2:transportation, 3:shopping, 4:others): ',
  );
  final categoryChoice = int.tryParse(stdin.readLineSync() ?? '');
  final category = categoryChoice == null
      ? null
      : ExpenseCategory.fromMenuChoice(categoryChoice);
  if (category == null) {
    print('Error: Invalid category');
    return;
  }

  stdout.write('Enter Date (YYYY-MM-DD) or press Enter for today: ');
  final dateInput = stdin.readLineSync() ?? '';
  final date = dateInput.isEmpty
      ? DateTime.now()
      : DateTime.tryParse(dateInput);
  if (date == null) {
    print('Error: Invalid date');
    return;
  }

  try {
    await connector.addExpense(
      title: title,
      amount: amount,
      category: category,
      date: date,
    );
    print('Expense added successfully!');
  } on Exception catch (e) {
    print('Error: $e');
  }
}

Future<void> deleteExpense(Connector connector) async {
  stdout.write('Enter expense number to delete: ');
  final index = int.tryParse(stdin.readLineSync() ?? '');
  if (index == null) {
    print('Error: Invalid expense number');
    return;
  }

  try {
    await connector.deleteExpenseByIndex(index);
    print('Expense deleted successfully!');
  } on Exception catch (e) {
    print('Error: $e');
  }
}

Future<void> searchExpense(Connector connector) async {
  stdout.write('Enter expense number to search: ');
  final index = int.tryParse(stdin.readLineSync() ?? '');
  if (index == null) {
    print('Error: Invalid expense number');
    return;
  }

  try {
    final expense = await connector.searchExpenseByIndex(index);
    print('\n--- Expense ---');
    print('$index. $expense');
  } on Exception catch (e) {
    print('Error: $e');
  }
}

Future<void> showExpense(Connector connector) async {
  try {
    final List<Expense> expenses = await connector.getExpense();
    if (expenses.isEmpty) {
      print('\nNo expenses found.');
      return;
    }

    print('\n--- All Expenses ---');
    for (var (index, expense) in expenses.indexed) {
      print('${index + 1}. $expense');
    }
  } on Exception catch (e) {
    print('Error: $e');
  }
}

// editTask
Future<void> editExpenses(Connector api) async {
  try {
    List<Expense> todos = await api.getExpense();
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

Future<void> showTotalExpenses(Connector connector) async {
  try {
    final expenses = await connector.getExpense();
    final total = connector.totalExpenses(expenses);
    print('\nTotal Expenses: ${total.toStringAsFixed(2)}');
  } on Exception catch (e) {
    print('Error: $e');
  }
}
