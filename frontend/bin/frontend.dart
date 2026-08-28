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
        break;
      case '8':
        await showTotalExpenses(connector);
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
  final date = dateInput.isEmpty ? DateTime.now() : DateTime.tryParse(dateInput);
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

Future<void> showTotalExpenses(Connector connector) async {
  try {
    final expenses = await connector.getExpense();
    final total = connector.totalExpenses(expenses);
    print('\nTotal Expenses: ${total.toStringAsFixed(2)}');
  } on Exception catch (e) {
    print('Error: $e');
  }
}
